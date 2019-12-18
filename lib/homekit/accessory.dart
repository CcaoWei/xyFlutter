part of homekit_shared;

class Accessory {
  String name;
  final bool isBridged;
  bool available = false;
  bool updating = true;

  final String identifier;
  String roomIdentifier;
  final String homeIdentifier;

  final List<Service> _services = List();
  List<Service> get services => _services;

  String firmwareVersion;
  String model;
  String manufacturer;

  Accessory.fromMap(Map map)
      : name = map['name'],
        isBridged = map['isBridged'],
        available = map['available'],
        updating = map['updating'],
        identifier = map['identifier'],
        roomIdentifier = map['roomIdentifier'],
        homeIdentifier = map['homeIdentifier'] {}

  Accessory.fromMap2(Map map)
      : name = map['name'],
        isBridged = map['isBridged'],
        available = map['available'],
        updating = map['updating'],
        identifier = map['identifier'],
        roomIdentifier = map['roomIdentifier'],
        homeIdentifier = map['homeIdentifier'],
        firmwareVersion = map['firmwareVersion'],
        manufacturer = map['manufacturer'],
        model = map['model'] {
    if (model == DEVICE_MODEL_SMART_LOCK) available = true;
  }

  Service findService(String identifier) {
    for (var service in _services) {
      if (service.identifier == identifier) {
        return service;
      }
    }
    return null;
  }

  Service findServiceByType(int serviceType) {
    for (var service in _services) {
      if (service.type == serviceType) {
        return service;
      }
    }
    return null;
  }

  bool get isOnOff {
    if (isLightSocket) {
      final Service light = findServiceByType(S_LIGHT_SOCKET);
      if (light == null) return false;
      final Characteristic onOff = light.findCharacteristicByType(C_ON_OFF);
      if (onOff == null) return false;
      return onOff.value == 1;
    } else if (isSmartDoorLock) {
      final Service lock = findServiceByType(S_LOCK_MECHANISM);
      if (lock == null) return false;
      final Characteristic onOff =
          lock.findCharacteristicByType(C_LOCK_CURRENT_STATE);
      if (onOff == null) return false;
      return onOff.value == 1;
    } else if (isSmartPlug) {
      final Service plug = findServiceByType(S_PLUG);
      if (plug == null) return false;
      final Characteristic onOff = plug.findCharacteristicByType(C_ON_OFF);
      if (onOff == null) return false;
      return onOff.value == 1;
    } else if (isCurtain) {
      final Service curtain = findServiceByType(S_CURTAIN);
      if (curtain == null) return false;
      final Characteristic currentPostion =
          curtain.findCharacteristicByType(C_CURRENT_POSITION);
      if (currentPostion == null) return false;
      return currentPostion.value > 10;
    } else {
      return false;
    }
  }

  bool get isLightSocket => model == DEVICE_MODEL_LIGHT_SOCKET;

  bool get isSmartPlug => model == DEVICE_MODEL_SMART_PLUG;

  bool get isCurtain => model == DEVICE_MODEL_CURTAIN;

  bool get isAwarenessSwitch => model == DEVICE_MODEL_AWARENESS_SWITCH;

  bool get isDoorSensor => model == DEVICE_MODEL_DOOR_SENSOR;

  bool get isWallSwitch =>
      model == DEVICE_MODEL_WALL_SWITCH_D1 ||
      model == DEVICE_MODEL_WALL_SWITCH_D2 ||
      model == DEVICE_MODEL_WALL_SWITCH_D3 ||
      model == DEVICE_MODEL_WALL_SWITCH_D4 ||
      model == DEVICE_MODEL_WALL_SWITCH_S1 ||
      model == DEVICE_MODEL_WALL_SWITCH_S2 ||
      model == DEVICE_MODEL_WALL_SWITCH_S3 ||
      model == DEVICE_MODEL_WALL_SWITCH_S4;

  bool get isWallSwitchUS => model == DEVICE_MODEL_WALL_SWITCH_US1;

  bool get isSmartDial => model == DEVICE_MODEL_SMART_DIAL;

  bool get isSwitchModule =>
      model == DEVICE_MODEL_SWITCH_MODULE_D1 ||
      model == DEVICE_MODEL_SWITCH_MODULE_D2 ||
      model == DEVICE_MODEL_SWITCH_MODULE_D3 ||
      model == DEVICE_MODEL_SWITCH_MODULE_D4 ||
      model == DEVICE_MODEL_SWITCH_MODULE_S1 ||
      model == DEVICE_MODEL_SWITCH_MODULE_S2 ||
      model == DEVICE_MODEL_SWITCH_MODULE_S3 ||
      model == DEVICE_MODEL_SWITCH_MODULE_S4;

  bool get isSmartDoorLock => model == DEVICE_MODEL_SMART_LOCK;

  bool get isHomeCenter => model == DEVICE_MODEL_HOME_CENTER;

  bool get isDelete {
    final Service service = findServiceByType(S_DELETE);
    if (service == null) return false;
    final Characteristic characteristic =
        service.findCharacteristicByType(C_DELETE);
    if (characteristic == null) return false;
    if (characteristic.value == -1) return false;
    return characteristic.value ?? false;
  }

  String getTypeLocalDes(BuildContext context) {
    if (isLightSocket) {
      return DefinedLocalizations.of(context).lightSocket;
    } else if (isSmartPlug) {
      return DefinedLocalizations.of(context).smartPlug;
    } else if (isAwarenessSwitch) {
      return DefinedLocalizations.of(context).awarenessSwitch;
    } else if (isDoorSensor) {
      return DefinedLocalizations.of(context).doorContact;
    } else if (isCurtain) {
      return DefinedLocalizations.of(context).smartCurtain;
    } else if (isWallSwitch || isWallSwitchUS) {
      return DefinedLocalizations.of(context).wallSwitch;
    } else if (isHomeCenter) {
      return DefinedLocalizations.of(context).homeCenter;
    } else if (isSmartDial) {
      return DefinedLocalizations.of(context).smartDial;
    } else if (isSwitchModule) {
      return DefinedLocalizations.of(context).switchModule;
    } else if (isSmartDoorLock) {
      return DefinedLocalizations.of(context).smartDoorLock;
    }
    return null;
  }

  void update(String name, bool available, bool updating) {
    this.name = name;
    this.available = available;
    this.updating = updating;
  }

  static int getVersionNumber(String versionString) {
    if (versionString == null) {
      versionString = "0.0.0";
    }
    final List<String> strs = versionString.split('.');
    if (strs.length < 3) return 0;
    String newString = strs[0];
    if (int.parse(strs[1]) < 10) {
      newString += '0';
    }
    newString += strs[1];
    if (int.parse(strs[2]) < 10) {
      newString += '0';
    }
    newString += strs[2];
    return int.parse(newString);
  }
}
