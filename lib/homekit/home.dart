part of homekit_shared;

class Home {
  String name;
  final String identifier;

  bool primary;

  final List<Accessory> _accessories = List();
  List<Accessory> get accessories => _accessories;

  final List<ActionSet> _actionSets = List();
  List<ActionSet> get actionSets => _actionSets;

  final List<Room> _rooms = List();
  List<Room> get rooms => _rooms;

  Home(this.name, this.identifier);

  Home.fromMap(Map map)
      : name = map['name'],
        identifier = map['identifier'],
        primary = map['primary'];

  Accessory findAccessory(String identifier) {
    for (var accessory in _accessories) {
      if (accessory.identifier == identifier) {
        return accessory;
      }
    }
    return null;
  }

  ActionSet findActionSet(String identifier) {
    for (var actionSet in _actionSets) {
      if (actionSet.identifier == identifier) {
        return actionSet;
      }
    }
    return null;
  }

  Room findRoom(String identifier) {
    for (var room in _rooms) {
      if (room.identifier == identifier) {
        return room;
      }
    }
    return null;
  }

  void update(String name) {
    this.name = name;
  }
}
