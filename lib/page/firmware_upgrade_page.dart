import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/firmware/firmware_manager.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/firmware/upgrade_util.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_page.dart';

import 'dart:async';

class FirmwareUpgradePage extends StatefulWidget {
  final String homeCenterUuid;

  FirmwareUpgradePage({
    @required this.homeCenterUuid,
  });

  State<StatefulWidget> createState() => FirmwareUpgradeState();
}

class FirmwareUpgradeState extends State<FirmwareUpgradePage> {
  static const String className = 'FirmwareUpgradePage';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  List<_Group> _groups = List<_Group>();

  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _resetData(true);
    _start();
  }

  void _resetData(bool init) {
    print("------------------------------firmware_upgrade_page.dart");
    _groups.clear();
    final List<FirmwareDeviceGroup> _deviceGroups =
        FirmwareManager().firmwareDeviceGroup(widget.homeCenterUuid);
    for (FirmwareDeviceGroup deviceGroup in _deviceGroups) {
      _Group group = _findGroup(deviceGroup.firmware.uuid);
      if (group == null) {
        group = _Group(deviceGroup.firmware);
      }
      for (FirmwareDevice fd in deviceGroup.devices.values) {
        if (fd.physicDevice.firmwareVersion >= deviceGroup.firmware.version)
          continue;
        if (!fd.physicDevice.available) continue;
        if (fd.state == UPGRADE_STATUS_FINISHED) {
          if (init) {
            fd.state = UPGRADE_STATUS_NONE;
          } else {
            continue;
          }
        }
        group.addFirmwareDevice(fd);
      }
      _groups.add(group);
    }
    setState(() {});
  }

  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void _start() {
    _subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == widget.homeCenterUuid)
        .where((event) =>
            event is PhysicDeviceAvailableEvent ||
            event is DeviceDeleteEvent ||
            event is DeviceOfflineEvent ||
            event is FirmwareAvailableEvent ||
            event is FirmwareUpgradeStatusChangeEvent)
        .listen((event) {
      if (event is FirmwareUpgradeStatusChangeEvent) {
        //_resetData(false);
        setState(() {});
      } else {
        _resetData(false);
      }
    });
  }

  bool _isLastUiEntityInGroup(_DeviceUiEntity uiEntity) {
    for (var group in _groups) {
      if (group.isLast(uiEntity)) return true;
    }
    return false;
  }

  String _description(BuildContext context, FirmwareDevice firmwareDevice) {
    final String methodName = 'description';
    if (firmwareDevice.state == UPGRADE_STATUS_NONE) {
      return DefinedLocalizations.of(context).currentVersion +
          ': ${firmwareDevice.versionString}';
    } else if (firmwareDevice.state == UPGRADE_STATUS_FINISHED) {
      return DefinedLocalizations.of(context).upgradeComplete;
    } else if (firmwareDevice.state == UPGRADE_STATUS_STARTED) {
      return DefinedLocalizations.of(context).prepareToUpgrade;
    } else if (firmwareDevice.state == UPGRADE_STATUS_ERROR) {
      return DefinedLocalizations.of(context).upgradeError;
    } else {
      return DefinedLocalizations.of(context).upgrading;
    }
  }

  bool _isUpgradeButtonShown(String firmwareUuid) {
    final _Group group = _findGroup(firmwareUuid);
    if (group != null) {
      return group.hasSelectedDevice;
    }
    return false;
  }

  int get _itemCount {
    int count = 0;
    for (var group in _groups) {
      count += group.count;
    }
    return count;
  }

  _Group _findGroup(String firmwareUuid) {
    for (var group in _groups) {
      if (group.firmware.uuid == firmwareUuid) {
        return group;
      }
    }
    return null;
  }

  void _upgradeDevices(String firmwareVersion, String firmwareUuid) {
    final _Group group = _findGroup(firmwareUuid);
    if (group != null) {
      for (_UiEntity uiEntity in group._uiEntities) {
        if (uiEntity is _GroupUiEntity) continue;
        final _DeviceUiEntity deviceUiEntity = uiEntity as _DeviceUiEntity;
        if (deviceUiEntity.selected) {
          _upgradeDevice(firmwareVersion, group.firmware.uuid, deviceUiEntity);
          deviceUiEntity.selected = false;
        }
      }
      setState(() {});
    }
  }

  void _upgradeDevice(
      String firmwareVersion, String firmwareUuid, _DeviceUiEntity uiEntity) {
    final String methodName = 'upgradeDevice';
    //final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    final String uuid = uiEntity.firmwareDevice.physicDevice.uuid;
    print('firmware uuid: $firmwareUuid');
    MqttProxy.upgradeDevice(widget.homeCenterUuid, firmwareUuid, uuid)
        .listen((response) {
      if (response.success) {
        log.i('upgrade device $uuid succeed', methodName);
        uiEntity.firmwareDevice.state = UPGRADE_STATUS_STARTED;

        if (uuid.startsWith('box-')) {
          UpgradeUtil.startHomeCenterUpgrade(
              widget.homeCenterUuid,
              firmwareUuid,
              firmwareVersion,
              uiEntity.firmwareDevice.physicDevice);
        }
      } else {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
        );
        uiEntity.firmwareDevice.state = UPGRADE_STATUS_ERROR;
      }
      setState(() {});
    });
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  _UiEntity getItem(int index) {
    int step = 0;
    for (var group in _groups) {
      if (index >= step && index < group.count + step) {
        return group.get(index - step);
      } else {
        step += group.count;
      }
    }
    return null;
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).firmwareUpgrade,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 13.0, right: 13.0),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10.0),
        itemCount: _itemCount,
        itemBuilder: (BuildContext context, int index) {
          final _UiEntity uiEntity = getItem(index);
          return _buildItem(context, uiEntity);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, _UiEntity uiEntity) {
    if (uiEntity is _GroupUiEntity) {
      return _buildGroupItem(context, uiEntity);
    } else if (uiEntity is _DeviceUiEntity) {
      return _buildDeviceItem(context, uiEntity);
    }
    return Container();
  }

  Widget _buildGroupItem(BuildContext context, _GroupUiEntity uiEntity) {
    return Container(
      height: 36.0,
      color: const Color(0xFFF5F5F5),
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.only(left: 13.0, right: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: Adapt.px(10)),
                width: 160.0,
                child: Text(
                  DefinedLocalizations.of(context).canUpgradeTo +
                      ' ' +
                      uiEntity.firmware.versionString,
                  style: TEXT_STYLE_UPGRADE_GROUP,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: Adapt.px(10)),
                  width: 90.0,
                  child: Text(
                    DefinedLocalizations.of(context).viewNewFeatures,
                    style: TEXT_STYLE_UPGRADE_GROUP,
                  ),
                ),
                onTap: () {
                  final String prefix = 'https://www.' +
                      DefinedLocalizations.of(context).officialSiteRoot +
                      '/blog/posts/';
                  launchUrl(prefix + uiEntity.releaseHistoryUrl);
                },
              ),
            ],
          ),
          Offstage(
            offstage: !_isUpgradeButtonShown(uiEntity.firmware.uuid),
            child: Container(
              width: 54.0,
              height: 24.0,
              child: CupertinoButton(
                child: Text(
                  DefinedLocalizations.of(context).upgrade,
                  style: TEXT_STYLE_UPGRADE_BUTTON,
                ),
                color: const Color(0xFF8B98A7),
                pressedOpacity: 0.8,
                borderRadius: BorderRadius.circular(12.0),
                padding: EdgeInsets.only(left: 0.0, right: 0.0),
                onPressed: () {
                  _upgradeDevices(uiEntity.firmware.version.toString(),
                      uiEntity.firmware.uuid);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(BuildContext context, _DeviceUiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: const Color(0xFFF5F5F5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 80.0,
                        height: 80.0,
                        alignment: Alignment.center,
                        child: _buildDeviceIcon(
                            uiEntity.firmwareDevice.physicDevice),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 5.0, bottom: 3.0),
                            child: Text(
                              uiEntity.firmwareDevice.deviceName,
                              style: TEXT_STYLE_UPGRADE_NAME,
                            ),
                          ),
                          Text(
                            _description(context, uiEntity.firmwareDevice),
                            style: TEXT_STYLE_UPGRADE_DESCRIPTION,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 50.0,
                    alignment: Alignment.centerRight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Offstage(
                          offstage: uiEntity.firmwareDevice.state !=
                              UPGRADE_STATUS_NONE,
                          child: Center(
                            child: Image(
                              width: uiEntity.selected ? 21.0 : 10.5,
                              height: uiEntity.selected ? 21.0 : 10.5,
                              image: AssetImage(uiEntity.checkImageUrl),
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: uiEntity.firmwareDevice.state !=
                              UPGRADE_STATUS_ONGOING,
                          child: _buildProgressWidget(
                              context, uiEntity.firmwareDevice),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Offstage(
                offstage: _isLastUiEntityInGroup(uiEntity),
                child: Padding(
                  padding: EdgeInsets.only(left: 13.0, right: 13.0),
                  child: Divider(
                    height: 2.0,
                    color: const Color(0x33000000),
                  ),
                )),
            Offstage(
              offstage: !_isLastUiEntityInGroup(uiEntity),
              child: Container(
                height: 10.0,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (uiEntity.firmwareDevice.state == UPGRADE_STATUS_FINISHED ||
            uiEntity.firmwareDevice.state == UPGRADE_STATUS_ONGOING ||
            uiEntity.firmwareDevice.state == UPGRADE_STATUS_STARTED) return;
        uiEntity.selected = !uiEntity.selected;
        setState(() {});
      },
    );
  }

  Widget _buildDeviceIcon(PhysicDevice physicDevice) {
    if (physicDevice.isLightSocket) {
      return Image(
        width: 80.0,
        height: 80.0,
        image: AssetImage('images/picture_light.png'),
      );
    } else if (physicDevice.isZHHVRVGateway) {
      return Image(
        width: 80.0,
        height: 80.0,
        image: AssetImage('images/new_device_air_conditioner.png'),
      );
    } else if (physicDevice.isSmartPlug) {
      return Image(
        width: 80.0,
        height: 80.0,
        image: AssetImage('images/picture_plug.png'),
      );
    } else if (physicDevice.isAwarenessSwitch) {
      return Image(
        width: 80.0,
        height: 80.0,
        image: AssetImage('images/picture_awareness_switch.png'),
      );
    } else if (physicDevice.isDoorContact) {
      return Image(
        width: 80.0,
        height: 80.0,
        image: AssetImage('images/picture_door_contact.png'),
      );
    } else if (physicDevice.isWallSwitch) {
      return Image(
        width: 80.0,
        height: 80.0,
        image: AssetImage('images/picture_wall_switch.png'),
      );
    } else if (physicDevice.isWallSwitchUS) {
      return Image.asset(
        'images/picture_wall_switch_us.png',
        width: 80.0,
        height: 80.0,
        gaplessPlayback: true,
      );
    } else if (physicDevice.isSwitchModule) {
      return Image.asset(
        'images/picture_switch_module.png',
        width: 80.0,
        height: 80.0,
        gaplessPlayback: true,
      );
    } else if (physicDevice.isCurtain) {
      return Image(
        width: 80.0,
        height: 80.0,
        image: AssetImage('images/picture_curtain.png'),
      );
    } else if (physicDevice.isLightSocket) {
      return Image.asset(
        'images/picture_rotary_knob.png',
        width: 80.0,
        height: 80.0,
        gaplessPlayback: true,
      );
    } else {
      if (physicDevice.uuid.startsWith('box-')) {
        return Image(
          width: 80.0,
          height: 80.0,
          image: AssetImage('images/picture_home_center.png'),
        );
      }
      return Container();
    }
  }

  Widget _buildProgressWidget(
      BuildContext context, FirmwareDevice firmwareDevice) {
    return Container(
      width: 40.0,
      height: 40.0,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFDAEBF4)),
          ),
          CircularProgressIndicator(
            value: firmwareDevice.percent / 100.0,
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF7ECFFE)),
          ),
          Text(
            firmwareDevice.percent.toString() + '%',
            style: TEXT_STYLE_UPGRADE_PROGRESS,
          ),
        ],
      ),
    );
  }
}

