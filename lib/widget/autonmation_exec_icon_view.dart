import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
// import 'package:xlive/widget/scene_icon_view.dart';

class AutomationExecIconDeviceView extends StatefulWidget {
  final Entity entity;
  final protobuf.Execution exec;
  AutomationExecIconDeviceView({
    Key key,
    @required this.entity,
    @required this.exec,
  }) : super(key: key);

  State<StatefulWidget> createState() => _ExecIconDeviceState();
}

class _ExecIconDeviceState extends State<AutomationExecIconDeviceView> {
  LogicDevice logicDevice;
  Scene scene;
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
  // void didUpdateWidget(AutomationExecIconDeviceView oldWidget) {
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

  void resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.entity is LogicDevice) {
      logicDevice = cache.findEntity(widget.entity.uuid) as LogicDevice;
      if (logicDevice == null) return;
      if (widget.exec.hasAction()) {
        if (widget.exec.action.action.actions[0].attrValue ==
            ON_OFF_STATUS_ON) {
          if (logicDevice.isOnOffLight || logicDevice.iscolorLight) {
            height = Adapt.px(105);
            width = Adapt.px(108);
            imageUrl = 'images/icon_light_on.png';
          } else if (logicDevice.isSmartPlug) {
            height = Adapt.px(78);
            width = Adapt.px(77);
            imageUrl = 'images/icon_plug_on.png';
          } else if (logicDevice.isCurtain) {
            print("阿斯顿发收款九分裤");
            height = Adapt.px(76);
            width = Adapt.px(66);
            imageUrl = 'images/icon_curtain.png';
          }
        } else {
          if (logicDevice.isOnOffLight || logicDevice.iscolorLight) {
            height = Adapt.px(105);
            width = Adapt.px(108);
            imageUrl = 'images/icon_light_off.png';
          } else if (logicDevice.isSmartPlug) {
            height = Adapt.px(78);
            width = Adapt.px(77);
            imageUrl = 'images/icon_plug_off.png';
          } else if (logicDevice.isCurtain) {
            height = Adapt.px(76);
            width = Adapt.px(66);
            imageUrl = 'images/icon_curtain.png';
          }
        }
      }

      setState(() {});
    } else if (widget.entity is Scene) {
      scene = cache.findEntity(widget.entity.uuid) as Scene;
      if (scene == null) imageUrl = 'images/defined_scene.png';
      if (scene.uuid == 'scene-000001') {
        height = Adapt.px(105);
        width = Adapt.px(93);
        imageUrl = 'images/scene_home_off.png';
      } else if (scene.uuid == 'scene-000002') {
        height = Adapt.px(75);
        width = Adapt.px(90);
        imageUrl = 'images/scene_leave_off.png';
      } else if (scene.uuid == 'scene-000003') {
        height = Adapt.px(89);
        width = Adapt.px(87);
        imageUrl = 'images/scene_up_off.png';
      } else if (scene.uuid == 'scene-000004') {
        height = Adapt.px(99);
        width = Adapt.px(93);
        imageUrl = 'images/scene_sleep_off.png';
      } else {
        height = Adapt.px(94);
        width = Adapt.px(96);
        imageUrl = 'images/defined_scene.png';
      }
    }
  }

  Widget build(BuildContext context) {
    resetData();
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(50), right: Adapt.px(50)),
      width: Adapt.px(105),
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
