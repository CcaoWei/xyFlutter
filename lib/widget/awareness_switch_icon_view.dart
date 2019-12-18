import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'dart:async';

class AwarenessSwitchIconView extends StatefulWidget {
  //final String uuid;
  final Entity entity;
  final bool showRealtimeState;
  AwarenessSwitchIconView({
    Key key,
    @required this.entity,
    this.showRealtimeState = true,
  }) : super(key: key);

  State<StatefulWidget> createState() => _AwarenessSwitchIconState();
}

class _AwarenessSwitchIconState extends State<AwarenessSwitchIconView>
    with TickerProviderStateMixin {
  LogicDevice logicDevice;
  String imageUrl;

  StreamSubscription subscription;

  Animation<double> leftOpacity;
  Animation<double> rightOpacity;

  AnimationController leftController;
  AnimationController rightController;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  @override
  void didUpdateWidget(AwarenessSwitchIconView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.entity != oldWidget.entity) {
      resetData();
    }
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    if (leftController != null) {
      leftController.stop();
      leftController.dispose();
      leftController = null;
      leftOpacity = null;
    }
    if (rightController != null) {
      rightController.stop();
      rightController.dispose();
      rightController = null;
      rightOpacity = null;
    }
    super.dispose();
  }

  void resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.entity is LogicDevice) {
      logicDevice = cache.findEntity(widget.entity.uuid) as LogicDevice;
      if (logicDevice == null) return;
      if (logicDevice.isAwarenessSwitch) {
        if (logicDevice.parent.available) {
          if (PirPanelUtil.isSafe(logicDevice.occupancy)) {
            imageUrl = 'images/icon_pir.png';
          } else {
            imageUrl = 'images/pir_icon_alarm.png';
          }
        } else {
          imageUrl = 'images/icon_pir_offline.png';
        }
        if (logicDevice.parent.available) {
          if (PirPanelUtil.isLeftAlarm(logicDevice.occupancy)) {
            createLeftAnimation();
          }
          if (PirPanelUtil.isRightAlarm(logicDevice.occupancy)) {
            createRightAnimation();
          }
          if (PirPanelUtil.isSafe(logicDevice.occupancy)) {
            cancelAnimation();
          }
        } else {
          cancelAnimation();
        }
      }
      setState(() {});
    }
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => logicDevice != null)
        .where((event) =>
            (event is HomeCenterCacheEvent &&
                event.homeCenterUuid ==
                    HomeCenterManager().defaultHomeCenterUuid &&
                (event.uuid == widget.entity.uuid ||
                    event.uuid == logicDevice.parent.uuid)) ||
            (event is HomeCenterEvent && event.type == HOME_CENTER_CHANGED))
        .where((event) =>
            (event is DeviceAttributeReportEvent &&
                event.attrId == ATTRIBUTE_ID_OCCUPANCY) ||
            event is DeviceOfflineEvent ||
            event is PhysicDeviceAvailableEvent ||
            event is HomeCenterEvent)
        .listen((event) {
      resetData();
    });
  }

  void createLeftAnimation() {
    if (leftController != null || leftOpacity != null) return;
    leftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
        setState(() {});
      });
    leftOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(leftController);
    leftController.repeat();
  }

  void createRightAnimation() {
    if (rightController != null || rightOpacity != null) return;
    rightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
        setState(() {});
      });
    rightOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(rightController);
    rightController.repeat();
  }

  void cancelAnimation() {
    if (leftController != null) {
      leftController.stop();
      leftController.dispose();
      leftController = null;
    }
    if (leftOpacity != null) {
      leftOpacity = null;
    }
    if (rightController != null) {
      rightController.stop();
      rightController.dispose();
      rightController = null;
    }
    if (rightOpacity != null) {
      rightOpacity = null;
    }
  }

  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Opacity(
            opacity: leftOpacity == null ? 0.0 : leftOpacity.value,
            child: Container(
              width: 6.0,
              height: 6.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3.0),
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 6.0),
          ),
          Image(
            width: 26.0,
            height: 26.0,
            image: AssetImage(imageUrl),
          ),
          Padding(
            padding: EdgeInsets.only(left: 6.0),
          ),
          Opacity(
            opacity: rightOpacity == null ? 0.0 : rightOpacity.value,
            child: Container(
              width: 6.0,
              height: 6.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
