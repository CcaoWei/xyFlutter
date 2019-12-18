part of data_shared;

class Entity {
  int baseType;
  String uuid;

  String name;

  String roomUuid;
  int rssi = -1;
  //bool isNew;

  //used for homekit
  String identifier;

  Map<int, Attribute> attributes = Map();

  Entity({
    this.baseType,
    @required this.uuid,
    this.roomUuid,
    this.name,
    this.identifier,
  });

  Entity.initLogicDevice(
      {@required this.uuid, @required this.roomUuid, this.name}) {
    baseType = BASE_TYPE_DEVICE;
  }

  Entity.initPhysicDevice({
    @required this.uuid,
    @required this.roomUuid,
    this.name,
    this.identifier,
  }) {
    baseType = BASE_TYPE_DEVICE;
  }

  Entity.initRoom({
    @required this.uuid,
    @required this.name,
    this.identifier,
  }) {
    baseType = BASE_TYPE_ROOM;
    roomUuid = uuid;
  }

  Entity.initBinding({@required this.uuid}) {
    baseType = BASE_TYPE_ACTION_GROUP;
  }

  Entity.initScene({@required this.uuid, @required this.name}) {
    baseType = BASE_TYPE_ACTION_GROUP;
  }

  Entity.initFirmware({@required this.uuid}) {
    baseType = BASE_TYPE_FIRMWARE;
  }

  Entity.initZigbeeSystem({@required this.uuid, this.name}) {
    baseType = BASE_TYPE_SYSTEM_DESCRIPTION;
  }

  Entity.initAutomation({@required this.uuid, this.name}) {
    baseType = BASE_TYPE_AUTOMATION;
  }

  Entity.initAutomationSet({@required this.uuid, this.name}) {
    baseType = BASE_TYPE_AUTOMATIONSET;
  }

  String getName() {
    if (name == null || name.isEmpty || name == "") {
      return uuid.substring(uuid.length - 6);
    }
    return name;
  }

  void setAttribute(int id, int value) {
    if (attributes.containsKey(id)) {
      final Attribute attribute = attributes[id];
      attribute.value = value;
    } else {
      final Attribute attribute = Attribute(id: id, value: value);
      attributes[id] = attribute;
    }
  }

  int getAttributeValue(int id) {
    // if(uuid == "000d6f000f94e99b-02"){
    //   print(uuid);
    //   print(id);
    //   for (var item in attributes.keys) {

    //   print("key"+"$item");
    //   print(attributes[item].value);
    // }
    // }

    if (attributes.containsKey(id)) {
      final Attribute attribute = attributes[id];
      return attribute.value;
    }
    return ATTRIBUTE_DEFAULT_VALUE;
  }

  bool containsUuid(String uuid) {
    if (this.uuid == uuid) return true;
    if (this is PhysicDevice) {
      final PhysicDevice pd = this as PhysicDevice;
      for (LogicDevice ld in pd.logicDevices) {
        if (ld.uuid == uuid) return true;
      }
    }
    return false;
  }

  bool get surpportTemperature =>
      attributes.containsKey(ATTRIBUTE_ID_TEMPERATURE);

  bool get isNew => getAttributeValue(ATTRIBUTE_ID_ENTITY_IS_NEW) == 1;

  int get onOffStatus => getAttributeValue(ATTRIBUTE_ID_ON_OFF_STATUS);

  int get alertLevel => getAttributeValue(ATTRIBUTE_ID_ALERT_LEVEL);

  int get occupancy => getAttributeValue(ATTRIBUTE_ID_OCCUPANCY);

  int get binaryInputStatus =>
      getAttributeValue(ATTRIBUTE_ID_BINARY_INPUT_STATUS);

  int get firmwareVersion {
    if (this is LogicDevice) {
      final LogicDevice ld = this as LogicDevice;
      if (ld.parent.isWallSwitch) {
        return ld.parent.getAttributeValue(ATTRIBUTE_ID_FIRMWARE_VERSION);
      } else {
        return ld.parent.getAttributeValue(ATTRIBUTE_ID_FIRMWARE_VERSION);
      }
    }
    return getAttributeValue(ATTRIBUTE_ID_FIRMWARE_VERSION);
  }

  int get activePower => getAttributeValue(ATTRIBUTE_ID_ACTIVE_POWER);

  int get insertExtractStatus =>
      getAttributeValue(ATTRIBUTE_ID_INSERT_EXTRACT_STATUS);

  int get batteryPercent => getAttributeValue(ATTRIBUTE_ID_BATTERY_PERCENT);

  int get temperature => getAttributeValue(ATTRIBUTE_ID_TEMPERATURE);

  int get luminance => getAttributeValue(ATTRIBUTE_ID_LUMINANCE);

  int get indicateLED => getAttributeValue(ATTRIBUTE_ID_CONFIG_INDICATOR_LED);

  int get disableRelay => getAttributeValue(ATTRIBUTE_ID_CONFIG_DISABLE_RELAY);

  int get enableKeepOnOffStatus =>
      getAttributeValue(ATTRIBUTE_ID_ENABLE_KEEP_ON_OFF_STATUS);

  int get currentPosition =>
      getAttributeValue(ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION);

  int get curtainType => getAttributeValue(ATTRIBUTE_ID_CURTAIN_TYPE);

  int get curtainDirection => getAttributeValue(ATTRIBUTE_ID_CURTAIN_DIRECTION);

  int get curtainConfigured =>
      getAttributeValue(ATTRIBUTE_ID_CURTAIN_TRIP_CONFIGURED);

  int get autoEnble => getAttributeValue(ATTRIBUTE_ID_AUTO_ENABLED);

  int get exclusiveOn => getAttributeValue(ATTRIBUTE_ID_CFG_MUTEXED_INDEX);

  int get smInputMode => getAttributeValue(ATTRIBUTE_ID_CFG_SW_INPUT_MODE);

  int get smPolarity => getAttributeValue(ATTRIBUTE_ID_CFG_SW_POLARITY);

  int get pureInput => getAttributeValue(ATTRIBUTE_ID_CFG_SW_PURE_INPUT);

  int get disabledRelayStatus =>
      getAttributeValue(ATTRIBUTE_ID_DISABLE_RELAY_STATUS);

  int get ledPolarity =>
      getAttributeValue(ATTRIBUTE_ID_CFG_BUTTON_LED_POLARITY);

  int get doorLockState => getAttributeValue(ATTRIBUTE_ID_DOOR_LOCK_STATE);
}
