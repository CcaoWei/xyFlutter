part of homekit_shared;

class Room {
  String name;

  final String identifier;
  final String homeIdentifier;

  Room(this.name, this.identifier, this.homeIdentifier);

  Room.fromMap(Map map)
      : name = map['name'],
        identifier = map['identifier'],
        homeIdentifier = map['homeIdentifier'];

  void update(String name) {
    this.name = name;
  }
}
