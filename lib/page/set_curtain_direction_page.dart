import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:xlive/const/adapt.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';

import 'dart:async';

class SetCurtainDirectionPage extends StatefulWidget {
  final int curtainType;
  final int originDirection;
  final bool isAdding;
  final String uuid;

  SetCurtainDirectionPage({
    @required this.curtainType,
    @required this.originDirection,
    @required this.isAdding,
    @required this.uuid,
  });

  State<StatefulWidget> createState() => _SetCurtainDirectionState();
}

class _SetCurtainDirectionState extends State<SetCurtainDirectionPage> {
  int currentDirection;

  bool adjustCompleted = false;

  StreamSubscription subscription;

  Timer timer;

  void initState() {
    super.initState();
    currentDirection = widget.originDirection;

    start();

    timer = Timer(const Duration(seconds: 60), () {
      adjustCompleted = true;
      setState(() {});
    });
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
        .where((event) =>
            event is DeviceAttributeReportEvent &&
            event.attrId == ATTRIBUTE_ID_CURTAIN_TRIP_CONFIGURED &&
            event.uuid == widget.uuid)
        .listen((event) {
      final DeviceAttributeReportEvent evt =
          event as DeviceAttributeReportEvent;
      if (evt.attrValue == 1) {
        adjustCompleted = true;
        setState(() {});
      }
    });
  }

  void writeAttribute(String uuid, int attrId, int attrValue) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.writeAttribute(homeCenterUuid, uuid, attrId, attrValue)
        .listen((response) {
      if (response is WriteAttributeResponse) {
        if (response.success || response.code == 41) {
          if (widget.isAdding) {
            final HomeCenterCache cache =
                HomeCenterManager().defaultHomeCenterCache;
            if (cache == null) return;
            if (cache.newDevices.length > 0) {
              Navigator.of(context).popUntil(
                ModalRoute.withName('/AddDevice'),
              );
            } else {
              Navigator.of(context).popUntil(
                ModalRoute.withName('/Home'),
              );
            }
          } else {
            Navigator.of(context).pop();
          }
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
      title: DefinedLocalizations.of(context).smartCurtain,
      barBackgroundColor: const Color(0xFF91D2F9),
      trailing: Offstage(
        offstage: !widget.isAdding || adjustCompleted,
        child: CupertinoActivityIndicator(),
      ),
      titleColor: Colors.white,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 15.0),
      color: const Color(0xFF91D2F9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                    DefinedLocalizations.of(context).chooseCurtainDirection,
                    style: TextStyle(
                      inherit: false,
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              _buildSingle(context),
              _buildDouble(context),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 55.0),
            child: Offstage(
              offstage: widget.isAdding && !adjustCompleted,
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
                    DefinedLocalizations.of(context).submit,
                    style: TextStyle(
                      inherit: false,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                onPressed: () {
                  final String uuid = widget.uuid;
                  final int attrId = ATTRIBUTE_ID_CURTAIN_DIRECTION;
                  writeAttribute(widget.uuid, attrId, currentDirection);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingle(BuildContext context) {
    return Offstage(
      offstage: widget.curtainType == CURTAIN_TYPE_DOUBLE,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Container(
              width: (MediaQuery.of(context).size.width - 13.0 * 3) / 2.0,
              height: 165.0,
              decoration: BoxDecoration(
                color: currentDirection == CURTAIN_DIRECTION_ORIGIN
                    ? Color(0xFF7DCBF4)
                    : Color(0xFFB4DEF9),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              margin: EdgeInsets.only(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 14.0),
                    child: Image(
                      width: 116.0,
                      height: 107.0,
                      image: AssetImage(widget.curtainType == CURTAIN_TYPE_LEFT
                          ? 'images/left_closed.png'
                          : 'images/right_closed.png'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(bottom: 12.0, right: 12.0),
                    child: Offstage(
                      offstage: currentDirection == CURTAIN_DIRECTION_REVERSE,
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
              currentDirection = CURTAIN_DIRECTION_ORIGIN;
              setState(() {});
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 13.0),
          ),
          GestureDetector(
            child: Container(
              width: (MediaQuery.of(context).size.width - 13.0 * 3) / 2.0,
              height: 165.0,
              decoration: BoxDecoration(
                color: currentDirection == CURTAIN_DIRECTION_REVERSE
                    ? Color(0xFF7DCBF4)
                    : Color(0xFFB4DEF9),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              margin: EdgeInsets.only(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 14.0),
                    child: Image(
                      width: 116.0,
                      height: 107.0,
                      image: AssetImage(widget.curtainType == CURTAIN_TYPE_LEFT
                          ? 'images/left_open.png'
                          : 'images/right_open.png'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(bottom: 12.0, right: 12.0),
                    child: Offstage(
                      offstage: currentDirection == CURTAIN_DIRECTION_ORIGIN,
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
              currentDirection = CURTAIN_DIRECTION_REVERSE;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDouble(BuildContext context) {
    return Offstage(
      offstage: widget.curtainType != CURTAIN_TYPE_DOUBLE,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            child: Container(
              height: 165.0,
              decoration: BoxDecoration(
                color: currentDirection == CURTAIN_DIRECTION_ORIGIN
                    ? Color(0xFF7DCBF4)
                    : Color(0xFFB4DEF9),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              margin: EdgeInsets.only(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 14.0),
                    child: Image(
                      width: 262.0,
                      height: 107.0,
                      image: AssetImage('images/double_closed.png'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(right: 12.0, bottom: 12.0),
                    child: Offstage(
                      offstage: currentDirection != CURTAIN_DIRECTION_ORIGIN,
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
              currentDirection = CURTAIN_DIRECTION_ORIGIN;
              setState(() {});
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          GestureDetector(
            child: Container(
              height: 165.0,
              decoration: BoxDecoration(
                color: currentDirection == CURTAIN_DIRECTION_REVERSE
                    ? Color(0xFF7DCBF4)
                    : Color(0xFFB4DEF9),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              margin: EdgeInsets.only(),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 14.0),
                    child: Image(
                      width: 262.0,
                      height: 107.0,
                      image: AssetImage('images/double_open.png'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(right: 12.0, bottom: 12.0),
                    child: Offstage(
                      offstage: currentDirection != CURTAIN_DIRECTION_REVERSE,
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
              currentDirection = CURTAIN_DIRECTION_REVERSE;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
