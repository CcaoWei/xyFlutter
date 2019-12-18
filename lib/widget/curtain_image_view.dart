import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/localization/defined_localization.dart';

import 'device_image_view.dart';

import 'dart:async';

const int OFFLINE = -1;
const int ONLINE = 1;
const int ORIGIN = -2;

class CurtainImageView extends StatefulWidget {
  //final String uuid;
  final Entity entity;

  CurtainImageView({
    Key key,
    @required this.entity,
  }) : super(key: key);

  State<StatefulWidget> createState() => _CurtainImageState();
}

class _CurtainImageState extends State<CurtainImageView>
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

  void didUpdateWidget(CurtainImageView oldWidget) {
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
    Color startColor;
    Color endColor;
    if (prestatus == ONLINE) {
      if (status == ONLINE) {
        startColor = const Color(0xFF8FD4F8);
        endColor = const Color(0xFF8FD4F8);
      } else {
        startColor = const Color(0xFF8FD4F8);
        endColor = const Color(0xFFD6D6D6);
      }
    } else {
      if (status == ONLINE) {
        startColor = const Color(0xFFD6D6D6);
        endColor = const Color(0xFF8FD4F8);
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
      return const Color(0xFF8FD4F8);
    }
    return const Color(0xFFD6D6D6);
  }

  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: 240.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Center(
            child: Image(
              width: 165.0,
              height: 165.0,
              image: AssetImage('images/image_curtain.png'),
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
