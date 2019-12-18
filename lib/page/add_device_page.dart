import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/widget/add_device_view.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'add_device_help_page.dart';
import 'config_info_page.dart';
import 'common_page.dart';

import 'dart:async';

class AddDevicePage extends StatefulWidget {
  State<StatefulWidget> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevicePage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'AddDevicePage');

  final List<_UiEntity> _uiEntities = List();

  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    print("------------------------------add_device_page.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    _uiEntities.clear();
    final List<PhysicDevice> newDevices = cache.newDevices;
    print('new device number: ${newDevices.length}');
    for (var newDevice in newDevices) {
      if (newDevice.isWallSwitch ||
          newDevice.isWallSwitchUS ||
          newDevice.isSwitchModule ||
          newDevice.isZHHVRVGateway) {
        _uiEntities.add(_UiEntity(newDevice));
      } else {
        for (var ld in newDevice.logicDevices) {
          _uiEntities.add(_UiEntity(ld));
        }
      }
    }
    setState(() {});
  }

  void _start() {
    _subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
        .where((event) =>
            event is PhysicDeviceAvailableEvent ||
            event is EntityInfoConfigureEvent ||
            event is DeviceDeleteEvent)
        .listen((event) {
      if (event is PhysicDeviceAvailableEvent) {
        if (event.physicDevice.isNew) {
          _resetData();
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).device +
                ' ' +
                event.physicDevice.getName() +
                ' ' +
                DefinedLocalizations.of(context).isOnline,
          );
        }
      } else if (event is EntityInfoConfigureEvent) {
        _resetData();
      } else if (event is DeviceDeleteEvent) {
        _resetData();
      }
    });
  }

  void dispose() {
    super.dispose();
    _setPermitJoin();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  int get _itemCount => _uiEntities.length;

  void _setPermitJoin() {
    final String methodName = 'setPermitJoin';
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    final ZigbeeSystem system = cache.system;
    MqttProxy.setPermitJoin(homeCenterUuid, system.uuid, 0).listen((response) {
      if (response is SetPermitJoinResponse) {
        if (!response.success) {
          log.w('set permit join failed: ${response.code}', methodName);
        }
      }
    });
  }

  void adjustCurtainTrip(String uuid) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    final int attrId = ATTRIBUTE_ID_CURTAIN_TRIP_ADJUSTING;
    MqttProxy.writeAttribute(homeCenterUuid, uuid, attrId, 1)
        .listen((response) {
      if (response is WriteAttributeResponse) {
        if (!response.success) {
          log.e('adjust trip error *** ${response.code}', 'adjustCurtainTrip');
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).addDevice,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AddDeviceView(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DefinedLocalizations.of(context).scanDevices,
                    style: TextStyle(
                      inherit: false,
                      color: Color(0x7F899198),
                      fontSize: 12.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        DefinedLocalizations.of(context).longPressButton,
                        style: TextStyle(
                          inherit: false,
                          color: Color(0xFF899198),
                          fontSize: 16.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Image(
                          width: 22.0,
                          height: 22.0,
                          image: AssetImage('images/icon_help.png'),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => AddDeviceHelpPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 13.0, top: 15.0),
            child: Text(
              _itemCount == 0
                  ? DefinedLocalizations.of(context).noNewDevice
                  : DefinedLocalizations.of(context).newDevice1 +
                      ' ' +
                      _itemCount.toString() +
                      ' ' +
                      DefinedLocalizations.of(context).newDevice2,
              style: TextStyle(
                inherit: false,
                color: Color(0xFFD4D4D4),
                fontSize: 14.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 5.0),
              itemCount: _itemCount,
              itemBuilder: (BuildContext context, int index) {
                return _buildItem(context, _uiEntities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, _UiEntity uiEntity) {
    return Container(
      height: 80.0,
      color: Color(0xFFF9F9F9),
      margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
      padding: EdgeInsets.only(left: 25.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(
            width: 60.0,
            height: 60.0,
            image: AssetImage(uiEntity.imageUrl),
          ),
          Text(
            uiEntity.entity.getName(),
            style: TextStyle(
              inherit: false,
              color: Colors.black,
              fontSize: 14.0,
            ),
          ),
          Container(
            width: 52.0,
            height: 26.0,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0x3397BAC6)),
              borderRadius: BorderRadius.all(Radius.circular(13.0)),
            ),
            child: CupertinoButton(
              padding: EdgeInsets.only(left: 0.0, right: 0.0),
              color: Colors.white,
              pressedOpacity: 0.7,
              borderRadius: BorderRadius.all(Radius.circular(13.0)),
              child: Text(
                DefinedLocalizations.of(context).add,
                style: TextStyle(
                  inherit: false,
                  color: Color(0xFF2D3B46),
                  fontSize: 13.0,
                ),
              ),
              onPressed: () {
                final String homeCenterUuid =
                    HomeCenterManager().defaultHomeCenterUuid;
                String devuuid;
                var ent = uiEntity.entity;
                if (ent is PhysicDevice) {
                  devuuid = ent.logicDevices[0].uuid;
                } else {
                  devuuid = uiEntity.entity.uuid;
                }
                MqttProxy.identifyDevice(
                        homeCenterUuid, devuuid, EXPIRE_IDENTIFY)
                    .listen((response) {});
                if (uiEntity.entity is LogicDevice) {
                  final LogicDevice ld = uiEntity.entity as LogicDevice;
                  if (ld.isCurtain) {
                    adjustCurtainTrip(ld.uuid);
                  }
                }
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        ConfigInfoPage(entity: uiEntity.entity),
                    settings: RouteSettings(
                      name: '/ConfigInfo',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UiEntity {
  final Entity _entity;
  Entity get entity => _entity;

  _UiEntity(this._entity);

  String get imageUrl {
    if (_entity is PhysicDevice) {
      // print(_entity.getName()+'我是物理设备');
      final PhysicDevice pd = _entity as PhysicDevice;
      if (pd.isWallSwitch) {
        return 'images/picture_wall_switch.png';
      } else if (pd.isWallSwitchUS) {
        return 'images/picture_wall_switch_us.png';
      } else if (pd.isSwitchModule) {
        return 'images/picture_switch_module.png';
      } else if (pd.isZHHVRVGateway) {
        return 'images/new_device_air_conditioner.png';
      }
    } else if (_entity is LogicDevice) {
      // print(_entity.getName()+'我是逻辑设备');
      final LogicDevice ld = _entity as LogicDevice;
      if (ld.isOnOffLight) {
        return 'images/picture_light.png';
      } else if (ld.isSmartPlug) {
        return 'images/picture_plug.png';
      } else if (ld.isAwarenessSwitch) {
        return 'images/picture_awareness_switch.png';
      } else if (ld.isDoorContact) {
        return 'images/picture_door_contact.png';
      } else if (ld.isCurtain) {
        return 'images/picture_curtain.png';
      } else if (ld.isSmartDial) {
        return 'images/new_device_rotary_knob.png';
      }
    }
    return '';
  }
}
