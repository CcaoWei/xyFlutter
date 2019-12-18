import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/widget/air_conditioner_image_view.dart';
import 'package:xlive/widget/indoor_unit_image_view.dart';

import 'light_image_view.dart';
import 'plug_image_view.dart';
import 'awareness_switch_image_view.dart';
import 'door_sensor_image_view.dart';
import 'curtain_image_view.dart';
import 'wall_switch_image_view.dart';
import 'smart_dial_image_view.dart';
import 'switch_module_image_view.dart';

const int IMAGE_UNKNOWN = 0;
const int IMAGE_LIGHT = 1;
const int IMAGE_PLUG = 2;
const int IMAGE_AWARENESS_SWITCH = 3;
const int IMAGE_DOOR_SENSOR = 4;
const int IMAGE_CURTAIN = 5;
const int IMAGE_WALL_SWITCH = 6;
const int IMAGE_HOME_CENTER = 7;
const int IMAGE_SMART_DIAL = 8;
const int IMAGE_SWITCH_MODULE = 9;
const int IMAGE_SCENE = 10;
const int ICON_AIR_CONDITIONER = 11;
const int ICON_INDOOR_UNIT = 12;

const double PADDING_BOTTOM = 15.0;
const double PADDING1 = 5.0;
const double PADDING2 = 15.0;

class DeviceImageView extends StatelessWidget {
  final int deviceType;
  //final String uuid;
  final Entity entity;

  DeviceImageView({
    Key key,
    @required this.deviceType,
    @required this.entity,
  });

  Widget build(BuildContext context) {
    switch (deviceType) {
      case IMAGE_LIGHT:
        return LightImageView(entity: entity);
      case IMAGE_PLUG:
        return PlugImageView(entity: entity);
      case IMAGE_AWARENESS_SWITCH:
        return AwarenessSwitchImageView(entity: entity);
      case IMAGE_DOOR_SENSOR:
        return DoorSensorImageView(entity: entity);
      case IMAGE_CURTAIN:
        return CurtainImageView(entity: entity);
      case IMAGE_WALL_SWITCH:
        return WallSwitchImageView(entity: entity);
      case IMAGE_SMART_DIAL:
        return SmartDialImageView(entity: entity);
      case IMAGE_SWITCH_MODULE:
        return SwitchModuleImageView(entity: entity);
      case ICON_AIR_CONDITIONER:
        return AirConditionerImageView(entity: entity);
      case ICON_INDOOR_UNIT:
        return IndoorUnitImageView(entity: entity);
      default:
        return Container(
          height: 240.0,
        );
    }
  }
}
