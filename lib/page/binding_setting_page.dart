import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';

import 'dart:async';
import 'dart:ui';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/widget/switch_button.dart';
import 'package:xlive/widget/binding_page_header.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';

const KEY_PRESS_TYPE_PIR = 1;
const KEY_PRESS_TYPE_WS = 2;
const KEY_PRESS_TYPE_KB = 3;
const KEY_PRESS_TYPE_WS_US = 4;

class BindingSettingPage extends StatefulWidget {
  final Binding binding;
  final int bindingType;
  final String triggerAddress;
  //final bool curtainOnly;
  final int keyPressType; //1-pir 2-wall switch
  final bool containsOnOffDevice;
  final bool containsCurtain;
  final int parameter;

  BindingSettingPage({
    @required this.binding,
    @required this.bindingType,
    @required this.triggerAddress,
    this.keyPressType = 0,
    this.containsOnOffDevice = false,
    this.containsCurtain = false,
    this.parameter = -1,
  });

  State<StatefulWidget> createState() => _BindingSettingState();
}

class _BindingSettingState extends State<BindingSettingPage>
    with TickerProviderStateMixin {
  static const String className = 'BindingSettingPage';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  StreamSubscription _subscription;

  List<_Group> _groups = List();
  _Header _header;
  _BindingGroup _bindingGroup;
  _SettingGroup _settingGroup;

  String get _pageTitle {
    switch (widget.bindingType) {
      case BINDING_TYPE_KEY_PRESS:
        return 'binding_set_title_1';
      case BINDING_TYPE_OPEN_CLOSE:
        return 'binding_set_title_2';
      case BINDING_TYPE_PIR:
        return 'binding_set_title_3';
      case BINDING_TYPE_SMART_DIAL:
        return 'binding_set_title_4';
      default:
        return '';
    }
  }

  void initState() {
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    print("------------------------------binding_setting_page.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;

    _groups.clear();

    _header = _Header();
    _groups.add(_header);
    _bindingGroup = _BindingGroup();
    if (widget.bindingType == BINDING_TYPE_KEY_PRESS) {
      _groups.add(_bindingGroup);
    } else if (widget.bindingType == BINDING_TYPE_OPEN_CLOSE) {
      _settingGroup = _SettingGroup();
      _groups.add(_bindingGroup);
      _groups.add(_settingGroup);
    } else if (widget.bindingType == BINDING_TYPE_PIR) {
      _settingGroup = _SettingGroup();
      _groups.add(_bindingGroup);
      _groups.add(_settingGroup);
    } else if (widget.bindingType == BINDING_TYPE_SMART_DIAL) {
      _groups.add(_bindingGroup);
    }

    final List<Room> rooms = cache.rooms;
    bool hasDefaultRoom = false;
    for (var room in rooms) {
      if (room.uuid == DEFAULT_ROOM) {
        hasDefaultRoom = true;
      }
      _bindingGroup.add(room);
    }
    if (!hasDefaultRoom) {
      _bindingGroup.add(Room(
        uuid: DEFAULT_ROOM,
        name: '',
      ));
    }

    final List<PhysicDevice> devices = cache.addedDevices;
    for (var pd in devices) {
      if (!pd.available) continue;
      if (pd.isAwarenessSwitch || pd.isDoorContact) continue;
      if (widget.containsCurtain) {
        for (var ld in pd.logicDevices) {
          if (ld.profile == PROFILE_WINDOW_CORVERING) {
            _bindingGroup.addLogicDevice(ld);
          }
        }
      }
      if (widget.containsOnOffDevice) {
        for (var ld in pd.logicDevices) {
          if (ld.isOnOffLight) {
            if (ld.roomUuid == DEFAULT_ROOM) {
              if (pd.isWallSwitch) {
                _bindingGroup.addLogicDeviceToRoom(ld, pd.roomUuid);
              } else {
                _bindingGroup.addLogicDevice(ld);
              }
            } else {
              _bindingGroup.addLogicDevice(ld);
            }
          } else if (ld.profile == PROFILE_SMART_PLUG) {
            _bindingGroup.addLogicDevice(ld);
          }
        }
      }
    }

    if (widget.bindingType == BINDING_TYPE_OPEN_CLOSE) {
      if (_settingGroup == null) return;
      _settingGroup.add(_SettingUiEntity.OPEN, ACTION_OPEN);
      _settingGroup.add(_SettingUiEntity.CLOSE, ACTION_CLOSE);
      _settingGroup.add(_SettingUiEntity.OPEN_OR_CLOSE, ACTION_OPEN_OR_CLOSE);
    } else if (widget.bindingType == BINDING_TYPE_PIR) {
      if (_settingGroup == null) return;
      _settingGroup.add(
          _SettingUiEntity.VERY_VERY_LIGHT, LUMINANCE_VERY_VERY_LIGHT);
      _settingGroup.add(_SettingUiEntity.LIGHT, LUMINANCE_LIGHT);
      _settingGroup.add(_SettingUiEntity.LITTLE_DARK, LUMINANCE_LITTLE_DARK);
      _settingGroup.add(_SettingUiEntity.VERY_DARK, LUMINANCE_VERY_DARK);
      _settingGroup.add(_SettingUiEntity.DEFINED, LUMINANCE_DEFINED);
    }

    if (widget.binding != null) {
      final List<xyAction> actions = widget.binding.actions;
      for (var action in actions) {
        _bindingGroup.fillAction(action.uuid, action.attrId, action.attrValue);
      }
      if (_settingGroup != null) {
        _settingGroup.initParameter(widget.binding.parameter);
      }
    } else {}

    setState(() {});
  }

  void _start() {
    _subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is PhysicDeviceAvailableEvent || event is DeviceDeleteEvent)
        .where((event) =>
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
        .listen((event) {
      if (event is PhysicDeviceAvailableEvent) {
        final String uuid = event.uuid;
        final HomeCenterCache cache =
            HomeCenterManager().defaultHomeCenterCache;
        if (cache == null) return;
        final Entity entity = cache.findEntity(uuid);
        if (entity is LogicDevice) {
          _bindingGroup.addLogicDevice(entity);
        } else if (entity is PhysicDevice) {
          if (!entity.isWallSwitch) return;
          for (var ld in entity.logicDevices) {
            if (ld.isOnOffLight) {
              if (ld.roomUuid == DEFAULT_ROOM) {
                _bindingGroup.addLogicDeviceToRoom(ld, entity.roomUuid);
              } else {
                _bindingGroup.addLogicDevice(ld);
              }
            }
          }
        }
      } else if (event is DeviceDeleteEvent) {
        final Entity entity = event.entity;
        if (entity is PhysicDevice) {
          for (var ld in entity.logicDevices) {
            _bindingGroup.remove(ld);
          }
        }
      }
      setState(() {});
    });
  }

  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  int get _itemCount {
    int count = 0;
    for (var group in _groups) {
      count += group.size();
    }
    return count;
  }

  Object _getItem(int index) {
    if (index == 0) {
      return _header;
    }
    int step = 0;
    for (var group in _groups) {
      if (group is _Header) {
        step++;
      } else if (index >= step && index < group.size() + step) {
        return group.getItem(index - step);
      } else {
        step += group.size();
      }
    }
    return null;
  }

  bool get shouldHideEidtIcon {
    final String methodName = 'shouldHideEditIcon';
    if (_settingGroup != null && _settingGroup.parameter == -99) {
      return true;
    }
    if (widget.binding == null) {
      return _bindingGroup.getActions(widget.bindingType).length == 0;
    } else {
      if (_bindingGroup.getActions(widget.bindingType).length == 0) return true;
      if (widget.binding.actions.length <
          _bindingGroup.getActions(widget.bindingType).length) return false;
      if (widget.binding.actions.length ==
          _bindingGroup.getActions(widget.bindingType).length) {
        for (var action in _bindingGroup.getActions(widget.bindingType)) {
          if (!_isActionInActions(action, widget.binding.actions)) {
            return false;
          }
        }
        return true;
      }
      if (widget.binding.actions.length >
          _bindingGroup.getActions(widget.bindingType).length) {
        final HomeCenterCache cache =
            HomeCenterManager().defaultHomeCenterCache;
        if (cache == null) return true;
        for (var action in _bindingGroup.getActions(widget.bindingType)) {
          final LogicDevice ld = cache.findEntity(action.uuid) as LogicDevice;
          if (ld == null || !ld.parent.available) continue;
          if (!_isActionInActions(action, widget.binding.actions)) {
            return false;
          }
        }
        return true;
      }
    }
    return false;
  }

  bool _isActionInActions(xyAction action, List<xyAction> actions) {
    for (var curAction in actions) {
      if (action.uuid == curAction.uuid &&
          action.attrId == curAction.attrId &&
          action.attrValue == curAction.attrValue) {
        return true;
      }
    }
    return false;
  }

  Binding get _newBinding {
    if (widget.binding == null) {
      final Binding binding = Binding(
        uuid: '',
        bindingType: widget.bindingType,
        triggerAddress: widget.triggerAddress,
        enabled: true,
        parameter: widget.parameter,
      );
      binding.actions = _bindingGroup.getActions(widget.bindingType);
      if (_settingGroup != null) {
        binding.parameter = _settingGroup.parameter;
      }
      return binding;
    } else {
      widget.binding.actions = _bindingGroup.getActions(widget.bindingType);
      if (_settingGroup != null) {
        widget.binding.parameter = _settingGroup.parameter;
      }
      return widget.binding;
    }
  }

  void _createBinding(BuildContext context) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    if (homeCenterUuid == null || homeCenterUuid == '') return;
    if (widget.bindingType == BINDING_TYPE_OPEN_CLOSE) {
      if (_newBinding.parameter == -99) {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).chooseAction,
        );
        return;
      }
    } else if (widget.bindingType == BINDING_TYPE_PIR) {
      if (_newBinding.parameter == -99) {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).chooseLuminance,
        );
        return;
      }
    }
    MqttProxy.createBinding(homeCenterUuid, _newBinding).listen((response) {
      if (response is CreateBindingResponse) {
        if (response.success) {
          Navigator.of(context).maybePop();
        } else if (response.isIllegalArgument) {
          if (widget.bindingType == BINDING_TYPE_OPEN_CLOSE) {
            Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).chooseAction,
            );
          } else if (widget.bindingType == BINDING_TYPE_PIR) {
            Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).chooseLuminance,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
        }
      }
    });
  }

  void _updateBinding(BuildContext context) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    if (homeCenterUuid == null || homeCenterUuid == '') return;
    for (xyAction action in _newBinding.actions) {
      print('action uuid: ${action.uuid}');
      print('action attrId: ${action.attrId}');
      print('action attrValue: ${action.attrValue}');
    }
    MqttProxy.updateBinding(homeCenterUuid, _newBinding).listen((response) {
      if (response is UpdateBindingResponse) {
        if (response.success) {
          Navigator.of(context).maybePop();
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
      title: DefinedLocalizations.of(context).definedString(_pageTitle),
      trailing: Offstage(
        offstage: false,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            alignment: Alignment.centerRight,
            width: Adapt.px(200),
            child: Image(
              width: 21.0,
              height: 20.0,
              image: AssetImage('images/edit_done.png'),
            ),
          ),
          onTap: () {
            if (widget.binding == null) {
              _createBinding(context);
            } else {
              _updateBinding(context);
            }
          },
        ),
      ),
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return ListView.builder(
      itemCount: _itemCount,
      padding: EdgeInsets.only(top: 0.0),
      itemBuilder: (context, index) {
        final Object obj = _getItem(index);
        if (obj is _Header) {
          return _buildHeader(context, obj);
        } else if (obj is _GroupUiEntity) {
          return _buildGroup(context, obj);
        } else if (obj is _BindingRoomUiEntity) {
          return _buildBindingRoom(context, obj);
        } else if (obj is _BindingDeviceUiEntity) {
          return _buildBindingDevice(context, obj);
        } else if (obj is _SettingUiEntity) {
          return _buildSettingItem(context, obj);
        }
        return Text("");
      },
    );
  }

  Widget _buildHeader(BuildContext context, _Header header) {
    return BindingPageHeader(
      bindingType: widget.bindingType,
      keyPressType: widget.keyPressType,
      containsCurtain: widget.containsCurtain,
      containsOnOffDevice: widget.containsOnOffDevice,
    );
  }

  Widget _buildGroup(BuildContext context, _GroupUiEntity groupUiEntity) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DefinedLocalizations.of(context)
                .definedString(groupUiEntity.title(widget.bindingType)),
            style: TextStyle(
              inherit: false,
              color: Color(0xFF6E869A),
              fontSize: 16.0,
            ),
          ),
          Offstage(
            offstage: groupUiEntity.type == _GroupUiEntity.BINDING,
            child: Text(
              DefinedLocalizations.of(context)
                  .definedString(groupUiEntity.description(widget.bindingType)),
              style: TextStyle(
                  inherit: false, color: Color(0xFFFFB34D), fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBindingRoom(
      BuildContext context, _BindingRoomUiEntity roomUiEntity) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
      child: Text(
        roomUiEntity.room.getRoomName(context),
        style: TextStyle(
          inherit: false,
          color: const Color(0xFF9B9B9B),
          fontSize: 14.0,
        ),
      ),
    );
  }

  Widget _buildBindingDevice(
      BuildContext context, _BindingDeviceUiEntity deviceUiEntity) {
    if (widget.bindingType == BINDING_TYPE_KEY_PRESS &&
        deviceUiEntity.logicDevice.profile == PROFILE_WINDOW_CORVERING) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: const Color(0xFFF9F9F9),
          margin:
              EdgeInsets.only(left: 13.0, right: 0.0, top: 5.0, bottom: 5.0),
          padding: EdgeInsets.only(left: 13.0, right: 13.0),
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 21.0,
                    height: 21.0,
                    alignment: Alignment.center,
                    child: Image(
                      width: deviceUiEntity.selected ? 21.0 : 10.5,
                      height: deviceUiEntity.selected ? 21.0 : 10.5,
                      image: AssetImage(deviceUiEntity.checkImageUrl),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                  ),
                  Image(
                    width: 25.0,
                    height: 22.0,
                    image: AssetImage('images/icon_curtain.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                  ),
                  Container(
                    width: 0.3 * MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      deviceUiEntity.logicDevice.getName(),
                      style: TEXT_STYLE_BINDING_DEVICE_NAME,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SwitchButton(
                activeColor: Color(0xFF7CD0FF),
                value: deviceUiEntity.checked,
                showIndicator: false,
                showText: false,
                onChanged: (value) {
                  deviceUiEntity.checked = value;
                  if (value) {
                    deviceUiEntity.selected = true;
                  }
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        onTap: () {
          deviceUiEntity.selected = !deviceUiEntity.selected;
          if (!deviceUiEntity.selected) {
            deviceUiEntity.checked = false;
          }
          setState(() {});
        },
      );
    } else {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: const Color(0xFFF9F9F9),
          margin:
              EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 40.0,
                    height: 40.0,
                    alignment: Alignment.center,
                    child: _buildDeviceIcon(deviceUiEntity.logicDevice.profile,
                        deviceUiEntity.selected),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                  ),
                  Container(
                    width: 120.0,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      deviceUiEntity.logicDevice.getName(),
                      style: TEXT_STYLE_BINDING_DEVICE_NAME,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Container(
                width: 21.0,
                height: 21.0,
                alignment: Alignment.center,
                child: Image(
                  width: deviceUiEntity.selected ? 21.0 : 10.5,
                  height: deviceUiEntity.selected ? 21.0 : 10.5,
                  image: AssetImage(deviceUiEntity.checkImageUrl),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          deviceUiEntity.selected = !deviceUiEntity.selected;
          setState(() {});
        },
      );
    }
  }

  Widget _buildDeviceIcon(int profile, bool selected) {
    if (profile == PROFILE_ON_OFF_LIGHT) {
      return Image(
        width: 35.0,
        height: 36.0,
        image: AssetImage(selected
            ? 'images/icon_light_on.png'
            : 'images/icon_light_off.png'),
      );
    } else if (profile == PROFILE_SMART_PLUG) {
      return Image(
        width: 25.0,
        height: 25.0,
        image: AssetImage(
            selected ? 'images/icon_plug_on.png' : 'images/icon_plug_off.png'),
      );
    } else if (profile == PROFILE_WINDOW_CORVERING) {
      return Image(
        width: 25.0,
        height: 22.0,
        image: AssetImage('images/icon_curtain.png'),
      );
    }
    return Container();
  }

  Widget _buildSettingItem(
      BuildContext context, _SettingUiEntity settingUiEntity) {
    if (settingUiEntity.type == _SettingUiEntity.OPEN ||
        settingUiEntity.type == _SettingUiEntity.CLOSE ||
        settingUiEntity.type == _SettingUiEntity.OPEN_OR_CLOSE) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: const Color(0xFFF9F9F9),
          height: 80.0,
          margin:
              EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
          padding: EdgeInsets.only(left: 20.0, right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DefinedLocalizations.of(context)
                    .definedString(settingUiEntity.title),
                style: TextStyle(
                  inherit: false,
                  color: const Color(0xFF55585A),
                  fontSize: 14.0,
                ),
              ),
              Container(
                width: 21.0,
                height: 21.0,
                alignment: Alignment.center,
                child: Image(
                  width: settingUiEntity.selected ? 21.0 : 10.5,
                  height: settingUiEntity.selected ? 21.0 : 10.5,
                  image: AssetImage(settingUiEntity.checkImageUrl),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          _settingGroup.clearSelection();
          settingUiEntity.selected = true;
          setState(() {});
        },
      );
    } else {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: const Color(0xFFF9F9F9),
          height: 80.0,
          margin:
              EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    width: 30.0,
                    height: 30.0,
                    image: AssetImage(settingUiEntity.imageUrl),
                  ),
                  Padding(padding: EdgeInsets.only(left: 30.0)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        DefinedLocalizations.of(context)
                            .definedString(settingUiEntity.title),
                        style: TextStyle(
                            inherit: false,
                            color: const Color(0xFF55585A),
                            fontSize: 14.0),
                      ),
                      Text(
                        DefinedLocalizations.of(context)
                            .definedString(settingUiEntity.content),
                        style: TextStyle(
                          inherit: false,
                          color: const Color(0xFFAAB0B4),
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 21.0,
                height: 21.0,
                alignment: Alignment.center,
                child: Image(
                  width: settingUiEntity.selected ? 21.0 : 10.5,
                  height: settingUiEntity.selected ? 21.0 : 10.5,
                  image: AssetImage(settingUiEntity.checkImageUrl),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          if (settingUiEntity.type == _SettingUiEntity.DEFINED) {
            Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).notSurpport,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          } else {
            _settingGroup.clearSelection();
            settingUiEntity.selected = true;
            setState(() {});
          }
        },
      );
    }
  }
}

abstract class _Group {
  int size();
  _UiEntity getItem(int index);
}

class _Header extends _Group {
  int size() {
    return 1;
  }

  _UiEntity getItem(int index) {
    return null;
  }
}

class _BindingGroup extends _Group {
  final List<_UiEntity> _bindingUiEntities = List();

  List<_UiEntity> get bindingUiEntities {
    _bindingUiEntities.sort((a, b) {
      if (a is _GroupUiEntity) return -1;
      if (b is _GroupUiEntity) return 1;
      final _DeviceGroup aa = a as _DeviceGroup;
      final _DeviceGroup bb = b as _DeviceGroup;
      if (aa.roomUuid == DEFAULT_ROOM) return 1;
      if (bb.roomUuid == DEFAULT_ROOM) return -1;
      return aa.roomUuid.compareTo(bb.roomUuid);
    });
    return _bindingUiEntities;
  }

  _BindingGroup() {
    _bindingUiEntities.add(_GroupUiEntity(_GroupUiEntity.BINDING));
  }

  int size() {
    int size = 0;
    for (var uiEntity in _bindingUiEntities) {
      if (uiEntity is _GroupUiEntity) {
        size++;
      } else if (uiEntity is _DeviceGroup) {
        size += uiEntity.size;
      }
    }
    return size;
  }

  _UiEntity getItem(int index) {
    if (index == 0) {
      return bindingUiEntities[0];
    }
    int step = 0;
    for (var uiEntity in bindingUiEntities) {
      if (uiEntity is _GroupUiEntity) {
        step++;
      } else if (uiEntity is _DeviceGroup) {
        if (index >= step && index < uiEntity.size + step) {
          return uiEntity.getItem(index - step);
        } else {
          step += uiEntity.size;
        }
      }
    }
    return null;
  }

  void add(Room room) {
    _bindingUiEntities.add(_DeviceGroup(room));
  }

  void addLogicDevice(LogicDevice logicDevice) {
    final _DeviceGroup deviceGroup = findDeviceGroup(logicDevice.roomUuid);
    if (deviceGroup != null) {
      deviceGroup.addItem(logicDevice);
    }
  }

  void addLogicDeviceToRoom(LogicDevice logicDevice, String roomUuid) {
    final _DeviceGroup deviceGroup = findDeviceGroup(roomUuid);
    if (deviceGroup != null) {
      deviceGroup.addItem(logicDevice);
    }
  }

  _DeviceGroup findDeviceGroup(String roomUuid) {
    _DeviceGroup defaultGroup;
    for (var uiEntity in _bindingUiEntities) {
      if (uiEntity is _DeviceGroup) {
        if (uiEntity.roomUuid == roomUuid) {
          return uiEntity;
        }
        if (uiEntity.roomUuid == DEFAULT_ROOM) {
          defaultGroup = uiEntity;
        }
      }
    }
    return defaultGroup;
  }

  void fillAction(String uuid, int attrId, int attrValue) {
    for (var uiEntity in _bindingUiEntities) {
      if (uiEntity is _DeviceGroup) {
        uiEntity.fillAction(uuid, attrId, attrValue);
      }
    }
  }

  List<xyAction> getActions(int bindingType) {
    final List<xyAction> actions = List();
    for (var uiEntity in _bindingUiEntities) {
      if (uiEntity is _DeviceGroup) {
        actions.addAll(uiEntity.getActions(bindingType));
      }
    }
    return actions;
  }

  void remove(LogicDevice logicDevice) {
    for (var uiEntity in _bindingUiEntities) {
      if (uiEntity is _DeviceGroup) {
        uiEntity.removeItem(logicDevice);
      }
    }
  }
}

class _SettingGroup extends _Group {
  final List<_UiEntity> _settingUiEntities = List();

  _SettingGroup() {
    _settingUiEntities.add(_GroupUiEntity(_GroupUiEntity.SETTING));
  }

  int size() => _settingUiEntities.length;

  _UiEntity getItem(int index) => _settingUiEntities[index];

  void add(int type, int parameter) {
    _settingUiEntities.add(_SettingUiEntity(type, parameter));
  }

  void clear() {
    _settingUiEntities.clear();
  }

  void selectAction(int parameter) {
    for (var uiEntity in _settingUiEntities) {
      if (uiEntity is _GroupUiEntity) continue;
      final _SettingUiEntity settingUiEntity = uiEntity as _SettingUiEntity;
      settingUiEntity.selected = (settingUiEntity.parameter == parameter);
    }
  }

  int get parameter {
    for (var uiEntity in _settingUiEntities) {
      if (uiEntity is _SettingUiEntity) {
        if (uiEntity.selected) {
          return uiEntity.parameter;
        }
      }
    }
    return -99;
  }

  void clearSelection() {
    for (var uiEntity in _settingUiEntities) {
      if (uiEntity is _SettingUiEntity) {
        uiEntity.selected = false;
      }
    }
  }

  void initParameter(int parameter) {
    for (var uiEntity in _settingUiEntities) {
      if (uiEntity is _SettingUiEntity) {
        if (uiEntity.parameter == parameter) {
          uiEntity.selected = true;
        }
      }
    }
  }
}

class _DeviceGroup extends _UiEntity {
  final List<_UiEntity> _deviceUiEntities = List();

  List<_UiEntity> get deviceUiEntities {
    _deviceUiEntities.sort((a, b) {
      if (a is _BindingRoomUiEntity) return -1;
      if (b is _BindingRoomUiEntity) return 1;
      final _BindingDeviceUiEntity aa = a as _BindingDeviceUiEntity;
      final _BindingDeviceUiEntity bb = b as _BindingDeviceUiEntity;
      return aa.logicDevice.uuid.compareTo(bb.logicDevice.uuid);
    });
    return _deviceUiEntities;
  }

  _DeviceGroup(Room room) {
    _deviceUiEntities.add(_BindingRoomUiEntity(room));
  }

  void addItem(LogicDevice logicDevice) {
    _deviceUiEntities.add(_BindingDeviceUiEntity(logicDevice));
  }

  int get size {
    final int size = _deviceUiEntities.length;
    return size < 2 ? 0 : size;
  }

  _UiEntity getItem(int index) {
    return deviceUiEntities[index];
  }

  String get roomUuid {
    final _BindingRoomUiEntity roomUiEntity =
        getItem(0) as _BindingRoomUiEntity;
    return roomUiEntity.room.uuid;
  }

  void fillAction(String uuid, int attrId, int attrValue) {
    for (var uiEntity in _deviceUiEntities) {
      if (uiEntity is _BindingRoomUiEntity) continue;
      final _BindingDeviceUiEntity deviceUiEntity =
          uiEntity as _BindingDeviceUiEntity;
      if (deviceUiEntity.logicDevice.uuid == uuid) {
        deviceUiEntity.selected = true;
        if (attrId == ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION) {
          deviceUiEntity.checked = (attrValue == 100);
        }
      }
    }
  }

  List<xyAction> getActions(int bindingType) {
    final List<xyAction> actions = List();
    for (var uiEntity in _deviceUiEntities) {
      if (uiEntity is _BindingDeviceUiEntity) {
        if (uiEntity.selected) {
          final String uuid = uiEntity.logicDevice.uuid;
          int attrId; // = ATTRIBUTE_ID_ON_OFF_STATUS;
          int attrValue; // = ON_OFF_STATUS_ON;
          if (uiEntity.logicDevice.profile == PROFILE_WINDOW_CORVERING) {
            attrId = ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION;
            if (bindingType == BINDING_TYPE_SMART_DIAL) {
              attrValue = 100;
            } else {
              attrValue = uiEntity.checked ? 100 : 0;
            }
          } else {
            attrId = ATTRIBUTE_ID_ON_OFF_STATUS;
            attrValue = ON_OFF_STATUS_ON;
          }
          actions
              .add(xyAction(uuid: uuid, attrId: attrId, attrValue: attrValue));
        }
      }
    }
    return actions;
  }

  void removeItem(LogicDevice logicDevice) {
    _UiEntity toBeRemoved = null;
    for (var uiEntity in _deviceUiEntities) {
      if (uiEntity is _BindingDeviceUiEntity) {
        if (uiEntity.logicDevice.uuid == logicDevice.uuid) {
          toBeRemoved = uiEntity;
          break;
        }
      }
    }
    if (toBeRemoved != null) {
      _deviceUiEntities.remove(toBeRemoved);
    }
  }
}

abstract class _UiEntity {}

class _GroupUiEntity extends _UiEntity {
  static const BINDING = 0;
  static const SETTING = 1;

  final int _type;
  int get type => _type;

  String title(int bindingType) {
    switch (_type) {
      case BINDING:
        return 'choose_device';
      case SETTING:
        if (bindingType == BINDING_TYPE_OPEN_CLOSE) {
          return 'choose_action';
        } else if (bindingType == BINDING_TYPE_PIR) {
          return 'choose_luminance';
        } else {
          return 'none';
        }
        break;
      default:
        return 'none';
    }
  }

  String description(int bindingType) {
    switch (_type) {
      case BINDING:
        return 'none';
      case SETTING:
        if (bindingType == BINDING_TYPE_OPEN_CLOSE) {
          return 'choose_action_description';
        } else if (bindingType == BINDING_TYPE_PIR) {
          return 'choose_luminance_description';
        } else {
          return 'none';
        }
        break;
      default:
        return 'none';
    }
  }

  _GroupUiEntity(this._type);
}

class _SettingUiEntity extends _UiEntity {
  static const OPEN = 0;
  static const CLOSE = 1;
  static const OPEN_OR_CLOSE = 2;
  static const VERY_VERY_LIGHT = 3;
  static const LIGHT = 4;
  static const LITTLE_DARK = 5;
  static const VERY_DARK = 6;
  static const DEFINED = 7;

  final int _type;
  int get type => _type;

  final int _parameter;
  int get parameter => _parameter;

  bool _selected = false;
  bool get selected => _selected;
  set selected(bool selected) => _selected = selected;

  _SettingUiEntity(this._type, this._parameter);

  String get title {
    switch (_type) {
      case OPEN:
        return 'open';
      case CLOSE:
        return 'close';
      case OPEN_OR_CLOSE:
        return 'open_or_close';
      case VERY_VERY_LIGHT:
        return 'very_very_light';
      case LIGHT:
        return 'light';
      case LITTLE_DARK:
        return 'little_dark';
      case VERY_DARK:
        return 'very_dark';
      case DEFINED:
        return 'defined';
      default:
        return 'none';
    }
  }

  String get content {
    switch (_type) {
      case VERY_VERY_LIGHT:
        return 'lux_10000';
      case LIGHT:
        return 'lux_300';
      case LITTLE_DARK:
        return 'lux_100';
      case VERY_DARK:
        return 'lux_30';
      case DEFINED:
        return 'lux_defined';
      default:
        return 'none';
    }
  }

  String get imageUrl {
    switch (_type) {
      case VERY_VERY_LIGHT:
        return 'images/very_very_light.png';
      case LIGHT:
        return 'images/light.png';
      case LITTLE_DARK:
        return 'images/little_dark.png';
      case VERY_DARK:
        return 'images/very_dark.png';
      case DEFINED:
        return 'images/defined.png';
      default:
        return '';
    }
  }

  String get checkImageUrl {
    return _selected ? 'images/icon_check.png' : 'images/icon_uncheck.png';
  }
}

class _BindingRoomUiEntity extends _UiEntity {
  final Room room;

  _BindingRoomUiEntity(this.room);
}

class _BindingDeviceUiEntity extends _UiEntity {
  final LogicDevice _logicDevice;
  LogicDevice get logicDevice => _logicDevice;

  bool _selected = false;
  bool get selected => _selected;
  set selected(bool selected) => _selected = selected;

  bool checked = false;

  _BindingDeviceUiEntity(this._logicDevice);

  String get imageUrl {
    if (_logicDevice.profile == PROFILE_ON_OFF_LIGHT) {
      return _selected
          ? 'images/icon_light_on.png'
          : 'images/icon_light_off.png';
    } else if (_logicDevice.profile == PROFILE_SMART_PLUG) {
      return _selected ? 'images/icon_plug_on.png' : 'images/icon_plug_off.png';
    } else {
      return '';
    }
  }

  String get checkImageUrl {
    return _selected ? 'images/icon_check.png' : 'images/icon_uncheck.png';
  }
}
