import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:async';
import 'dart:ui';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/session/network_status_manager.dart';
import 'package:xlive/widget/notification_view.dart';
import 'package:xlive/widget/device_icon_view.dart';
import 'package:xlive/widget/switch_button.dart';
import 'package:xlive/session/session.dart';
import 'package:xlive/firmware/firmware_manager.dart';
import 'package:xlive/session/app_state_manager.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'device_detail_page.dart';
import 'add_device_page.dart';
import 'common_page.dart';

// import 'dart:convert' as convert;

import 'package:fluttertoast/fluttertoast.dart';

class DevicePage extends StatefulWidget {
  State<StatefulWidget> createState() => _DeviceState();
}

class _DeviceState extends State<DevicePage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'DevicePage');

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _resetData();
    _start();
  }

  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  void _start() {
    _subscription = RxBus().toObservable().where((event) {
      if (event is HomeCenterCacheEvent) {
        return event.homeCenterUuid ==
            HomeCenterManager().defaultHomeCenterUuid;
      } else {
        return true;
      }
    }).listen((event) {
      if (event is HomeCenterEvent) {
        if (event.type == HOME_CENTER_CHANGED ||
            event.type == HOME_CENTER_OFFLINE ||
            event.type == HOME_CENTER_ONLINE) {
          _resetData();
        }
      } else if (event is NetworkStatusChangedEvent) {
        if (event.networkType == NETWORK_TYPE_NONE) _resetData();
      } else if (event is DeviceAttributeReportEvent) {
        _processDeviceAttributeReportEvent(
            event.uuid, event.attrId, event.attrValue);
      } else if (event is EntityInfoConfigureEvent) {
        _resetData();
      } else if (event is PhysicDeviceAvailableEvent ||
          event is UpdatePhysicDeviceAvailableEvent) {
        _resetData();
      } else if (event is DeviceOfflineEvent) {
        _resetData();
      } else if (event is DeviceDeleteEvent) {
        _resetData();
      } else if (event is SessionStateChangedEvent) {
        _resetData();
      } else if (event is GetEntityCompletedEvent) {
        _resetData();
      } else if (event is RoomDeleteEvent) {
        _resetData();
      }
    });
  }

  final List<_DeviceGroup> _deviceGroups = List();

  List<_DeviceGroup> get deviceGroups {
    _deviceGroups.sort((a, b) {
      if (a.roomUuid == DEFAULT_ROOM) return 1;
      if (b.roomUuid == DEFAULT_ROOM) return -1;
      return a.roomUuid.compareTo(b.roomUuid);
    });
    return _deviceGroups;
  }

  void _processDeviceAttributeReportEvent(
      String uuid, int attrId, int attrValue) {
    final String methodName = 'processDeviceAttributeReportEvent';
    if (attrId == ATTRIBUTE_ID_ON_OFF_STATUS) {
      log.d('on off status changed event: $uuid', methodName);
      _resetData();
    } else if (attrId == ATTRIBUTE_ID_ALERT_LEVEL) {
      _resetData();
    } else if (attrId == ATTRIBUTE_ID_BINARY_INPUT_STATUS) {
      //_createDoorContactAnimation(uuid, attrValue);
      //_dcStatusMap[uuid] = attrValue;
    } else if (attrId == ATTRIBUTE_ID_OCCUPANCY) {
      //_createAlarmAnimation(uuid, attrValue);
    } else if (attrId == ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION) {
      final _DeviceUiEntity deviceUiEntity = _findDeviceUiEntity(uuid);
      if (deviceUiEntity != null) {
        deviceUiEntity.switchShowIndicator = false;
      }
      setState(() {});
    } else if (attrId == ATTRIBUTE_ID_CONFIG_DISABLE_RELAY) {
      _resetData();
    }
  }

  void _resetData() {
    print("------------------------------device_page.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;

    _deviceGroups.clear();

    bool hasDefaultRoom = false;
    final List<Room> rooms = cache.rooms;
    for (var room in rooms) {
      if (room.uuid == DEFAULT_ROOM) {
        hasDefaultRoom = true;
      }
      _deviceGroups.add(_DeviceGroup(room));
    }
    if (!hasDefaultRoom) {
      _deviceGroups.add(_DeviceGroup(Room(uuid: DEFAULT_ROOM, name: '')));
    }
    final List<PhysicDevice> physicDevices = cache.addedDevices;
    for (var physicDevice in physicDevices) {
      if (physicDevice.isWallSwitch ||
          physicDevice.isWallSwitchUS ||
          physicDevice.isSwitchModule ||
          physicDevice.isZHHVRVGateway) {
        final _DeviceGroup deviceGroup1 =
            _findDeviceGroup(physicDevice.roomUuid);
        if (deviceGroup1 != null) {
          deviceGroup1.add(physicDevice);
        }
        for (var logicDevice in physicDevice.logicDevices) {
          if (logicDevice.isOnOffLight) {
            _DeviceGroup deviceGroup2;
            if (logicDevice.roomUuid == null ||
                logicDevice.roomUuid.isEmpty ||
                logicDevice.roomUuid == DEFAULT_ROOM) {
              deviceGroup2 = _findDeviceGroup(physicDevice.roomUuid);
            } else {
              deviceGroup2 = _findDeviceGroup(logicDevice.roomUuid);
            }
            if (deviceGroup2 != null) {
              deviceGroup2.add(logicDevice);
            }
          } else if (logicDevice.isIndoorUnit) {
            _DeviceGroup deviceGroup2;
            if (logicDevice.roomUuid == null ||
                logicDevice.roomUuid.isEmpty ||
                logicDevice.roomUuid == DEFAULT_ROOM) {
              deviceGroup2 = _findDeviceGroup(physicDevice.roomUuid);
            } else {
              if (_findDeviceGroup(logicDevice.roomUuid).roomUuid ==
                  DEFAULT_ROOM) {
                deviceGroup2 = _findDeviceGroup(physicDevice.roomUuid);
              } else {
                deviceGroup2 =
                    _findDeviceGroup(logicDevice.roomUuid); //area-0001
              }
            }
            if (deviceGroup2 != null) {
              deviceGroup2.add(logicDevice);
            }
          }
        }
      } else {
        for (var logicDevice in physicDevice.logicDevices) {
          final _DeviceGroup deviceGroup =
              _findDeviceGroup(logicDevice.roomUuid);

          deviceGroup.add(logicDevice);
        }
      }
    }

    setState(() {});
  }

  _DeviceGroup _findDeviceGroup(String roomUuid) {
    _DeviceGroup defaultGroup;
    for (var deviceGroup in _deviceGroups) {
      if (deviceGroup.roomUuid == roomUuid) {
        return deviceGroup;
      }
      if (deviceGroup.roomUuid == DEFAULT_ROOM) {
        defaultGroup = deviceGroup;
      }
    }
    return defaultGroup;
  }

  _DeviceUiEntity _findDeviceUiEntity(String uuid) {
    for (_DeviceGroup deviceGroup in _deviceGroups) {
      final _DeviceUiEntity deviceUiEntity = deviceGroup.findUiEntity(uuid);
      if (deviceUiEntity != null) {
        return deviceUiEntity;
      }
    }
    return null;
  }

  int get itemCount {
    int count = 0;
    for (var deviceGroup in _deviceGroups) {
      count += deviceGroup.count;
    }
    return count;
  }

  _UiEntity _getItem(int index) {
    int step = 0;
    for (var deviceGroup in deviceGroups) {
      if (index >= step && index < step + deviceGroup.count) {
        return deviceGroup.get(index - step);
      } else {
        step += deviceGroup.count;
      }
    }
    return null;
  }

  void _writeAttribute(
      Entity entity, int attrId, int attrValue, _DeviceUiEntity uiEntity) {
    final String methodName = 'writeAttribute';
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.writeAttribute(homeCenterUuid, entity.uuid, attrId, attrValue)
        .listen((response) {
      if (response is WriteAttributeResponse) {
        if (!response.success && response.code != 41) {
          uiEntity.switchShowIndicator = false;
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
        } else {
          if (attrId != ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION) {
            uiEntity.switchShowIndicator = false;
            entity.setAttribute(attrId, attrValue);
          }
        }
        setState(() {});
      }
    });
  }

  void _setPermitJoin() {
    final String methodName = 'setPermitJoin';
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null || homeCenterUuid == null || homeCenterUuid == '') return;
    final ZigbeeSystem system = cache.system;
    MqttProxy.setPermitJoin(homeCenterUuid, system.uuid, 240)
        .listen((response) {
      if (AppStateManager().history.last.settings.name == '/AddDevice') return;
      if (response is SetPermitJoinResponse) {
        if (response.success) {
          log.d('set permit join succeed', methodName);
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).openScanSucceed,
          );
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (context) => AddDevicePage(),
              settings: RouteSettings(
                name: '/AddDevice',
              ),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).setPermitJoinFailed +
                ': ${response.code}',
          );
        }
      }
    });
  }

  bool get showIndicatorRedPoint {
    final List<HomeCenter> temp1 = HomeCenterManager().localFoundHomeCenters;
    for (HomeCenter homeCenter in temp1) {
      if (homeCenter.state == ASSOCIATION_TYPE_NONE) return true;
    }
    final Map<String, HomeCenter> temp2 = HomeCenterManager().homeCenters;
    for (String uuid in temp2.keys) {
      final int number = FirmwareManager().numberOfDevicesCanUpgrade(uuid);
      if (number > 0) return true;
    }
    return false;
  }

  bool get showIndicatorNewDevice {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache != null) {
      return !cache.hasNewDevices;
    } else {
      return false;
    }
  }

  Widget build(BuildContext context) {
    final HomeCenter homeCenter = HomeCenterManager().defaultHomeCenter;
    return CommonPage(
      title: HomeCenterManager().defaultHomeCenter == null
          ? DefinedLocalizations.of(context).device
          : HomeCenterManager().defaultHomeCenter.getName(),
      showBackIcon: false,
      showMenuIcon: true,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: Adapt.px(250),
          alignment: Alignment.centerRight,
          child: Row(
            children: <Widget>[
              Offstage(
                  offstage: showIndicatorNewDevice,
                  child: Image.asset(
                    'images/red_point.png',
                    width: 5.0,
                    height: 5.0,
                    gaplessPlayback: true,
                  )),
              Text(
                DefinedLocalizations.of(context).addDevice,
                style: TEXT_STYLE_ADD_TEXT,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          height: kToolbarHeight,
        ),
        onTap: () {
          _setPermitJoin();
        },
      ),
      showRedPoint: showIndicatorRedPoint,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    bool isEmpty = false;
    if (cache == null) {
      isEmpty = true;
    } else {
      isEmpty = !cache.hasDevices;
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          NotificationView(), //显示  失去网络  xxx请求添加 啊 之类的
          Expanded(
            child: isEmpty ? buildEmpty(context) : buildDevice(context),
          ),
        ],
      ),
    );
  }

  Widget buildDevice(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      itemBuilder: (BuildContext context, int index) {
        final _UiEntity uiEntity = _getItem(index);
        if (uiEntity is _GroupUiEntity) {
          return _buildGroup(context, uiEntity);
        } else if (uiEntity is _DeviceUiEntity) {
          return _buildDevice(context, uiEntity);
        }
        return Text("");
      },
    );
  }

  Widget _buildGroup(BuildContext context, _GroupUiEntity groupUiEntity) {
    return Container(
      height: 24.0,
      color: const Color(0xFFFFFFFF),
      margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 2.5),
      child: Text(
        groupUiEntity.room.getRoomName(context),
        style: TEXT_STYLE_ROOM_NAME,
      ),
    );
  }

  Widget _buildDevice(BuildContext context, _DeviceUiEntity deviceUiEntity) {
    final double paddingRight = !deviceUiEntity.showSwitchButton ? 13.0 : 0.0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque, //一定要写
      child: Container(
        height: 80.0,
        color: const Color(0xFFF9F9F9),
        margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 2.5, bottom: 2.5),
        child: Padding(
          padding: EdgeInsets.only(right: paddingRight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DeviceIconView(
                    deviceType: deviceUiEntity.iconType,
                    entity: deviceUiEntity.entity,
                  ),
                  Container(
                    width: 0.30 * MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      deviceUiEntity.entity.getName(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(0xFF2D3B46),
                          fontSize: 15.0,
                          inherit: false),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 80.0,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: <Widget>[
                    //SwitchButton
                    Offstage(
                      offstage: !deviceUiEntity.showSwitchButton,
                      child: SwitchButton(
                        activeColor: deviceUiEntity.isSecuratyDevice
                            ? const Color(0xFFFFB34D)
                            : const Color(0xFF7CD0FF),
                        showIndicator: deviceUiEntity.switchShowIndicator,
                        showText: deviceUiEntity.isSecuratyDevice,
                        onText: DefinedLocalizations.of(context).alarm,
                        offText: DefinedLocalizations.of(context).disalarm,
                        value: deviceUiEntity.isButtonChecked,
                        onChanged: (bool value) {
                          deviceUiEntity.switchShowIndicator = true;
                          setState(() {});
                          if (deviceUiEntity.entity is LogicDevice) {
                            final LogicDevice ld =
                                deviceUiEntity.entity as LogicDevice;
                            //final String uuid = ld.uuid;
                            if (ld.isOnOffLight ||
                                ld.isSmartPlug ||
                                ld.iscolorLight) {
                              final int attrId = ATTRIBUTE_ID_ON_OFF_STATUS;
                              final int attrValue =
                                  (ld.onOffStatus == ON_OFF_STATUS_ON)
                                      ? ON_OFF_STATUS_OFF
                                      : ON_OFF_STATUS_ON;
                              _writeAttribute(
                                  ld, attrId, attrValue, deviceUiEntity);
                            } else if (ld.profile == PROFILE_HA_DOOR_LOCK) {
                              final int attrId = ATTRIBUTE_ID_DOOR_LOCK_STATE;
                              int attrValue =
                                  ld.doorLockState == ON_OFF_STATUS_ON
                                      ? ON_OFF_STATUS_OFF
                                      : ON_OFF_STATUS_ON;
                              _writeAttribute(
                                  ld, attrId, attrValue, deviceUiEntity);
                            } else if (ld.isAwarenessSwitch ||
                                ld.isDoorContact) {
                              final int attrId = ATTRIBUTE_ID_ALERT_LEVEL;
                              final int attrValue =
                                  (ld.alertLevel == 1) ? 0 : 1;
                              _writeAttribute(
                                  ld, attrId, attrValue, deviceUiEntity);
                            } else if (ld.isCurtain) {
                              final int attrId =
                                  ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION;
                              final int attrValue =
                                  deviceUiEntity.isButtonChecked ? 0 : 100;
                              _writeAttribute(
                                  ld, attrId, attrValue, deviceUiEntity);
                            }
                          }
                        },
                      ),
                    ),
                    //Next Icon
                    Offstage(
                      offstage: !deviceUiEntity.showNextIcon,
                      child: Image(
                        image: AssetImage('images/icon_next.png'),
                        width: 15.0,
                        height: 15.0,
                      ),
                    ),
                    //离线
                    Offstage(
                      offstage: !deviceUiEntity.showOffline,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
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
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (context) => DeviceDetailPage(entity: deviceUiEntity.entity),
          settings: RouteSettings(
            name: '/DeviceDetail',
          ),
        ));
      },
    );
  }

  Widget buildEmpty(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(top: 30.0, right: 10.0),
            child: Image.asset(
              'images/arrow.png',
              width: 68.0,
              height: 80.0,
              gaplessPlayback: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 70.0),
            child: Image.asset(
              'images/no_device.png',
              width: 80.0,
              height: 80.0,
              gaplessPlayback: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text(
              DefinedLocalizations.of(context).noDeviceDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                inherit: false,
                fontSize: 14.0,
                color: const Color(0xFFD4D4D4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceGroup {
  final List<_UiEntity> _uiEntities = List<_UiEntity>();

  List<_UiEntity> get uiEntities {
    _uiEntities.sort((a, b) {
      if (a is _GroupUiEntity) return -1;
      if (b is _GroupUiEntity) return 1;
      final _DeviceUiEntity deviceA = a as _DeviceUiEntity;
      final _DeviceUiEntity deviceB = b as _DeviceUiEntity;
      return deviceA.entity.uuid.compareTo(deviceB.entity.uuid);
    });
    return _uiEntities;
  }

  _DeviceGroup(Room room) {
    _uiEntities.add(_GroupUiEntity(room));
  }

  void add(Entity entity) {
    if (hasEntity(entity)) return;
    if (!(entity is PhysicDevice) && !(entity is LogicDevice)) return;
    _uiEntities.add(_DeviceUiEntity(entity));
  }

  bool hasEntity(Entity entity) {
    for (var uiEntity in _uiEntities) {
      if (uiEntity is _DeviceUiEntity) {
        if (uiEntity.entity.uuid == entity.uuid) {
          return true;
        }
      }
    }
    return false;
  }

  _DeviceUiEntity findUiEntity(String uuid) {
    for (_UiEntity uiEntity in _uiEntities) {
      if (uiEntity is _GroupUiEntity) continue;
      final _DeviceUiEntity deviceUiEntity = uiEntity as _DeviceUiEntity;
      if (deviceUiEntity.entity.uuid == uuid) {
        return deviceUiEntity;
      }
    }
    return null;
  }

  String get roomUuid {
    final _GroupUiEntity groupUiEntity = _uiEntities.first as _GroupUiEntity;
    return groupUiEntity.room.uuid;
  }

  int get count {
    if (_uiEntities.length <= 1) {
      return 0;
    }
    return _uiEntities.length;
  }

  _UiEntity get(int index) {
    return uiEntities[index];
  }
}

class _UiEntity {}

class _GroupUiEntity extends _UiEntity {
  final Room room;

  _GroupUiEntity(this.room);
}

class _DeviceUiEntity extends _UiEntity {
  final Entity entity;

  bool switchShowIndicator = false;

  _DeviceUiEntity(this.entity);

  int get iconType {
    if (entity is PhysicDevice) {
      final PhysicDevice pd = entity as PhysicDevice;
      if (pd.isWallSwitch) return ICON_WALL_SWITCH;
      if (pd.isWallSwitchUS) return ICON_WALL_SWITCH;
      if (pd.isSwitchModule) return ICON_SWITCH_MODULE;
      if (pd.isZHHVRVGateway) return ICON_AIR_CONDITIONER;
      return ICON_UNKNOWN;
    } else if (entity is LogicDevice) {
      final LogicDevice ld = entity as LogicDevice;
      if (ld.isOnOffLight) {
        if (ld.parent.isSwitchModule)
          return ICON_SWITCH_MODULE;
        else
          return ICON_LIGHT;
      }
      if (ld.iscolorLight) return ICON_LIGHT;
      if (ld.isSmartPlug) return ICON_PLUG;
      if (ld.isAwarenessSwitch) return ICON_AWARENESS_SWITCH;
      if (ld.isDoorContact) return ICON_DOOR_SENSOR;
      if (ld.isCurtain) return ICON_CURTAIN;
      if (ld.isSmartDial) return ICON_SMART_DIAL;
      if (ld.isIndoorUnit) return ICON_INDOOR_UNIT;
      return ICON_UNKNOWN;
    } else {
      return ICON_UNKNOWN;
    }
  }

  bool get isSecuratyDevice =>
      iconType == ICON_DOOR_SENSOR || iconType == ICON_AWARENESS_SWITCH;

  bool get showNextIcon {
    if (entity is PhysicDevice) {
      return true;
    } else if (entity is LogicDevice) {
      final LogicDevice ld = entity as LogicDevice;
      if (ld.isIndoorUnit) return true;
      return ld.isSmartDial;
    }
    return false;
  }

  bool get showSwitchButton {
    if (!available) return false;
    if (entity is PhysicDevice) return false;
    if (entity is LogicDevice) {
      final LogicDevice ld = entity as LogicDevice;
      if (ld.isSmartDial || ld.isIndoorUnit) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  bool get showOffline {
    if (entity is PhysicDevice) return false;
    if (entity is LogicDevice) {
      final LogicDevice ld = entity as LogicDevice;
      if (ld.isSmartDial || ld.isIndoorUnit) return false;
      return !ld.parent.available;
    }
    return false;
  }

  bool get available {
    if (entity is PhysicDevice) {
      final PhysicDevice pd = entity as PhysicDevice;
      return pd.available;
    }
    if (entity is LogicDevice) {
      final LogicDevice ld = entity as LogicDevice;
      return ld.parent.available;
    }
    return false;
  }

  bool get isButtonChecked {
    if (entity is LogicDevice) {
      final LogicDevice ld = entity as LogicDevice;
      if (ld.isOnOffLight || ld.isSmartPlug || ld.iscolorLight) {
        return ld.onOffStatus == ON_OFF_STATUS_ON;
      }
      if (ld.profile == PROFILE_HA_DOOR_LOCK) {
        return ld.doorLockState == ON_OFF_STATUS_ON;
      }
      if (ld.isAwarenessSwitch || ld.isDoorContact) {
        return ld.alertLevel == 1;
      }
      if (ld.isCurtain) {
        return ld.currentPosition > 10;
      }
    }
    return false;
  }
}
