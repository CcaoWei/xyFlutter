import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/page/scene_page.dart';

import 'dart:async';

class SceneTextView extends StatefulWidget {
  State<StatefulWidget> createState() => _SceneTextState();
}

class _SceneTextState extends State<SceneTextView>
    with TickerProviderStateMixin {
  AnimationController animController1;
  AnimationController animController2;
  AnimationController animController3;

  Animation<EdgeInsets> position1;
  Animation<EdgeInsets> position2;
  Animation<EdgeInsets> position3;

  Animation<double> opacity1;
  Animation<double> opacity2;
  Animation<double> opacity3;

  String name1;
  String name2;
  String name3;

  int state1;
  int state2;
  int state3;

  StreamSubscription subscription;

  void initState() {
    super.initState();
    start();
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    if (animController1 != null) {
      animController1.dispose();
    }
    if (animController2 != null) {
      animController2.dispose();
    }
    if (animController3 != null) {
      animController3.dispose();
    }
    super.dispose();
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => event is SceneTextAnimationEvent)
//        .where((event) => event is HomeCenterCacheEvent &&
//            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
//        .where((event) => event is DeviceAttributeReportEvent &&
//            (event.attrId == ATTRIBUTE_ID_ON_OFF_STATUS || event.attrId == ATTRIBUTE_ID_ALERT_LEVEL))
        .listen((event) {
      final SceneTextAnimationEvent evt = event as SceneTextAnimationEvent;
      createAnimation(evt.name, evt.state);
    });
  }

  void createAnimation(String name, int state) {
    if (animController1 == null) {
      createAnimation1(name, state);
    } else if (animController2 == null) {
      createAnimation2(name, state);
    } else if (animController3 == null) {
      createAnimation3(name, state);
    }
  }

  void createAnimation1(String name, int state) {
    animController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          animController1.dispose();
          animController1 = null;
        } else if (status == AnimationStatus.forward) {
          name1 = name;
          state1 = state;
        }
      });
    position1 = EdgeInsetsTween(
      begin: EdgeInsets.only(),
      end: EdgeInsets.only(bottom: 42.0),
    ).animate(animController1)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          position1 = null;
        }
      });
    opacity1 = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: animController1,
        curve: Interval(0.75, 1.0),
      ),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          opacity1 = null;
        }
      });
    animController1.forward();
  }

  void createAnimation2(String name, int state) {
    animController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.forward) {
          name2 = name;
          state2 = state;
        } else if (status == AnimationStatus.completed) {
          animController2.dispose();
          animController2 = null;
        }
      });
    position2 = EdgeInsetsTween(
      begin: EdgeInsets.only(),
      end: EdgeInsets.only(bottom: 42.0),
    ).animate(animController2)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          position2 = null;
        }
      });
    opacity2 = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: animController2,
        curve: Interval(0.75, 1.0),
      ),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          opacity2 = null;
        }
      });
    animController2.forward();
  }

  void createAnimation3(String name, int state) {
    animController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.forward) {
          name3 = name;
          state3 = state;
        } else if (status == AnimationStatus.completed) {
          animController3.dispose();
          animController3 = null;
        }
      });
    position3 = EdgeInsetsTween(
      begin: EdgeInsets.only(),
      end: EdgeInsets.only(bottom: 42.0),
    ).animate(animController3)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          position3 = null;
        }
      });
    opacity3 = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: animController3,
        curve: Interval(0.75, 1.0),
      ),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          opacity3 = null;
        }
      });
    animController3.forward();
  }

  String getString0(BuildContext context) {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return '';
    final int numberOfLightsOn = cache.numberOfLightsOn;
    final int numberOfDevicesArming = cache.numberOfDevicesArming;
    final double currentTemperature = cache.currentTemperature;
    String des = '';
    if (numberOfLightsOn > 0) {
      des += numberOfLightsOn.toString() +
          ' ' +
          DefinedLocalizations.of(context).devicesOn;
    }
    if (numberOfDevicesArming > 0) {
      if (numberOfLightsOn > 0) {
        des += ', ';
      }
      des += numberOfDevicesArming.toString() +
          ' ' +
          DefinedLocalizations.of(context).devicesArming;
    }
    if (currentTemperature != -999.0) {
      if (numberOfLightsOn > 0 || numberOfDevicesArming > 0) {
        des += ', ';
      }
      des += DefinedLocalizations.of(context).currentTemperature +
          ' ' +
          (currentTemperature / 10).toString() +
          '°C';
    }
    return des;
  }

  String getString1(BuildContext context) {
    switch (state1) {
      case ON:
        return name1 + ' ' + DefinedLocalizations.of(context).on;
      case OFF:
        return name1 + ' ' + DefinedLocalizations.of(context).off;
      case ALARM:
        return name1 + ' ' + DefinedLocalizations.of(context).alarm;
      case DISALARM:
        return name1 + ' ' + DefinedLocalizations.of(context).disalarm;
      default:
        return '';
    }
  }

  String getString2(BuildContext context) {
    switch (state2) {
      case ON:
        return name2 + ' ' + DefinedLocalizations.of(context).on;
      case OFF:
        return name2 + ' ' + DefinedLocalizations.of(context).off;
      case ALARM:
        return name2 + ' ' + DefinedLocalizations.of(context).alarm;
      case DISALARM:
        return name2 + ' ' + DefinedLocalizations.of(context).disalarm;
      default:
        return '';
    }
  }

  String getString3(BuildContext context) {
    switch (state3) {
      case ON:
        return name3 + ' ' + DefinedLocalizations.of(context).on;
      case OFF:
        return name3 + ' ' + DefinedLocalizations.of(context).off;
      case ALARM:
        return name3 + ' ' + DefinedLocalizations.of(context).alarm;
      case DISALARM:
        return name3 + ' ' + DefinedLocalizations.of(context).disalarm;
      default:
        return '';
    }
  }

  bool get descriptionShown =>
      animController1 == null &&
      animController2 == null &&
      animController3 == null;

  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      padding: EdgeInsets.only(left: 13.0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 56.0,
            child: Offstage(
              offstage: !descriptionShown,
              child: Text(
                getString0(context),
                style: TEXT_STYLE_SCENE_ANIMATION_TEXT,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            height: 56.0,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                Container(
                  height: 56.0,
                  alignment: Alignment.bottomLeft,
                  padding:
                      position1 == null ? EdgeInsets.only() : position1.value,
                  child: Opacity(
                    opacity: animController1 == null
                        ? 0.0
                        : opacity1 == null ? 1.0 : opacity1.value,
                    child: Text(
                      getString1(context),
                      style: TEXT_STYLE_SCENE_ANIMATION_TEXT,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  height: 56.0,
                  alignment: Alignment.bottomLeft,
                  padding:
                      position2 == null ? EdgeInsets.only() : position2.value,
                  child: Opacity(
                    opacity: animController2 == null
                        ? 0.0
                        : opacity2 == null ? 1.0 : opacity2.value,
                    child: Text(
                      getString2(context),
                      style: TEXT_STYLE_SCENE_ANIMATION_TEXT,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  height: 56.0,
                  alignment: Alignment.bottomLeft,
                  padding:
                      position3 == null ? EdgeInsets.only() : position3.value,
                  child: Opacity(
                    opacity: animController3 == null
                        ? 0.0
                        : opacity3 == null ? 1.0 : opacity3.value,
                    child: Text(
                      getString3(context),
                      style: TEXT_STYLE_SCENE_ANIMATION_TEXT,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
