part of homekit_shared;

class HomeManager {
  static final HomeManager _manager = HomeManager._internal();

  HomeManager._internal();

  factory HomeManager() {
    return _manager;
  }

  Home get primaryHome {
    for (var home in homes) {
      if (home.primary) {
        return home;
      }
    }
    return null;
  }

  final List<Home> _homes = List();
  List<Home> get homes => _homes;

  Home findHome(String identifier) {
    for (var home in homes) {
      if (home.identifier == identifier) {
        return home;
      }
    }
    return null;
  }
}
