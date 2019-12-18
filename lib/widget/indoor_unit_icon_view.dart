import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'dart:async';

class IndoorUnitIconView extends StatefulWidget {
  //final String uuid;
  final Entity entity;
  IndoorUnitIconView({
    Key key,
    @required this.entity,
  }) : super(key: key);

  State<StatefulWidget> createState() => _IndoorUnitState();
}

class _IndoorUnitState extends State<IndoorUnitIconView> {
  LogicDevice logicDevice;
  String imageUrl;

  StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  @override
  void didUpdateWidget(IndoorUnitIconView oldWidget) {
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
      if (logicDevice.isIndoorUnit) {
        if (logicDevice.parent.available) {
          imageUrl = 'images/dev_icon_air_conditioner_on.png';
        } else {
          imageUrl = 'images/dev_icon_air_conditioner_off.png';
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
                    event.uuid == logicDevice.uuid)) ||
            (event is HomeCenterEvent && event.type == HOME_CENTER_CHANGED))
        .where((event) =>
            (event is DeviceAttributeReportEvent &&
                event.attrId == ATTRIBUTE_ID_ON_OFF_STATUS) ||
            event is DeviceOfflineEvent ||
            event is PhysicDeviceAvailableEvent ||
            event is HomeCenterEvent)
        .listen((event) {
      if (event is DeviceOfflineEvent) {
        print('widget uuid: ${widget.entity.uuid}');
      }
      resetData();
    });
  }

  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      alignment: Alignment.center,
      child: Image.asset(
        imageUrl,
        width: 35.0,
        height: 36.0,
        gaplessPlayback: true,
      ),
    );
  }
}