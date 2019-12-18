import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/page/device_input_page.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/widget/device_image_view.dart';
import 'package:xlive/widget/switch_button.dart';

import 'set_name_page.dart';
import 'set_room_page.dart';
import 'device_informations_page.dart';
import 'binding_setting_page.dart';
import 'key_press_binding_list_page.dart';
import 'wall_switch_binding_list_page.dart';
import 'set_curtain_direction_page.dart';
import 'set_curtain_type_page.dart';
import 'common_page.dart';
import 'package:xlive/widget/xy_picker.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'dart:async';

const int S_WALL_SWITCH_VERSION_SUPPORT_INPUT_CFG = 54;
const int D_WALL_SWITCH_VERSION_SUPPORT_INPUT_CFG = 42;

class EntityWrapper {
  // create a entity wrapper to allow us change entity at runtime
  Entity entity;
  EntityWrapper(Entity this.entity);
}

class DeviceDetailPage extends StatefulWidget {
  final EntityWrapper entityWrapper;
  Entity get entity => entityWrapper.entity;

  DeviceDetailPage({
    @required entity,
  }) : entityWrapper = EntityWrapper(entity);

  State<StatefulWidget> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetailPage>
    with TickerProviderStateMixin {
  static const String className = 'DeviceDetailPage';
  Log log = LogFactory().getLogger(Log.DEBUG, className);
  int onOffValue; //开关打开关闭值
  int speedValue; //点开风速默认选中值
  int selectMode; //点开模式选中的值
  int selectTemp; //点开温度选中的值

  final List<_Group> _groups = List();
  _Header _header;
  final _ChildrenGroup _childrenGroup = _ChildrenGroup();
  final _InputChildrenGroup _inputChildrenGroup = _InputChildrenGroup();
  final _BindingGroup _bindingGroup = _BindingGroup();
  final _SettingGroup _settingGroup = _SettingGroup();
  final _ControlGroup _controlGroup = _ControlGroup();
  final _AirCChildrenGroup _airCChildrenGroup = _AirCChildrenGroup();
  final _IndoorUnitGroup _indoorUnitGroup = _IndoorUnitGroup();
  _Footer _footer;

  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _header = _Header(entity: widget.entity);
    _footer = _Footer(entity: widget.entity);

    _resetData();

    _start();
  }

  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  void _resetData() {
    print("------------------------------device_detail_page.dart");
    _childrenGroup.clear();
    _inputChildrenGroup.clear();
    _controlGroup.clear();
    _bindingGroup.clear();
    _settingGroup.clear();
    _childrenGroup.init();
    _inputChildrenGroup.init();
    _controlGroup.init();
    _bindingGroup.init();
    _settingGroup.init();
    _airCChildrenGroup.clear();
    _indoorUnitGroup.clear();
    _groups.clear();
    _groups.add(_header);
    _settingGroup.add(widget.entity, SETTING_NAME);
    _settingGroup.add(widget.entity, SETTING_AREA);

    final HomeCenter hc = HomeCenterManager().defaultHomeCenter;
    if (widget.entity is PhysicDevice) {
      final PhysicDevice pd = widget.entity as PhysicDevice;
      if (pd.isWallSwitch) {
        for (var ld in pd.logicDevices) {
          if (ld.profile == PROFILE_ON_OFF_LIGHT) {
            final Entity entity =
                HomeCenterManager().defaultHomeCenterCache.findEntity(hc.uuid);
            var hcVersion = entity == null
                ? 0
                : entity.getAttributeValue(ATTRIBUTE_ID_FIRMWARE_VERSION);
            if (hcVersion >= CAN_CHANGE_CHANNEL) {
              if ((pd.isWallSwitchD &&
                      pd.firmwareVersion >=
                          D_WALL_SWITCH_VERSION_SUPPORT_INPUT_CFG) ||
                  (pd.isWallSwitchS &&
                      pd.firmwareVersion >=
                          S_WALL_SWITCH_VERSION_SUPPORT_INPUT_CFG)) {
                _inputChildrenGroup.add(ld);
              }
            }
          }
          if (ld.isOnOffLight) {
            _childrenGroup.add(ld);
          } else {
            if (ld.uuid.endsWith('-02')) {
              if (hc.supportAutoVersion < 0) {
                _bindingGroup.add(ld, BINDING_TOP_RIGHT_BUTTON);
              }
            } else if (ld.uuid.endsWith('-04')) {
              if (hc.supportAutoVersion < 0) {
                _bindingGroup.add(ld, BINDING_BOTTOM_RIGHT_BUTTON);
              }
            } else if (ld.uuid.endsWith('-03')) {
              if (hc.supportAutoVersion < 0) {
                _bindingGroup.add(ld, BINDING_BOTTOM_LEFT_BUTTON);
              }
            } else if (ld.uuid.endsWith('-01')) {
              if (hc.supportAutoVersion < 0) {
                _bindingGroup.add(ld, BINDING_TOP_LEFT_BUTTON);
              }
            }
          }
        }
      } else if (pd.isWallSwitchUS) {
        for (var ld in pd.logicDevices) {
          if (ld.isOnOffLight) {
            _childrenGroup.add(ld);
          } else {
            if (ld.uuid.endsWith('-01')) {
              if (hc.supportAutoVersion < 0) {
                _bindingGroup.add(ld, BINDING_SECOND_BUTTON);
              }
            } else if (ld.uuid.endsWith('-02')) {
              if (hc.supportAutoVersion < 0) {
                _bindingGroup.add(ld, BINDING_FIRST_BUTTON);
              }
            } else if (ld.uuid.endsWith('-03')) {
              if (hc.supportAutoVersion < 0) {
                _bindingGroup.add(ld, BINDING_THIRD_BUTTON);
              }
            }
          }
        }
      } else if (pd.isSwitchModule) {
        final Entity entity =
            HomeCenterManager().defaultHomeCenterCache.findEntity(hc.uuid);
        var hcVersion = entity == null
            ? 0
            : entity.getAttributeValue(ATTRIBUTE_ID_FIRMWARE_VERSION);
        if (hcVersion >= CAN_CHANGE_CHANNEL) {
          for (LogicDevice ld in pd.logicDevices) {
            if (ld.isOnOffLight) _childrenGroup.add(ld);
            if (ld.profile == PROFILE_ON_OFF_LIGHT) {
              _inputChildrenGroup.add(ld);
            } else {}
          }
        }
      } else if (pd.isZHHVRVGateway) {
        for (var ld in pd.logicDevices) {
          if (ld.isZHHVRVGateway) continue;
          _airCChildrenGroup.add(ld);
        }
      }
    } else if (widget.entity is LogicDevice) {
      final LogicDevice ld = widget.entity as LogicDevice;
      if (ld.isOnOffLight) {
      } else if (ld.isSmartPlug) {
        if (hc.supportAutoVersion < 0) {
          _bindingGroup.add(ld, BINDING_TIMER);
          _bindingGroup.add(ld, BINDING_COUNT_COWN);
        }
      } else if (ld.isAwarenessSwitch) {
        _controlGroup.add(ld, BINDING_ALERT);
        if (hc.supportAutoVersion < 0) {
          _bindingGroup.add(ld, BINDING_AWARENESS_SWITCH);
          _bindingGroup.add(ld, BINDING_CLICK);
          _bindingGroup.add(ld, BINDING_DOUBLE_CLICK);
        }
      } else if (ld.isDoorContact) {
        _controlGroup.add(ld, BINDING_ALERT);
        if (hc.supportAutoVersion < 0) {
          _bindingGroup.add(ld, BINDING_OPEN_CLOSE);
        }
      } else if (ld.isCurtain) {
        _settingGroup.add(ld, SETTING_TYPE);
        _settingGroup.add(ld, SETTING_DIRECTION);
        _settingGroup.add(ld, SETTING_TRIP_ADJUSTED);
      } else if (ld.isSmartDial) {
        if (hc.supportAutoVersion < 0) {
          _bindingGroup.add(ld, BINDING_SD_ROTATE);
          _bindingGroup.add(ld, BINDING_CLICK);
          _bindingGroup.add(ld, BINDING_DOUBLE_CLICK);
        }
      } else if (ld.isIndoorUnit) {
        //给开关赋默认值
        ld.getAttributeValue(ATTRIBUTE_ID_ZHH_IS_RUNNING) == 1
            ? onOffValue = 1
            : onOffValue = 0;
        //给风速赋默认值
        if (ld.getAttributeValue(ATTRIBUTE_ID_AC_FAN_SPEED) == 1) {
          speedValue = 1;
        } else if (ld.getAttributeValue(ATTRIBUTE_ID_AC_FAN_SPEED) == 2) {
          speedValue = 0;
        } else {
          speedValue = 2;
        }
        //给模式赋默认值
        if (ld.getAttributeValue(ATTRIBUTE_ID_AC_WORK_MODE) == 1) {
          selectMode = 0;
        } else if (ld.getAttributeValue(ATTRIBUTE_ID_AC_WORK_MODE) == 2) {
          selectMode = 2;
        } else if (ld.getAttributeValue(ATTRIBUTE_ID_AC_WORK_MODE) == 4) {
          selectMode = 3;
        } else {
          selectMode = 1;
        }
        selectTemp =
            ld.getAttributeValue(ATTRIBUTE_ID_AC_TARGET_TEMPERATURE) - 16;
        _indoorUnitGroup.add(ld, INDOOR_UNIT_ON_OFF);
        _indoorUnitGroup.add(ld, INDOOR_UNIT_FLOW);
        _indoorUnitGroup.add(ld, INDOOR_UNIT_MODE);
        _indoorUnitGroup.add(ld, INDOOR_UNIT_TARGET_TEM);
        _indoorUnitGroup.add(ld, INDOOR_UNIT_NOW_TEM);
      }
    }
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    _settingGroup.add(widget.entity, SETTING_OTHERS);
    _groups.add(_childrenGroup);
    _groups.add(_bindingGroup);
    _groups.add(_controlGroup);
    _groups.add(_inputChildrenGroup);
    _groups.add(_airCChildrenGroup);
    _groups.add(_indoorUnitGroup);
    _groups.add(_settingGroup);
    _groups.add(_footer);

    final List<Binding> bindings = cache.bindings;
    for (var binding in bindings) {
      _bindingGroup.addBinding(binding);
    }

    setState(() {});
  }

  void _start() {
    final String methodName = 'start';
    _subscription = RxBus().toObservable().where((event) {
      if (event is HomeCenterCacheEvent) {
        return event.homeCenterUuid ==
            HomeCenterManager().defaultHomeCenterUuid;
      }
      return true;
    }).listen((event) {
      if (event is DeviceAttributeReportEvent) {
        if (widget.entity.containsUuid(event.uuid)) {
          log.d(
              'Get an attr report event, attrId=${event.attrId}, attrValue=${event.attrValue}',
              methodName);
          _processAttributeReport(event.attrId, event.attrValue);
        }
      } else if (event is BindingEnableChanegeEvent) {
        if (event.triggerAddress == widget.entity.uuid ||
            event.triggerAddress.substring(0, 16) ==
                widget.entity.uuid.substring(0, 16)) {
          log.d('Get a binding enabled event', methodName);
          //setState(() {});
          _resetData();
        }
      } else if (event is BindingCreateEvent) {
        if (widget.entity.containsUuid(event.binding.triggerAddress)) {
          _resetData();
        }
      } else if (event is EntityInfoConfigureEvent) {
        if (event.uuid == widget.entity.uuid) {
          log.d('Get an entity info configure event', methodName);
          setState(() {});
        }
      } else if (event is DeviceOfflineEvent) {
        if (event.uuid == widget.entity.uuid) {
          log.d('Get a device offline event', methodName);
          //TODO: PIR and DC
          setState(() {});
        }
      } else if (event is DeviceDeleteEvent) {
        if (event.uuid == widget.entity.uuid) {
          log.d('Get a device deleted event', methodName);
          //Navigator.of(context).maybePop();
        }
      } else if (event is UpdatePhysicDeviceAvailableEvent) {
        log.d(
            'get update entity available event: ${event.uuid}, ${widget.entity.uuid}',
            methodName);
      } else if (event is PhysicDeviceAvailableEvent) {
        log.d(
            'get entity available event: ${event.uuid}, ${widget.entity.uuid}',
            methodName);
        bool isCurrentDeviceAvailable = false;
        if (event.uuid == widget.entityWrapper.entity.uuid) {
          log.d(
              'Get current physic device available event, change widget associated entity',
              methodName);
          widget.entityWrapper.entity = event.physicDevice;
          _header.entity = event.physicDevice;
          isCurrentDeviceAvailable = true;
        } else {
          for (var ld in event.physicDevice.logicDevices) {
            if (ld.uuid == widget.entity.uuid) {
              log.d(
                  'Get current logic device available event, change widget associated entity',
                  methodName);
              widget.entityWrapper.entity = ld;

              _header.entity = ld;
              isCurrentDeviceAvailable = true;
            }
          }
        }

        if (isCurrentDeviceAvailable) {
          _resetData();
        }
      }
    });
  }

