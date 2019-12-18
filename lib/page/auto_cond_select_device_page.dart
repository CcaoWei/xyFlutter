import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:async';
import 'dart:ui';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/page/auto_cond_select_device_condition_page.dart';
import 'package:xlive/widget/notification_view.dart';
import 'package:xlive/widget/device_icon_view.dart';
import 'common_page.dart';
import 'package:xlive/page/auto_condition_radio_type_page.dart';
import 'package:xlive/page/auto_cond_selected_wallswitch_device_page.dart';

class AutoCondSelectDevice extends StatefulWidget {
  final Automation automation; //带参数的类的实现方法

  AutoCondSelectDevice({
    this.automation, //带参数的类的实现方法 和上面一起的  下面的类_AutoMationPage要在怎么用呢 就是widgei.参数名 就行了
  });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddDeviceConditionPage();
  }
}

class _AddDeviceConditionPage extends State<AutoCondSelectDevice> {
  //这个一定要跟着一个build
  //创建一个自动化的列表
  final List<_DeviceGroup> _deviceGroups = List();

  List<_DeviceGroup> get deviceGroups {
    _deviceGroups.sort((a, b) {
      if (a.roomUuid == DEFAULT_ROOM) return 1;
      if (b.roomUuid == DEFAULT_ROOM) return -1;
      return a.roomUuid.compareTo(b.roomUuid);
    });
    return _deviceGroups;
  }

  StreamSubscription _subscription; //消息通道

  void initState() {
    //onshow
    super.initState();
    _resetData();
  }

