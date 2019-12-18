import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'dart:async';

class WallSwitchIconView extends StatefulWidget {
  //final String uuid;
  final Entity entity;
  WallSwitchIconView({
    @required this.entity,
  });

  State<StatefulWidget> createState() => _WallSwitchIconState();
}

class _WallSwitchIconState extends State<WallSwitchIconView> {
  PhysicDevice physicDevice;
  String imageUrl;

  StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void didUpdateWidget(WallSwitchIconView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entity != oldWidget.entity) {
      resetData();
    }
  }

  void dispose() {
    super.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
  }

  void resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    var ent = widget.entity;
    if (cache == null) return;
    if (ent is PhysicDevice) {
      physicDevice = cache.findEntity(widget.entity.uuid) as PhysicDevice;
      if (physicDevice == null) return;
      if (physicDevice.isWallSwitch) {
        if (physicDevice.available) {
          imageUrl = 'images/icon_ws.png';
        } else {
          imageUrl = 'images/icon_ws_offline.png';
        }
      } else if (physicDevice.isWallSwitchUS) {
        if (physicDevice.available) {
          imageUrl = 'images/icon_ws_us.png';
        } else {
          imageUrl = 'images/icon_ws_us_offline.png';
        }
      }
      setState(() {});
    } else if (ent is LogicDevice && ent.isWallSwitchButton) {
      physicDevice = ent.parent;
      if (ent.uuid.contains("-01")) {
        imageUrl = 'images/wall_switch_binding_left_top.png';
      } else if (ent.uuid.contains("-02")) {
        imageUrl = 'images/wall_switch_binding_top.png';
      } else if (ent.uuid.contains("-03")) {
        imageUrl = 'images/wall_switch_binding_left.png';
      } else if (ent.uuid.contains("-04")) {
        imageUrl = 'images/wall_switch_binding_right.png';
      }
    }
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => physicDevice != null)
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

  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      alignment: Alignment.center,
      child: Image(
        width: physicDevice.isWallSwitchUS ? 22.0 : 26.0,
        height: physicDevice.isWallSwitchUS ? 33.0 : 26.0,
        image: AssetImage(imageUrl),
      ),
    );
  }
}
