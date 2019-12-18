part of homekit_shared;

class xyAction {
  Characteristic characteristic;
  var targetValue;

  final String identifier;
  final String actionSetIdentifier;
  final String homeIdentifier;

  xyAction.fromMap(Map map)
      : identifier = map['identifier'],
        actionSetIdentifier = map['actionSetIdentifier'],
        homeIdentifier = map['homeIdentifier'];

  void update(Characteristic characteristic, targetValue) {
    this.characteristic = characteristic;
    this.targetValue = targetValue;
  }

  bool get isButtonChecked {
    if (characteristic.type == C_ON_OFF) {
      return targetValue == 1;
    } else if (characteristic.type == C_TARGET_POSITION) {
      return targetValue == 100;
    }
    return false;
  }
}
