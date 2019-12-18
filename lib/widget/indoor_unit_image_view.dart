import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as prefix0;
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/localization/defined_localization.dart';

import 'device_image_view.dart';

import 'dart:async';

const int OFFLINE = -1;
const int ONLINE = 1;
const int ORIGIN = -2;

class IndoorUnitImageView extends StatefulWidget {
  final Entity entity;

  IndoorUnitImageView({@required this.entity});

  State<StatefulWidget> createState() => _IndoorUnitImageState();
}

class _IndoorUnitImageState extends State<IndoorUnitImageView>
    with TickerProviderStateMixin {
  LogicDevice logicDevice;

  StreamSubscription subscription;

  AnimationController animController;

  Animation<Color> backgroundColorAnim;

  int prestatus = ORIGIN;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void didUpdateWidget(IndoorUnitImageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entity != oldWidget.entity) {
      resetData();
    }
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    if (animController != null) {
      animController.stop();
      animController.dispose();
    }
    super.dispose();
  }

  void resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.entity is LogicDevice) {
      logicDevice = cache.findEntity(widget.entity.uuid) as LogicDevice;
      if (logicDevice == null) return;
      if (prestatus == ORIGIN) {
        prestatus = status;
      }
      createAnimation();
      prestatus = status;
    }
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => logicDevice != null)
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid &&
            event.uuid == widget.entity.uuid)
        .where((event) =>
            event is DeviceOfflineEvent || event is PhysicDeviceAvailableEvent)
        .listen((event) {
      resetData();
    });
  }

  void createAnimation() {
    if (animController != null) return;
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          animController = null;
        }
      });
    final Color onlineBackColor = logicDevice.isIndoorUnit
        ? const Color(0xFFAEABCD)
        : const Color(0xFF9CA8B6);
    Color startColor;
    Color endColor;
    if (prestatus == ONLINE) {
      if (status == ONLINE) {
        startColor = onlineBackColor;
        endColor = onlineBackColor;
      } else {
        startColor = onlineBackColor;
        endColor = const Color(0xFFD6D6D6);
      }
    } else {
      if (status == ONLINE) {
        startColor = const Color(0xFFD6D6D6);
        endColor = onlineBackColor;
      } else {
        startColor = const Color(0xFFD6D6D6);
        endColor = const Color(0xFFD6D6D6);
      }
    }
    backgroundColorAnim = ColorTween(
      begin: startColor,
      end: endColor,
    ).animate(animController)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          backgroundColorAnim = null;
        }
      });
    animController.forward();
  }

  int get status {
    if (logicDevice == null) return ORIGIN;
    if (logicDevice.parent.available) return ONLINE;
    return OFFLINE;
  }

  Color get backgroundColor {
    if (logicDevice == null) return const Color(0xFFD6D6D6);
    if (animController != null && animController.isAnimating) {
      return backgroundColorAnim.value;
    }
    if (logicDevice.parent.available) {
      return logicDevice.isIndoorUnit
          ? const Color(0xFFAEABCD)
          : const Color(0xFF9CA8B6);
    }
    return const Color(0xFFD6D6D6);
  }

  Image get image {
    if (logicDevice.isIndoorUnit) {
      return Image.asset(
        'images/image_ws_us.png',
        width: 135.0,
        height: 189.0,
        gaplessPlayback: true,
      );
    } else {
      return Image.asset(
        'images/image_wall_switch.png',
        width: 165.0,
        height: 165.0,
        gaplessPlayback: true,
      );
    }
  }

  String getAirConditionSpeed(BuildContext context) {
    var speed = logicDevice.getAttributeValue(ATTRIBUTE_ID_AC_FAN_SPEED);
    if (speed == AIR_CONDITION_SPEED_LOW) {
      return DefinedLocalizations.of(context).windSpeedLow;
    } else if (speed == AIR_CONDITION_SPEED_INTERMEDIATE) {
      return DefinedLocalizations.of(context).windSpeedMedium;
    } else {
      return DefinedLocalizations.of(context).windSpeedQuick;
    }
  }

  String getAirConditionModeImgUrl() {
    var mode = logicDevice.getAttributeValue(ATTRIBUTE_ID_AC_WORK_MODE);
    if (mode == MODE_HEATING) {
      // return "制热";
      return "images/icon_mode_hot.png";
    } else if (mode == MODE_REFRIGERATION) {
      // return "制冷";
      return "images/icon_mode_cool.png";
    } else if (mode == MODE_DEHUMIDIFICATION) {
      // return "除湿";
      return "images/icon_mode_demoisture.png";
    } else {
      // return "通风";
      return "images/icon_mode_flow.png";
    }
  }

  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: 240.0,
      child: Column(
        // alignment: Alignment.bottomCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Container(
              child: Stack(
            children: <Widget>[
              Image(
                image: AssetImage("images/image_air_condition.png"),
                height: Adapt.px(493),
                width: Adapt.px(492),
              ),
              Positioned(
                top: Adapt.px(184),
                left: Adapt.px(215),
                child: Text(
                  logicDevice
                          .getAttributeValue(ATTRIBUTE_ID_AC_TARGET_TEMPERATURE)
                          .toString() +
                      '°C',
                  style: TextStyle(fontSize: Adapt.px(26), color: Colors.white),
                ),
              )
            ],
          )),
          Offstage(
            offstage:
                !(logicDevice == null ? true : logicDevice.parent.available),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage("images/icon_temperature.png"),
                        width: Adapt.px(35),
                        height: Adapt.px(38),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                      ),
                      Text(
                        logicDevice
                                .getAttributeValue(
                                    ATTRIBUTE_ID_AC_CURRENT_TEMPERATURE)
                                .toString() +
                            "°C",
                        style: TextStyle(
                            fontSize: Adapt.px(50), color: Color(0xffffffff)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage("images/icon_flow.png"),
                        width: Adapt.px(35),
                        height: Adapt.px(38),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                      ),
                      Text(
                        getAirConditionSpeed(context),
                        style: TextStyle(
                            fontSize: Adapt.px(50), color: Color(0xffffffff)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage(getAirConditionModeImgUrl()),
                        width: Adapt.px(50),
                        height: Adapt.px(38),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Offstage(
            offstage: logicDevice == null ? true : logicDevice.parent.available,
            child: Padding(
              padding: EdgeInsets.only(bottom: PADDING_BOTTOM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 15.0,
                    height: 15.0,
                    image: AssetImage('images/icon_offline_white.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: PADDING1),
                  ),
                  Text(
                    DefinedLocalizations.of(context).offline,
                    style: TEXT_STYLE_OFFLINE,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
