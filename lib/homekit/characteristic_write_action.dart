part of homekit_shared;

class CharacteristicWriteAction {
  Characteristic characteristic;
  var targetValue;

  final String characteristicIdentifier;
  final String serviceIdentifier;
  final String accessoryIdentifier;
  final String actionIdentifier;
  final String actionSetIdentifier;
  final String homeIdentifier;

  CharacteristicWriteAction.fromMap(Map map)
      : targetValue = map['targetValue'],
        characteristicIdentifier = map['characteristicIdentifier'],
        serviceIdentifier = map['serviceIdentifier'],
        accessoryIdentifier = map['accessoryIdentifier'],
        actionIdentifier = map['actionIdentifier'],
        actionSetIdentifier = map['actionSetIdentifier'],
        homeIdentifier = map['homeIdentifier'];
}