  void _processAttributeReport(int attrId, int attrValue) {
    if (attrId == ATTRIBUTE_ID_ZHH_IS_RUNNING) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_AC_TARGET_TEMPERATURE) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_AC_WORK_MODE) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_AC_FAN_SPEED) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_ON_OFF_STATUS) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_ALERT_LEVEL) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_BINARY_INPUT_STATUS) {
    } else if (attrId == ATTRIBUTE_ID_OCCUPANCY) {
    } else if (attrId == ATTRIBUTE_ID_ACTIVE_POWER) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_INSERT_EXTRACT_STATUS) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_BATTERY_PERCENT) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_LUMINANCE) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_TEMPERATURE) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_CONFIG_DISABLE_RELAY) {
      _resetData();
    } else if (attrId == ATTRIBUTE_ID_CURTAIN_TYPE) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_CURTAIN_DIRECTION) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_CURTAIN_STATUS) {
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_CURTAIN_TRIP_CONFIGURED) {
      setState(() {});
    }
  }

  int _itemCount() =>
      2 +
      _childrenGroup.size() +
      _inputChildrenGroup.size() +
      _controlGroup.size() +
      _bindingGroup.size() +
      _settingGroup.size() +
      _indoorUnitGroup.size() +
      _airCChildrenGroup.size();

  Object _getItem(int index) {
    if (index == 0) {
      return _header;
    }
    if (index == _itemCount() - 1) {
      return _footer;
    }
    int step = 1;
    for (var group in _groups) {
      if (group is _Header) continue;
      if (group is _Footer) continue;
      if (index >= step && index < step + group.size()) {
        return group.get(index - step);
      } else {
        step += group.size();
      }
    }
    return null;
  }

  void _deleteDevice(BuildContext context, String uuid) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.deleteEntity(homeCenterUuid, uuid).listen((response) {
      if (response is DeleteDeviceResponse) {
        if (response.success) {
          print('delete entity response: ${response.code}');
          Navigator.of(context, rootNavigator: true).maybePop();
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
        }
      }
    });
  }

  void _writeAttribute(
      Entity entity, int attrId, int attrValue, _UiEntity uiEntity) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.writeAttribute(homeCenterUuid, entity.uuid, attrId, attrValue)
        .listen((response) {
      if (response is WriteAttributeResponse) {
        //uiEntity.switchShowIndicator = false;
        if (uiEntity is _BindingUiEntity) {
          uiEntity.switchShowIndicator = false;
        } else if (uiEntity is _ControlUiEntity) {
          uiEntity.switchShowIndicator = false;
        } else if (uiEntity is _ChildUiEntity) {
          uiEntity.switchShowIndicator = false;
        }
        if (!response.success) {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
        } else {
          entity.setAttribute(attrId, attrValue);
        }
      }
      setState(() {});
    });
  }

  void _setBindingEnabled(
      Binding binding, bool enabled, _BindingUiEntity uiEntity) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.setBindingEnable(homeCenterUuid, binding.uuid, enabled)
        .listen((response) {
      if (response is SetBindingEnableResponse) {
        uiEntity.switchShowIndicator = false;
        if (!response.success) {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + '${response.code}',
          );
        } else {
          binding.enabled = enabled;
        }
      }
      setState(() {});
    });
  }

  void _setControlEnabled(
      Binding binding, bool enabled, _ControlUiEntity uiEntity) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.setBindingEnable(homeCenterUuid, binding.uuid, enabled)
        .listen((response) {
      if (response is SetBindingEnableResponse) {
        uiEntity.switchShowIndicator = false;
        if (!response.success) {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + '${response.code}',
          );
        } else {
          binding.enabled = enabled;
        }
      }
      setState(() {});
    });
  }

  void displayAdjustTripDialog(String uuid) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(DefinedLocalizations.of(context).adjustCurtainDes),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).cancel,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).maybePop();
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).confirm,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).maybePop();
                  adjustCurtainTrip(uuid);
                },
              ),
            ],
          ),
    );
  }

  void adjustCurtainTrip(String uuid) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    final int attrId = ATTRIBUTE_ID_CURTAIN_TRIP_ADJUSTING;
    MqttProxy.writeAttribute(homeCenterUuid, uuid, attrId, 1)
        .listen((response) {
      if (response is WriteAttributeResponse) {
        if (response.success) {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).commondSent,
          );
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: widget.entity.getName(),
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(),
      itemCount: _itemCount(),
      itemBuilder: (BuildContext context, int index) {
        final Object obj = _getItem(index);
        if (obj is _Header) {
          return buildHeader(context, obj);
        } else if (obj is _GroupUiEntity) {
          return buildGroup(context, obj);
        } else if (obj is _ChildUiEntity) {
          return buildChildItem(context, obj);
        } else if (obj is _InputChildUiEntity) {
          return buildInputChildItem(context, obj);
        } else if (obj is _ControlUiEntity) {
          return buildControlItem(context, obj);
        } else if (obj is _BindingUiEntity) {
          return buildBindingItem(context, obj);
        } else if (obj is _SettingUiEntity) {
          return buildSettingItem(context, obj);
        } else if (obj is _AirCChildrenUiEntity) {
          return buildAirCChildrenItem(context, obj);
        } else if (obj is _IndoorUnitUiEntity) {
          return buildIndoorUnitItem(context, obj);
        } else {
          final _Footer footer = obj as _Footer;
          return buildFooter(context, footer);
        }
      },
    );
  }

  Widget buildHeader(BuildContext context, _Header header) {
    return DeviceImageView(
      deviceType: header.deviceType,
      entity: header.entity,
    );
  }

  Widget buildGroup(BuildContext context, _GroupUiEntity groupUiEntity) {
    return Container(
      padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 20.0, bottom: 5.0),
      child: Text(
        groupUiEntity.getLocaleDescription(context),
        style: TextStyle(
          inherit: false,
          color: Color(0xFF9B9B9B),
          fontSize: 14.0,
        ),
      ),
    );
  }

  Widget buildChildItem(BuildContext context, _ChildUiEntity childUiEntity) {
    return Container(
      margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
      padding: EdgeInsets.only(left: 20.0, right: 0.0, top: 5.0, bottom: 5.0),
      color: Color(0xFFF9F9F9),
      height: 85.0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    childUiEntity.childImageUrl,
                    width: childUiEntity.logicDevice.parent.isWallSwitchUS
                        ? 17.0
                        : childUiEntity.logicDevice.parent.isSwitchModule
                            ? 40.0
                            : 26.0,
                    height: childUiEntity.logicDevice.parent.isWallSwitchUS
                        ? 33.0
                        : childUiEntity.logicDevice.parent.isSwitchModule
                            ? 40.0
                            : 26.0,
                    gaplessPlayback: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                ),
                Text(
                  childUiEntity.logicDevice.getName(),
                  style: TextStyle(
                    inherit: false,
                    color: const Color(0xFF55585A),
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Offstage(
                  offstage: !childUiEntity.logicDevice.parent.available,
                  child: SwitchButton(
                    activeColor: Color(0xFF7CD0FF),
                    value: childUiEntity.logicDevice.onOffStatus ==
                        ON_OFF_STATUS_ON,
                    showIndicator: childUiEntity.switchShowIndicator,
                    showText: false,
                    onChanged: (bool value) {
                      childUiEntity.switchShowIndicator = true;
                      setState(() {});
                      final int attrId = ATTRIBUTE_ID_ON_OFF_STATUS;
                      final int attrValue =
                          1 - childUiEntity.logicDevice.onOffStatus;
                      _writeAttribute(childUiEntity.logicDevice, attrId,
                          attrValue, childUiEntity);
                    },
                  ),
                ),
                Offstage(
                  offstage: childUiEntity.logicDevice.parent.available,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        width: 10.0,
                        height: 10.0,
                        image: AssetImage('images/icon_offline.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                      ),
                      Text(
                        DefinedLocalizations.of(context).offline,
                        style: TextStyle(
                          inherit: false,
                          fontSize: 14.0,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  DeviceDetailPage(entity: childUiEntity.logicDevice),
              settings: RouteSettings(
                name: '/DeviceDetail',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAirCChildrenItem(
      BuildContext context, _AirCChildrenUiEntity airCChildrenUiEntity) {
    return Container(
      margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
      padding: EdgeInsets.only(left: 20.0, right: 0.0, top: 5.0, bottom: 5.0),
      color: Color(0xFFF9F9F9),
      height: 85.0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image(
                  image: AssetImage(airCChildrenUiEntity.childImageUrl),
                  height: Adapt.px(85),
                  width: Adapt.px(85),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                ),
                Text(
                  airCChildrenUiEntity.logicDevice.getName(),
                  style: TextStyle(
                    inherit: false,
                    color: const Color(0xFF55585A),
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(right: Adapt.px(30)),
              child: Image(
                width: 7.0,
                height: 11.0,
                image: AssetImage('images/icon_next.png'),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  DeviceDetailPage(entity: airCChildrenUiEntity.logicDevice),
              settings: RouteSettings(
                name: '/DeviceDetail',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildIndoorUnitItem(
      BuildContext context, _IndoorUnitUiEntity _indoorUnitUiEntity) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: Adapt.px(160),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Color(0x20101b25),
                        style: BorderStyle.solid,
                        width: 1))),
            margin: EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(40)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _indoorUnitUiEntity.getLeftName(context),
                  style: TextStyle(
                      color: Color(0x502d3b46), fontSize: Adapt.px(46)),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      _indoorUnitUiEntity.getIndoorUnitValue(context),
                      style: TextStyle(
                          color: Color(0x732D3B46), fontSize: Adapt.px(46)),
                    ),
                    Offstage(
                      offstage: _indoorUnitUiEntity.type == INDOOR_UNIT_NOW_TEM,
                      child: Padding(
                        padding: EdgeInsets.only(right: Adapt.px(15)),
                      ),
                    ),
                    Offstage(
                      offstage: _indoorUnitUiEntity.type == INDOOR_UNIT_NOW_TEM,
                      child: Image(
                        image: AssetImage("images/icon_next.png"),
                        width: 7.0,
                        height: 11.0,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          onTap: () {
            final String homeCenterUuid =
                HomeCenterManager().defaultHomeCenterUuid;
            final String uuid = widget.entity.uuid;
            if (_indoorUnitUiEntity.type == INDOOR_UNIT_ON_OFF) {
              //打开关闭
              pickerOnOff(context, homeCenterUuid, uuid);
            } else if (_indoorUnitUiEntity.type == INDOOR_UNIT_FLOW) {
              //风速
              pickerSpeed(context, homeCenterUuid, uuid);
            } else if (_indoorUnitUiEntity.type == INDOOR_UNIT_MODE) {
              //模式
              pickerMode(context, homeCenterUuid, uuid);
            } else if (_indoorUnitUiEntity.type == INDOOR_UNIT_TARGET_TEM) {
              //设定温度
              pickerTargetTem(context, homeCenterUuid, uuid);
            }
          },
        ),
      ],
    );
  }

  void pickerTargetTem(
      BuildContext context, String homeCenteruuid, String uuid) {
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: [
          "16°C",
          "17°C",
          "18°C",
          "19°C",
          "20°C",
          "21°C",
          "22°C",
          "23°C",
          "24°C",
          "25°C",
          "26°C",
          "27°C",
          "28°C",
          "29°C",
          "30°C"
        ]),
        selecteds: [selectTemp],
        columnPadding: EdgeInsets.all(0.0),
        cancelText: DefinedLocalizations.of(context).cancel,
        cancelTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        confirmText: DefinedLocalizations.of(context).confirm,
        confirmTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        hideHeader: false,
        title: Text(DefinedLocalizations.of(context).targetTemperture),
        onConfirm: (Picker picker, List value) {
          if (widget.entity
                  .getAttributeValue(ATTRIBUTE_ID_AC_TARGET_TEMPERATURE) ==
              value[0] + 16) return;
          MqttProxy.writeAttribute(homeCenteruuid, uuid,
                  ATTRIBUTE_ID_AC_TARGET_TEMPERATURE, value[0] + 16)
              .listen((response) {
            if (response is WriteAttributeResponse) {
              if (response.success) {
                selectTemp = value[0];
                Fluttertoast.showToast(
                  msg: DefinedLocalizations.of(context).commondSent,
                );
              } else {
                Fluttertoast.showToast(
                  msg: DefinedLocalizations.of(context).failed +
                      ': ${response.code}',
                );
              }
            }
          });
        }).showDialogXy(context);
  }

  void pickerMode(BuildContext context, String homeCenteruuid, String uuid) {
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: [
          DefinedLocalizations.of(context).indoorUnitModeRefrigeration,
          DefinedLocalizations.of(context).indoorUnitModeHot,
          DefinedLocalizations.of(context).indoorUnitModeDehumidification,
          DefinedLocalizations.of(context).indoorUnitModeVentilation
        ]),
        selecteds: [selectMode],
        columnPadding: EdgeInsets.all(0.0),
        cancelText: DefinedLocalizations.of(context).cancel,
        cancelTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        confirmText: DefinedLocalizations.of(context).confirm,
        confirmTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        hideHeader: false,
        title: Text(DefinedLocalizations.of(context).indoorUnitMode),
        onConfirm: (Picker picker, List value) {
          if (value[0] == selectMode) return;
          if (value[0] == 0) {
            print("--------1");
            MqttProxy.writeAttribute(
                    homeCenteruuid, uuid, ATTRIBUTE_ID_AC_WORK_MODE, 1)
                .listen((response) {
              if (response is WriteAttributeResponse) {
                if (response.success) {
                  selectMode = 0;
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).commondSent,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).failed +
                        ': ${response.code}',
                  );
                }
              }
            });
          } else if (value[0] == 1) {
            print("--------2");
            MqttProxy.writeAttribute(
                    homeCenteruuid, uuid, ATTRIBUTE_ID_AC_WORK_MODE, 8)
                .listen((response) {
              if (response is WriteAttributeResponse) {
                if (response.success) {
                  selectMode = 1;
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).commondSent,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).failed +
                        ': ${response.code}',
                  );
                }
              }
            });
          } else if (value[0] == 2) {
            print("--------3");
            MqttProxy.writeAttribute(
                    homeCenteruuid, uuid, ATTRIBUTE_ID_AC_WORK_MODE, 2)
                .listen((response) {
              if (response is WriteAttributeResponse) {
                if (response.success) {
                  selectMode = 2;
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).commondSent,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).failed +
                        ': ${response.code}',
                  );
                }
              }
            });
          } else if (value[0] == 3) {
            MqttProxy.writeAttribute(
                    homeCenteruuid, uuid, ATTRIBUTE_ID_AC_WORK_MODE, 4)
                .listen((response) {
              if (response is WriteAttributeResponse) {
                if (response.success) {
                  selectMode = 3;
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).commondSent,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).failed +
                        ': ${response.code}',
                  );
                }
              }
            });
          }
        }).showDialogXy(context);
  }

  void pickerSpeed(BuildContext context, String homeCenteruuid, String uuid) {
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: [
          DefinedLocalizations.of(context).intermediateSpeed,
          DefinedLocalizations.of(context).quickSpeed,
          DefinedLocalizations.of(context).lowSpeed
        ]),
        selecteds: [speedValue],
        columnPadding: EdgeInsets.all(0.0),
        cancelText: DefinedLocalizations.of(context).cancel,
        cancelTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        confirmText: DefinedLocalizations.of(context).confirm,
        confirmTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        hideHeader: false,
        title: Text(DefinedLocalizations.of(context).windSpeed),
        onConfirm: (Picker picker, List value) {
          if (value[0] == speedValue) return;
          if (value[0] == 0) {
            MqttProxy.writeAttribute(
                    homeCenteruuid, uuid, ATTRIBUTE_ID_AC_FAN_SPEED, 2)
                .listen((response) {
              if (response is WriteAttributeResponse) {
                if (response.success) {
                  speedValue = 0;
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).commondSent,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).failed +
                        ': ${response.code}',
                  );
                }
              }
            });
          } else if (value[0] == 1) {
            MqttProxy.writeAttribute(
                    homeCenteruuid, uuid, ATTRIBUTE_ID_AC_FAN_SPEED, 1)
                .listen((response) {
              if (response is WriteAttributeResponse) {
                if (response.success) {
                  speedValue = 1;
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).commondSent,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).failed +
                        ': ${response.code}',
                  );
                }
              }
            });
          } else if (value[0] == 2) {
            MqttProxy.writeAttribute(
                    homeCenteruuid, uuid, ATTRIBUTE_ID_AC_FAN_SPEED, 4)
                .listen((response) {
              if (response is WriteAttributeResponse) {
                if (response.success) {
                  speedValue = 2;
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).commondSent,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).failed +
                        ': ${response.code}',
                  );
                }
              }
            });
          }
        }).showDialogXy(context);
  }

  void pickerOnOff(BuildContext context, String homeCenteruuid, String uuid) {
    new Picker(
        adapter: PickerDataAdapter<String>(
            // pickerdata: new JsonDecoder().convert(PickerDataAngle),
            pickerdata: [
              DefinedLocalizations.of(context).close,
              DefinedLocalizations.of(context).open
            ]),
        selecteds: [onOffValue],
        columnPadding: EdgeInsets.all(0.0),
        cancelText: DefinedLocalizations.of(context).cancel,
        cancelTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        confirmText: DefinedLocalizations.of(context).confirm,
        confirmTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        hideHeader: false,
        title: Text(""),
        onConfirm: (Picker picker, List value) {
          if (value[0] == onOffValue) return;
          MqttProxy.writeAttribute(
                  homeCenteruuid, uuid, ATTRIBUTE_ID_ZHH_IS_RUNNING, value[0])
              .listen((response) {
            if (response is WriteAttributeResponse) {
              if (response.success) {
                onOffValue = value[0];
                Fluttertoast.showToast(
                  msg: DefinedLocalizations.of(context).commondSent,
                );
              } else {
                Fluttertoast.showToast(
                  msg: DefinedLocalizations.of(context).failed +
                      ': ${response.code}',
                );
              }
            }
          });
        }).showDialogXy(context);
  }

  Widget buildInputChildItem(
      BuildContext context, _InputChildUiEntity inputChildUiEntity) {
    return Container(
      margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
      padding: EdgeInsets.only(left: 20.0, right: 13.0, top: 5.0, bottom: 5.0),
      height: 85.0,
      color: Color(0xFFF9F9F9),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 40.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    inputChildUiEntity.childImageUrl,
                    width: inputChildUiEntity.logicDevice.parent.isWallSwitchUS
                        ? 17.0
                        : inputChildUiEntity.logicDevice.parent.isSwitchModule
                            ? 40.0
                            : 26.0,
                    height: inputChildUiEntity.logicDevice.parent.isWallSwitchUS
                        ? 33.0
                        : inputChildUiEntity.logicDevice.parent.isSwitchModule
                            ? 40.0
                            : 26.0,
                    gaplessPlayback: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                ),
                Text(
                  inputChildUiEntity.getLocaleDescription(context),
                  style: TextStyle(
                    inherit: false,
                    color: const Color(0xFF55585A),
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 13.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //SiwtchButton
                Offstage(
                  offstage: true,
                  child: SwitchButton(
                    activeColor: Color(0xFF7CD0FF),
                    value: false,
                    showIndicator: true,
                    showText: true,
                    onText: DefinedLocalizations.of(context).start,
                    offText: DefinedLocalizations.of(context).stop,
                    onChanged: (bool value) {
                      //TODO:
                      // bindingUiEntity.switchShowIndicator = true;
                      setState(() {});
                      // final bool enabled = !bindingUiEntity.binding.enabled;
                      // _setBindingEnabled(
                      //     bindingUiEntity.binding, enabled, bindingUiEntity);
                    },
                  ),
                ),
                //箭头
                Offstage(
                  offstage: false,
                  child: Image(
                    width: 7.0,
                    height: 11.0,
                    image: AssetImage('images/icon_next.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          final String triggerAddress = inputChildUiEntity.logicDevice.uuid;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeviceInputPage(
                  entity: inputChildUiEntity.logicDevice,
                  inputIndex: inputChildUiEntity.inputIndex),
            ),
          );
        },
      ),
    );
  }

  Widget buildBindingItem(
      BuildContext context, _BindingUiEntity bindingUiEntity) {
    final String methodName = 'buildBindingItem';
    final double paddingRight = bindingUiEntity.isBindingEmpty ? 13.0 : 0.0;
    if (bindingUiEntity.type == BINDING_TOP_LEFT_BUTTON ||
        bindingUiEntity.type == BINDING_TOP_RIGHT_BUTTON ||
        bindingUiEntity.type == BINDING_BOTTOM_RIGHT_BUTTON ||
        bindingUiEntity.type == BINDING_BOTTOM_LEFT_BUTTON ||
        bindingUiEntity.type == BINDING_FIRST_BUTTON ||
        bindingUiEntity.type == BINDING_SECOND_BUTTON ||
        bindingUiEntity.type == BINDING_THIRD_BUTTON) {
      return Container(
        margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
        padding:
            EdgeInsets.only(left: 20.0, right: 13.0, top: 5.0, bottom: 5.0),
        height: 85.0,
        color: Color(0xFFF9F9F9),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40.0,
                    alignment: Alignment.center,
                    child: Image.asset(
                      bindingUiEntity.bindingImageSingleUrl,
                      width: bindingUiEntity.logicDevice.parent.isWallSwitchUS
                          ? 17.0
                          : 26.0,
                      height: bindingUiEntity.logicDevice.parent.isWallSwitchUS
                          ? 33.0
                          : 26.0,
                      gaplessPlayback: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                  ),
                  Text(
                    bindingUiEntity.getBindingNameDescription(context),
                    style: TextStyle(
                      inherit: false,
                      color: const Color(0xFF55585A),
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 13.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //SiwtchButton
                  Offstage(
                    offstage: true,
                    child: SwitchButton(
                      activeColor: Color(0xFF7CD0FF),
                      value: bindingUiEntity.isBindingEnabled,
                      showIndicator: bindingUiEntity.switchShowIndicator,
                      showText: true,
                      onText: DefinedLocalizations.of(context).start,
                      offText: DefinedLocalizations.of(context).stop,
                      onChanged: (bool value) {
                        //TODO:
                        bindingUiEntity.switchShowIndicator = true;
                        setState(() {});
                        final bool enabled = !bindingUiEntity.binding.enabled;
                        _setBindingEnabled(
                            bindingUiEntity.binding, enabled, bindingUiEntity);
                      },
                    ),
                  ),
                  //箭头
                  Offstage(
                    offstage: false,
                    child: Image(
                      width: 7.0,
                      height: 11.0,
                      image: AssetImage('images/icon_next.png'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            final String triggerAddress = bindingUiEntity.logicDevice.uuid;
            int buttonType = BOTTOM_LEFT_BUTTON;
            if (bindingUiEntity.type == BINDING_TOP_LEFT_BUTTON) {
              buttonType = TOP_LEFT_BUTTON;
            } else if (bindingUiEntity.type == BINDING_TOP_RIGHT_BUTTON) {
              buttonType = TOP_RIGHT_BUTTON;
            } else if (bindingUiEntity.type == BINDING_BOTTOM_LEFT_BUTTON) {
              buttonType = BOTTOM_LEFT_BUTTON;
            } else if (bindingUiEntity.type == BINDING_BOTTOM_RIGHT_BUTTON) {
              buttonType = BOTTOM_RIGHT_BUTTON;
            } else if (bindingUiEntity.type == BINDING_FIRST_BUTTON) {
              buttonType = FIRST_BUTTON;
            } else if (bindingUiEntity.type == BINDING_SECOND_BUTTON) {
              buttonType = SECOND_BUTTON;
            } else if (bindingUiEntity.type == BINDING_THIRD_BUTTON) {
              buttonType = THIRD_BUTTON;
            }
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => WallSwitchBindingListPage(
                    buttonType: buttonType, triggerAddress: triggerAddress),
                settings: RouteSettings(
                  name: '/WallSwitchBindingList',
                ),
              ),
            );
          },
        ),
      );
    } else {
      final double paddingRight = bindingUiEntity.isBindingEmpty ? 13.0 : 0.0;
      return Container(
        padding: EdgeInsets.only(
            left: 10.0, right: paddingRight, top: 5.0, bottom: 5.0),
        margin: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0, right: 10.0),
        height: 85.0,
        color: Color(0xFFF9F9F9),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    width: 39.0,
                    height: 39.0,
                    image: AssetImage(bindingUiEntity.bindingImageLeftUrl),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3.0),
                  ),
                  Image(
                    width: 7.0,
                    height: 9.0,
                    image: AssetImage('images/binding_arrow.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3.0),
                  ),
                  Image(
                    width: 39.0,
                    height: 39.0,
                    image: AssetImage(bindingUiEntity.bindingImageRightUrl),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 0.4 * MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          bindingUiEntity.getBindingNameDescription(context),
                          style: TextStyle(
                            inherit: false,
                            color: Color(0xFFFFB34D),
                            fontSize: 16.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0),
                      ),
                      Container(
                        width: 0.4 * MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          bindingUiEntity.getBindingDescription(context),
                          style: TextStyle(
                            inherit: false,
                            color: Color(0x7F899198),
                            fontSize: 12.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //SwitchButton
                  Offstage(
                    offstage: bindingUiEntity.isBindingEmpty,
                    child: SwitchButton(
                      activeColor: Color(0xFF7CD0FF),
                      value: bindingUiEntity.isBindingEnabled,
                      showIndicator: bindingUiEntity.switchShowIndicator,
                      showText: true,
                      onText: bindingUiEntity.getOnText(context),
                      offText: bindingUiEntity.getOffText(context),
                      onChanged: (bool value) {
                        bindingUiEntity.switchShowIndicator = true;
                        setState(() {});
                        if (bindingUiEntity.type == BINDING_ALERT) {
                          //final String uuid = bindingUiEntity.logicDevice.uuid;
                          final int attrId = ATTRIBUTE_ID_ALERT_LEVEL;
                          final int attrValue =
                              1 - bindingUiEntity.logicDevice.alertLevel;
                          _writeAttribute(bindingUiEntity.logicDevice, attrId,
                              attrValue, bindingUiEntity);
                        } else if (bindingUiEntity.type == BINDING_OPEN_CLOSE ||
                            bindingUiEntity.type == BINDING_AWARENESS_SWITCH ||
                            bindingUiEntity.type == BINDING_SD_ROTATE) {
                          //final String uuid = bindingUiEntity.binding.uuid;
                          final bool enabled = !bindingUiEntity.binding.enabled;
                          _setBindingEnabled(bindingUiEntity.binding, enabled,
                              bindingUiEntity);
                        }
                      },
                    ),
                  ),
                  //箭头
                  Offstage(
                    offstage: !bindingUiEntity.isBindingEmpty,
                    child: Image(
                      width: 7.0,
                      height: 11.0,
                      image: AssetImage('images/icon_next.png'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            if (bindingUiEntity.type == BINDING_TIMER ||
                bindingUiEntity.type == BINDING_COUNT_COWN) {
              Fluttertoast.showToast(
                msg: DefinedLocalizations.of(context).notSurpport,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            } else if (bindingUiEntity.type == BINDING_OPEN_CLOSE ||
                bindingUiEntity.type == BINDING_AWARENESS_SWITCH ||
                bindingUiEntity.type == BINDING_SD_ROTATE) {
              final Binding binding = bindingUiEntity.binding;
              final String triggerAddress = bindingUiEntity.logicDevice.uuid;
              int bindingType;
              if (bindingUiEntity.type == BINDING_OPEN_CLOSE) {
                bindingType = BINDING_TYPE_OPEN_CLOSE;
              } else if (bindingUiEntity.type == BINDING_SD_ROTATE) {
                bindingType = BINDING_TYPE_SMART_DIAL;
              } else {
                bindingType = BINDING_TYPE_PIR;
              }
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => BindingSettingPage(
                        binding: binding,
                        bindingType: bindingType,
                        triggerAddress: triggerAddress,
                        containsOnOffDevice: true,
                        containsCurtain:
                            bindingUiEntity.type == BINDING_SD_ROTATE,
                      ),
                  settings: RouteSettings(
                    name: '/BindingSetting',
                  ),
                ),
              );
            } else if (bindingUiEntity.type == BINDING_CLICK ||
                bindingUiEntity.type == BINDING_DOUBLE_CLICK) {
              final String triggerAddress = bindingUiEntity.logicDevice.uuid;
              final parameter = (bindingUiEntity.type == BINDING_CLICK) ? 1 : 2;
              final int keyPressType = bindingUiEntity.logicDevice.isSmartDial
                  ? KEY_PRESS_TYPE_KB
                  : KEY_PRESS_TYPE_PIR;
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) => KeyPressBindingListPage(
                        triggerAddress: triggerAddress,
                        parameter: parameter,
                        keyPressType: keyPressType,
                      ),
                  settings: RouteSettings(
                    name: '/KeyPressBindingList',
                  ),
                ),
              );
            }
          },
        ),
      );
    }
  }

  Widget buildControlItem(
      BuildContext context, _ControlUiEntity controlUiEntity) {
    final String methodName = 'buildControlItem';
    // final double paddingRight = controlUiEntity.isBindingEmpty ? 13.0 : 0.0;
    // if (controlUiEntity.type == BINDING_TOP_LEFT_BUTTON ||
    //     controlUiEntity.type == BINDING_TOP_RIGHT_BUTTON ||
    //     controlUiEntity.type == BINDING_BOTTOM_RIGHT_BUTTON ||
    //     controlUiEntity.type == BINDING_BOTTOM_LEFT_BUTTON ||
    //     controlUiEntity.type == BINDING_FIRST_BUTTON ||
    //     controlUiEntity.type == BINDING_SECOND_BUTTON ||
    //     controlUiEntity.type == BINDING_THIRD_BUTTON) {
    //   return Container(
    //     margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
    //     // padding:
    //         // EdgeInsets.only(left: 20.0, right: 13.0, top: 5.0, bottom: 5.0),
    //     height: 85.0,
    //     color: Color(0xFFF9F9F9),
    //     child: GestureDetector(
    //       behavior: HitTestBehavior.opaque,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               Container(
    //                 width: 40.0,
    //                 alignment: Alignment.center,
    //                 child: Image.asset(
    //                   controlUiEntity.bindingImageSingleUrl,
    //                   width: controlUiEntity.logicDevice.parent.isWallSwitchUS
    //                       ? 17.0
    //                       : 26.0,
    //                   height: controlUiEntity.logicDevice.parent.isWallSwitchUS
    //                       ? 33.0
    //                       : 26.0,
    //                   gaplessPlayback: true,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(left: Adapt.px(35)),
    //               ),
    //               Text(
    //                 controlUiEntity.getBindingNameDescription(context),
    //                 style: TextStyle(
    //                   inherit: false,
    //                   color: const Color(0xFF55585A),
    //                   fontSize: 16.0,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Padding(
    //             padding: EdgeInsets.only(right: Adapt.px(15)),
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    //               //SiwtchButton
    //               Offstage(
    //                 offstage: true,
    //                 child: SwitchButton(
    //                   activeColor: Color(0xFF7CD0FF),
    //                   value: controlUiEntity.isBindingEnabled,
    //                   showIndicator: controlUiEntity.switchShowIndicator,
    //                   showText: true,
    //                   onText: DefinedLocalizations.of(context).start,
    //                   offText: DefinedLocalizations.of(context).stop,
    //                   onChanged: (bool value) {
    //                     //TODO:
    //                     controlUiEntity.switchShowIndicator = true;
    //                     setState(() {});
    //                     final bool enabled = !controlUiEntity.binding.enabled;
    //                     _setControlEnabled(
    //                         controlUiEntity.binding, enabled, controlUiEntity);
    //                   },
    //                 ),
    //               ),
    //               //箭头
    //               Offstage(
    //                 offstage: false,
    //                 child: Image(
    //                   width: 7.0,
    //                   height: 11.0,
    //                   image: AssetImage('images/icon_next.png'),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //       onTap: () {
    //         final String triggerAddress = controlUiEntity.logicDevice.uuid;
    //         int buttonType = BOTTOM_LEFT_BUTTON;
    //         if (controlUiEntity.type == BINDING_TOP_LEFT_BUTTON) {
    //           buttonType = TOP_LEFT_BUTTON;
    //         } else if (controlUiEntity.type == BINDING_TOP_RIGHT_BUTTON) {
    //           buttonType = TOP_RIGHT_BUTTON;
    //         } else if (controlUiEntity.type == BINDING_BOTTOM_LEFT_BUTTON) {
    //           buttonType = BOTTOM_LEFT_BUTTON;
    //         } else if (controlUiEntity.type == BINDING_BOTTOM_RIGHT_BUTTON) {
    //           buttonType = BOTTOM_RIGHT_BUTTON;
    //         } else if (controlUiEntity.type == BINDING_FIRST_BUTTON) {
    //           buttonType = FIRST_BUTTON;
    //         } else if (controlUiEntity.type == BINDING_SECOND_BUTTON) {
    //           buttonType = SECOND_BUTTON;
    //         } else if (controlUiEntity.type == BINDING_THIRD_BUTTON) {
    //           buttonType = THIRD_BUTTON;
    //         }
    //         Navigator.of(context).push(
    //           CupertinoPageRoute(
    //             builder: (context) => WallSwitchBindingListPage(
    //                 buttonType: buttonType, triggerAddress: triggerAddress),
    //             settings: RouteSettings(
    //               name: '/WallSwitchBindingList',
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   );
    // // } else {
    //   // final double paddingRight = controlUiEntity.isBindingEmpty ? 13.0 : 0.0;
    return Container(
      padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
      margin: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0, right: 10.0),
      height: 85.0,
      color: Color(0xFFF9F9F9),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  width: 39.0,
                  height: 39.0,
                  image: AssetImage(controlUiEntity.bindingImageLeftUrl),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.0),
                ),
                Image(
                  width: 7.0,
                  height: 9.0,
                  image: AssetImage('images/binding_arrow.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.0),
                ),
                Image(
                  width: 39.0,
                  height: 39.0,
                  image: AssetImage(controlUiEntity.bindingImageRightUrl),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Adapt.px(340),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        controlUiEntity.getBindingNameDescription(context),
                        style: TextStyle(
                          inherit: false,
                          color: Color(0xFFFFB34D),
                          fontSize: 16.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    Container(
                      width: Adapt.px(340),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        controlUiEntity.getBindingDescription(context),
                        style: TextStyle(
                          inherit: false,
                          color: Color(0x7F899198),
                          fontSize: 12.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SwitchButton(
              activeColor: Color(0xFF7CD0FF),
              value: controlUiEntity.isBindingEnabled,
              showIndicator: controlUiEntity.switchShowIndicator,
              showText: true,
              onText: controlUiEntity.getOnText(context),
              offText: controlUiEntity.getOffText(context),
              onChanged: (bool value) {
                controlUiEntity.switchShowIndicator = true;
                setState(() {});
                if (controlUiEntity.type == BINDING_ALERT) {
                  //final String uuid = controlUiEntity.logicDevice.uuid;
                  final int attrId = ATTRIBUTE_ID_ALERT_LEVEL;
                  final int attrValue =
                      1 - controlUiEntity.logicDevice.alertLevel;
                  _writeAttribute(controlUiEntity.logicDevice, attrId,
                      attrValue, controlUiEntity);
                } else if (controlUiEntity.type == BINDING_OPEN_CLOSE ||
                    controlUiEntity.type == BINDING_AWARENESS_SWITCH ||
                    controlUiEntity.type == BINDING_SD_ROTATE) {
                  //final String uuid = controlUiEntity.binding.uuid;
                  final bool enabled = !controlUiEntity.binding.enabled;
                  _setControlEnabled(
                      controlUiEntity.binding, enabled, controlUiEntity);
                }
              },
            ),
          ],
        ),
        onTap: () {
          if (controlUiEntity.type == BINDING_TIMER ||
              controlUiEntity.type == BINDING_COUNT_COWN) {
            Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).notSurpport,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
          } else if (controlUiEntity.type == BINDING_OPEN_CLOSE ||
              controlUiEntity.type == BINDING_AWARENESS_SWITCH ||
              controlUiEntity.type == BINDING_SD_ROTATE) {
            final Binding binding = controlUiEntity.binding;
            final String triggerAddress = controlUiEntity.logicDevice.uuid;
            int bindingType;
            if (controlUiEntity.type == BINDING_OPEN_CLOSE) {
              bindingType = BINDING_TYPE_OPEN_CLOSE;
            } else if (controlUiEntity.type == BINDING_SD_ROTATE) {
              bindingType = BINDING_TYPE_SMART_DIAL;
            } else {
              bindingType = BINDING_TYPE_PIR;
            }
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => BindingSettingPage(
                      binding: binding,
                      bindingType: bindingType,
                      triggerAddress: triggerAddress,
                      containsOnOffDevice: true,
                      containsCurtain:
                          controlUiEntity.type == BINDING_SD_ROTATE,
                    ),
                settings: RouteSettings(
                  name: '/BindingSetting',
                ),
              ),
            );
          } else if (controlUiEntity.type == BINDING_CLICK ||
              controlUiEntity.type == BINDING_DOUBLE_CLICK) {
            final String triggerAddress = controlUiEntity.logicDevice.uuid;
            final parameter = (controlUiEntity.type == BINDING_CLICK) ? 1 : 2;
            final int keyPressType = controlUiEntity.logicDevice.isSmartDial
                ? KEY_PRESS_TYPE_KB
                : KEY_PRESS_TYPE_PIR;
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (BuildContext context) => KeyPressBindingListPage(
                      triggerAddress: triggerAddress,
                      parameter: parameter,
                      keyPressType: keyPressType,
                    ),
                settings: RouteSettings(
                  name: '/KeyPressBindingList',
                ),
              ),
            );
          }
        },
      ),
    );
    // }
  }

  Widget buildSettingItem(
      BuildContext context, _SettingUiEntity settingUiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 53.0,
        padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 0.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 51.0,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    settingUiEntity.getLocaleDescription(context),
                    style: TEXT_STYLE_INFORMATION_TYPE,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      //名称区域
                      Text(
                        settingUiEntity.getContent(context),
                        style: TEXT_STYLE_INFORMATION_CONTENT,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                      ),
                      Image(
                        width: 7.0,
                        height: 11.0,
                        image: AssetImage('images/icon_next.png'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 2.0,
              color: Color(0x33000000),
            ),
          ],
        ),
      ),
      onTap: () {
        if (settingUiEntity.type == SETTING_NAME) {
          print('push to set name page');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetNamePage(
                    entity: settingUiEntity.entity,
                  ),
              //SetNamePage.initWithEntity(settingUiEntity.entity),
            ),
          );
        } else if (settingUiEntity.type == SETTING_AREA) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetRoomPage(entity: settingUiEntity.entity),
            ),
          );
        } else if (settingUiEntity.type == SETTING_OTHERS) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DeviceInformationsPage(entity: settingUiEntity.entity),
            ),
          );
        } else if (settingUiEntity.type == SETTING_TYPE) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (BuildContext context) => SetCurtainTypePage(
                    originType: settingUiEntity.entity.curtainType,
                    isAdding: false,
                    uuid: settingUiEntity.entity.uuid,
                  ),
              settings: RouteSettings(
                name: '/SetCurtainType',
              ),
            ),
          );
        } else if (settingUiEntity.type == SETTING_DIRECTION) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (BuildContext context) => SetCurtainDirectionPage(
                    curtainType: settingUiEntity.entity.curtainType,
                    originDirection: settingUiEntity.entity.curtainDirection,
                    isAdding: false,
                    uuid: settingUiEntity.entity.uuid,
                  ),
              settings: RouteSettings(
                name: '/SetCurtainDirection',
              ),
            ),
          );
        } else if (settingUiEntity.type == SETTING_TRIP_ADJUSTED) {
          displayAdjustTripDialog(settingUiEntity.entity.uuid);
        }
      },
    );
  }

  Widget buildFooter(BuildContext context, _Footer footer) {
    return Container(
      margin: EdgeInsets.only(top: 136.0, bottom: 62.0),
      alignment: Alignment.center,
      child: CupertinoButton(
        child: Text(
          DefinedLocalizations.of(context).delete,
          style: TEXT_STYLE_DELETE_BUTTON,
        ),
        color: Color(0xFFFF8443),
        pressedOpacity: 0.8,
        borderRadius: BorderRadius.circular(22.0),
        padding: EdgeInsets.only(left: 90.0, right: 90.0),
        onPressed: () {
          showDialog(
            context: context,
            child: CupertinoAlertDialog(
              title: Text(
                DefinedLocalizations.of(context).sureToDeleteDevice,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    DefinedLocalizations.of(context).cancel,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).maybePop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    DefinedLocalizations.of(context).delete,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).maybePop();
                    _deleteDevice(context, footer.entity.uuid);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

abstract class _Group {
  int size() {
    return 0;
  }

  Object get(int index) {
    return Object();
  }
}

class _Header extends _Group {
  Entity entity;

  _Header({
    @required this.entity,
  });

  //0 - light socket/wall switch light, 1 - plug, 2 - pir, 3 - door contact, 4 - curtain, 5 - wall switch
  int get deviceType {
    if (entity is PhysicDevice) {
      final PhysicDevice pd = entity as PhysicDevice;
      if (pd.isWallSwitch) return IMAGE_WALL_SWITCH;
      if (pd.isWallSwitchUS) return IMAGE_WALL_SWITCH;
      if (pd.isSwitchModule) return IMAGE_SWITCH_MODULE;
      if (pd.isZHHVRVGateway) return ICON_AIR_CONDITIONER;
    } else if (entity is LogicDevice) {
      final LogicDevice ld = entity as LogicDevice;
      if (ld.isOnOffLight) return IMAGE_LIGHT;
      if (ld.isSmartPlug) return IMAGE_PLUG;
      if (ld.isAwarenessSwitch) return IMAGE_AWARENESS_SWITCH;
      if (ld.isDoorContact) return IMAGE_DOOR_SENSOR;
      if (ld.isCurtain) return IMAGE_CURTAIN;
      if (ld.isSmartDial) return IMAGE_SMART_DIAL;
      if (ld.isIndoorUnit) return ICON_INDOOR_UNIT;
    }
    return IMAGE_UNKNOWN;
  }
}

class _ChildrenGroup extends _Group {
  final List<_UiEntity> _uiEntities = List();
  List<_UiEntity> get uiEntities {
    _uiEntities.sort((a, b) {
      if (a is _GroupUiEntity) return -1;
      if (b is _GroupUiEntity) return 1;
      final _ChildUiEntity childA = a as _ChildUiEntity;
      final _ChildUiEntity childB = b as _ChildUiEntity;
      return childA.logicDevice.uuid.compareTo(childB.logicDevice.uuid);
    });
    return _uiEntities;
  }

  void init() {
    _uiEntities.add(_GroupUiEntity(type: _GroupUiEntity.CHILD));
  }

  void clear() {
    _uiEntities.clear();
  }

  int size() {
    return _uiEntities.length > 1 ? _uiEntities.length : 0;
  }

  void add(LogicDevice logicDevice) {
    _uiEntities.add(
      _ChildUiEntity(logicDevice: logicDevice),
    );
  }

  Object get(int index) => uiEntities[index];
}

class _AirCChildrenGroup extends _Group {
  final List<_UiEntity> _uiEntities = List();
  List<_UiEntity> get uiEntities {
    _uiEntities.sort((a, b) {
      if (a is _GroupUiEntity) return -1;
      if (b is _GroupUiEntity) return 1;
      final _AirCChildrenUiEntity childA = a as _AirCChildrenUiEntity;
      final _AirCChildrenUiEntity childB = b as _AirCChildrenUiEntity;
      return childA.logicDevice.uuid.compareTo(childB.logicDevice.uuid);
    });
    return _uiEntities;
  }

  void init() {
    _uiEntities.add(_GroupUiEntity(type: _GroupUiEntity.CHILD));
  }

  void clear() {
    _uiEntities.clear();
  }

  int size() {
    return _uiEntities.length > 1 ? _uiEntities.length : 0;
  }

  void add(LogicDevice logicDevice) {
    _uiEntities.add(
      _AirCChildrenUiEntity(logicDevice: logicDevice),
    );
  }

  Object get(int index) => uiEntities[index];
}

class _IndoorUnitGroup extends _Group {
  final List<_UiEntity> _uiEntities = List();
  List<_UiEntity> get uiEntities {
    _uiEntities.sort((a, b) {
      if (a is _GroupUiEntity) return -1;
      if (b is _GroupUiEntity) return 1;
      final _IndoorUnitUiEntity childA = a as _IndoorUnitUiEntity;
      final _IndoorUnitUiEntity childB = b as _IndoorUnitUiEntity;
      return childA.logicDevice.uuid.compareTo(childB.logicDevice.uuid);
    });
    return _uiEntities;
  }

  void init() {
    _uiEntities.add(_GroupUiEntity(type: _GroupUiEntity.CHILD));
  }

  void clear() {
    _uiEntities.clear();
  }

  int size() {
    return _uiEntities.length > 0 ? _uiEntities.length : 0;
  }

  void add(LogicDevice logicDevice, int type) {
    _uiEntities.add(
      _IndoorUnitUiEntity(logicDevice: logicDevice, type: type),
    );
  }

  Object get(int index) => uiEntities[index];
}

class _InputChildrenGroup extends _Group {
  final List<_UiEntity> _uiEntities = List();
  List<_UiEntity> get uiEntities {
    _uiEntities.sort((a, b) {
      if (a is _GroupUiEntity) return -1;
      if (b is _GroupUiEntity) return 1;
      final _InputChildUiEntity childA = a as _InputChildUiEntity;
      final _InputChildUiEntity childB = b as _InputChildUiEntity;
      return childA.logicDevice.uuid.compareTo(childB.logicDevice.uuid);
    });
    return _uiEntities;
  }

  void init() {
    _uiEntities.add(_GroupUiEntity(type: _GroupUiEntity.INPUT));
  }

  void clear() {
    _uiEntities.clear();
  }

  int size() {
    return _uiEntities.length > 1 ? _uiEntities.length : 0;
  }

  void add(LogicDevice logicDevice) {
    _uiEntities.add(
      _InputChildUiEntity(logicDevice: logicDevice),
    );
  }

  Object get(int index) => uiEntities[index];
}

class _BindingGroup extends _Group {
  final List<_UiEntity> _uiEntities = List();
  List<_UiEntity> get uiEntities {
    // _uiEntities.sort((a, b) {
    //   if (a is _GroupUiEntity) return -1;
    //   if (b is _GroupUiEntity) return 1;
    //   final _BindingUiEntity bindingA = a as _BindingUiEntity;
    //   final _BindingUiEntity bindingB = b as _BindingUiEntity;
    //   return bindingA.type.compareTo(bindingB.type);
    // });
    return _uiEntities;
  }

  void init() {
    _uiEntities.add(_GroupUiEntity(type: _GroupUiEntity.BINDING));
  }

  void clear() {
    _uiEntities.clear();
  }

  int size() {
    return _uiEntities.length > 1 ? _uiEntities.length : 0;
  }

  void add(LogicDevice logicDevice, int type) {
    _uiEntities.add(
      _BindingUiEntity(
        logicDevice: logicDevice,
        type: type,
      ),
    );
  }

  void addBinding(Binding binding) {
    for (var uiEntity in _uiEntities) {
      if (uiEntity is _GroupUiEntity) continue;
      final _BindingUiEntity bindingUiEntity = uiEntity as _BindingUiEntity;
      bindingUiEntity.addBinding(binding);
    }
  }

  Object get(int index) => uiEntities[index];
}

class _ControlGroup extends _Group {
  final List<_UiEntity> _uiEntities = List();
  List<_UiEntity> get uiEntities {
    return _uiEntities;
  }

  void init() {
    _uiEntities.add(_GroupUiEntity(type: _GroupUiEntity.CONTROL));
  }

  void clear() {
    _uiEntities.clear();
  }

  int size() {
    return _uiEntities.length > 1 ? _uiEntities.length : 0;
  }

  void add(LogicDevice logicDevice, int type) {
    _uiEntities.add(
      _ControlUiEntity(
        logicDevice: logicDevice,
        type: type,
      ),
    );
  }

  // void addBinding(Binding binding) {
  //   for (var uiEntity in _uiEntities) {
  //     if (uiEntity is _GroupUiEntity) continue;
  //     final _ControlUiEntity controlUiEntity = uiEntity as _ControlUiEntity;
  //     controlUiEntity.addBinding(binding);
  //   }
  // }

  Object get(int index) => uiEntities[index];
}

class _SettingGroup extends _Group {
  final List<_UiEntity> _uiEntities = List();

  void init() {
    _uiEntities.add(
      _GroupUiEntity(type: _GroupUiEntity.SETTING),
    );
  }

  void clear() {
    _uiEntities.clear();
  }

  int size() {
    return _uiEntities.length > 1 ? _uiEntities.length : 0;
  }

  void add(Entity entity, int type) {
    _uiEntities.add(
      _SettingUiEntity(
        entity: entity,
        type: type,
      ),
    );
  }

  Object get(int index) => _uiEntities[index];
}

class _Footer extends _Group {
  final Entity entity;

  _Footer({
    @required this.entity,
  });
}

abstract class _UiEntity {}

class _GroupUiEntity extends _UiEntity {
  static const int CHILD = 0;
  static const int BINDING = 1;
  static const int SETTING = 2;
  static const int INPUT = 3;
  static const int CONTROL = 4;

  final int type;

  _GroupUiEntity({
    @required this.type,
  });

  String getLocaleDescription(BuildContext context) {
    switch (type) {
      case CHILD:
        return DefinedLocalizations.of(context).lights;
      case INPUT:
        return DefinedLocalizations.of(context).input;
      case BINDING:
        return DefinedLocalizations.of(context).binding;
      case SETTING:
        return DefinedLocalizations.of(context).setting;
      case CONTROL:
        return "控制";
      default:
        return '';
    }
  }
}

//用于显示墙壁开关的灯座
class _ChildUiEntity extends _UiEntity {
  final LogicDevice logicDevice;

  _ChildUiEntity({
    @required this.logicDevice,
  });

  bool switchShowIndicator = false;

  String get childImageUrl {
    if (logicDevice.parent.isWallSwitch) {
      if (logicDevice.uuid.endsWith('-01')) {
        if (logicDevice.parent.available) {
          return logicDevice.onOffStatus == ON_OFF_STATUS_ON
              ? 'images/icon_ws_lt_on.png'
              : 'images/icon_ws_lt_off.png';
        } else {
          return 'images/icon_ws_lt_offline.png';
        }
      } else if (logicDevice.uuid.endsWith('-02')) {
        if (logicDevice.parent.available) {
          return logicDevice.onOffStatus == ON_OFF_STATUS_ON
              ? 'images/icon_ws_rt_on.png'
              : 'images/icon_ws_rt_off.png';
        } else {
          return 'images/icon_ws_rt_offline.png';
        }
      } else if (logicDevice.uuid.endsWith('-04')) {
        if (logicDevice.parent.available) {
          return logicDevice.onOffStatus == ON_OFF_STATUS_ON
              ? 'images/icon_ws_rb_on.png'
              : 'images/icon_ws_rb_off.png';
        } else {
          return 'images/icon_ws_rb_offline.png';
        }
      } else if (logicDevice.uuid.endsWith('-03')) {
        if (logicDevice.parent.available) {
          return logicDevice.onOffStatus == ON_OFF_STATUS_ON
              ? 'images/icon_ws_lb_on.png'
              : 'images/icon_ws_lb_off.png';
        } else {
          return 'images/icon_ws_lb_offline.png';
        }
      }
    } else if (logicDevice.parent.isWallSwitchUS) {
      if (logicDevice.parent.available) {
        return logicDevice.onOffStatus == ON_OFF_STATUS_ON
            ? 'images/icon_ws_us_m_on.png'
            : 'images/icon_ws_us_m_off.png';
      } else {
        return 'images/icon_ws_m_offline.png';
      }
    } else if (logicDevice.parent.isSwitchModule) {
      if (logicDevice.uuid.endsWith('-01')) {
        return 'images/icon_sm_output1.png';
      } else if (logicDevice.uuid.endsWith('-02')) {
        return 'images/icon_sm_output2.png';
      }
    } else if (logicDevice.parent.isZHHVRVGateway) {
      return 'images/dev_icon_air_conditioner_on.png';
    }
    return 'images/icon_ws_lt_on.png';
  }
}

class _AirCChildrenUiEntity extends _UiEntity {
  final LogicDevice logicDevice;

  _AirCChildrenUiEntity({
    @required this.logicDevice,
  });

  bool switchShowIndicator = false;

  String get childImageUrl {
    if (logicDevice.parent.isZHHVRVGateway) {
      if (logicDevice.parent.available)
        return 'images/dev_icon_air_conditioner_on.png';
      return 'images/dev_icon_air_conditioner_on.png';
    }
    return 'images/dev_icon_air_conditioner_on.png';
  }
}

const int INDOOR_UNIT_ON_OFF = 0;
const int INDOOR_UNIT_FLOW = 1;
const int INDOOR_UNIT_MODE = 2;
const int INDOOR_UNIT_NOW_TEM = 3;
const int INDOOR_UNIT_TARGET_TEM = 4;

class _IndoorUnitUiEntity extends _UiEntity {
  final LogicDevice logicDevice;
  final int type;

  _IndoorUnitUiEntity({@required this.logicDevice, this.type});

  bool switchShowIndicator = false;

  String get childImageUrl {
    if (logicDevice.parent.isZHHVRVGateway) {
      if (logicDevice.parent.available)
        return 'images/dev_icon_air_conditioner_on.png';
      return 'images/dev_icon_air_conditioner_on.png';
    }
    return 'images/dev_icon_air_conditioner_on.png';
  }

  String getIndoorUnitValue(BuildContext context) {
    switch (type) {
      case INDOOR_UNIT_ON_OFF:
        return logicDevice.getAttributeValue(ATTRIBUTE_ID_ZHH_IS_RUNNING) == 0
            ? DefinedLocalizations.of(context).close
            : DefinedLocalizations.of(context).open;

        break;
      case INDOOR_UNIT_NOW_TEM:
        return logicDevice
                .getAttributeValue(ATTRIBUTE_ID_AC_CURRENT_TEMPERATURE)
                .toString() +
            "°C";
        break;
      case INDOOR_UNIT_FLOW:
        var speed = logicDevice.getAttributeValue(ATTRIBUTE_ID_AC_FAN_SPEED);
        if (speed == AIR_CONDITION_SPEED_LOW) {
          return DefinedLocalizations.of(context).lowSpeed;
        } else if (speed == AIR_CONDITION_SPEED_INTERMEDIATE) {
          return DefinedLocalizations.of(context).intermediateSpeed;
        } else {
          return DefinedLocalizations.of(context).quickSpeed;
        }
        break;
      case INDOOR_UNIT_MODE:
        var mode = logicDevice.getAttributeValue(ATTRIBUTE_ID_AC_WORK_MODE);
        if (mode == MODE_HEATING) {
          return DefinedLocalizations.of(context).indoorUnitModeHot;
        } else if (mode == MODE_REFRIGERATION) {
          return DefinedLocalizations.of(context).indoorUnitModeRefrigeration;
        } else if (mode == MODE_DEHUMIDIFICATION) {
          return DefinedLocalizations.of(context)
              .indoorUnitModeDehumidification;
        } else {
          return DefinedLocalizations.of(context).indoorUnitModeVentilation;
        }
        break;
      case INDOOR_UNIT_TARGET_TEM:
        return logicDevice
                .getAttributeValue(ATTRIBUTE_ID_AC_TARGET_TEMPERATURE)
                .toString() +
            "°C";
        break;
      default:
        return "";
    }
  }

  String getLeftName(BuildContext context) {
    switch (type) {
      case INDOOR_UNIT_ON_OFF:
        return DefinedLocalizations.of(context).indoorUnitOnOff;
        break;
      case INDOOR_UNIT_NOW_TEM:
        return DefinedLocalizations.of(context).currentTemperture;
        break;
      case INDOOR_UNIT_FLOW:
        return DefinedLocalizations.of(context).windSpeed;
        break;
      case INDOOR_UNIT_MODE:
        return DefinedLocalizations.of(context).indoorUnitMode;
        break;
      case INDOOR_UNIT_TARGET_TEM:
        return DefinedLocalizations.of(context).targetTemperture;
        break;
      default:
        return "";
    }
  }
}

class _InputChildUiEntity extends _UiEntity {
  final LogicDevice logicDevice;
  int inputIndex;

  _InputChildUiEntity({
    @required this.logicDevice,
  }) {
    if (logicDevice.uuid.endsWith('-01')) {
      inputIndex = 0;
    } else if (logicDevice.uuid.endsWith('-02')) {
      inputIndex = 1;
    } else if (logicDevice.uuid.endsWith('-03')) {
      inputIndex = 2;
    } else if (logicDevice.uuid.endsWith('-04')) {
      inputIndex = 3;
    }
  }

  bool switchShowIndicator = false;

  String getLocaleDescription(BuildContext context) {
    return "${DefinedLocalizations.of(context).input} ${inputIndex + 1}";
  }

  String get childImageUrl {
    if (logicDevice.parent.isSwitchModule) {
      if (logicDevice.uuid.endsWith('-01')) {
        return 'images/inputL.png';
      } else if (logicDevice.uuid.endsWith('-02')) {
        return 'images/inputR.png';
      }
    }
    if (logicDevice.parent.isWallSwitch) {
      if (logicDevice.uuid.endsWith('-01')) {
        return 'images/wall_switch_binding_left_top.png';
      } else if (logicDevice.uuid.endsWith('-02')) {
        return 'images/wall_switch_binding_top.png';
      } else if (logicDevice.uuid.endsWith('-03')) {
        return 'images/wall_switch_binding_left.png';
      } else if (logicDevice.uuid.endsWith('-04')) {
        return 'images/wall_switch_binding_right.png';
      }
    }
    return '';
  }
}

const int BINDING_ALERT = 0;
const int BINDING_TIMER = 1;
const int BINDING_COUNT_COWN = 2;
const int BINDING_CLICK = 3;
const int BINDING_DOUBLE_CLICK = 10;
const int BINDING_AWARENESS_SWITCH = 4;
const int BINDING_OPEN_CLOSE = 5;
const int BINDING_TOP_RIGHT_BUTTON = 6;
const int BINDING_BOTTOM_LEFT_BUTTON = 7;
const int BINDING_BOTTOM_RIGHT_BUTTON = 8;
const int BINDING_TOP_LEFT_BUTTON = 9;
const int BINDING_SD_ROTATE = 11;
const int BINDING_FIRST_BUTTON = 12;
const int BINDING_SECOND_BUTTON = 13;
const int BINDING_THIRD_BUTTON = 14;

class _BindingUiEntity extends _UiEntity {
  final LogicDevice logicDevice;
  final int type;

  bool switchShowIndicator = false;

  List<Binding> _bindings = List();
  List<Binding> get bindings => _bindings;
  Binding get binding {
    if (bindings.isEmpty) return null;
    return bindings[0];
  }

  _BindingUiEntity({
    @required this.logicDevice,
    @required this.type,
  });

  void addBinding(Binding binding) {
    if (binding.triggerAddress != logicDevice.uuid) return;
    //_binding = binding;
    switch (binding.bindingType) {
      case BINDING_TYPE_KEY_PRESS:
        if (type == BINDING_CLICK ||
            type == BINDING_DOUBLE_CLICK ||
            type == BINDING_TOP_LEFT_BUTTON ||
            type == BINDING_BOTTOM_LEFT_BUTTON ||
            type == BINDING_BOTTOM_RIGHT_BUTTON ||
            type == BINDING_FIRST_BUTTON ||
            type == BINDING_SECOND_BUTTON ||
            type == BINDING_THIRD_BUTTON) {
          _bindings.add(binding);
        }
        break;
      case BINDING_TYPE_PIR:
        if (type == BINDING_AWARENESS_SWITCH) {
          _bindings.add(binding);
        }
        break;
      case BINDING_TYPE_OPEN_CLOSE:
        if (type == BINDING_OPEN_CLOSE) {
          _bindings.add(binding);
        }
        break;
      case BINDING_TYPE_SMART_DIAL:
        if (type == BINDING_SD_ROTATE) {
          _bindings.add(binding);
        }
        break;
      default:
        break;
    }
  }

  String get bindingImageLeftUrl {
    switch (type) {
      case BINDING_ALERT:
        if (logicDevice.isOnOffLight) {
          return 'images/binding_light.png';
        } else if (logicDevice.isSmartPlug) {
          return 'images/binding_plug.png';
        } else if (logicDevice.isAwarenessSwitch) {
          return 'images/binding_alarm.png';
        } else if (logicDevice.isDoorContact) {
          return 'images/binding_open.png';
        } else if (logicDevice.isCurtain) {
          return 'images/binding_curtain.png';
        }
        return '';
      case BINDING_TIMER:
        return 'images/binding_timer.png';
      case BINDING_COUNT_COWN:
        return 'images/binding_count_down.png';
      case BINDING_CLICK:
      case BINDING_DOUBLE_CLICK:
        if (logicDevice.isAwarenessSwitch) {
          return 'images/binding_press.png';
        } else if (logicDevice.isSmartDial) {
          return 'images/binding_sd_press.png';
        }
        return '';
      case BINDING_AWARENESS_SWITCH:
        return 'images/binding_alarm.png';
      case BINDING_OPEN_CLOSE:
        return 'images/binding_open.png';
      case BINDING_SD_ROTATE:
        return 'images/binding_sd_rotate.png';
      default:
        return '';
    }
  }

  String get bindingImageRightUrl {
    switch (type) {
      case BINDING_ALERT:
        return 'images/binding_notification.png';
      case BINDING_TIMER:
        return 'images/binding_plug.png';
      case BINDING_COUNT_COWN:
        return 'images/binding_plug.png';
      case BINDING_CLICK:
      case BINDING_DOUBLE_CLICK:
        return 'images/binding_light.png';
      case BINDING_AWARENESS_SWITCH:
        return 'images/binding_light.png';
      case BINDING_OPEN_CLOSE:
        return 'images/binding_light.png';
      case BINDING_SD_ROTATE:
        return 'images/binding_curtain.png';
      default:
        return '';
    }
  }

  String get bindingImageSingleUrl {
    switch (type) {
      case BINDING_TOP_LEFT_BUTTON:
        return 'images/wall_switch_binding_left_top.png';
      case BINDING_BOTTOM_LEFT_BUTTON:
        return 'images/wall_switch_binding_left.png';
      case BINDING_BOTTOM_RIGHT_BUTTON:
        return 'images/wall_switch_binding_right.png';
      case BINDING_TOP_RIGHT_BUTTON:
        return 'images/wall_switch_binding_top.png';
      case BINDING_FIRST_BUTTON:
        return 'images/icon_ws_us_t.png';
      case BINDING_SECOND_BUTTON:
        return 'images/icon_ws_us_m.png';
      case BINDING_THIRD_BUTTON:
        return 'images/icon_ws_us_b.png';
      default:
        return '';
    }
  }

  String getBindingNameDescription(BuildContext context) {
    switch (type) {
      case BINDING_ALERT:
        if (logicDevice.isOnOffLight ||
            logicDevice.isSmartPlug ||
            logicDevice.isCurtain) {
          return DefinedLocalizations.of(context).notification;
        }
        return DefinedLocalizations.of(context).alarmDisalarm;
      case BINDING_TIMER:
        return DefinedLocalizations.of(context).timer;
      case BINDING_COUNT_COWN:
        return DefinedLocalizations.of(context).countDown;
      case BINDING_CLICK:
        return DefinedLocalizations.of(context).clickButton;
      case BINDING_DOUBLE_CLICK:
        return DefinedLocalizations.of(context).doubleClickButton;
      case BINDING_AWARENESS_SWITCH:
        return DefinedLocalizations.of(context).pirPanel;
      case BINDING_OPEN_CLOSE:
        return DefinedLocalizations.of(context).openClose;
      case BINDING_TOP_RIGHT_BUTTON:
        return DefinedLocalizations.of(context).rightTopButton;
      case BINDING_BOTTOM_LEFT_BUTTON:
        return DefinedLocalizations.of(context).leftBottomButton;
      case BINDING_BOTTOM_RIGHT_BUTTON:
        return DefinedLocalizations.of(context).rightBottomButton;
      case BINDING_TOP_LEFT_BUTTON:
        return DefinedLocalizations.of(context).leftTopButton;
      case BINDING_SD_ROTATE:
        return DefinedLocalizations.of(context).sdRotate;
      case BINDING_FIRST_BUTTON:
        return DefinedLocalizations.of(context).firstButton;
      case BINDING_SECOND_BUTTON:
        return DefinedLocalizations.of(context).secondButton;
      case BINDING_THIRD_BUTTON:
        return DefinedLocalizations.of(context).thirdButton;
      default:
        return '';
    }
  }

  String getBindingDescription(BuildContext context) {
    switch (type) {
      case BINDING_ALERT:
        if (logicDevice.isAwarenessSwitch) {
          return DefinedLocalizations.of(context).notificationSomeonePassby;
        } else if (logicDevice.isDoorContact) {
          return DefinedLocalizations.of(context).notificationOpenClosed;
        }
        return DefinedLocalizations.of(context).notificationStateChanged;
      case BINDING_TIMER:
        return DefinedLocalizations.of(context).timerDescription;
      case BINDING_COUNT_COWN:
        return DefinedLocalizations.of(context).countDownDescription;
      case BINDING_CLICK:
        return DefinedLocalizations.of(context).keyPressDescription;
      case BINDING_DOUBLE_CLICK:
        return DefinedLocalizations.of(context).doubleClickDescription;
      case BINDING_AWARENESS_SWITCH:
        return DefinedLocalizations.of(context).pirPanelDescirption;
      case BINDING_OPEN_CLOSE:
        return DefinedLocalizations.of(context).openCloseDescription;
      case BINDING_SD_ROTATE:
        return DefinedLocalizations.of(context).sdRotateDescription;
      default:
        return '';
    }
  }

  String getOnText(BuildContext context) {
    switch (type) {
      case BINDING_ALERT:
        return DefinedLocalizations.of(context).alarm;
      default:
        return DefinedLocalizations.of(context).start;
    }
  }

  String getOffText(BuildContext context) {
    switch (type) {
      case BINDING_ALERT:
        return DefinedLocalizations.of(context).disalarm;
      default:
        return DefinedLocalizations.of(context).stop;
    }
  }

  bool get isBindingEmpty {
    switch (type) {
      case BINDING_ALERT:
        return false;
      case BINDING_TIMER:
      case BINDING_COUNT_COWN:
        return true;
      case BINDING_CLICK:
      case BINDING_DOUBLE_CLICK:
        return true;
      case BINDING_AWARENESS_SWITCH:
      case BINDING_OPEN_CLOSE:
      case BINDING_TOP_LEFT_BUTTON:
      case BINDING_TOP_RIGHT_BUTTON:
      case BINDING_BOTTOM_LEFT_BUTTON:
      case BINDING_BOTTOM_RIGHT_BUTTON:
      case BINDING_SD_ROTATE:
      case BINDING_FIRST_BUTTON:
      case BINDING_SECOND_BUTTON:
      case BINDING_THIRD_BUTTON:
        return bindings.isEmpty;
      default:
        return true;
    }
  }

  bool get isBindingEnabled {
    switch (type) {
      case BINDING_ALERT:
        return logicDevice.alertLevel == 1;
      case BINDING_TIMER:
      case BINDING_COUNT_COWN:
        return false;
      case BINDING_CLICK:
      case BINDING_DOUBLE_CLICK:
        return false;
      case BINDING_AWARENESS_SWITCH:
      case BINDING_OPEN_CLOSE:
      case BINDING_TOP_LEFT_BUTTON:
      case BINDING_BOTTOM_RIGHT_BUTTON:
      case BINDING_BOTTOM_LEFT_BUTTON:
      case BINDING_TOP_RIGHT_BUTTON:
      case BINDING_SD_ROTATE:
      case BINDING_FIRST_BUTTON:
      case BINDING_SECOND_BUTTON:
      case BINDING_THIRD_BUTTON:
        return binding == null ? false : binding.enabled;
      default:
        return false;
    }
  }
}

class _ControlUiEntity extends _UiEntity {
  final LogicDevice logicDevice;
  final int type;

  bool switchShowIndicator = false;

  List<Binding> _bindings = List();
  List<Binding> get bindings => _bindings;
  Binding get binding {
    if (bindings.isEmpty) return null;
    return bindings[0];
  }

  _ControlUiEntity({
    @required this.logicDevice,
    @required this.type,
  });

  void addBinding(Binding binding) {
    if (binding.triggerAddress != logicDevice.uuid) return;
    //_binding = binding;
    switch (binding.bindingType) {
      case BINDING_TYPE_KEY_PRESS:
        if (type == BINDING_CLICK ||
            type == BINDING_DOUBLE_CLICK ||
            type == BINDING_TOP_LEFT_BUTTON ||
            type == BINDING_BOTTOM_LEFT_BUTTON ||
            type == BINDING_BOTTOM_RIGHT_BUTTON ||
            type == BINDING_FIRST_BUTTON ||
            type == BINDING_SECOND_BUTTON ||
            type == BINDING_THIRD_BUTTON) {
          _bindings.add(binding);
        }
        break;
      case BINDING_TYPE_PIR:
        if (type == BINDING_AWARENESS_SWITCH) {
          _bindings.add(binding);
        }
        break;
      case BINDING_TYPE_OPEN_CLOSE:
        if (type == BINDING_OPEN_CLOSE) {
          _bindings.add(binding);
        }
        break;
      case BINDING_TYPE_SMART_DIAL:
        if (type == BINDING_SD_ROTATE) {
          _bindings.add(binding);
        }
        break;
      default:
        break;
    }
  }

  String get bindingImageLeftUrl {
    switch (type) {
      case BINDING_ALERT:
        if (logicDevice.isOnOffLight) {
          return 'images/binding_light.png';
        } else if (logicDevice.isSmartPlug) {
          return 'images/binding_plug.png';
        } else if (logicDevice.isAwarenessSwitch) {
          return 'images/binding_alarm.png';
        } else if (logicDevice.isDoorContact) {
          return 'images/binding_open.png';
        } else if (logicDevice.isCurtain) {
          return 'images/binding_curtain.png';
        }
        return '';
      case BINDING_TIMER:
        return 'images/binding_timer.png';
      case BINDING_COUNT_COWN:
        return 'images/binding_count_down.png';
      case BINDING_CLICK:
      case BINDING_DOUBLE_CLICK:
        if (logicDevice.isAwarenessSwitch) {
          return 'images/binding_press.png';
        } else if (logicDevice.isSmartDial) {
          return 'images/binding_sd_press.png';
        }
        return '';
      case BINDING_AWARENESS_SWITCH:
        return 'images/binding_alarm.png';
      case BINDING_OPEN_CLOSE:
        return 'images/binding_open.png';
      case BINDING_SD_ROTATE:
        return 'images/binding_sd_rotate.png';
      default:
        return '';
    }
  }

  String get bindingImageRightUrl {
    switch (type) {
      case BINDING_ALERT:
        return 'images/binding_notification.png';
      case BINDING_TIMER:
        return 'images/binding_plug.png';
      case BINDING_COUNT_COWN:
        return 'images/binding_plug.png';
      case BINDING_CLICK:
      case BINDING_DOUBLE_CLICK:
        return 'images/binding_light.png';
      case BINDING_AWARENESS_SWITCH:
        return 'images/binding_light.png';
      case BINDING_OPEN_CLOSE:
        return 'images/binding_light.png';
      case BINDING_SD_ROTATE:
        return 'images/binding_curtain.png';
      default:
        return '';
    }
  }

  String get bindingImageSingleUrl {
    switch (type) {
      case BINDING_TOP_LEFT_BUTTON:
        return 'images/wall_switch_binding_left_top.png';
      case BINDING_BOTTOM_LEFT_BUTTON:
        return 'images/wall_switch_binding_left.png';
      case BINDING_BOTTOM_RIGHT_BUTTON:
        return 'images/wall_switch_binding_right.png';
      case BINDING_TOP_RIGHT_BUTTON:
        return 'images/wall_switch_binding_top.png';
      case BINDING_FIRST_BUTTON:
        return 'images/icon_ws_us_t.png';
      case BINDING_SECOND_BUTTON:
        return 'images/icon_ws_us_m.png';
      case BINDING_THIRD_BUTTON:
        return 'images/icon_ws_us_b.png';
      default:
        return '';
    }
  }

  String getBindingNameDescription(BuildContext context) {
    switch (type) {
      case BINDING_ALERT:
        if (logicDevice.isOnOffLight ||
            logicDevice.isSmartPlug ||
            logicDevice.isCurtain) {
          return DefinedLocalizations.of(context).notification;
        }
        return DefinedLocalizations.of(context).alarmDisalarm;
      case BINDING_TIMER:
        return DefinedLocalizations.of(context).timer;
      case BINDING_COUNT_COWN:
        return DefinedLocalizations.of(context).countDown;
      case BINDING_CLICK:
        return DefinedLocalizations.of(context).clickButton;
      case BINDING_DOUBLE_CLICK:
        return DefinedLocalizations.of(context).doubleClickButton;
      case BINDING_AWARENESS_SWITCH:
        return DefinedLocalizations.of(context).pirPanel;
      case BINDING_OPEN_CLOSE:
        return DefinedLocalizations.of(context).openClose;
      case BINDING_TOP_RIGHT_BUTTON:
        return DefinedLocalizations.of(context).rightTopButton;
      case BINDING_BOTTOM_LEFT_BUTTON:
        return DefinedLocalizations.of(context).leftBottomButton;
      case BINDING_BOTTOM_RIGHT_BUTTON:
        return DefinedLocalizations.of(context).rightBottomButton;
      case BINDING_TOP_LEFT_BUTTON:
        return DefinedLocalizations.of(context).leftTopButton;
      case BINDING_SD_ROTATE:
        return DefinedLocalizations.of(context).sdRotate;
      case BINDING_FIRST_BUTTON:
        return DefinedLocalizations.of(context).firstButton;
      case BINDING_SECOND_BUTTON:
        return DefinedLocalizations.of(context).secondButton;
      case BINDING_THIRD_BUTTON:
        return DefinedLocalizations.of(context).thirdButton;
      default:
        return '';
    }
  }

  String getBindingDescription(BuildContext context) {
    switch (type) {
      case BINDING_ALERT:
        if (logicDevice.isAwarenessSwitch) {
          return DefinedLocalizations.of(context).notificationSomeonePassby;
        } else if (logicDevice.isDoorContact) {
          return DefinedLocalizations.of(context).notificationOpenClosed;
        }
        return DefinedLocalizations.of(context).notificationStateChanged;
      case BINDING_TIMER:
        return DefinedLocalizations.of(context).timerDescription;
      case BINDING_COUNT_COWN:
        return DefinedLocalizations.of(context).countDownDescription;
      case BINDING_CLICK:
        return DefinedLocalizations.of(context).keyPressDescription;
      case BINDING_DOUBLE_CLICK:
        return DefinedLocalizations.of(context).doubleClickDescription;
      case BINDING_AWARENESS_SWITCH:
        return DefinedLocalizations.of(context).pirPanelDescirption;
      case BINDING_OPEN_CLOSE:
        return DefinedLocalizations.of(context).openCloseDescription;
      case BINDING_SD_ROTATE:
        return DefinedLocalizations.of(context).sdRotateDescription;
      default:
        return '';
    }
  }

  String getOnText(BuildContext context) {
    switch (type) {
      case BINDING_ALERT:
        return DefinedLocalizations.of(context).alarm;
      default:
        return DefinedLocalizations.of(context).start;
    }
  }

  String getOffText(BuildContext context) {
    switch (type) {
      case BINDING_ALERT:
        return DefinedLocalizations.of(context).disalarm;
      default:
        return DefinedLocalizations.of(context).stop;
    }
  }

  bool get isBindingEmpty {
    switch (type) {
      case BINDING_ALERT:
        return false;
      case BINDING_TIMER:
      case BINDING_COUNT_COWN:
        return true;
      case BINDING_CLICK:
      case BINDING_DOUBLE_CLICK:
        return true;
      case BINDING_AWARENESS_SWITCH:
      case BINDING_OPEN_CLOSE:
      case BINDING_TOP_LEFT_BUTTON:
      case BINDING_TOP_RIGHT_BUTTON:
      case BINDING_BOTTOM_LEFT_BUTTON:
      case BINDING_BOTTOM_RIGHT_BUTTON:
      case BINDING_SD_ROTATE:
      case BINDING_FIRST_BUTTON:
      case BINDING_SECOND_BUTTON:
      case BINDING_THIRD_BUTTON:
        return bindings.isEmpty;
      default:
        return true;
    }
  }

  bool get isBindingEnabled {
    switch (type) {
      case BINDING_ALERT:
        return logicDevice.alertLevel == 1;
      case BINDING_TIMER:
      case BINDING_COUNT_COWN:
        return false;
      case BINDING_CLICK:
      case BINDING_DOUBLE_CLICK:
        return false;
      case BINDING_AWARENESS_SWITCH:
      case BINDING_OPEN_CLOSE:
      case BINDING_TOP_LEFT_BUTTON:
      case BINDING_BOTTOM_RIGHT_BUTTON:
      case BINDING_BOTTOM_LEFT_BUTTON:
      case BINDING_TOP_RIGHT_BUTTON:
      case BINDING_SD_ROTATE:
      case BINDING_FIRST_BUTTON:
      case BINDING_SECOND_BUTTON:
      case BINDING_THIRD_BUTTON:
        return binding == null ? false : binding.enabled;
      default:
        return false;
    }
  }
}

const int SETTING_NAME = 0;
const int SETTING_AREA = 1;
const int SETTING_TYPE = 2;
const int SETTING_DIRECTION = 3;
const int SETTING_TRIP_ADJUSTED = 4;
const int SETTING_OTHERS = 5;

class _SettingUiEntity extends _UiEntity {
  final Entity entity;
  final int type;

  _SettingUiEntity({
    @required this.entity,
    @required this.type,
  });

  String getLocaleDescription(BuildContext context) {
    switch (type) {
      case SETTING_NAME:
        return DefinedLocalizations.of(context).name;
      case SETTING_AREA:
        return DefinedLocalizations.of(context).room;
      case SETTING_TYPE:
        return DefinedLocalizations.of(context).curtainType;
      case SETTING_DIRECTION:
        return DefinedLocalizations.of(context).curtainDirection;
      case SETTING_TRIP_ADJUSTED:
        return DefinedLocalizations.of(context).tripAdjusted;
      case SETTING_OTHERS:
        return DefinedLocalizations.of(context).others;
      default:
        return '';
    }
  }

  String getContent(BuildContext context) {
    switch (type) {
      case SETTING_NAME:
        return entity.getName();
      case SETTING_AREA:
        var area = HomeCenterManager()
            .defaultHomeCenterCache
            .findEntity(entity.roomUuid);
        if (area is Room) {
          return area.getRoomName(context);
        }
        return DefinedLocalizations.of(context).roomDefault;
      case SETTING_TYPE:
        if (entity is LogicDevice) {
          final LogicDevice ld = entity as LogicDevice;
          if (ld.isCurtain) {
            switch (ld.curtainType) {
              case CURTAIN_TYPE_LEFT:
                return DefinedLocalizations.of(context).leftCurtain;
              case CURTAIN_TYPE_RIGHT:
                return DefinedLocalizations.of(context).rightCurtain;
              case CURTAIN_TYPE_DOUBLE:
                return DefinedLocalizations.of(context).doubleCurtain;
            }
          }
        }
        return '';
      case SETTING_DIRECTION:
        if (entity is LogicDevice) {
          final LogicDevice ld = entity as LogicDevice;
          if (ld.isCurtain) {
            switch (ld.curtainDirection) {
              case CURTAIN_DIRECTION_ORIGIN:
                return DefinedLocalizations.of(context).origin;
              case CURTAIN_DIRECTION_REVERSE:
                return DefinedLocalizations.of(context).reverse;
            }
          }
        }
        return '';
      case SETTING_TRIP_ADJUSTED:
        if (entity is LogicDevice) {
          final LogicDevice ld = entity as LogicDevice;
          if (ld.isCurtain) {
            switch (ld.curtainConfigured) {
              case 1:
                return DefinedLocalizations.of(context).yes;
              default:
                return DefinedLocalizations.of(context).no;
            }
          }
        }
        return '';
      case SETTING_OTHERS:
        return '';
      default:
        return '';
    }
  }
}
