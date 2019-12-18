import 'package:flutter/cupertino.dart';

import 'package:xlive/const/const_shared.dart';
import 'package:xlive/page/binding_setting_page.dart';

import 'dart:async';

class BindingPageHeader extends StatefulWidget {
  final int bindingType;
  final int keyPressType;
  //final bool isCurtainOnly;
  final bool containsCurtain;
  final bool containsOnOffDevice;

  BindingPageHeader({
    @required this.bindingType,
    @required this.keyPressType,
    @required this.containsCurtain,
    @required this.containsOnOffDevice,
  });

  State<StatefulWidget> createState() => BindingPageHeaderState();
}

class BindingPageHeaderState extends State<BindingPageHeader> {
  Timer timer;

  int time = 0;

  void initState() {
    super.initState();

    if (widget.bindingType == BINDING_TYPE_OPEN_CLOSE ||
        widget.bindingType == BINDING_TYPE_SMART_DIAL) {
      startOpenCloseTimer();
    } else {
      startTimer();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      time += 500;
      if (time >= 4500) {
        time -= 4500;
      }
      setState(() {});
    });
  }

  void startOpenCloseTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time += 1;
      if (time >= 5) {
        time -= 5;
      }
      setState(() {});
    });
  }

  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  String get imageUrl {
    if (widget.bindingType == BINDING_TYPE_OPEN_CLOSE) {
      if (time > 3) {
        return 'images/open_close_2.png';
      } else {
        return 'images/open_close_1.png';
      }
    } else if (widget.bindingType == BINDING_TYPE_PIR) {
      if (time < 500) {
        return 'images/pir_panel_1.png';
      } else if (time < 1000) {
        return 'images/pir_panel_2.png';
      } else {
        return 'images/pir_panel_3.png';
      }
    } else if (widget.bindingType == BINDING_TYPE_KEY_PRESS) {
      if (widget.keyPressType == KEY_PRESS_TYPE_PIR) {
        if (widget.containsCurtain && !widget.containsOnOffDevice) {
          if (time < 500) {
            return 'images/pir_binding_curtain_1.png';
          } else if (time < 1000) {
            return 'images/pir_binding_curtain_2.png';
          } else {
            return 'images/pir_binding_curtain_3.png';
          }
        } else {
          if (time < 500) {
            return 'images/pir_binding_device_1.png';
          } else if (time < 1000) {
            return 'images/pir_binding_device_2.png';
          } else {
            return 'images/pir_binding_device_3.png';
          }
        }
      } else if (widget.keyPressType == KEY_PRESS_TYPE_WS) {
        if (widget.containsCurtain && !widget.containsOnOffDevice) {
          if (time < 500) {
            return 'images/ws_binding_curtain_1.png';
          } else if (time < 1000) {
            return 'images/ws_binding_curtain_2.png';
          } else {
            return 'images/ws_binding_curtain_3.png';
          }
        } else {
          if (time < 500) {
            return 'images/ws_binding_device_1.png';
          } else if (time < 1000) {
            return 'images/ws_binding_device_2.png';
          } else {
            return 'images/ws_binding_device_3.png';
          }
        }
      } else if (widget.keyPressType == KEY_PRESS_TYPE_KB) {
        if (widget.containsCurtain && !widget.containsOnOffDevice) {
          if (time < 500) {
            return 'images/sd_press_curtain_1.png';
          } else if (time < 1000) {
            return 'images/sd_press_curtain_2.png';
          } else {
            return 'images/sd_press_curtain_3.png';
          }
        } else {
          if (time < 500) {
            return 'images/sd_press_device_1.png';
          } else if (time < 1000) {
            return 'images/sd_press_device_2.png';
          } else {
            return 'images/sd_press_device_3.png';
          }
        }
      } else if (widget.keyPressType == KEY_PRESS_TYPE_WS_US) {
        if (widget.containsCurtain && !widget.containsOnOffDevice) {
          if (time < 500) {
            return 'images/ws_us_press_curtain_1.png';
          } else if (time < 1000) {
            return 'images/ws_us_press_curtain_2.png';
          } else {
            return 'images/ws_us_press_curtain_3.png';
          }
        } else {
          if (time < 500) {
            return 'images/ws_us_press_device_1.png';
          } else if (time < 1000) {
            return 'images/ws_us_press_device_2.png';
          } else {
            return 'images/ws_us_press_device_3.png';
          }
        }
      }
    } else if (widget.bindingType == BINDING_TYPE_SMART_DIAL) {
      if (time > 3) {
        return 'images/sd_rotate_2.png';
      } else {
        return 'images/sd_rotate_1.png';
      }
    }
    return '';
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Image.asset(
        imageUrl,
        gaplessPlayback: true,
      ),
    );
  }
}
