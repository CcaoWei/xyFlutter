import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/widget/air_conditioner_icon_view.dart';
import 'package:xlive/widget/indoor_unit_icon_view.dart';
import 'package:xlive/widget/scene_icon_view.dart';

import 'light_icon_view.dart';
import 'plug_icon_view.dart';
import 'awareness_switch_icon_view.dart';
import 'door_sensor_icon_view.dart';
import 'curtain_icon_view.dart';
import 'wall_switch_icon_view.dart';
import 'smart_dial_icon_view.dart';
import 'switch_module_icon_view.dart';

const int ICON_UNKNOWN = 0;
const int ICON_LIGHT = 1;
const int ICON_PLUG = 2;
const int ICON_AWARENESS_SWITCH = 3;
const int ICON_DOOR_SENSOR = 4;
const int ICON_CURTAIN = 5;
const int ICON_WALL_SWITCH = 6;
const int ICON_HOME_CENTER = 7;
const int ICON_SMART_DIAL = 8;
const int ICON_SWITCH_MODULE = 9;
const int ICON_SCENE = 10;
const int ICON_AIR_CONDITIONER = 11;
const int ICON_INDOOR_UNIT = 12;

class DeviceIconView extends StatelessWidget {
  final int deviceType;
  //final String uuid;
  final Entity entity;
  final bool showRealtimeState;

  DeviceIconView({
    Key key,
    @required this.deviceType,
    @required this.entity,
    this.showRealtimeState = true,
  }) : super(key: key);

  Widget build(BuildContext context) {
    switch (deviceType) {
      case ICON_LIGHT:
        return LightIconView(entity: entity);
      case ICON_PLUG:
        return PlugIconView(entity: entity);
      case ICON_AWARENESS_SWITCH:
        return AwarenessSwitchIconView(
          entity: entity,
          showRealtimeState: showRealtimeState,
        );
      case ICON_DOOR_SENSOR:
        return DoorSensorIconView(
          entity: entity,
          showRealtimeState: showRealtimeState,
        );
      case ICON_CURTAIN:
        return CurtainIconView(entity: entity);
      case ICON_WALL_SWITCH:
        return WallSwitchIconView(entity: entity);
      case ICON_SMART_DIAL:
        return SmartDialIconView(entity: entity);
      case ICON_SWITCH_MODULE:
        return SwitchModuleIconView(entity: entity);
      case ICON_SCENE:
        return SceneIconView(
          entity: entity,
          showRealTimeState: showRealtimeState,
        );
      case ICON_AIR_CONDITIONER:
        return AirConditionerIconView(
          entity: entity,
        );
      case ICON_INDOOR_UNIT:
        return IndoorUnitIconView(
          entity: entity,
        );
      default:
        return Container(
          width: 80.0,
          height: 80.0,
        );
    }
  }
}
