import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/data/data_shared.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'set_curtain_direction_page.dart';
import 'common_page.dart';

class SetCurtainTypePage extends StatefulWidget {
  final int originType;
  final bool isAdding;
  final String uuid; //curtain uuid

  SetCurtainTypePage({
    @required this.originType,
    @required this.isAdding,
    @required this.uuid,
  });

  State<StatefulWidget> createState() => _SetCurtainTypeState();
}

class _SetCurtainTypeState extends State<SetCurtainTypePage> {
  int currentType;

  void initState() {
    super.initState();
    currentType = widget.originType;
  }

  void dispose() {
    super.dispose();
  }

  void writeAttribute(String uuid, int attrId, int attrValue) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.writeAttribute(homeCenterUuid, uuid, attrId, attrValue)
        .listen((response) {
      if (response is WriteAttributeResponse) {
        if (response.success || response.code == 41) {
          if (!widget.isAdding) {
            Navigator.of(context).pop();
          } else {}
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
        }
      }
    });
    if (widget.isAdding) {
      Navigator.of(context).push(CupertinoPageRoute(
        builder: (BuildContext context) => SetCurtainDirectionPage(
              curtainType: currentType,
              originDirection: CURTAIN_DIRECTION_ORIGIN,
              isAdding: true,
              uuid: widget.uuid,
            ),
        settings: RouteSettings(
          name: '/SetCurtainDirection',
        ),
      ));
    }
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
                final String uuid = widget.uuid;
                final int attrId = ATTRIBUTE_ID_CURTAIN_TYPE;
                writeAttribute(uuid, attrId, currentType);
              },
            ),
          ),
        ],
      ),
    );
  }
}
