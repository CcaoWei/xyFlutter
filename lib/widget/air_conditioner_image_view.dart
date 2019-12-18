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

class AirConditionerImageView extends StatefulWidget {
  //final String uuid;
  final Entity entity;

  AirConditionerImageView({
    @required this.entity,
  });

  State<StatefulWidget> createState() => _AirConditionerImageState();
}

class _AirConditionerImageState extends State<AirConditionerImageView>
    with TickerProviderStateMixin {
  PhysicDevice physicDevice;

  StreamSubscription subscription;

  AnimationController animController;

  Animation<Color> backgroundColorAnim;

  int prestatus = ORIGIN;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void didUpdateWidget(AirConditionerImageView oldWidget) {
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
    if (widget.entity is PhysicDevice) {
      physicDevice = cache.findEntity(widget.entity.uuid) as PhysicDevice;
      if (physicDevice == null) return;
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
        .where((event) => physicDevice != null)
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
    final Color onlineBackColor = physicDevice.isZHHVRVGateway
        ? const Color(0xFF9CA8B6)
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
    if (physicDevice == null) return ORIGIN;
    if (physicDevice.available) return ONLINE;
    return OFFLINE;
  }

  Color get backgroundColor {
    if (physicDevice == null) return const Color(0xFFD6D6D6);
    if (animController != null && animController.isAnimating) {
      return backgroundColorAnim.value;
    }
    if (physicDevice.available) {
      return physicDevice.isZHHVRVGateway
          ? const Color(0xFF9CA8B6)
          : const Color(0xFF9CA8B6);
    }
    return const Color(0xFFD6D6D6);
  }

  Image get image {
    if (physicDevice.isZHHVRVGateway) {
      return Image.asset(
        'images/image_air_condition_controller.png',
        width: 135.0,
        height: 189.0,
        gaplessPlayback: true,
      );
    } else {
      return Image.asset(
        'images/image_air_condition_controller.png',
        width: 165.0,
        height: 165.0,
        gaplessPlayback: true,
      );
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
            child: image,
          ),
          Offstage(
            offstage: physicDevice == null ? true : physicDevice.available,
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
