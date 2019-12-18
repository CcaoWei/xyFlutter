import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/widget/switch_button.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';

import 'dart:async';

const int SERIAL_NUMBER = 0;
const int VERSION = 1;
const int RSSI = 2;
const int DEVICE_TYPE = 3;

const int GROUP_LED_INDICATE = 1;
const int GROUP_DISABLE_RELAY = 2;
const int GROUP_RECOVER_RELAY = 3;
const int GROUP_SM_INPUT_MODE = 5;

//临界版本 不支持
const int PLUG_VERSION_SUPPORT_LED = 84;
const int CURTAIN_VERSION_SUPPORT_LED = 25;
const int S_WALL_SWITCH_VERSION_SUPPORT_LED = 54;
const int D_WALL_SWITCH_VERSION_SUPPORT_LED = 13;

class DeviceInformationsPage extends StatefulWidget {
  final Entity entity;

  DeviceInformationsPage({Key key, @required this.entity}) : super(key: key);

  State<StatefulWidget> createState() => _DeviceInformationsState();
}

class _DeviceInformationsState extends State<DeviceInformationsPage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'DeviceInformationPage');

  Entity entity;

  final List<_Group> groups = List();

  StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    super.dispose();
  }

  void resetData() {
    print("------------------------------device_information_page.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) {
      entity = widget.entity;
    } else {
      entity = cache.findEntity(widget.entity.uuid);
    }
    groups.clear();

    final _InformationGroup informationGroup =
        _InformationGroup(entity: entity);
    groups.add(informationGroup);
    if (entity is LogicDevice) {
      final LogicDevice ld = entity;
      if (ld.isSmartPlug) {
        if (ld.parent.firmwareVersion > PLUG_VERSION_SUPPORT_LED) {
          if (ld.indicateLED == 1 || ld.indicateLED == 0) {
            final _LEDIndicateGroup ledIndicateGroup = _LEDIndicateGroup();
            ledIndicateGroup.add(entity);
            groups.add(ledIndicateGroup);
          }
          if (ld.enableKeepOnOffStatus == 1 || ld.enableKeepOnOffStatus == 0) {
            final _RecoverRelayGroup recoverRelayGroup = _RecoverRelayGroup();
            recoverRelayGroup.add(entity);
            groups.add(recoverRelayGroup);
          }
        }
      } else if (ld.isCurtain) {
        if (ld.parent.firmwareVersion > CURTAIN_VERSION_SUPPORT_LED) {
          if (ld.indicateLED == 1 || ld.indicateLED == 0) {
            final _LEDIndicateGroup ledIndicateGroup = _LEDIndicateGroup();
            ledIndicateGroup.add(entity);
            groups.add(ledIndicateGroup);
          }
        }
      } else if (ld.isOnOffLight) {
        if (ld.enableKeepOnOffStatus == 1 || ld.enableKeepOnOffStatus == 0) {
          final _RecoverRelayGroup recoverRelayGroup = _RecoverRelayGroup();
          recoverRelayGroup.add(entity);
          groups.add(recoverRelayGroup);
        }
      }
    } else if (entity is PhysicDevice) {
      final PhysicDevice pd = entity;
      if (pd.isWallSwitch) {
        if (pd.isWallSwitchD || pd.isWallSwitchS) {
          if ((pd.isWallSwitchD &&
                  pd.firmwareVersion > D_WALL_SWITCH_VERSION_SUPPORT_LED) ||
              (pd.isWallSwitchS &&
                  pd.firmwareVersion > S_WALL_SWITCH_VERSION_SUPPORT_LED)) {
            final LogicDevice first = pd.getLogicDevice(0);
            if (first.indicateLED == 1 || first.indicateLED == 0) {
              final _LEDIndicateGroup ledIndicateGroup = _LEDIndicateGroup();
              ledIndicateGroup.add(entity);
              groups.add(ledIndicateGroup);
            }
          }
        }
      } else if (pd.isSwitchModule) {
      } else if (pd.isWallSwitchS) {
        if (pd.firmwareVersion > S_WALL_SWITCH_VERSION_SUPPORT_LED) {
          final LogicDevice first = pd.getLogicDevice(0);
          if (first.indicateLED == 1 || first.indicateLED == 0) {
            final _LEDIndicateGroup ledIndicateGroup = _LEDIndicateGroup();
            ledIndicateGroup.add(entity);
            groups.add(ledIndicateGroup);
          }
        }
      }
    }
    setState(() {});
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid &&
            event.uuid == widget.entity.uuid)
        .where((event) =>
            event is PhysicDeviceAvailableEvent ||
            event is DeviceOfflineEvent ||
            (event is DeviceAttributeReportEvent &&
                (event.attrId == ATTRIBUTE_ID_ON_OFF_STATUS ||
                    event.attrId == ATTRIBUTE_ID_FIRMWARE_VERSION ||
                    event.attrId == ATTRIBUTE_ID_CFG_MUTEXED_INDEX ||
                    event.attrId == ATTRIBUTE_ID_CFG_SW_INPUT_MODE ||
                    event.attrId == ATTRIBUTE_ID_CONFIG_INDICATOR_LED ||
                    event.attrId == ATTRIBUTE_ID_CONFIG_DISABLE_RELAY ||
                    event.attrId == ATTRIBUTE_ID_ENABLE_KEEP_ON_OFF_STATUS)))
        .listen((event) {
      if (event.attrId == ATTRIBUTE_ID_CFG_SW_INPUT_MODE) {
        resetData();
      } else {
        setState(() {});
      }
    });
  }

  void writeAttribute(
      Entity entity, int attrId, int attrValue, _UiEntity uiEntity) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.writeAttribute(homeCenterUuid, entity.uuid, attrId, attrValue)
        .listen((response) {
      if (response is WriteAttributeResponse) {
        if (uiEntity is _LEDIndicateUiEntity) {
          uiEntity.switchShowIndicator = false;
        } else if (uiEntity is _RecoverRelayUiEntity) {
          uiEntity.switchShowIndicator = false;
        } else if (uiEntity is _DisableRelayUiEntity) {
          uiEntity.switchShowIndicator = false;
        }
        if (!response.success) {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
          //log.e('write attr error: ${response.code}', 'writeAttribute');
        } else {
          entity.setAttribute(attrId, attrValue);
        }
        setState(() {});
      }
    });
  }

  int get itemCount {
    int count = 0;
    for (var group in groups) {
      count += group.size();
    }
    return count;
  }

  _UiEntity getUiEntity(int index) {
    int step = 0;
    for (var group in groups) {
      if (index >= step && index < step + group.size()) {
        return group.get(index - step);
      } else {
        step += group.size();
      }
    }
    return null;
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: entity.getName(),
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(context, getUiEntity(index));
      },
    );
  }

  Widget _buildItem(BuildContext context, _UiEntity uiEntity) {
    if (uiEntity is _InformationUiEntity) {
      return _buildInfomationItem(context, uiEntity);
    } else if (uiEntity is _GroupUiEntity) {
      return _buildGroupItem(context, uiEntity);
    } else if (uiEntity is _LEDIndicateUiEntity) {
      return _buildLEDIndicateItem(context, uiEntity);
    } else if (uiEntity is _DisableRelayUiEntity) {
      return _buildDisableRelayItem(context, uiEntity);
    } else if (uiEntity is _RecoverRelayUiEntity) {
      return _buildRecoverRelayItem(context, uiEntity);
    } else {
      return Container();
    }
  }

  Widget _buildInfomationItem(
      BuildContext context, _InformationUiEntity uiEntity) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 0.0),
      height: 53.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 51.0,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  uiEntity.getTitle(context),
                  style: TextStyle(
                      inherit: false, color: Color(0x7F2D3B46), fontSize: 15.0),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 13.0),
                  child: Text(
                    uiEntity.content,
                    style: TextStyle(
                      inherit: false,
                      color: Color(0xB22D3B46),
                      fontSize: 15.0,
                    ),
                  ),
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
    );
  }

  Widget _buildGroupItem(BuildContext context, _GroupUiEntity uiEntity) {
    return Container(
      padding: EdgeInsets.only(left: 13.0, right: 13.0),
      margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
      alignment: Alignment.centerLeft,
      child: Text(
        uiEntity.getTitle(context),
        style: TextStyle(
          inherit: false,
          fontSize: 14.0,
          color: const Color(0xFF9B9B9B),
        ),
      ),
    );
  }

  Widget _buildLEDIndicateItem(
      BuildContext context, _LEDIndicateUiEntity uiEntity) {
    return Container(
      color: const Color(0xFFFAFAFA),
      height: 80.0,
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 13.0, right: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Image(
                  width: 26.0,
                  height: 26.0,
                  image: AssetImage(uiEntity.imageUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 27.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getTitle(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 15.0,
                          color: const Color(0xFF55585A),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getDescription(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 11.0,
                          color: const Color(0xFF899198),
                        ),
                        //overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 0.0),
            child: SwitchButton(
              activeColor: const Color(0xFF7CD0FF),
              value: uiEntity.isButtonChecked,
              showIndicator: uiEntity.switchShowIndicator,
              showText: false,
              onChanged: (bool value) {
                uiEntity.switchShowIndicator = true;
                setState(() {});
                //final String uuid = uiEntity.entity.uuid;
                final int attrId = ATTRIBUTE_ID_CONFIG_INDICATOR_LED;
                final int attrValue = uiEntity.isButtonChecked ? 0 : 1;
                if (uiEntity.entity is PhysicDevice) {
                  final PhysicDevice pd = uiEntity.entity as PhysicDevice;
                  final LogicDevice ld = pd.getLogicDevice(0);
                  writeAttribute(ld, attrId, attrValue, uiEntity);
                } else {
                  writeAttribute(uiEntity.entity, attrId, attrValue, uiEntity);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoverRelayItem(
      BuildContext context, _RecoverRelayUiEntity uiEntity) {
    return Container(
      color: const Color(0xFFFAFAFA),
      height: 80.0,
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 13.0, right: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Image(
                  width: 26.0,
                  height: 26.0,
                  image: AssetImage(uiEntity.imageUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 27.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getTitle(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 15.0,
                          color: const Color(0xFF55585A),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getDescription(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 11.0,
                          color: const Color(0xFF899198),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 0.0),
            child: SwitchButton(
              activeColor: const Color(0xFF7CD0FF),
              value: uiEntity.isButtonChecked,
              showIndicator: uiEntity.switchShowIndicator,
              showText: false,
              onChanged: (bool value) {
                uiEntity.switchShowIndicator = true;
                setState(() {});
                //final String uuid = uiEntity.entity.uuid;
                final int attrId = ATTRIBUTE_ID_ENABLE_KEEP_ON_OFF_STATUS;
                final int attrValue = uiEntity.isButtonChecked ? 0 : 1;
                writeAttribute(uiEntity.entity, attrId, attrValue, uiEntity);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisableRelayItem(
      BuildContext context, _DisableRelayUiEntity uiEntity) {
    return Container(
      color: const Color(0xFFFAFAFA),
      height: 80.0,
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 13.0, right: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Image(
                  width: 26.0,
                  height: 26.0,
                  image: AssetImage(uiEntity.imageUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 27.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getTitle(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 15.0,
                          color: const Color(0xFF55585A),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getDescription(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 11.0,
                          color: const Color(0xFF899198),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 0.0),
            child: SwitchButton(
              activeColor: const Color(0xFF7CD0FF),
              value: uiEntity.isButtonChecked,
              showIndicator: uiEntity.switchShowIndicator,
              showText: false,
              onChanged: (bool value) {
                uiEntity.switchShowIndicator = true;
                setState(() {});
                //final String uuid = uiEntity.logicDevice.uuid;
                final int attrId = ATTRIBUTE_ID_CONFIG_DISABLE_RELAY;
                final int attrValue = uiEntity.isButtonChecked ? 0 : 1;
                writeAttribute(
                    uiEntity.logicDevice, attrId, attrValue, uiEntity);
              },
            ),
          ),
        ],
      ),
    );
  }
}

abstract class _Group {
  int size();
  _UiEntity get(int index);
}

class _InformationGroup extends _Group {
  final List<_InformationUiEntity> uiEntities = List();

  _InformationGroup({
    Key key,
    @required entity,
  }) {
    uiEntities.add(_InformationUiEntity(entity: entity, type: SERIAL_NUMBER));
    uiEntities.add(_InformationUiEntity(entity: entity, type: VERSION));
    uiEntities.add(_InformationUiEntity(entity: entity, type: DEVICE_TYPE));
    uiEntities.add(_InformationUiEntity(entity: entity, type: RSSI));
  }

  int size() => uiEntities.length;

  _UiEntity get(int index) => uiEntities.elementAt(index);
}

class _RecoverRelayGroup extends _Group {
  final List<_UiEntity> uiEntities = List();

  _RecoverRelayGroup() {
    uiEntities.add(_GroupUiEntity(type: GROUP_RECOVER_RELAY));
  }

  int size() => uiEntities.length > 1 ? uiEntities.length : 0;

  void add(Entity entity) {
    uiEntities.add(_RecoverRelayUiEntity(entity: entity));
  }

  _UiEntity get(int index) => uiEntities.elementAt(index);
}

class _LEDIndicateGroup extends _Group {
  final List<_UiEntity> uiEntities = List();

  _LEDIndicateGroup() {
    uiEntities.add(_GroupUiEntity(type: GROUP_LED_INDICATE));
  }

  int size() => uiEntities.length > 1 ? uiEntities.length : 0;

  void add(Entity entity) {
    uiEntities.add(_LEDIndicateUiEntity(entity: entity));
  }

  _UiEntity get(int index) => uiEntities.elementAt(index);
}

abstract class _UiEntity {}

class _InformationUiEntity extends _UiEntity {
  final Entity entity;
  final int type;

  _InformationUiEntity({
    @required this.entity,
    @required this.type,
  });

  String getTitle(BuildContext context) {
    switch (type) {
      case SERIAL_NUMBER:
        return DefinedLocalizations.of(context).serialNumber;
      case VERSION:
        return DefinedLocalizations.of(context).version;
      case RSSI:
        return DefinedLocalizations.of(context).rssi;
      case DEVICE_TYPE:
        return DefinedLocalizations.of(context).deviceType;
      default:
        return '';
    }
  }

  String get content {
    switch (type) {
      case SERIAL_NUMBER:
        return entity.uuid;
      case VERSION:
        return entity.firmwareVersion.toString();
      case RSSI:
        return entity.rssi.toString();
      case DEVICE_TYPE:
        if (entity is LogicDevice) {
          final LogicDevice ld = entity as LogicDevice;
          return ld.parent.model;
        } else if (entity is PhysicDevice) {
          final PhysicDevice pd = entity as PhysicDevice;
          return pd.model;
        }
        return '';
      default:
        return '';
    }
  }
}

class _GroupUiEntity extends _UiEntity {
  final int type;

  _GroupUiEntity({
    Key key,
    @required this.type,
  });

  String getTitle(BuildContext context) {
    switch (type) {
      case GROUP_LED_INDICATE:
        return DefinedLocalizations.of(context).ledIndicatorConfiguration;
      case GROUP_DISABLE_RELAY:
        return DefinedLocalizations.of(context).switchConfiguration;
      case GROUP_RECOVER_RELAY:
        return DefinedLocalizations.of(context).recoverRelayConfiguration;
      case GROUP_SM_INPUT_MODE:
        return DefinedLocalizations.of(context).smInputMode;
      default:
        return '';
    }
  }
}

class _RecoverRelayUiEntity extends _UiEntity {
  final Entity entity;

  bool switchShowIndicator = false;

  _RecoverRelayUiEntity({
    @required this.entity,
  });

  String get imageUrl {
    if (entity.enableKeepOnOffStatus == 1) {
      return 'images/recover_relay_on.png';
    } else {
      return 'images/recover_relay_off.png';
    }
  }

  String getTitle(BuildContext context) {
    if (isButtonChecked) {
      return DefinedLocalizations.of(context).recoverRelayOn;
    } else {
      return DefinedLocalizations.of(context).recoverRelayOff;
    }
  }

  String getDescription(BuildContext context) {
    if (isButtonChecked) {
      return DefinedLocalizations.of(context).recoverRelayOnDes;
    } else {
      return DefinedLocalizations.of(context).recoverRelayOffDes;
    }
  }

  bool get isButtonChecked {
    return entity.enableKeepOnOffStatus == 1;
  }
}

class _LEDIndicateUiEntity extends _UiEntity {
  final Entity entity;

  bool switchShowIndicator = false;

  _LEDIndicateUiEntity({
    @required this.entity,
  });

  String get imageUrl {
    if (isButtonChecked) {
      return 'images/indicate_led_on.png';
    } else {
      return 'images/indicate_led_off.png';
    }
  }

  String getTitle(BuildContext context) {
    if (isButtonChecked) {
      return DefinedLocalizations.of(context).ledIndicatorOn;
    } else {
      return DefinedLocalizations.of(context).ledIndicatorOff;
    }
  }

  String getDescription(BuildContext context) {
    if (isButtonChecked) {
      return DefinedLocalizations.of(context).ledIndicatorSingleOnDes;
    } else {
      return DefinedLocalizations.of(context).ledIndicatorOffDes;
    }
  }

  bool get isButtonChecked {
    if (entity is PhysicDevice) {
      final PhysicDevice pd = entity as PhysicDevice;
      final LogicDevice ld = pd.getLogicDevice(0);
      return ld.indicateLED == 1;
    } else if (entity is LogicDevice) {
      return entity.indicateLED == 1;
    }
    return false;
  }
}

class _DisableRelayUiEntity extends _UiEntity {
  final LogicDevice logicDevice;

  bool switchShowIndicator = false;

  _DisableRelayUiEntity({
    @required this.logicDevice,
  });

  String getTitle(BuildContext context) {
    if (!isButtonChecked) {
      return DefinedLocalizations.of(context).relayLight;
    } else {
      return DefinedLocalizations.of(context).relayButton;
    }
  }

  String getDescription(BuildContext context) {
    if (!isButtonChecked) {
      return DefinedLocalizations.of(context).relayLightDes;
    } else {
      return DefinedLocalizations.of(context).relayButtonDes;
    }
  }

  String get imageUrl {
    if (logicDevice.uuid.endsWith('-01')) {
      if (logicDevice.disableRelay == 1) {
        return 'images/wall_switch_binding_left_top.png';
      }
      if (logicDevice.parent.available) {
        if (logicDevice.onOffStatus == ON_OFF_STATUS_ON) {
          return 'images/icon_ws_lt_on.png';
        } else {
          return 'images/icon_ws_lt_off.png';
        }
      } else {
        return 'images/icon_ws_lt_offline.png';
      }
    } else if (logicDevice.uuid.endsWith('-02')) {
      if (logicDevice.disableRelay == 1) {
        return 'images/wall_switch_binding_top.png';
      }
      if (logicDevice.parent.available) {
        if (logicDevice.onOffStatus == ON_OFF_STATUS_ON) {
          return 'images/icon_ws_rt_on.png';
        } else {
          return 'images/icon_ws_rt_off.png';
        }
      } else {
        return 'images/icon_ws_rt_offline.png';
      }
    } else if (logicDevice.uuid.endsWith('-03')) {
      if (logicDevice.disableRelay == 1) {
        return 'images/wall_switch_binding_left.png';
      }
      if (logicDevice.parent.available) {
        if (logicDevice.onOffStatus == ON_OFF_STATUS_ON) {
          return 'images/icon_ws_lb_on.png';
        } else {
          return 'images/icon_ws_lb_off.png';
        }
      } else {
        return 'images/icon_ws_lb_offline.png';
      }
    } else {
      if (logicDevice.disableRelay == 1) {
        return 'images/wall_switch_binding_right.png';
      }
      if (logicDevice.parent.available) {
        if (logicDevice.onOffStatus == ON_OFF_STATUS_ON) {
          return 'images/icon_ws_rb_on.png';
        } else {
          return 'images/icon_ws_rb_off.png';
        }
      } else {
        return 'images/icon_ws_rb_offline.png';
      }
    }
  }

  bool get isButtonChecked {
    return logicDevice.disableRelay == 1;
  }
}