class _Group {
  final List<_UiEntity> _uiEntities = List();
  Firmware firmware;

  _Group(Firmware firmware) {
    this.firmware = firmware;
    _uiEntities.add(_GroupUiEntity(firmware));
  }

  void addFirmwareDevice(FirmwareDevice firmwareDevice) {
    for (var uiEntity in _uiEntities) {
      if (uiEntity is _DeviceUiEntity) {
        if (uiEntity.firmwareDevice.physicDevice.uuid ==
            firmwareDevice.physicDevice.uuid) return;
      }
    }
    _uiEntities.add(_DeviceUiEntity(firmwareDevice));
  }

  int get count => _uiEntities.length > 1 ? _uiEntities.length : 0;

  _UiEntity get(int index) => _uiEntities[index];

  bool isLast(_DeviceUiEntity uiEntity) {
    final _UiEntity last = _uiEntities[_uiEntities.length - 1];
    if (uiEntity == last) return true;
    if (last is _DeviceUiEntity) {
      return last.firmwareDevice.physicDevice.uuid ==
          uiEntity.firmwareDevice.physicDevice.uuid;
    }
    return false;
  }

  bool get hasSelectedDevice {
    for (var uiEntity in _uiEntities) {
      if (uiEntity is _GroupUiEntity) continue;
      final _DeviceUiEntity deviceUiEntity = uiEntity as _DeviceUiEntity;
      if (deviceUiEntity.selected) return true;
    }
    return false;
  }
}

