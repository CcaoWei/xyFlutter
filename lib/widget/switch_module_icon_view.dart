import 'package:flutter/material.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'dart:async';

class SwitchModuleIconView extends StatefulWidget {
  final Entity entity;

  SwitchModuleIconView({
    @required this.entity,
  });

  State<StatefulWidget> createState() => _SwitchModuleIconState();
}

class _SwitchModuleIconState extends State<SwitchModuleIconView> {
  PhysicDevice physicDevice;

  StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void didUpdateWidget(SwitchModuleIconView oldWidget) {
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
    if (widget.entity is PhysicDevice) {
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
    if (physicDevice != null && physicDevice.isSwitchModule) {
      if (physicDevice.available) {
        return 'images/icon_switch_module.png';
      } else {
        return 'images/icon_switch_module_offline.png';
      }
    }
    var ent = widget.entity;
    if (ent is LogicDevice) {
      if (!ent.parent.available) return 'images/icon_sm_out_offline.png';
      if (widget.entity.uuid.contains("-01")) {
        return 'images/icon_sm_output1.png';
      } else {
        return 'images/icon_sm_output2.png';
      }
    }
    return 'images/icon_switch_module_offline.png';
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
