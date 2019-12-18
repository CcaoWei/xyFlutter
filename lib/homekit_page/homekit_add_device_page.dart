import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/channel/event_channel.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;

import 'homekit_set_curtain_type_page.dart';

import 'dart:async';

class HomekitAddDevicePage extends StatefulWidget {
  State<StatefulWidget> createState() => _HomekitAddDeviceState();
}

class _HomekitAddDeviceState extends State<HomekitAddDevicePage> {
  final List<_UiEntity> _uiEntities = List();

  StreamSubscription subscription;

  void initState() {
    super.initState();
    start();
    setPermitJoin(true);
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    super.dispose();
  }

  void setPermitJoin(bool open) {
    final Home home = HomeManager().primaryHome;
    if (home == null) return;
    for (Accessory accessory in home.accessories) {
      if (!accessory.isHomeCenter) continue;
      final Service service =
          accessory.findServiceByType(S_DEFINED_PERMIT_JOIN);
      if (service == null) continue;
      final Characteristic characteristic =
          service.findCharacteristicByType(C_DEFINED_PERMIT_JOIN);
      if (characteristic == null) continue;
      final String homeIdentifier = home.identifier;
      final String accessoryIdentifier = accessory.identifier;
      final String serviceIdentifier = service.identifier;
      final String characteristicIdentifier = characteristic.identifier;
      final bool value = open;
      methodChannel
          .writeValue(homeIdentifier, accessoryIdentifier, serviceIdentifier,
              characteristicIdentifier, value)
          .then((response) {
        final int code = response['code'];
        if (code != 0) {
          print('set permit join error: $code');
        } else {
          print('set permit join success');
        }
      });
    }
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => event is HomekitEvent)
        .where((event) => event is AccessoryAddedEvent)
        .listen((event) {
      if (event is AccessoryAddedEvent) {
        print('Accessory added event');
        _uiEntities.add(_UiEntity(
          accessoryIdentifier: event.accessoryIdentifier,
          homeIdentifier: event.homeIdentifier,
        ));
        setState(() {});
      }
    });
  }

  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          child: Container(
            width: 40.0,
            height: 40.0,
            alignment: Alignment.center,
            child: Text(
              DefinedLocalizations.of(context).complete,
              style: TextStyle(
                  inherit: false, color: Colors.black, fontSize: 17.0),
            ),
          ),
          onTap: () {
            setPermitJoin(false);
            Navigator.of(context).pop();
          },
        ),
        middle: Text(
          DefinedLocalizations.of(context).addEndDevice,
        ),
        trailing: CupertinoActivityIndicator(),
        backgroundColor: Colors.white,
      ),
      child: Container(
        padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 13.0, right: 13.0),
              child: Text(
                DefinedLocalizations.of(context).addEndDeviceDes,
                style: TextStyle(
                  inherit: false,
                  fontSize: 15.0,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                    left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
                itemCount: _uiEntities.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildItem(context, _uiEntities[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, _UiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 80.0,
        padding: EdgeInsets.only(left: 13.0, right: 13.0),
        margin: EdgeInsets.only(bottom: 2.5, top: 2.5),
        color: const Color(0xFFFAFAFA),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 60.0,
              height: 60.0,
              alignment: Alignment.center,
              child: buildDeviceIcon(context, uiEntity),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  uiEntity.accessoryName,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 15.0,
                    color: const Color(0xFF2D3B46),
                  ),
                ),
                Text(
                  uiEntity.getAccessoryType(context),
                  style: TextStyle(
                    inherit: false,
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (uiEntity.accessory == null) return;
        if (!uiEntity.accessory.isCurtain) return;
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (BuildContext context) => HomekitSetCurtainTypePage(
                  originType: CURTAIN_TYPE_NONE,
                  isAdding: true,
                  homeIdentifier: uiEntity.homeIdentifier,
                  accessoryIdentifier: uiEntity.accessoryIdentifier,
                ),
            settings: RouteSettings(
              name: '/SetCurtainType',
            ),
          ),
        );
      },
    );
  }

  Widget buildDeviceIcon(BuildContext context, _UiEntity uiEntity) {
    if (uiEntity.accessory != null) {
      if (uiEntity.accessory.isLightSocket) {
        return Image.asset(
          'images/icon_light_on.png',
          width: 35.0,
          height: 36.0,
          gaplessPlayback: true,
        );
      } else if (uiEntity.accessory.isSmartPlug) {
        return Image.asset(
          'images/icon_plug_on.png',
          width: 25.0,
          height: 25.0,
          gaplessPlayback: true,
        );
      } else if (uiEntity.accessory.isAwarenessSwitch) {
        return Image.asset(
          'images/icon_pir.png',
          width: 25.0,
          height: 25.0,
          gaplessPlayback: true,
        );
      } else if (uiEntity.accessory.isDoorSensor) {
        return Image.asset(
          'images/icon_dc.png',
          width: 24.0,
          height: 24.0,
          gaplessPlayback: true,
        );
      } else if (uiEntity.accessory.isCurtain) {
        return Image.asset(
          'images/icon_curtain.png',
          width: 25.0,
          height: 22.0,
          gaplessPlayback: true,
        );
      } else if (uiEntity.accessory.isWallSwitch) {
        return Image.asset(
          'images/icon_ws.png',
          width: 26.0,
          height: 26.0,
          gaplessPlayback: true,
        );
      } else if (uiEntity.accessory.isWallSwitchUS) {
        return Image.asset(
          'images/icon_ws_us.png',
          width: 22.0,
          height: 33.0,
          gaplessPlayback: true,
        );
      } else if (uiEntity.accessory.isSmartDial) {
        return Image.asset(
          'images/icon_sd_online.png',
          width: 26.0,
          height: 24.0,
          gaplessPlayback: true,
        );
      } else if (uiEntity.accessory.isSwitchModule) {
        return Image.asset(
          'images/icon_switch_module.png',
          width: 40.0,
          height: 40.0,
          gaplessPlayback: true,
        );
      }
    }
    return Container();
  }
}

class _UiEntity {
  final String accessoryIdentifier;
  final String homeIdentifier;

  _UiEntity({
    @required this.accessoryIdentifier,
    @required this.homeIdentifier,
  });

  Accessory get accessory {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home == null) return null;
    return home.findAccessory(accessoryIdentifier);
  }

  String get accessoryName => accessory.name ?? '';

  String getAccessoryType(BuildContext context) {
    if (accessory == null) return '';
    if (accessory.isLightSocket) {
      return DefinedLocalizations.of(context).lightSocket;
    } else if (accessory.isSmartPlug) {
      return DefinedLocalizations.of(context).smartPlug;
    } else if (accessory.isAwarenessSwitch) {
      return DefinedLocalizations.of(context).awarenessSwitch;
    } else if (accessory.isDoorSensor) {
      return DefinedLocalizations.of(context).doorContact;
    } else if (accessory.isWallSwitch || accessory.isWallSwitchUS) {
      return DefinedLocalizations.of(context).wallSwitch;
    } else if (accessory.isCurtain) {
      return DefinedLocalizations.of(context).curtain +
          '(' +
          DefinedLocalizations.of(context).clickToConfig +
          ')';
    } else if (accessory.isSmartDial) {
      return '';
    }
    return '';
  }
}
