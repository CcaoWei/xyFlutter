import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;
import 'package:xlive/homekit/homekit_shared.dart';

import 'homekit_set_curtain_direction_page.dart';

class HomekitSetCurtainTypePage extends StatefulWidget {
  final int originType;
  final bool isAdding;
  final String homeIdentifier;
  final String accessoryIdentifier;

  HomekitSetCurtainTypePage({
    @required this.originType,
    @required this.isAdding,
    @required this.homeIdentifier,
    @required this.accessoryIdentifier,
  });

  State<StatefulWidget> createState() => _HomekitSetCurtainTypeState();
}

class _HomekitSetCurtainTypeState extends State<HomekitSetCurtainTypePage> {
  int currentType;

  void initState() {
    super.initState();
    currentType = widget.originType;
  }

  void dispose() {
    super.dispose();
  }

  void setCurtainType() {
    print('set curtain type');
    final Home home = HomeManager().findHome(widget.homeIdentifier);
    if (home == null) return;
    final Accessory accessory = home.findAccessory(widget.accessoryIdentifier);
    if (accessory == null) return;
    for (Service s in accessory.services) {
      print('*** ${s.name} *** ${s.type}');
    }
    final Service service = accessory.findServiceByType(S_CURTAIN_SETTNG);
    if (service == null) return;
    final Characteristic characteristic =
        service.findCharacteristicByType(C_TYPE);
    final Characteristic characteristicAdjusting =
        service.findCharacteristicByType(C_TRIP_ADJUSTING);
    if (characteristic == null) return;
    final String homeIdentifier = home.identifier;
    final String accessoryIdentifier = accessory.identifier;
    final String serviceIdentifier = service.identifier;
    final String characteristicIdentifier = characteristic.identifier;
    final int value = currentType;
    print('write type value');
    methodChannel
        .writeValue(homeIdentifier, accessoryIdentifier, serviceIdentifier,
            characteristicIdentifier, value)
        .then((response) {
      final int code = response['code'];
      if (code == 0) {
        if (!widget.isAdding) {
          Navigator.of(context).pop();
        }
      } else {
        if (!widget.isAdding) {
          final String messageType = DefinedLocalizations.of(context).error;
          final String message = response['message'];
          displayMessage(messageType, message);
        }
      }
    });
    print('is add: ${widget.isAdding}');
    if (widget.isAdding) {
      methodChannel
          .writeValue(homeIdentifier, accessoryIdentifier, serviceIdentifier,
              characteristicAdjusting.identifier, value)
          .then((response) {
        final int code = response['code'];
        print("set trip adjusting result is ${code}");
      });
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (BuildContext context) => HomekitSetCurtainDirectionPage(
                curtainType: currentType,
                originDirection: CURTAIN_DIRECTION_UNKNOWN,
                isAdding: widget.isAdding,
                homeIdentifier: widget.homeIdentifier,
                accessoryIdentifier: widget.accessoryIdentifier,
              ),
          settings: RouteSettings(
            name: '/SetCurtainDirection',
          ),
        ),
      );
    }
  }

  void displayMessage(String messageType, String message) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(messageType),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).confirm),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).smartCurtain,
      barBackgroundColor: const Color(0xFF91D2F9),
      titleColor: Colors.white,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0, left: 13.0, right: 13.0),
      color: const Color(0xFF91D2F9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  DefinedLocalizations.of(context).chooseCurtainType,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 39.0) / 2.0,
                        height: 165.0,
                        decoration: BoxDecoration(
                          color: (currentType == CURTAIN_TYPE_LEFT)
                              ? const Color(0xFF7DC8F4)
                              : const Color(0xFFB4DEF9),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 14.0),
                                child: Image(
                                  width: 116.0,
                                  height: 107.0,
                                  image: AssetImage('images/type_left.png'),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: Text(
                                DefinedLocalizations.of(context).leftCurtain,
                                style: TextStyle(
                                  inherit: false,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              padding:
                                  EdgeInsets.only(right: 12.0, bottom: 12.0),
                              child: Offstage(
                                offstage: currentType != CURTAIN_TYPE_LEFT,
                                child: Image(
                                  width: 21.0,
                                  height: 21.0,
                                  image: AssetImage(
                                      'images/icon_curtain_setting_select.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        currentType = CURTAIN_TYPE_LEFT;
                        setState(() {});
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 13.0),
                    ),
                    GestureDetector(
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 13.0 * 3) /
                            2.0,
                        height: 165.0,
                        decoration: BoxDecoration(
                          color: (currentType == CURTAIN_TYPE_RIGHT)
                              ? const Color(0xFF7DC8F4)
                              : const Color(0xFFB4DEF9),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 14.0),
                                child: Image(
                                  width: 116.0,
                                  height: 107.0,
                                  image: AssetImage('images/type_right.png'),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 15.0),
                                child: Text(
                                  DefinedLocalizations.of(context).rightCurtain,
                                  style: TextStyle(
                                    inherit: false,
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: 12.0, bottom: 12.0),
                                child: Offstage(
                                  offstage: currentType != CURTAIN_TYPE_RIGHT,
                                  child: Image(
                                    width: 21.0,
                                    height: 21.0,
                                    image: AssetImage(
                                        'images/icon_curtain_setting_select.png'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        currentType = CURTAIN_TYPE_RIGHT;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0),
                child: GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 13.0 * 2,
                    height: 165.0,
                    decoration: BoxDecoration(
                      color: (currentType == CURTAIN_TYPE_DOUBLE)
                          ? const Color(0xFF7DC8F4)
                          : const Color(0xFFB4DEF9),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 14.0),
                            child: Image(
                              width: 262.0,
                              height: 107.0,
                              image: AssetImage('images/type_double.png'),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              DefinedLocalizations.of(context).doubleCurtain,
                              style: TextStyle(
                                inherit: false,
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 12.0, bottom: 12.0),
                            child: Offstage(
                              offstage: currentType != CURTAIN_TYPE_DOUBLE,
                              child: Image(
                                width: 21.0,
                                height: 21.0,
                                image: AssetImage(
                                    'images/icon_curtain_setting_select.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    currentType = CURTAIN_TYPE_DOUBLE;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 55.0),
            child: CupertinoButton(
              padding: EdgeInsets.only(),
              borderRadius: BorderRadius.all(Radius.circular(22.0)),
              color: Colors.transparent,
              disabledColor: Colors.transparent,
              child: Container(
                width: 200.0,
                height: 44.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Text(
                  widget.isAdding
                      ? DefinedLocalizations.of(context).next
                      : DefinedLocalizations.of(context).submit,
                  style: TextStyle(
                    inherit: false,
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              onPressed: () {
                setCurtainType();
              },
            ),
          ),
        ],
      ),
    );
  }
}
