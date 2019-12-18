import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';

import 'package:xlive/log/log_shared.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

typedef ClickCallBack = void Function();
typedef LongClickCallBack = void Function();

class SceneView extends StatefulWidget {
  //final String sceneUuid;
  final Scene scene;
  final ClickCallBack onClick;
  final LongClickCallBack onLongClick;
  final bool showRealTimeState;

  SceneView({
    Key key,
    //@required this.sceneUuid,
    @required this.scene,
    @required this.onClick,
    @required this.onLongClick,
    this.showRealTimeState = true,
  }) : super(key: key);

  State<StatefulWidget> createState() => _SceneViewState();
}

class _SceneViewState extends State<SceneView> with TickerProviderStateMixin {
  static const String className = 'SceneView';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  static const int CLICK_TIME_INTERVAL = 115;
  static const int LONG_CLICK_TIME_INTERVAL = 850;
  static const int EVENT_MIN_INTERVAL = 500;

  Scene scene;

  int startTime = 0;
  int lastEventTime = 0;

  Timer clickTimer;
  Timer longClickTimer;

  AnimationController animationController;
  Animation<double> scaleAnimation1;
  Animation<double> scaleAnimation2;

  StreamSubscription subscription;

  double get scale {
    if (animationController == null) {
      return 1.0;
    } else {
      if (scaleAnimation1 != null) {
        return scaleAnimation1.value;
      } else {
        return scaleAnimation2.value;
      }
    }
  }

  void initState() {
    super.initState();
    resetData();
    start();
  }

