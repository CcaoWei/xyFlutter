import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'dart:async';

class SmartDialIconView extends StatefulWidget {
  //final String uuid;
  final Entity entity;
  SmartDialIconView({
    @required this.entity,
  });

  State<StatefulWidget> createState() => _SmartDialIconState();
}

class _SmartDialIconState extends State<SmartDialIconView> {
  PhysicDevice physicDevice;

  StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  @override
  void didUpdateWidget(SmartDialIconView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.entity != oldWidget.entity) {
      setState(() {});
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
    if (cache == null) return;
    if (widget.entity is PhysicDevice) {
      if (physicDevice == null) return;
      physicDevice = cache.findEntity(widget.entity.uuid) as PhysicDevice;
      setState(() {});
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
                (event.uuid == widget.entity.uuid ||
                    event.uuid == physicDevice.uuid)) ||
            (event is HomeCenterEvent && event.type == HOME_CENTER_CHANGED))
        .where((event) => (event is DeviceOfflineEvent ||
            event is PhysicDeviceAvailableEvent ||
            event is HomeCenterEvent))
        .listen((event) {
      resetData();
    });
  }

  String get imageUrl {
    if (physicDevice != null && physicDevice.isSmartDial) {
      print("physicDevice.isSmartDial");
      print(physicDevice.isSmartDial);
      if (physicDevice.available) {
        return 'images/icon_sd_online.png';
      } else {
        return 'images/icon_sd_offline.png';
      }
    }
    return 'images/icon_sd_offline.png';
  }

  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      alignment: Alignment.center,
      child: Image.asset(
        imageUrl,
        width: 26.0,
        height: 24.0,
        gaplessPlayback: true,
      ),
    );
  }
}
