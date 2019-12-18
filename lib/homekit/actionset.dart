part of homekit_shared;

const String SCENE_WAKE_UP = 'wakeUp';
const String SCENE_HOME_DEPARTURE = 'homeDeparture';
const String SCENE_HOME_ARRIVAL = 'homeArrival';
const String SCENE_SLEEP = 'sleep';
const String SCENE_USER_DEFINED = 'userDefined';

class ActionSet {
  String name;
  final String type;

  final String identifier;
  final String homeIdentifier;

  final Set<xyAction> _actions = Set();
  Set<xyAction> get actions => _actions;

  ActionSet(this.name, this.type, this.identifier, this.homeIdentifier);

  ActionSet.fromMap(Map map)
      : name = map['name'],
        type = map['actionSetType'],
        identifier = map['identifier'],
        homeIdentifier = map['homeIdentifier'];

  xyAction findAction(String identifier) {
    for (var action in _actions) {
      if (action.identifier == identifier) {
        return action;
      }
    }
    return null;
  }

  bool get isOn {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home == null) return false;
    if (home.accessories.length == 0) return false;
    if (actions.length == 0) return false;
    for (xyAction action in actions) {
      if (action.characteristic == null) {
        continue;
      }
      if (action.characteristic.type == C_ON_OFF) {
        int value = 0;
        if (action.characteristic.value is bool)
          value = action.characteristic.value ? 1 : 0;
        else
          value = action.characteristic.value;
        int targetValue = 0;
        if (action.targetValue is bool)
          targetValue = action.targetValue ? 1 : 0;
        if (action.targetValue is int) targetValue = action.targetValue;
        if (targetValue != value) return false;
      } else if (action.characteristic.type == C_TARGET_POSITION) {
        //TODO: may need fix
        final Home home =
            HomeManager().findHome(action.characteristic.homeIdentifier);
        if (home == null) return false;
        final Accessory accessory =
            home.findAccessory(action.characteristic.accessoryIdentifier);
        if (accessory == null) return false;
        final Service service =
            accessory.findService(action.characteristic.serviceIdentifier);
        if (service == null) return false;
        final Characteristic characteristic =
            service.findCharacteristicByType(C_CURRENT_POSITION);
        if (characteristic.value == null) return false;
        final int value = characteristic.value;
        //final int value = action.characteristic.value;
        int targetValue = 0;
        var tv = action.targetValue;
        if (action.targetValue is int) {
          targetValue = action.targetValue;
        } else if (tv is double) {
          targetValue = tv.toInt();
        } else if (tv is bool) {
          targetValue = tv ? 1 : 0;
        } else {
          print("unsupported target value type");
        }
        if (targetValue != value) return false;
      } else {
        print('unsupport action characteristic type');
      }
    }
    return true;
  }

  bool isActionInActionSet(String characteristicIdentifier) {
    if (actions.length == 0) return false;
    for (xyAction action in actions) {
      if (action.characteristic == null) continue;
      if (action.characteristic.identifier == characteristicIdentifier)
        return true;
    }
    return false;
  }

  xyAction findActionByCharacteristicIdentifier(
      String characteristicIdentifier) {
    if (actions.length == 0) return null;
    for (xyAction action in actions) {
      if (action.characteristic == null) continue;
      if (action.characteristic.identifier == characteristicIdentifier)
        return action;
    }
    return null;
  }

  void update(String name) {
    this.name = name;
  }

  void removeAction(String actionIdentifier) {
    for (xyAction action in _actions) {
      if (action.identifier == actionIdentifier) {
        _actions.remove(action);
        return;
      }
    }
  }
}
