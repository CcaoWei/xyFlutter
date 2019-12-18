part of homekit_shared;

class Service {
  final int type;
  String name;

  final String identifier;
  final String accessoryIdentifier;
  final String homeIdentifier;

  final List<Characteristic> _characteristics = List();
  List<Characteristic> get characteristics => _characteristics;

  Service.fromMap(Map map)
      : type = map['serviceType'],
        name = map['name'],
        identifier = map['identifier'],
        accessoryIdentifier = map['accessoryIdentifier'],
        homeIdentifier = map['homeIdentifier'];

  Characteristic findCharacteristic(String identifier) {
    for (var characteristic in _characteristics) {
      if (characteristic.identifier == identifier) {
        return characteristic;
      }
    }
    return null;
  }

  Characteristic findCharacteristicByType(int characteristicType) {
    for (var characteristic in _characteristics) {
      if (characteristic.type == characteristicType) {
        return characteristic;
      }
    }
    return null;
  }

  void update(String name) {
    this.name = name;
  }
}
