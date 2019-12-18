import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'dart:async';

class SceneIconView extends StatefulWidget {
  final Entity entity;
  final bool showRealTimeState;

  SceneIconView({
    @required this.entity,
    @required this.showRealTimeState,
  });

  State<StatefulWidget> createState() => _SceneIconState();
}

class _SceneIconState extends State<SceneIconView> {
  Scene scene;

  StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    if (widget.showRealTimeState) start();
  }

  void didUpdateWidget(SceneIconView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entity != oldWidget.entity) {
      resetData();
    }
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    super.dispose();
  }

  void resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.entity is Scene) {
      scene = cache.findEntity(widget.entity.uuid) as Scene;
      setState(() {});
    }
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => scene != null)
        .where((event) =>
            (event is HomeCenterCacheEvent &&
                event.homeCenterUuid ==
                    HomeCenterManager().defaultHomeCenterUuid &&
                event.uuid == widget.entity.uuid) ||
            (event is HomeCenterEvent && event.type == HOME_CENTER_CHANGED))
        .where((event) => (event is DeviceOfflineEvent ||
            event is PhysicDeviceAvailableEvent ||
            event is HomeCenterEvent))
        .listen((event) {
      resetData();
    });
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

  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      alignment: Alignment.center,
      child: Image.asset(
        imageUrl,
        width: 40.0,
        height: 40.0,
        gaplessPlayback: true,
      ),
    );
  }
}
