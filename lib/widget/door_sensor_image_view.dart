import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/localization/defined_localization.dart';

import 'device_image_view.dart';
import 'battery.dart';

import 'dart:async';

const int OFFLINE = -1;
const int CLOSED = 0;
const int OPEN = 1;
const int ORIGIN = -2;

class DoorSensorImageView extends StatefulWidget {
  //final String uuid;
  final Entity entity;

  DoorSensorImageView({
    Key key,
    @required this.entity,
  }) : super(key: key);

  State<StatefulWidget> createState() => _DoorSensorImageState();
}

class _DoorSensorImageState extends State<DoorSensorImageView>
    with TickerProviderStateMixin {
  LogicDevice logicDevice;

  StreamSubscription subscription;

  AnimationController animController;

  Animation<Color> backgroundColorAnim;

  Animation<EdgeInsets> leftAnim;
  Animation<EdgeInsets> rightAnim;

  int prestatus = ORIGIN;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void didUpdateWidget(DoorSensorImageView oldWidget) {
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
    setState(() {});
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
                event.attrId == ATTRIBUTE_ID_BINARY_INPUT_STATUS))
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
    if (prestatus == OPEN) {
      if (status == OPEN) {
        startColor = const Color(0xFFFE7070);
        endColor = const Color(0xFFFE7070);
      } else if (status == CLOSED) {
        startColor = const Color(0xFFFE7070);
        endColor = const Color(0xFF55D65C);
        if (leftAnim == null) {
          leftAnim = EdgeInsetsTween(
            begin: EdgeInsets.only(right: 35.0),
            end: EdgeInsets.only(),
          ).animate(animController)
            ..addStatusListener((AnimationStatus status) {
              if (status == AnimationStatus.completed) {
                leftAnim = null;
              }
            });
        }
        if (rightAnim == null) {
          rightAnim = EdgeInsetsTween(
            begin: EdgeInsets.only(left: 35.0),
            end: EdgeInsets.only(),
          ).animate(animController)
            ..addStatusListener((AnimationStatus status) {
              if (status == AnimationStatus.completed) {
                rightAnim = null;
              }
            });
        }
      } else {
        startColor = const Color(0xFFFE7070);
        endColor = const Color(0xFFD6D6D6);
        if (leftAnim == null) {
          leftAnim = EdgeInsetsTween(
            begin: EdgeInsets.only(right: 35.0),
            end: EdgeInsets.only(),
          ).animate(animController)
            ..addStatusListener((AnimationStatus status) {
              if (status == AnimationStatus.completed) {
                leftAnim = null;
              }
            });
        }
        if (rightAnim == null) {
          rightAnim = EdgeInsetsTween(
            begin: EdgeInsets.only(left: 35.0),
            end: EdgeInsets.only(),
          ).animate(animController)
            ..addStatusListener((AnimationStatus status) {
              if (status == AnimationStatus.completed) {
                rightAnim = null;
              }
            });
        }
      }
    } else if (prestatus == CLOSED) {
      if (status == OPEN) {
        startColor = const Color(0xFF55D65C);
        endColor = const Color(0xFFFE7070);
        if (leftAnim == null) {
          leftAnim = EdgeInsetsTween(
            begin: EdgeInsets.only(),
            end: EdgeInsets.only(right: 35.0),
          ).animate(animController)
            ..addStatusListener((AnimationStatus status) {
              if (status == AnimationStatus.completed) {
                leftAnim = null;
              }
            });
        }
        if (rightAnim == null) {
          rightAnim = EdgeInsetsTween(
            begin: EdgeInsets.only(),
            end: EdgeInsets.only(left: 35.0),
          ).animate(animController)
            ..addStatusListener((AnimationStatus status) {
              if (status == AnimationStatus.completed) {
                rightAnim = null;
              }
            });
        }
      } else if (status == CLOSED) {
        startColor = const Color(0xFF55D65C);
        endColor = const Color(0xFF55D65C);
      } else {
        startColor = const Color(0xFF55D65C);
        endColor = const Color(0xFFD6D6D6);
      }
    } else {
      if (status == OPEN) {
        startColor = const Color(0xFFD6D6D6);
        endColor = const Color(0xFFFE7070);
        if (leftAnim == null) {
          leftAnim = EdgeInsetsTween(
            begin: EdgeInsets.only(),
            end: EdgeInsets.only(right: 35.0),
          ).animate(animController)
            ..addStatusListener((AnimationStatus status) {
              if (status == AnimationStatus.completed) {
                leftAnim = null;
              }
            });
        }
        if (rightAnim == null) {
          rightAnim = EdgeInsetsTween(
            begin: EdgeInsets.only(),
            end: EdgeInsets.only(left: 35.0),
          ).animate(animController)
            ..addStatusListener((AnimationStatus status) {
              if (status == AnimationStatus.completed) {
                rightAnim = null;
              }
            });
        }
      } else if (status == CLOSED) {
        startColor = const Color(0xFFD6D6D6);
        endColor = const Color(0xFF55D65C);
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
    if (logicDevice.parent.available) {
      if (logicDevice.binaryInputStatus == 1) {
        return OPEN;
      } else {
        return CLOSED;
      }
    } else {
      return OFFLINE;
    }
  }

  Color get backgroundColor {
    if (logicDevice == null) return const Color(0xFFD6D6D6);
    if (animController != null && animController.isAnimating) {
      return backgroundColorAnim.value;
    }
    if (logicDevice.parent.available) {
      if (logicDevice.binaryInputStatus == 1) {
        return const Color(0xFFFE7070);
      } else {
        return const Color(0xFF55D65C);
      }
    }
    return const Color(0xFFD6D6D6);
  }

  EdgeInsets get leftPaddingRight {
    if (logicDevice == null) return EdgeInsets.only();
    if (animController != null &&
        animController.isAnimating &&
        leftAnim != null) {
      return leftAnim.value;
    }
    if (logicDevice.parent.available && logicDevice.binaryInputStatus == 1) {
      return EdgeInsets.only(right: 35.0);
    }
    return EdgeInsets.only();
  }

  EdgeInsets get rightPaddingLeft {
    if (logicDevice == null) return EdgeInsets.only();
    if (animController != null &&
        animController.isAnimating &&
        rightAnim != null) {
      return rightAnim.value;
    }
    if (logicDevice.parent.available && logicDevice.binaryInputStatus == 1) {
      return EdgeInsets.only(left: 35.0);
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
            padding: EdgeInsets.only(bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  alignment: Alignment.bottomRight,
                  padding: leftPaddingRight,
                  child: Image(
                    width: 76.0,
                    height: 154.0,
                    image: AssetImage('images/icon_dc_left.png'),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  alignment: Alignment.bottomLeft,
                  padding: rightPaddingLeft,
                  child: Image(
                    width: 61.0,
                    height: 127.0,
                    image: AssetImage('images/icon_dc_right.png'),
                  ),
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
                  Offstage(
                    offstage: logicDevice == null
                        ? true
                        : !logicDevice.surpportTemperature,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              : (logicDevice.temperature / 10).toString() +
                                  '°C',
                          style: TEXT_STYLE_OFFLINE,
                        ),
                      ],
                    ),
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
