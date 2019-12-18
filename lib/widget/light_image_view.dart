import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'device_image_view.dart';

import 'dart:async';

const int OFFLINE = -1;
const int OFF = 0;
const int ON = 1;
const int ORIGIN = -2;

class LightImageView extends StatefulWidget {
  //final String uuid;
  final Entity entity;
  LightImageView({
    Key key,
    @required this.entity,
  }) : super(key: key);

  State<StatefulWidget> createState() => _LightImageState();
}

class _LightImageState extends State<LightImageView>
    with TickerProviderStateMixin {
  LogicDevice logicDevice;

  StreamSubscription subscription;

  AnimationController animController;

  Animation<double> onOpacityAnim;
  Animation<Color> backgroundColorAnim;

  bool waitingForResponse = false;

  int prestatus = ORIGIN;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void didUpdateWidget(LightImageView oldWidget) {
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
                event.attrId == ATTRIBUTE_ID_ON_OFF_STATUS))
        .listen((event) {
      resetData();
    });
  }

  void createAnimation() {
    if (logicDevice == null) return;
    if (animController != null ||
        backgroundColorAnim != null ||
        onOpacityAnim != null) return;
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
    double startOpacity;
    double endOpacity;
    if (prestatus == ON) {
      if (status == ON) {
        startColor = const Color(0xFFF2A845);
        endColor = const Color(0xFFF2A845);
        startOpacity = 1.0;
        endOpacity = 1.0;
      } else if (status == OFF) {
        startColor = const Color(0xFFF2A845);
        endColor = const Color(0xFFD6D6D6);
        startOpacity = 1.0;
        endOpacity = 0.0;
      } else {
        startColor = const Color(0xFFF2A845);
        endColor = const Color(0xFFD6D6D6);
        startOpacity = 1.0;
        endOpacity = 0.0;
      }
    } else if (prestatus == OFF) {
      if (status == ON) {
        startColor = const Color(0xFFD6D6D6);
        endColor = const Color(0xFFF2A845);
        startOpacity = 0.0;
        endOpacity = 1.0;
      } else if (status == OFF) {
        startColor = const Color(0xFFD6D6D6);
        endColor = const Color(0xFFD6D6D6);
        startOpacity = 0.0;
        endOpacity = 0.0;
      } else {
        startColor = const Color(0xFFD6D6D6);
        endColor = const Color(0xFFD6D6D6);
        startOpacity = 0.0;
        endOpacity = 0.0;
      }
    } else {
      if (status == ON) {
        startColor = const Color(0xFFD6D6D6);
        endColor = const Color(0xFFF2A845);
        startOpacity = 0.0;
        endOpacity = 1.0;
      } else if (status == OFF) {
        startColor = const Color(0xFFD6D6D6);
        endColor = const Color(0xFFD6D6D6);
        startOpacity = 0.0;
        endOpacity = 0.0;
      } else {
        startColor = const Color(0xFFD6D6D6);
        endColor = const Color(0xFFD6D6D6);
        startOpacity = 0.0;
        endOpacity = 0.0;
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
    onOpacityAnim = Tween<double>(
      begin: startOpacity,
      end: endOpacity,
    ).animate(animController);
    animController.forward();
  }

  int get status {
    if (logicDevice == null) return ORIGIN;
    if (logicDevice.parent.available) {
      if (logicDevice.onOffStatus == ON_OFF_STATUS_ON) {
        return ON;
      } else {
        return OFF;
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
    if (logicDevice.parent.available &&
        logicDevice.onOffStatus == ON_OFF_STATUS_ON) {
      return const Color(0xFFF2A845);
    }
    return const Color(0xFFD6D6D6);
  }

  double get onOpacity {
    if (logicDevice == null) return 0.0;
    if (animController == null) {
      if (logicDevice.parent.available) {
        if (logicDevice.onOffStatus == 1 || logicDevice.onOffStatus == 0) {
          return logicDevice.onOffStatus + 0.0;
        }
      }
      return 0.0;
    }
    if (animController.isAnimating) {
      return onOpacityAnim.value;
    }
    if (logicDevice.parent.available) {
      if (logicDevice.onOffStatus == 1 || logicDevice.onOffStatus == 0) {
        return logicDevice.onOffStatus + 0.0;
      }
    }
    return 0.0;
  }

  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: 240.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Opacity(
                  opacity: onOpacity,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Image(
                      width: 275.0,
                      height: 165.0,
                      image: AssetImage('images/big_light_on.png'),
                    ),
                    onTap: () {
                      setOnOff(context);
                    },
                  ),
                ),
                Opacity(
                  opacity: 1.0 - onOpacity,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Image(
                      width: 275.0,
                      height: 165.0,
                      image: AssetImage('images/big_light_off.png'),
                    ),
                    onTap: () {
                      if (!waitingForResponse) {
                        waitingForResponse = true;
                        setOnOff(context);
                      }
                    },
                  ),
                ),
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
                    padding: EdgeInsets.only(left: 5.0),
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

  void setOnOff(BuildContext context) {
    if (status == OFFLINE) return;
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    final int attrId = ATTRIBUTE_ID_ON_OFF_STATUS;
    final int attrValue = status == ON ? 0 : 1;
    MqttProxy.writeAttribute(
            homeCenterUuid, widget.entity.uuid, attrId, attrValue)
        .listen((response) {
      if (response is WriteAttributeResponse) {
        waitingForResponse = false;
        createAnimation();
      } else {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
        );
      }
    });
  }
}