abstract class _UiEntity {}

class _GroupUiEntity extends _UiEntity {
  final Firmware firmware;

  _GroupUiEntity(this.firmware);

  String get releaseHistoryUrl {
    if (firmware.imageModel == DEVICE_MODEL_HOME_CENTER) {
      return 'home_center_release_history/#v${firmware.versionString2}';
    } else if (firmware.imageModel == DEVICE_MODEL_LIGHT_SOCKET) {
      return 'light_socket_release_history/#v${firmware.versionString2}';
    } else if (firmware.imageModel == DEVICE_MODEL_SMART_PLUG) {
      return 'smart_plug_release_history/#v${firmware.versionString2}';
    } else if (firmware.imageModel == DEVICE_MODEL_AWARENESS_SWITCH) {
      return 'awareness_switch_release_history/#v${firmware.versionString2}';
    } else if (firmware.imageModel == DEVICE_MODEL_DOOR_SENSOR) {
      return 'door_sensor_release_history/#v${firmware.versionString2}';
    } else if (firmware.imageModel == DEVICE_MODEL_CURTAIN) {
      return 'curtain_motor_release_history/#v${firmware.versionString2}';
    } else if (firmware.imageModel == DEVICE_MODEL_WALL_SWITCH_D1 ||
        firmware.imageModel == DEVICE_MODEL_WALL_SWITCH_D2 ||
        firmware.imageModel == DEVICE_MODEL_WALL_SWITCH_D3 ||
        firmware.imageModel == DEVICE_MODEL_WALL_SWITCH_D4) {
      return 'wall_switch_dx_release_history/#v${firmware.versionString2}';
    } else if (firmware.imageModel == DEVICE_MODEL_WALL_SWITCH_S1 ||
        firmware.imageModel == DEVICE_MODEL_WALL_SWITCH_S2 ||
        firmware.imageModel == DEVICE_MODEL_WALL_SWITCH_S3 ||
        firmware.imageModel == DEVICE_MODEL_WALL_SWITCH_S4) {
      return 'wall_switch_sx_release_history/#v${firmware.versionString2}';
    } else if (firmware.imageModel == DEVICE_MODEL_SMART_DIAL) {
      return 'smart_dial_release_history/#v${firmware.versionString2}';
    } else if (firmware.imageModel == DEVICE_MODEL_SWITCH_MODULE_D1 ||
        firmware.imageModel == DEVICE_MODEL_SWITCH_MODULE_D2 ||
        firmware.imageModel == DEVICE_MODEL_SWITCH_MODULE_D3 ||
        firmware.imageModel == DEVICE_MODEL_SWITCH_MODULE_D4 ||
        firmware.imageModel == DEVICE_MODEL_SWITCH_MODULE_S1 ||
        firmware.imageModel == DEVICE_MODEL_SWITCH_MODULE_S2 ||
        firmware.imageModel == DEVICE_MODEL_SWITCH_MODULE_S3 ||
        firmware.imageModel == DEVICE_MODEL_SWITCH_MODULE_S4) {
      return 'switch_module_release_history/#v${firmware.versionString2}';
    }
    return '';
  }
}

class _DeviceUiEntity extends _UiEntity {
  final FirmwareDevice firmwareDevice;

  bool selected = false;

  _DeviceUiEntity(this.firmwareDevice);

  String get checkImageUrl {
    return selected ? 'images/icon_check.png' : 'images/icon_uncheck.png';
  }
}
