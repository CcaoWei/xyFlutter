part of homekit_shared;

class Characteristic {
  final int type;
  var value;

  bool supportNotification;
  bool isNotificationEnabled;

  final String identifier;
  final String serviceIdentifier;
  final String accessoryIdentifier;
  final String homeIdentifier;

  Characteristic.fromMap(Map map)
      : type = map['characteristicType'],
        value = map['value'],
        isNotificationEnabled = map['isNotificationEnabled'],
        identifier = map['identifier'],
        serviceIdentifier = map['serviceIdentifier'],
        accessoryIdentifier = map['accessoryIdentifier'],
        homeIdentifier = map['homeIdentifier'],
        supportNotification = map['supportNotification'];

  void update(value) {
    this.value = value;
  }
}