  void _resetData() {
    print("--------------------auto_cond_select_device_page.dart");
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
      if (physicDevice.isZHHVRVGateway) continue;

      if (physicDevice.isWallSwitch ||
          physicDevice.isWallSwitchUS ||
          physicDevice.isSwitchModule) {
        final _DeviceGroup deviceGroup1 =
            _findDeviceGroup(physicDevice.roomUuid);
        if (deviceGroup1 != null) {
          deviceGroup1.add(physicDevice);
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

  void dispose() {
    //页面卸载是执行的
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
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

  String getDeviceDetail(int icontype) {
    if (icontype == ICON_LIGHT) {
      return DefinedLocalizations.of(context).autoOnoffCondType;
    } else if (icontype == ICON_PLUG) {
      return DefinedLocalizations.of(context).autoOnoffPowerCondType;
    } else if (icontype == ICON_AWARENESS_SWITCH) {
      return DefinedLocalizations.of(context).autoBodyTemCondType;
    } else if (icontype == ICON_DOOR_SENSOR) {
      return DefinedLocalizations.of(context).autoOpenCloseTemCondType;
    } else if (icontype == ICON_CURTAIN) {
      return DefinedLocalizations.of(context).autoOpenCloseExerciseCondType;
    } else if (icontype == ICON_WALL_SWITCH) {
      return DefinedLocalizations.of(context).autoLightKeypressCondType;
    } else if (icontype == ICON_SWITCH_MODULE) {
      return DefinedLocalizations.of(context).autoLightKeypressCondType;
    } else if (icontype == ICON_SMART_DIAL) {
      return DefinedLocalizations.of(context).autoAngleRotateCondType;
    }
    return DefinedLocalizations.of(context).noBriefIntroductionProduct;
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
        title: DefinedLocalizations.of(context).addDeviceConditions,
        showBackIcon: true,
        child: _buildDeviceList(context));
  }

  Widget _buildDeviceList(BuildContext context) {
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
            child:
                isEmpty ? _buildEmpty(context) : _buildDeviceListItem(context),
          )
        ],
      ),
    );
  }

  Widget _buildDeviceListItem(BuildContext context) {
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
        });
  }

  Widget _buildGroup(BuildContext context, _GroupUiEntity groupUiEntity) {
    //房间名字
    return Container(
      height: Adapt.px(59),
      color: const Color(0xFFFFFFFF),
      margin: EdgeInsets.only(
          left: Adapt.px(40), top: Adapt.px(65), bottom: Adapt.px(30)),
      child: Text(groupUiEntity.room.getRoomName(context),
          style: TEXT_STYLE_DEVICE_ROOM_NAME),
    );
  }

  Widget _buildDevice(BuildContext context, _DeviceUiEntity deviceUiEntity) {
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          //一条
          height: Adapt.px(240),
          color: const Color(0xFFF9F9F9),
          margin: EdgeInsets.only(
              left: Adapt.px(40),
              right: Adapt.px(40),
              top: Adapt.px(15),
              bottom: Adapt.px(15)),
          padding: EdgeInsets.only(right: Adapt.px(67)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                //图+字
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DeviceIconView(
                      deviceType: deviceUiEntity.iconType,
                      entity: deviceUiEntity.entity,
                      showRealtimeState: false,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(deviceUiEntity.entity.getName(),
                                overflow: TextOverflow.ellipsis,
                                style: TEXT_STYLE_DEVICE_DEVICE_NAME),
                            Text(getDeviceDetail(deviceUiEntity.iconType),
                                overflow: TextOverflow.ellipsis,
                                style: TEXT_STYLE_DEVICE_DEVICE_DETAIL)
                          ],
                        ))
                  ],
                ),
              ),
              Container(
                  child: Stack(
                children: <Widget>[
                  //箭头
                  Offstage(
                    offstage: !deviceUiEntity.showNextIcon,
                    child: Image(
                      image: AssetImage('images/icon_next.png'),
                      width: Adapt.px(19),
                      height: Adapt.px(35),
                    ),
                  ),
                  //离线
                  Offstage(
                    offstage: !deviceUiEntity.showOffline,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Image(
                          width: Adapt.px(30),
                          height: Adapt.px(30),
                          image: AssetImage('images/icon_offline.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Adapt.px(10)),
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
                          padding: EdgeInsets.only(right: Adapt.px(10)),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
        onTap: () {
          if (deviceUiEntity.entity is LogicDevice) {
            LogicDevice logicDevice = deviceUiEntity.entity;
            if (logicDevice.isOnOffLight) {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (context) => AutoConditionRadioType(
                        entity: deviceUiEntity.entity,
                        automation: widget.automation,
                        stateType: TYPE_CONDITION_ONOFF,
                        deviceProfile: CONDITION_DEVICE_TYPE_LIGHT,
                        cond: null,
                      ),
                  settings: RouteSettings(
                    name: '/AutoConditionRadioType',
                  ),
                ),
              );
              return;
            }
          } else if (deviceUiEntity.entity is PhysicDevice) {
            PhysicDevice physicDevice = deviceUiEntity.entity;
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder: (context) => AutoCondSelectedWallswitchDevice(
                      physicDevice: deviceUiEntity.entity,
                      automation: widget.automation,
                    ),
                settings: RouteSettings(
                  name: '/AutoConditionRadioType',
                ),
              ),
            );
            return;
          }
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (context) => AutoCondSelectDeviceCondition(
                    entity: deviceUiEntity.entity,
                    automation: widget.automation,
                  ),
              settings: RouteSettings(
                name: '/AutoCondSelectDeviceCondition',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
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
              height: Adapt.px(240),
              gaplessPlayback: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 70.0),
            child: Image.asset(
              'images/no_device.png',
              width: 80.0,
              height: Adapt.px(240),
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
    //给entity排序
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
    //是不是设备
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
    //查找设备
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
    //获取房间uuid
    final _GroupUiEntity groupUiEntity = _uiEntities.first as _GroupUiEntity;
    return groupUiEntity.room.uuid;
  }

  int get count {
    //获取个数
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
  final Entity entity; //定义了一个类型的entity

  // bool switchShowIndicator = false;//是否显示转圈

  _DeviceUiEntity(this.entity);

  int get iconType {
    //获取设备类型
    if (entity is PhysicDevice) {
      final PhysicDevice pd = entity as PhysicDevice;
      if (pd.isWallSwitch) return ICON_WALL_SWITCH;
      if (pd.isWallSwitchUS) return ICON_WALL_SWITCH;
      if (pd.isSwitchModule) return ICON_SWITCH_MODULE;
      return ICON_UNKNOWN;
    } else if (entity is LogicDevice) {
      final LogicDevice ld = entity as LogicDevice;
      if (ld.isOnOffLight) return ICON_LIGHT;
      if (ld.isSmartPlug) return ICON_PLUG;
      if (ld.isAwarenessSwitch) return ICON_AWARENESS_SWITCH;
      if (ld.isDoorContact) return ICON_DOOR_SENSOR;
      if (ld.isCurtain) return ICON_CURTAIN;
      if (ld.isSmartDial) return ICON_SMART_DIAL;
      return ICON_UNKNOWN;
    } else {
      return ICON_UNKNOWN;
    }
  }

  // bool get isSecuratyDevice =>//布防设备
  //     iconType == ICON_DOOR_SENSOR || iconType == ICON_AWARENESS_SWITCH;

  bool get showNextIcon {
    //是否显示箭头到下一级
    if ((entity is PhysicDevice || entity is LogicDevice) &&
        available == true) {
      // if(available) return false;
      return true;
    }
    return false;
  }

  bool get showOffline {
    //是不是离线 是否要显示离线
    if (entity is PhysicDevice) {
      final PhysicDevice pd = entity as PhysicDevice;
      return !pd.available;
    }
    if (entity is LogicDevice) {
      final LogicDevice ld = entity as LogicDevice;
      // if (ld.isSmartDial) return false;
      return !ld.parent.available;
    }
    return false;
  }

  bool get available {
    //是否在线
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
}
