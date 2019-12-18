import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/localization/defined_localization.dart';

import 'device_image_view.dart';
import 'battery.dart';

import 'dart:async';
import 'dart:math' as math;

const int OFFLINE = -1;
const int SAFE = 0;
const int ALARM = 1;
const int ORIGIN = 2;

class AwarenessSwitchImageView extends StatefulWidget {
  //final String uuid;
  final Entity entity;

  AwarenessSwitchImageView({
    Key key,
    @required this.entity,
  }) : super(key: key);

  State<StatefulWidget> createState() => _AwarenessSwitchImageState();
}

class _AwarenessSwitchImageState extends State<AwarenessSwitchImageView>
    with TickerProviderStateMixin {
  LogicDevice logicDevice;

  Animation<double> leftAnim;
  Animation<double> rightAnim;

  AnimationController leftController;
  AnimationController rightController;

  Animation<Color> backgroundColorAnim;

  AnimationController animController;

  StreamSubscription subscription;

  int prestatus = ORIGIN;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void didUpdateWidget(AwarenessSwitchImageView oldWidget) {
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
    if (leftController != null) {
      leftController.stop();
      leftController.dispose();
    }
    if (rightController != null) {
      rightController.stop();
      rightController.dispose();
    }
    super.dispose();
  }

  void resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.entity is LogicDevice) {
      logicDevice = cache.findEntity(widget.entity.uuid) as LogicDevice;
      if (logicDevice == null) return;
      logicDevice = widget.entity;
      if (prestatus == ORIGIN) {
        prestatus = status;
      }
      createAnimation();
      createAlarmAnimation();
      prestatus = status;
    }
  }

  int get status {
    if (logicDevice == null) return ORIGIN;
    if (logicDevice.parent.available) {
      if (PirPanelUtil.isSafe(logicDevice.occupancy)) {
        return SAFE;
      } else {
        return ALARM;
      }
    } else {
      return OFFLINE;
    }
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => logicDevice != null)
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid &&
            (event.uuid == widget.entity.uuid ||
                event.uuid == logicDevice.parent.uuid))
        .where((event) =>
            event is DeviceOfflineEvent ||
            event is PhysicDeviceAvailableEvent ||
            (event is DeviceAttributeReportEvent &&
                event.attrId == ATTRIBUTE_ID_OCCUPANCY))
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
          animController.dispose();
          animController = null;
        }
      });
    Color startColor;
    Color endColor;
    if (prestatus == ALARM) {
      if (status == ALARM) {
        startColor = Color(0xFFFE7070);
        endColor = Color(0xFFFE7070);
      } else if (status == 0) {
        startColor = Color(0xFFFE7070);
        endColor = Color(0xFF9CA8B6);
      } else {
        startColor = Color(0xFFFE7070);
        endColor = Color(0xFFD6D6D6);
      }
    } else if (prestatus == SAFE) {
      if (status == ALARM) {
        startColor = Color(0xFF9CA8B6);
        endColor = Color(0xFFFE7070);
      } else if (status == SAFE) {
        startColor = Color(0xFF9CA8B6);
        endColor = Color(0xFF9CA8B6);
      } else {
        startColor = Color(0xFF9CA8B6);
        endColor = Color(0xFFD6D6D6);
      }
    } else {
      if (status == ALARM) {
        startColor = Color(0xFFD6D6D6);
        endColor = Color(0xFFFE7070);
      } else if (status == SAFE) {
        startColor = Color(0xFFD6D6D6);
        endColor = Color(0xFF9CA8B6);
      } else {
        startColor = Color(0xFFD6D6D6);
        endColor = Color(0xFFD6D6D6);
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

  void createAlarmAnimation() {
    if (logicDevice == null) return;
    if (!logicDevice.parent.available) {
      cancelAnim();
      return;
    }
    if (PirPanelUtil.isLeftAlarm(logicDevice.occupancy)) {
      if (leftController == null && leftAnim == null) {
        leftController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 2000),
        )..addListener(() {
            setState(() {});
          });
        leftAnim = Tween<double>(
          begin: 0.0,
          end: 2 * math.pi,
        ).animate(leftController);
        leftController.repeat();
      }
    }
    if (PirPanelUtil.isRightAlarm(logicDevice.occupancy)) {
      if (rightController == null && rightAnim == null) {
        rightController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 2000),
        )..addListener(() {
            setState(() {});
          });
        rightAnim = Tween<double>(
          begin: 0.0,
          end: 2 * math.pi,
        ).animate(rightController);
        rightController.repeat();
      }
    }
    if (PirPanelUtil.isSafe(logicDevice.occupancy)) {
      cancelAnim();
      setState(() {});
    }
  }

  void cancelAnim() {
    if (leftController != null) {
      leftController.stop();
      leftController.dispose();
      leftController = null;
    }
    if (leftAnim != null) {
      leftAnim = null;
    }
    if (rightController != null) {
      rightController.stop();
      rightController.dispose();
      rightController = null;
    }
    if (rightAnim != null) {
      rightAnim = null;
    }
  }

  Color get backgroundColor {
    if (logicDevice == null) return const Color(0xFFD6D6D6);
    if (animController != null && animController.isAnimating) {
      return backgroundColorAnim.value;
    }
    if (logicDevice.parent.available) {
      if (PirPanelUtil.isSafe(logicDevice.occupancy)) {
        return const Color(0xFF9CA8B6);
      } else {
        return const Color(0xFFFE7070);
      }
    }
    return const Color(0xFFD6D6D6);
  }

  EdgeInsets get leftPosition {
    if (leftAnim != null) {
      double leftX = 0.2029 * 40.0 * math.cos(leftAnim.value);
      double leftY = 0.7071 * 80.0 * math.sin(leftAnim.value);
      if (leftAnim.value < 0.5 * math.pi) {
        return EdgeInsets.only(right: 80.0 + leftX, bottom: leftY);
      } else if (leftAnim.value < math.pi) {
        return EdgeInsets.only(right: 80.0 - leftX, bottom: leftY);
      } else if (leftAnim.value < 1.5 * math.pi) {
        return EdgeInsets.only(right: 80.0 - leftX, top: -leftY);
      } else {
        return EdgeInsets.only(right: 80.0 + leftX, top: -leftY);
      }
    }
    return EdgeInsets.only();
  }

  EdgeInsets get rightPosition {
    if (rightAnim != null) {
      double rightX = 0.2029 * 40.0 * math.cos(rightAnim.value);
      double rightY = 0.7071 * 80.0 * math.sin(rightAnim.value);
      if (rightAnim.value < 0.5 * math.pi) {
        return EdgeInsets.only(left: 80.0 + rightX, bottom: rightY);
      } else if (rightAnim.value < math.pi) {
        return EdgeInsets.only(left: 80.0 - rightX, bottom: rightY);
      } else if (rightAnim.value < 1.5 * math.pi) {
        return EdgeInsets.only(left: 80.0 - rightX, top: -rightY);
      } else {
        return EdgeInsets.only(left: 80.0 + rightX, top: -rightY);
      }
    }
    return EdgeInsets.only();
  }

  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: 240.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Center(
                  child: Image(
                    width: 150.0,
                    height: 150.0,
                    image: AssetImage('images/pir_center.png'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Offstage(
                      offstage: leftAnim == null,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        alignment: Alignment.centerRight,
                        padding: leftPosition,
                        child: Image(
                          width: 24.0,
                          height: 24.0,
                          image: AssetImage('images/icon_pir_alarm.png'),
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: rightAnim == null,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        alignment: Alignment.centerLeft,
                        padding: rightPosition,
                        child: Image(
                          width: 24.0,
                          height: 24.0,
                          image: AssetImage('images/icon_pir_alarm.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: PADDING_BOTTOM),
            child: Offstage(
              offstage:
                  logicDevice == null ? true : !logicDevice.parent.available,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 8.0,
                    height: 17.0,
                    image: AssetImage('images/icon_temperature.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: PADDING1),
                  ),
                  Text(
                    logicDevice == null
                        ? ''
                        : (logicDevice.temperature / 10).toString() + '°C',
                    style: TEXT_STYLE_OFFLINE,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: PADDING2),
                  ),
                  Battery(
                    percent:
                        logicDevice == null ? 0 : logicDevice.batteryPercent,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: PADDING1),
                  ),
                  Text(
                    logicDevice == null
                        ? ''
                        : logicDevice.batteryPercent.toString() + '%',
                    style: TEXT_STYLE_OFFLINE,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: PADDING2),
                  ),
                  Image(
                    width: 19.0,
                    height: 19.0,
                    image: AssetImage('images/icon_luminance.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: PADDING1),
                  ),
                  Text(
                    logicDevice == null
                        ? ''
                        : logicDevice.luminance.toString() + ' Lux',
                    style: TEXT_STYLE_OFFLINE,
                  ),
                ],
              ),
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
