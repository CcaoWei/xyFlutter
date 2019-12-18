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

class PlugImageView extends StatefulWidget {
  //final String uuid;
  final Entity entity;

  PlugImageView({
    Key key,
    @required this.entity,
  }) : super(key: key);

  State<StatefulWidget> createState() => _PlugImageState();
}

class _PlugImageState extends State<PlugImageView>
    with TickerProviderStateMixin {
  LogicDevice logicDevice;

  StreamSubscription subscription;

  AnimationController animController;

  Animation<Color> backgroundColorAnim;

  int prestatus = ORIGIN;

  bool waitingForResponse = false;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void didUpdateWidget(PlugImageView oldWidget) {
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
    if (animController != null || backgroundColorAnim != null) return;
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
    final int status = logicDevice.onOffStatus;
    Color startColor;
    Color endColor;
    if (prestatus == 1) {
      if (status == 1) {
        startColor = Color(0xFF8FD4FB);
        endColor = Color(0xFF8FD4FB);
      } else if (status == 0) {
        startColor = Color(0xFF8FD4FB);
        endColor = Color(0xFFD6D6D6);
      } else {
        startColor = Color(0xFF8FD4FB);
        endColor = Color(0xFFD6D6D6);
      }
    } else if (prestatus == 0) {
      if (status == 1) {
        startColor = Color(0xFFD6D6D6);
        endColor = Color(0xFF8FD4FB);
      } else if (status == 0) {
        startColor = Color(0xFFD6D6D6);
        endColor = Color(0xFFD6D6D6);
      } else {
        startColor = Color(0xFFD6D6D6);
        endColor = Color(0xFFD6D6D6);
      }
    } else {
      if (status == 1) {
        startColor = Color(0xFFD6D6D6);
        endColor = Color(0xFF8FD4FB);
      } else if (status == 0) {
        startColor = Color(0xFFD6D6D6);
        endColor = Color(0xFFD6D6D6);
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

  Color get backgroundColor {
    if (logicDevice == null) return const Color(0xFFD6D6D6);
    if (animController != null && animController.isAnimating) {
      return backgroundColorAnim.value;
    }
    if (logicDevice.parent.available &&
        logicDevice.onOffStatus == ON_OFF_STATUS_ON) {
      return const Color(0xFF8FD4FB);
    }
    return const Color(0xFFD6D6D6);
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

  String get imageUrl {
    if (logicDevice == null) return 'images/big_plug_off.png';
    if (logicDevice.parent.available) {
      if (logicDevice.onOffStatus == ON_OFF_STATUS_ON) {
        return 'images/big_plug_on.png';
      } else {
        return 'images/big_plug_off.png';
      }
    } else {
      return 'images/big_plug_off.png';
    }
  }

  // 0 - none, 1 - two, 2 - three
  String get inuseImageUrl {
    if (logicDevice == null) return 'images/plug_in_use_none.png';
    if (logicDevice.insertExtractStatus == 1) {
      return 'images/plug_in_use_two.png';
    } else if (logicDevice.insertExtractStatus == 2) {
      return 'images/plug_in_use_three.png';
    } else {
      return 'images/plug_in_use_none.png';
    }
  }

  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: 240.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Image(
                width: 155.0,
                height: 155.0,
                image: AssetImage(imageUrl),
              ),
              onTap: () {
                if (!waitingForResponse) {
                  waitingForResponse = true;
                  setOnOff(context);
                }
              },
            ),
          ),
          Offstage(
            offstage:
                logicDevice == null ? true : !logicDevice.parent.available,
            child: Padding(
              padding: EdgeInsets.only(bottom: PADDING_BOTTOM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 13.0,
                    height: 20.0,
                    image: AssetImage('images/icon_power.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: PADDING1),
                  ),
                  Text(
                    logicDevice == null
                        ? ''
                        : (logicDevice.activePower / 10.0).toString() + 'w',
                    style: TEXT_STYLE_OFFLINE,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: PADDING2),
                  ),
                  Image(
                    width: 25.0,
                    height: 25.0,
                    image: AssetImage(inuseImageUrl),
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
