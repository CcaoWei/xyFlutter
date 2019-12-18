part of data_shared;

class PhysicDevice extends Entity {
  String model;
  bool available;
  List<LogicDevice> logicDevices;
  String newVersion;

  PhysicDevice({
    @required String uuid,
    @required String roomUuid,
    @required this.model,
    this.available,
    String name,
    String identifier,
    this.newVersion,
  }) : super.initPhysicDevice(
          uuid: uuid,
          roomUuid: roomUuid,
          name: name,
          identifier: identifier,
        );

  LogicDevice getLogicDevice(int index) {
    if (logicDevices == null || logicDevices.length == 0) return null;
    return logicDevices.elementAt(index);
  }

  final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
  String getRoomName(BuildContext context, String roomUuid) {
    for (var item in cache.rooms) {
      if (roomUuid == item.uuid) {
        return item.getRoomName(context);
      }
    }
    return "空";
  }

  bool get isHomeCenter => model == DEVICE_MODEL_HOME_CENTER;

  bool get isWallSwitch =>
      model == DEVICE_MODEL_WALL_SWITCH_D1 ||
      model == DEVICE_MODEL_WALL_SWITCH_D2 ||
      model == DEVICE_MODEL_WALL_SWITCH_D3 ||
      model == DEVICE_MODEL_WALL_SWITCH_D4 ||
      model == DEVICE_MODEL_WALL_SWITCH_S1 ||
      model == DEVICE_MODEL_WALL_SWITCH_S2 ||
      model == DEVICE_MODEL_WALL_SWITCH_S3 ||
      model == DEVICE_MODEL_WALL_SWITCH_S4;

  bool get isWallSwitchD =>
      model == DEVICE_MODEL_WALL_SWITCH_D1 ||
      model == DEVICE_MODEL_WALL_SWITCH_D2 ||
      model == DEVICE_MODEL_WALL_SWITCH_D3 ||
      model == DEVICE_MODEL_WALL_SWITCH_D4;

  bool get isWallSwitchS =>
      model == DEVICE_MODEL_WALL_SWITCH_S1 ||
      model == DEVICE_MODEL_WALL_SWITCH_S2 ||
      model == DEVICE_MODEL_WALL_SWITCH_S3 ||
      model == DEVICE_MODEL_WALL_SWITCH_S4;

  bool get isWallSwitchUS => model == DEVICE_MODEL_WALL_SWITCH_US1;

  bool get isDoorContact => model == DEVICE_MODEL_DOOR_SENSOR;

  bool get isAwarenessSwitch => model == DEVICE_MODEL_AWARENESS_SWITCH;

  bool get isCurtain => model == DEVICE_MODEL_CURTAIN;

  bool get isLightSocket => model == DEVICE_MODEL_LIGHT_SOCKET;

  bool get isLightSocketPhilips =>
      logicDevices.length > 0 && logicDevices[0].profile == PROFILE_COLOR_LIGHT;

  bool get isSmartPlug => model == DEVICE_MODEL_SMART_PLUG;

  bool get isSmartDial => model == DEVICE_MODEL_SMART_DIAL;

  bool get isZHHVRVGateway => model == DEVICE_MODEL_VG;

  bool get isSwitchModule =>
      model == DEVICE_MODEL_SWITCH_MODULE_D1 ||
      model == DEVICE_MODEL_SWITCH_MODULE_D2 ||
      model == DEVICE_MODEL_SWITCH_MODULE_D3 ||
      model == DEVICE_MODEL_SWITCH_MODULE_D4 ||
      model == DEVICE_MODEL_SWITCH_MODULE_S1 ||
      model == DEVICE_MODEL_SWITCH_MODULE_S2 ||
      model == DEVICE_MODEL_SWITCH_MODULE_S3 ||
      model == DEVICE_MODEL_SWITCH_MODULE_S4;
}
