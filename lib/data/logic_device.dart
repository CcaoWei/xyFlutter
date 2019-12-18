part of data_shared;

class LogicDevice extends Entity {
  int profile;
  PhysicDevice parent;

  LogicDevice(
      {@required String uuid,
      @required this.profile,
      @required String roomUuid,
      String name})
      : super.initLogicDevice(uuid: uuid, roomUuid: roomUuid, name: name);

  bool get isOnOffLight {
    if (profile != PROFILE_ON_OFF_LIGHT &&
        profile != PROFILE_COLOR_LIGHT &&
        profile != PROFILE_EXTENDED_COLOR_LIGHT &&
        profile != PROFILE_COLOR_TEMPERATURE_LIGHT) return false;
    if (disableRelay != 0 && disableRelay != 1) return true;
    return disableRelay == 0;
  }

  bool get iscolorLight {
    if (profile != PROFILE_COLOR_LIGHT &&
        profile != PROFILE_EXTENDED_COLOR_LIGHT) return false;
    if (disableRelay != 0 && disableRelay != 1) return true;
    return disableRelay == 0;
  }

  // final List rooms = HomeCenterManager().defaultHomeCenterCache.rooms;
  final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;

  // if (cache == null) return true;
  // final List<Room> rooms = cache.rooms;
  String getRoomName(BuildContext context, String roomUuid) {
    for (var item in cache.rooms) {
      if (roomUuid == item.uuid) {
        return item.getRoomName(context);
      }
    }
    return DefinedLocalizations.of(context).empty;
  }

  bool get isWallSwitchButton => profile == PROFILE_YAN_BUTTON;

  bool get isSmartPlug => profile == PROFILE_SMART_PLUG;

  bool get isAwarenessSwitch => profile == PROFILE_PIR;

  bool get isDoorContact => profile == PROFILE_DOOR_CONTACT;

  bool get isCurtain => profile == PROFILE_WINDOW_CORVERING;

  bool get isSmartDial => profile == PROFILE_SMART_DIAL;

  bool get isIndoorUnit => profile == PROFILE_HA_ZHH_UNIT_MACHINE;

  bool get isZHHVRVGateway => profile == PROFILE_HA_ZHH_GATEWAY;
}
