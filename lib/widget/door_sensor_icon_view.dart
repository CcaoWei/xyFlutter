import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'dart:async';

const int OPEN = 0;
const int CLOSED = 1;
const int OFFLINE = -1;
const int ORIGIN = -2;

class DoorSensorIconView extends StatefulWidget {
  //final String uuid;
  final Entity entity;
  final bool showRealtimeState;
  DoorSensorIconView({
    Key key,
    @required this.entity,
    this.showRealtimeState = true,
  }) : super(key: key);

  State<StatefulWidget> createState() => _DoorSensorIconState();
}

class _DoorSensorIconState extends State<DoorSensorIconView>
    with TickerProviderStateMixin {
  LogicDevice logicDevice;

  StreamSubscription subscription;

  Animation<double> topOpacityAnimation;
  AnimationController topController;

  Animation<EdgeInsets> leftPositionAnimation;
  Animation<EdgeInsets> rightPositionAnimation;
  AnimationController positionController;

  Animation<double> openOpacityAnimation;

  int prestatus = ORIGIN;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  @override
  void didUpdateWidget(DoorSensorIconView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.entity != oldWidget.entity) {
      resetData();
    }
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
      subscription = null;
    }
    cancelAnims();
    super.dispose();
  }

  void resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.entity is LogicDevice) {
      logicDevice = cache.findEntity(widget.entity.uuid) as LogicDevice;
      if (logicDevice == null) return;
      if (logicDevice.isDoorContact) {
        if (prestatus == ORIGIN) {
          prestatus = status;
        }
        if (logicDevice.parent.available) {
          if (widget.showRealtimeState) {
            createTopAnimation();
            createPositionAnimation();
          }
        } else {
          cancelAnims();
        }

        prestatus = status;
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
                event.attrId == ATTRIBUTE_ID_BINARY_INPUT_STATUS) ||
            event is DeviceOfflineEvent ||
            event is PhysicDeviceAvailableEvent ||
            event is HomeCenterEvent)
        .listen((event) {
      resetData();
    });
  }

  void createTopAnimation() {
    if (logicDevice == null) return;
    if (status == OPEN) {
      topController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      )..addListener(() {
          try {
            setState(() {});
          } catch (e) {
            print("got exception on animation ${this.hashCode}");
            cancelAnims();
          }
        });
      topOpacityAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(topController);
      topController.repeat();
    } else {
      if (topController != null) {
        topController.stop();
        topController.dispose();
        topController = null;
      }
      if (topOpacityAnimation != null) {
        topOpacityAnimation = null;
      }
      setState(() {});
    }
  }

  void createPositionAnimation() {
    if (logicDevice == null) return;
    if (prestatus == status) return;
    if (positionController != null ||
        leftPositionAnimation != null ||
        rightPositionAnimation != null) return;
    positionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          positionController.dispose();
          positionController = null;
        }
      });
    leftPositionAnimation = EdgeInsetsTween(
      begin: (status == OPEN)
          ? EdgeInsets.only(right: 1.5)
          : EdgeInsets.only(right: 5.0),
      end: (status == OPEN)
          ? EdgeInsets.only(right: 5.0)
          : EdgeInsets.only(right: 1.5),
    ).animate(positionController)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          leftPositionAnimation = null;
        }
      });
    rightPositionAnimation = EdgeInsetsTween(
      begin: (status == OPEN)
          ? EdgeInsets.only(left: 1.5)
          : EdgeInsets.only(left: 5.0),
      end: (status == OPEN)
          ? EdgeInsets.only(left: 5.0)
          : EdgeInsets.only(left: 1.5),
    ).animate(positionController)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          rightPositionAnimation = null;
        }
      });
    openOpacityAnimation = Tween(
      begin: status == OPEN ? 0.0 : 1.0,
      end: status == OPEN ? 1.0 : 0.0,
    ).animate(positionController)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          openOpacityAnimation = null;
        }
      });
    positionController.forward();
  }

  void cancelAnims() {
    if (topController != null) {
      topController.stop();
      topController.dispose();
      topController = null;
      topOpacityAnimation = null;
    }
    if (positionController != null) {
      positionController.stop();
      positionController.dispose();
      leftPositionAnimation = null;
      rightPositionAnimation = null;
    }
    openOpacityAnimation = null;
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

  double get openOpacity {
    if (openOpacityAnimation != null) return openOpacityAnimation.value;
    if (logicDevice != null && logicDevice.parent.available) {
      if (logicDevice.binaryInputStatus == 0 ||
          logicDevice.binaryInputStatus == 1) {
        return logicDevice.binaryInputStatus + 0.0;
      }
    }
    return 0.0;
  }

  double get closedOpacity {
    if (openOpacityAnimation != null) return 1 - openOpacityAnimation.value;
    if (logicDevice != null && logicDevice.parent.available) {
      if (logicDevice.binaryInputStatus == 0 ||
          logicDevice.binaryInputStatus == 1) {
        return 1.0 - logicDevice.binaryInputStatus;
      }
    }
    return 1.0;
  }

  EdgeInsets get leftPadding {
    if (leftPositionAnimation != null) return leftPositionAnimation.value;
    if (logicDevice != null && logicDevice.binaryInputStatus == 1)
      return EdgeInsets.only(right: 5.0);
    return EdgeInsets.only(right: 1.5);
  }

  EdgeInsets get rightPadding {
    if (rightPositionAnimation != null) return rightPositionAnimation.value;
    if (logicDevice != null && logicDevice.binaryInputStatus == 1)
      return EdgeInsets.only(left: 5.0);
    return EdgeInsets.only(right: 1.5);
  }

  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Offstage(
            offstage: logicDevice == null ? true : logicDevice.parent.available,
            child: Image(
              width: 24.0,
              height: 24.0,
              image: AssetImage('images/dc_icon_offline.png'),
            ),
          ),
          Offstage(
            offstage:
                logicDevice == null ? true : !logicDevice.parent.available,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 42.0),
                  child: Offstage(
                    offstage: logicDevice.binaryInputStatus == 0,
                    child: Opacity(
                      opacity: topOpacityAnimation == null
                          ? 0.0
                          : topOpacityAnimation.value,
                      child: Image(
                        width: 30.0,
                        height: 9.0,
                        image: AssetImage('images/dc_icon_top.png'),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 40.0,
                      height: 25.0,
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: leftPadding,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Opacity(
                              opacity: openOpacity,
                              child: Image(
                                width: 13.0,
                                height: 24.0,
                                image:
                                    AssetImage('images/dc_icon_open_left.png'),
                              ),
                            ),
                            Opacity(
                              opacity: closedOpacity,
                              child: Image(
                                width: 13.0,
                                height: 24.0,
                                image: AssetImage(
                                    'images/dc_icon_closed_left.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 40.0,
                      height: 25.0,
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: rightPadding,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Opacity(
                              opacity: openOpacity,
                              child: Image(
                                width: 10.0,
                                height: 18.0,
                                image:
                                    AssetImage('images/dc_icon_open_right.png'),
                              ),
                            ),
                            Opacity(
                              opacity: closedOpacity,
                              child: Image(
                                width: 10.0,
                                height: 18.0,
                                image: AssetImage(
                                    'images/dc_icon_closed_right.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
