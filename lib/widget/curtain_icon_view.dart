import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'dart:async';

class CurtainIconView extends StatefulWidget {
  //final String uuid;
  final Entity entity;
  CurtainIconView({
    Key key,
    @required this.entity,
  }) : super(key: key);

  State<StatefulWidget> createState() => _CurtainIconState();
}

class _CurtainIconState extends State<CurtainIconView> {
  LogicDevice logicDevice;
  String imageUrl;

  StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  @override
  void didUpdateWidget(CurtainIconView oldWidget) {
    // TODO: implement didUpdateWidget
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
    if (cache == null) return;
    if (widget.entity is LogicDevice) {
      logicDevice = cache.findEntity(widget.entity.uuid) as LogicDevice;
      if (logicDevice == null) return;
      if (logicDevice.isCurtain) {
        if (logicDevice.parent.available) {
          imageUrl = 'images/icon_curtain.png';
        } else {
          imageUrl = 'images/icon_curtain_offline.png';
        }
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
            (event is DeviceOfflineEvent ||
                event is PhysicDeviceAvailableEvent) ||
            event is HomeCenterEvent)
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
        width: 25.0,
        height: 22.0,
        image: AssetImage(imageUrl),
      ),
    );
  }
}
