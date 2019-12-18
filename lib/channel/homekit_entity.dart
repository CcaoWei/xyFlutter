class HomekitAccessory {
  final String identifier;
  final String roomIdentifier;
  final bool available;
  final bool isBridged;

  final String name;
  final String manufacturer;
  final String model;
  final String serialNumber;
  final String firmwareVersion;
  final String hardwareVersion;

  final String serviceName;
  final int onOff;
  final bool plugBeingUsed;
  final int activePower;

  final double temperature;
  final int lowBattery;
  final double lightLevel;
  final int openClose;

  final String newVersion;

  final int targetPosition;
  final int currentPosition;
  final int currentState;

  final int type;
  final int direction;
  final int tripLearned;
  final int adjustTrip;

  final int leftOccupancy;
  final int rightOccupancy;

  final String serviceName01;
  final int type01;
  final int onOff01;

  final String serviceName02;
  final int type02;
  final int onOff02;

  final String serviceName03;
  final int type03;
  final int onOff03;

  final String serviceName04;
  final int type04;
  final int onOff04;

  HomekitAccessory.fromMap(Map map)
      : identifier = map['identifier'],
        roomIdentifier = map['roomIdentifier'],
        available = map['available'],
        isBridged = map['isBridged'],
        name = map['name'],
        manufacturer = map['manufacturer'],
        model = map['model'],
        serialNumber = map['serialNumber'],
        firmwareVersion = map['firmwareVersion'],
        hardwareVersion = map['hardwareVersion'],
        serviceName = map['serviceName'],
        onOff = map['onOff'],
        plugBeingUsed = map['plugBeingUsed'],
        activePower = map['activePower'],
        temperature = map['temperature'],
        lowBattery = map['lowBattery'],
        lightLevel = map['lightLevel'],
        openClose = map['openClose'],
        newVersion = map['newVersion'],
        targetPosition = map['targetPosition'],
        currentPosition = map['currentPosition'],
        currentState = map['currentState'],
        type = map['type'],
        direction = map['direction'],
        tripLearned = map['tripLeared'],
        adjustTrip = map['adjustTrip'],
        leftOccupancy = map['leftOccupancy'],
        rightOccupancy = map['rightOccupancy'],
        serviceName01 = map['serviceName01'],
        type01 = map['type01'],
        onOff01 = map['onOff01'],
        serviceName02 = map['serviceName02'],
        type02 = map['type02'],
        onOff02 = map['onOff02'],
        serviceName03 = map['serviceName03'],
        type03 = map['type03'],
        onOff03 = map['onOff03'],
        serviceName04 = map['serviceName04'],
        type04 = map['type04'],
        onOff04 = map['onOff04'];
}

class HomekitRoom {
  final String name;
  final String identifier;

  HomekitRoom.fromMap(Map map)
      : name = map['name'],
        identifier = map['identifier'];
}

class HomekitActionSet {
  String name;
  String identifier;
  String type;

  final List<String> actions = List();

  HomekitActionSet.fromMap(Map map) {
    name = map['name'];
    identifier = map['identifier'];
    type = map['type'];

    final int actionNumber = map['actionNumber'];
    for (var i = 0; i < actionNumber; i++) {
      final String key = 'action' + i.toString();
      final actionIdentifier = map[key];
      actions.add(actionIdentifier);
    }
  }
}
