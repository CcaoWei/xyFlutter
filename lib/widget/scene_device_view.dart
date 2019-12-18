import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/page/scene_page.dart';

import 'dart:async';

typedef OnDeviceIndexChanged = void Function(int index);

class SceneDeviceView extends StatefulWidget {
  final OnDeviceIndexChanged onDeviceIndexChanged;

  SceneDeviceView({
    Key key,
    @required this.onDeviceIndexChanged,
  });

  State<StatefulWidget> createState() =>
      _SceneDeviceState(onDeviceIndexChanged);
}

class _SceneDeviceState extends State<SceneDeviceView>
    with TickerProviderStateMixin {
  final OnDeviceIndexChanged onDeviceIndexChanged;

  _SceneDeviceState(this.onDeviceIndexChanged);

  AnimationController animController1;
  AnimationController animController2;
  AnimationController animController3;
  AnimationController animController4;
  AnimationController animController5;

  Animation<EdgeInsets> position1;
  Animation<EdgeInsets> position2;
  Animation<EdgeInsets> position3;
  Animation<EdgeInsets> position4;
  Animation<EdgeInsets> position5;

  AnimationController opacityController;

  Animation<double> opacity1;
  Animation<double> opacity2;
  Animation<double> opacity3;
  Animation<double> opacity4;
  Animation<double> opacity5;

  int deviceType1 = LIGHT;
  int deviceType2 = LIGHT;
  int deviceType3 = LIGHT;
  int deviceType4 = LIGHT;
  int deviceType5 = LIGHT;

  int state1 = ON;
  int state2 = ON;
  int state3 = ON;
  int state4 = ON;
  int state5 = ON;

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
      animController1 = null;
      position1 = null;
      opacity1 = null;
    }
    if (animController2 != null) {
      animController2.dispose();
      animController2 = null;
      position2 = null;
      opacity2 = null;
    }
    if (animController3 != null) {
      animController3.dispose();
      animController3 = null;
      position3 = null;
      opacity3 = null;
    }
    if (animController4 != null) {
      animController4.dispose();
      animController4 = null;
      position4 = null;
      opacity4 = null;
    }
    if (animController5 != null) {
      animController5.dispose();
      animController5 = null;
      position5 = null;
      opacity5 = null;
    }
    if (opacityController != null) {
      opacityController.dispose();
      opacityController = null;
    }
    super.dispose();
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => event is SceneDeviceAnimationEvent)
        .listen((event) {
      final SceneDeviceAnimationEvent evt = event as SceneDeviceAnimationEvent;
      if (evt.deviceType == -1 && evt.state == -1) {
        if (animController1 == null &&
            animController2 == null &&
            animController3 == null &&
            animController4 == null &&
            animController5 == null) return;
        createOpacityAnimation();
      } else {
        createAnimation(evt.deviceType, evt.state);
      }
    });
  }

  void createAnimation(int deviceType, int state) {
    if (animController1 == null) {
      createAnimation1(deviceType, state);
    } else if (animController2 == null) {
      createAnimation2(deviceType, state);
    } else if (animController3 == null) {
      createAnimation3(deviceType, state);
    } else if (animController4 == null) {
      createAnimation4(deviceType, state);
    } else if (animController5 == null) {
      createAnimation5(deviceType, state);
    }
  }

  void createAnimation1(int deviceType, int state) {
    animController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: POSITION_DURATION),
    )..addListener(() {
        setState(() {});
      });
    position1 = EdgeInsetsTween(
      begin: EdgeInsets.only(),
      end: EdgeInsets.only(bottom: DEVICE_PADDING_BOTTOM),
    ).animate(animController1)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (deviceType == LIGHT || deviceType == PLUG) {
            state1 = (state == 1) ? ON : OFF;
          } else {
            state1 = (state == 1) ? ALARM : DISALARM;
          }
        } else if (status == AnimationStatus.forward) {
          deviceType1 = deviceType;
          onDeviceIndexChanged(0);
          if (deviceType == LIGHT || deviceType == PLUG) {
            state1 = (state == 1) ? OFF : ON;
          } else {
            state1 = (state == 1) ? DISALARM : ALARM;
          }
        }
      });
    animController1.forward();
  }

  void createAnimation2(int deviceType, int state) {
    animController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: POSITION_DURATION),
    )..addListener(() {
        setState(() {});
      });
    position2 = EdgeInsetsTween(
      begin: EdgeInsets.only(),
      end: EdgeInsets.only(bottom: DEVICE_PADDING_BOTTOM),
    ).animate(animController2)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (deviceType == LIGHT || deviceType == PLUG) {
            state2 = (state == 1) ? ON : OFF;
          } else {
            state2 = (state == 1) ? ALARM : DISALARM;
          }
        } else if (status == AnimationStatus.forward) {
          deviceType2 = deviceType;
          onDeviceIndexChanged(1);
          if (deviceType == LIGHT || deviceType == PLUG) {
            state2 = (state == 1) ? OFF : ON;
          } else {
            state2 = (state == 1) ? DISALARM : ALARM;
          }
        }
      });
    animController2.forward();
  }

  void createAnimation3(int deviceType, int state) {
    animController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: POSITION_DURATION),
    )..addListener(() {
        setState(() {});
      });
    position3 = EdgeInsetsTween(
      begin: EdgeInsets.only(),
      end: EdgeInsets.only(bottom: DEVICE_PADDING_BOTTOM),
    ).animate(animController3)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (deviceType == LIGHT || deviceType == PLUG) {
            state3 = (state == 1) ? ON : OFF;
          } else {
            state3 = (state == 1) ? ALARM : DISALARM;
          }
        } else if (status == AnimationStatus.forward) {
          deviceType3 = deviceType;
          onDeviceIndexChanged(2);
          if (deviceType == LIGHT || deviceType == PLUG) {
            state3 = (state == 1) ? OFF : ON;
          } else {
            state3 = (state == 1) ? DISALARM : ALARM;
          }
        }
      });
    animController3.forward();
  }

  void createAnimation4(int deviceType, int state) {
    animController4 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: POSITION_DURATION),
    )..addListener(() {
        setState(() {});
      });
    position4 = EdgeInsetsTween(
      begin: EdgeInsets.only(),
      end: EdgeInsets.only(bottom: DEVICE_PADDING_BOTTOM),
    ).animate(animController4)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (deviceType == LIGHT || deviceType == PLUG) {
            state4 = (state == 1) ? ON : OFF;
          } else {
            state4 = (state == 1) ? ALARM : DISALARM;
          }
        } else if (status == AnimationStatus.forward) {
          deviceType4 = deviceType;
          onDeviceIndexChanged(3);
          if (deviceType == LIGHT || deviceType == PLUG) {
            state4 = (state == 1) ? OFF : ON;
          } else {
            state4 = (state == 1) ? DISALARM : ALARM;
          }
        }
      });
    animController4.forward();
  }

  void createAnimation5(int deviceType, int state) {
    animController5 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: POSITION_DURATION),
    )..addListener(() {
        setState(() {});
      });
    position5 = EdgeInsetsTween(
      begin: EdgeInsets.only(),
      end: EdgeInsets.only(bottom: DEVICE_PADDING_BOTTOM),
    ).animate(animController5)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (deviceType == LIGHT || deviceType == PLUG) {
            state5 = (state == 1) ? ON : OFF;
          } else {
            state5 = (state == 1) ? ALARM : DISALARM;
          }
          createOpacityAnimation();
        } else if (status == AnimationStatus.forward) {
          deviceType5 = deviceType;
          onDeviceIndexChanged(4);
          if (deviceType == LIGHT || deviceType == PLUG) {
            state5 = (state == 1) ? OFF : ON;
          } else {
            state5 = (state == 1) ? DISALARM : ALARM;
          }
        }
      });
    animController5.forward();
  }

  void createOpacityAnimation() {
    if ((animController1 != null && animController1.isAnimating) ||
        (animController2 != null && animController2.isAnimating) ||
        (animController3 != null && animController3.isAnimating) ||
        (animController4 != null && animController4.isAnimating) ||
        (animController5 != null && animController5.isAnimating)) return;
    if (opacityController != null) return;
    opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: OPACITY_DURATION),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          opacityController.dispose();
          opacityController = null;
          onDeviceIndexChanged(0);
        }
      });
    if (animController1 != null) {
      opacity1 = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(opacityController)
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animController1.dispose();
            animController1 = null;
            position1 = null;
            opacity1 = null;
          }
        });
    }
    if (animController2 != null) {
      opacity2 = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(opacityController)
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animController2.dispose();
            animController2 = null;
            position2 = null;
            opacity2 = null;
          }
        });
    }
    if (animController3 != null) {
      opacity3 = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(opacityController)
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animController3.dispose();
            animController3 = null;
            position3 = null;
            opacity3 = null;
          }
        });
    }
    if (animController4 != null) {
      opacity4 = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(opacityController)
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animController4.dispose();
            animController4 = null;
            position4 = null;
            opacity4 = null;
          }
        });
    }
    if (animController5 != null) {
      opacity5 = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(opacityController)
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animController5.dispose();
            animController5 = null;
            position5 = null;
            opacity5 = null;
          }
        });
    }
    opacityController.forward();
  }

  String get deviceImageUrl1 {
    switch (deviceType1) {
      case LIGHT:
        return state1 == ON
            ? 'images/icon_light_on.png'
            : 'images/icon_light_off.png';
      case PLUG:
        return state1 == ON
            ? 'images/icon_plug_on.png'
            : 'images/icon_plug_off.png';
      case PIR:
        return state1 == ALARM
            ? 'images/pir_icon_alarm.png'
            : 'images/icon_pir.png';
      case DOOR_CONTACT:
        return state1 == ALARM
            ? 'images/icon_dc_alarm.png'
            : 'images/icon_dc.png';
      default:
        return '';
    }
  }

  String get deviceImageUrl2 {
    switch (deviceType2) {
      case LIGHT:
        return state2 == ON
            ? 'images/icon_light_on.png'
            : 'images/icon_light_off.png';
      case PLUG:
        return state2 == ON
            ? 'images/icon_plug_on.png'
            : 'images/icon_plug_off.png';
      case PIR:
        return state2 == ALARM
            ? 'images/pir_icon_alarm.png'
            : 'images/icon_pir.png';
      case DOOR_CONTACT:
        return state2 == ALARM
            ? 'images/icon_dc_alarm.png'
            : 'images/icon_dc.png';
      default:
        return '';
    }
  }

  String get deviceImageUrl3 {
    switch (deviceType3) {
      case LIGHT:
        return state3 == ON
            ? 'images/icon_light_on.png'
            : 'images/icon_light_off.png';
      case PLUG:
        return state3 == ON
            ? 'images/icon_plug_on.png'
            : 'images/icon_plug_off.png';
      case PIR:
        return state3 == ALARM
            ? 'images/pir_icon_alarm.png'
            : 'images/icon_pir.png';
      case DOOR_CONTACT:
        return state3 == ALARM
            ? 'images/icon_dc_alarm.png'
            : 'images/icon_dc.png';
      default:
        return '';
    }
  }

  String get deviceImageUrl4 {
    switch (deviceType4) {
      case LIGHT:
        return state4 == ON
            ? 'images/icon_light_on.png'
            : 'images/icon_light_off.png';
      case PLUG:
        return state4 == ON
            ? 'images/icon_plug_on.png'
            : 'images/icon_plug_off.png';
      case PIR:
        return state4 == ALARM
            ? 'images/pir_icon_alarm.png'
            : 'images/icon_pir.png';
      case DOOR_CONTACT:
        return state4 == ALARM
            ? 'images/icon_dc_alarm.png'
            : 'images/icon_dc.png';
      default:
        return '';
    }
  }

  String get deviceImageUrl5 {
    switch (deviceType5) {
      case LIGHT:
        return state5 == ON
            ? 'images/icon_light_on.png'
            : 'images/icon_light_off.png';
      case PLUG:
        return state5 == ON
            ? 'images/icon_plug_on.png'
            : 'images/icon_plug_off.png';
      case PIR:
        return state5 == ALARM
            ? 'images/pir_icon_alarm.png'
            : 'images/icon_pir.png';
      case DOOR_CONTACT:
        return state5 == ALARM
            ? 'images/icon_dc_alarm.png'
            : 'images/icon_dc.png';
      default:
        return '';
    }
  }

  Widget build(BuildContext context) {
    final double totalWidth = MediaQuery.of(context).size.width - 40.0;
    return Container(
      height: 70.0,
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: totalWidth / 5,
            alignment: Alignment.bottomCenter,
            padding: position1 == null ? EdgeInsets.only() : position1.value,
            child: Opacity(
              opacity: animController1 == null
                  ? 0.0
                  : (opacity1 == null) ? 1.0 : opacity1.value,
              child: buildDeviceImage(deviceType1, 0),
            ),
          ),
          Container(
            width: totalWidth / 5,
            alignment: Alignment.bottomCenter,
            padding: position2 == null ? EdgeInsets.only() : position2.value,
            child: Opacity(
              opacity: animController2 == null
                  ? 0.0
                  : (opacity2 == null) ? 1.0 : opacity2.value,
              child: buildDeviceImage(deviceType2, 1),
            ),
          ),
          Container(
            width: totalWidth / 5,
            alignment: Alignment.bottomCenter,
            padding: position3 == null ? EdgeInsets.only() : position3.value,
            child: Opacity(
              opacity: animController3 == null
                  ? 0.0
                  : (opacity3 == null) ? 1.0 : opacity3.value,
              child: buildDeviceImage(deviceType3, 2),
            ),
          ),
          Container(
            width: totalWidth / 5,
            alignment: Alignment.bottomCenter,
            padding: position4 == null ? EdgeInsets.only() : position4.value,
            child: Opacity(
              opacity: animController4 == null
                  ? 0.0
                  : (opacity4 == null) ? 1.0 : opacity4.value,
              child: buildDeviceImage(deviceType4, 3),
            ),
          ),
          Container(
            width: totalWidth / 5,
            alignment: Alignment.bottomCenter,
            padding: position5 == null ? EdgeInsets.only() : position5.value,
            child: Opacity(
              opacity: animController5 == null
                  ? 0.0
                  : (opacity5 == null) ? 1.0 : opacity5.value,
              child: buildDeviceImage(deviceType5, 4),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeviceImage(int deviceType, int index) {
    double width = 0.0;
    double height = 0.0;
    if (deviceType == LIGHT) {
      width = 35.0;
      height = 36.0;
    } else if (deviceType == PLUG) {
      width = 25.0;
      height = 25.0;
    } else if (deviceType == PIR) {
      width = 25.0;
      height = 25.0;
    } else if (deviceType == DOOR_CONTACT) {
      width = 24.0;
      height = 24.0;
    }
    String imageUrl = deviceImageUrl1;
    if (index == 0) {
      imageUrl = deviceImageUrl1;
    } else if (index == 1) {
      imageUrl = deviceImageUrl2;
    } else if (index == 2) {
      imageUrl = deviceImageUrl3;
    } else if (index == 3) {
      imageUrl = deviceImageUrl4;
    } else if (index == 4) {
      imageUrl = deviceImageUrl5;
    }
    return Image(
      width: width,
      height: height,
      image: AssetImage(imageUrl),
    );
  }
}
