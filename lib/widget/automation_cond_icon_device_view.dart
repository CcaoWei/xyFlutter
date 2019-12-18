import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/data/data_shared.dart';
import 'dart:ui';
// import 'package:xlive/widget/scene_icon_view.dart';

class AutomationCondIconDeviceView extends StatefulWidget {
  final Entity entity;
  final protobuf.Condition cond;
  AutomationCondIconDeviceView({
    Key key,
    @required this.entity,
    @required this.cond,
  }) : super(key: key);

  State<StatefulWidget> createState() => _CondIconDeviceState();
}

class _CondIconDeviceState extends State<AutomationCondIconDeviceView> {
  LogicDevice logicDevice;
  String imageUrl = "images/icon_light_off.png";
  double height = Adapt.px(85);
  double width = Adapt.px(85);
  // StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    // start();
  }

  @override
  // void didUpdateWidget(AutomationCondIconDeviceView oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.entity != oldWidget.entity) {
  //     resetData();
  //   }
  // }

  void dispose() {
    super.dispose();
    // if (subscription != null) {
    //   subscription.cancel();
    // }
  }

  String getChildImageUrl(LogicDevice ld) {
    if (ld.parent.isWallSwitch) {
      if (ld.uuid.endsWith('-01')) {
        if (ld.isWallSwitchButton) {
          return 'images/wall_switch_binding_left_top.png';
        } else {
          return 'images/icon_ws_lt_off.png';
        }
      } else if (ld.uuid.endsWith('-02')) {
        if (ld.isWallSwitchButton) {
          return 'images/wall_switch_binding_top.png';
        } else {
          return 'images/icon_ws_rt_off.png';
        }
      } else if (ld.uuid.endsWith('-04')) {
        if (ld.isWallSwitchButton) {
          return 'images/wall_switch_binding_right.png';
        } else {
          return 'images/icon_ws_rb_off.png';
        }
      } else if (ld.uuid.endsWith('-03')) {
        if (ld.isWallSwitchButton) {
          return 'images/wall_switch_binding_left.png';
        } else {
          return 'images/icon_ws_lb_off.png';
        }
      }
    } else if (ld.parent.isWallSwitchUS) {
      return 'images/icon_ws_us_m_off.png';
    } else if (ld.parent.isSwitchModule) {
      if (widget.cond.hasAttributeVariation() &&
          widget.cond.attributeVariation.attrID.value ==
              ATTRIBUTE_ID_ON_OFF_STATUS) {
        if (ld.uuid.endsWith('-01')) {
          return 'images/cond_icon_sm_output1.png';
        } else if (ld.uuid.endsWith('-02')) {
          return 'images/cond_icon_sm_output2.png';
        }
      } else {
        if (ld.uuid.endsWith('-01')) {
          return 'images/cond_icon_sm_input1.png';
        } else if (ld.uuid.endsWith('-02')) {
          return 'images/cond_icon_sm_input2.png';
        }
      }
    }
    return 'images/icon_ws_lt_on.png';
  }

  void resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (widget.cond == null) {
      height = Adapt.px(75);
      width = Adapt.px(89);
      imageUrl = "images/auto_timer.png";
      return;
    }
    if (widget.cond.hasTimer()) {
      height = Adapt.px(75);
      width = Adapt.px(89);
      imageUrl = "images/auto_timer.png";
      return;
    } else if (widget.cond.hasCalendar()) {
      height = Adapt.px(75);
      width = Adapt.px(75);
      imageUrl = "images/auto_time_table.png";
      return;
    }
    if (cache == null) return;

    if (widget.entity != null) {
      if (widget.entity is LogicDevice) {
        logicDevice = cache.findEntity(widget.entity.uuid) as LogicDevice;
        if (logicDevice == null) return;
        if (logicDevice.parent.isLightSocket ||
            logicDevice.parent.isLightSocketPhilips) {
          height = Adapt.px(105);
          width = Adapt.px(108);
          imageUrl = 'images/icon_light_off.png';
        } else if (logicDevice.parent.isAwarenessSwitch) {
          height = Adapt.px(78);
          width = Adapt.px(78);
          imageUrl = 'images/icon_pir.png';
        } else if (logicDevice.parent.isSmartPlug) {
          height = Adapt.px(78);
          width = Adapt.px(77);
          imageUrl = 'images/icon_plug_off.png';
        } else if (logicDevice.parent.isCurtain) {
          height = Adapt.px(76);
          width = Adapt.px(66);
          imageUrl = 'images/icon_curtain.png';
        } else if (logicDevice.parent.isDoorContact) {
          height = Adapt.px(71);
          width = Adapt.px(71);
          imageUrl = 'images/icon_dc.png';
        } else if (logicDevice.parent.isSmartDial) {
          height = Adapt.px(79);
          width = Adapt.px(73);
          imageUrl = 'images/icon_sd_offline.png';
        } else if (logicDevice.parent.isWallSwitch) {
          height = Adapt.px(79);
          width = Adapt.px(79);
          imageUrl = getChildImageUrl(logicDevice);
        } else if (logicDevice.parent.isSwitchModule) {
          height = Adapt.px(120);
          width = Adapt.px(120);
          imageUrl = getChildImageUrl(logicDevice);
        } else if (logicDevice.parent.isWallSwitchUS) {
          height = Adapt.px(51);
          width = Adapt.px(98);
          imageUrl = getChildImageUrl(logicDevice);
        }
        setState(() {});
      }
    }
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(50), right: Adapt.px(50)),
      width: Adapt.px(120),
      alignment: Alignment.center,
      child: Image.asset(
        imageUrl,
        width: width,
        height: height,
        gaplessPlayback: true,
      ),
    );
  }
}