  @override
  void didUpdateWidget(SceneView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scene != oldWidget.scene ||
        widget.scene.name != oldWidget.scene.name) {
      resetData();
    }
  }

  void dispose() {
    if (clickTimer != null) {
      clickTimer.cancel();
    }
    if (longClickTimer != null) {
      longClickTimer.cancel();
    }
    if (animationController != null) {
      animationController.stop();
      animationController.dispose();
    }
    if (subscription != null) {
      subscription.cancel();
    }
    super.dispose();
  }

  void start() {
    final String methodName = 'start';
    subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
        .where((event) => (event is SceneOnOffStatusChangedEvent ||
            event is SceneUpdateEvent ||
            event is SceneDeleteEvent ||
            event is SceneCreateEvent ||
            event is DeviceAttributeReportEvent))
        .listen((event) {
      if (event is SceneOnOffStatusChangedEvent) {
        resetData();
        // setState(() {});
      } else {
        resetData();
      }
    });
  }

  void resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    final Entity entity = cache.findEntity(widget.scene.uuid);
    if (entity is Scene) {
      scene = entity;
    }
    setState(() {});
  }

  void createClickAnimation() {
    final String methodName = 'createClickAnimation';
    if (animationController == null) {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
      )
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animationController = null;
            scaleAnimation1 = null;
            cancelClickAnimation();
          }
        })
        ..addListener(() {
          setState(() {});
        });
      scaleAnimation1 = Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(0.0, 1.0, curve: Curves.decelerate),
        ),
      );
      animationController.forward();
    }
  }

  void cancelClickAnimation() {
    if (animationController == null) {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      )
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animationController = null;
            scaleAnimation1 = null;
          }
        })
        ..addListener(() {
          setState(() {});
        });
      scaleAnimation1 = Tween<double>(
        begin: 1.2,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(0.0, 1.0, curve: Curves.bounceOut),
        ),
      );
      animationController.forward();
    }
  }

  void createPressAnimation() {
    final String methodName = 'createPressAnimation';
    if (animationController == null) {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900),
      )
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animationController = null;
            scaleAnimation1 = null;
          }
        })
        ..addListener(() {
          setState(() {});
        });
      scaleAnimation1 = Tween<double>(
        begin: 1.0,
        end: 1.3,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(0.0, 1.0, curve: Curves.decelerate),
        ),
      );
      animationController.forward();
    }
  }

  void cancelPressAnimation() {
    double scale = 1.3;
    if (scaleAnimation1 != null) {
      scale = scaleAnimation1.value;
      animationController.stop();
      animationController = null;
      scaleAnimation1 = null;
    }
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          animationController = null;
          scaleAnimation2 = null;
        }
      })
      ..addListener(() {
        setState(() {});
      });
    scaleAnimation2 = Tween<double>(
      begin: scale,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 1.0, curve: Curves.bounceOut),
      ),
    );
    animationController.forward();
  }

  void checkUpAndCancel() {
    final int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - startTime < CLICK_TIME_INTERVAL) {
      if (clickTimer != null) {
        clickTimer.cancel();
      }
      if (longClickTimer != null) {
        longClickTimer.cancel();
      }
      createClickAnimation();
      if (currentTime - lastEventTime < EVENT_MIN_INTERVAL) {
        print("skip too frequent click event");
      } else {
        widget.onClick();
        lastEventTime = DateTime.now().millisecondsSinceEpoch;
      }
    } else if (currentTime - startTime > LONG_CLICK_TIME_INTERVAL) {
      //_cancelPressAnimation();
      //_onLongClick;
    } else {
      if (longClickTimer != null) {
        longClickTimer.cancel();
      }
      cancelPressAnimation();
    }
    startTime = 0;
  }

  String get imageUrl {
    if (scene == null) return 'images/defined_scene.png';
    if (scene.uuid == 'scene-000001') {
      return widget.showRealTimeState && scene.isOn
          ? 'images/scene_home_on.png'
          : 'images/scene_home_off.png';
    } else if (scene.uuid == 'scene-000002') {
      return widget.showRealTimeState && scene.isOn
          ? 'images/scene_leave_on.png'
          : 'images/scene_leave_off.png';
    } else if (scene.uuid == 'scene-000003') {
      return widget.showRealTimeState && scene.isOn
          ? 'images/scene_up_on.png'
          : 'images/scene_up_off.png';
    } else if (scene.uuid == 'scene-000004') {
      return widget.showRealTimeState && scene.isOn
          ? 'images/scene_sleep_on.png'
          : 'images/scene_sleep_off.png';
    } else {
      return widget.showRealTimeState && scene.isOn
          ? 'images/defined_scene_on.png'
          : 'images/defined_scene.png';
    }
  }

  double get imageWidth {
    if (scene == null) return 31.0;
    if (scene.uuid == 'scene-000001') {
      return 35.0;
    } else if (scene.uuid == 'scene-000002') {
      return 25.0;
    } else if (scene.uuid == 'scene-000003') {
      return 30.0;
    } else if (scene.uuid == 'scene-000004') {
      return 33.0;
    } else {
      return 31.0;
    }
  }

  double get imageHeight {
    if (scene == null) return 32.0;
    if (scene.uuid == 'scene-000001') {
      return 31.0;
    } else if (scene.uuid == 'scene-000002') {
      return 30.0;
    } else if (scene.uuid == 'scene-000003') {
      return 29.0;
    } else if (scene.uuid == 'scene-000004') {
      return 31.0;
    } else {
      return 32.0;
    }
  }

  Widget build(BuildContext context) {
    final String methodName = 'build';
    if (scene == null) {
      return Container();
    }
    final totalWidth = MediaQuery.of(context).size.width;
    return Container(
        width: totalWidth / 3,
        height: totalWidth / 3,
        alignment: Alignment.center,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: totalWidth * scale / 3.9,
            height: totalWidth * scale / 3.9,
            decoration: BoxDecoration(
              color: widget.showRealTimeState && scene.onOffStatus == 1
                  ? const Color(0xFF92D4FD)
                  : const Color(0xFFF8F8F8),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  width: imageWidth * scale,
                  height: imageHeight * scale,
                  image: AssetImage(imageUrl),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7.0),
                ),
                Container(
                  width: 90,
                  alignment: Alignment.center,
                  child: Text(
                    scene.getSceneName(context),
                    style: TextStyle(
                      inherit: false,
                      fontSize: 13.0 * scale,
                      color: widget.showRealTimeState && scene.onOffStatus == 1
                          ? Colors.white
                          : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          onTapDown: (TapDownDetails detail) {
            print(
                '-> down ${detail.globalPosition.dx} ${detail.globalPosition.dy}');

            int currentTime = DateTime.now().millisecondsSinceEpoch;

            if (startTime != 0 && currentTime - startTime < 1000) return;
            startTime = currentTime;

            if (longClickTimer != null) {
              longClickTimer.cancel();
            }
            if (clickTimer != null) {
              clickTimer.cancel();
            }
            clickTimer =
                Timer(const Duration(milliseconds: CLICK_TIME_INTERVAL), () {
              createPressAnimation();
            });
            longClickTimer = Timer(
                const Duration(milliseconds: LONG_CLICK_TIME_INTERVAL), () {
              if (currentTime - lastEventTime < EVENT_MIN_INTERVAL) {
                print("skip too frequent long click event");
              } else {
                widget.onLongClick();
                lastEventTime = DateTime.now().millisecondsSinceEpoch;
              }
            });
          },
          onTapCancel: () {
            checkUpAndCancel();
          },
          onTapUp: (TapUpDetails detail) {
            checkUpAndCancel();
          },
        ));
  }
}
