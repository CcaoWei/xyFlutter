part of data_shared; //有几个家庭中心

const int HOME_CENTER_NEW = 0;
const int HOME_CENTER_CHANGED = 1; //default changed
const int HOME_CENTER_LOCAL_FOUND = 2;
const int HOME_CENTER_LOCAL_LOST = 3;
const int HOME_CENTER_UPDATE = 4;
const int HOME_CENTER_OFFLINE = 5;
const int HOME_CENTER_ONLINE = 6;

class HomeCenterManager {
  Log log = LogFactory().getLogger(Log.DEBUG, 'HomeCenterManager');

  static final HomeCenterManager _instance = HomeCenterManager._internal();

  factory HomeCenterManager() {
    return _instance;
  }

  HomeCenterManager._internal();

  Map<String, HomeCenterCache> _homeCenterCaches = Map();

  Map<String, HomeCenter> _homeCenters = Map();
  Map<String, HomeCenter> get homeCenters => _homeCenters;

  Map<String, HomeCenter> _localFoundHomeCenters = Map();
  List<HomeCenter> get localFoundHomeCenters {
    final List<HomeCenter> list = List();
    list.addAll(_localFoundHomeCenters.values);
    return list;
  }

  String _defaultHomeCenterUuid;
  String get defaultHomeCenterUuid => _defaultHomeCenterUuid;
  set defaultHomeCenterUuid(String defaultHomeCenterUuid) {
    //_defaultHomeCenterUuid = defaultHomeCenterUuid;
    if (_homeCenters.containsKey(defaultHomeCenterUuid)) {
      final HomeCenter homeCenter = _homeCenters[defaultHomeCenterUuid];
      if (homeCenter.state == ASSOCIATION_TYPE_BOTH) {
        _defaultHomeCenterUuid = defaultHomeCenterUuid;

        final HomeCenterEvent event =
            HomeCenterEvent(type: HOME_CENTER_CHANGED, homeCenter: homeCenter);
        RxBus().post(event);
      }
    }
  }

  void resetDefaultHomeCenterUuid() {
    for (HomeCenter homeCenter in _homeCenters.values) {
      if (homeCenter.state == ASSOCIATION_TYPE_BOTH) {
        defaultHomeCenterUuid = homeCenter.uuid;

        final HomeCenterEvent event =
            HomeCenterEvent(type: HOME_CENTER_CHANGED, homeCenter: homeCenter);
        RxBus().post(event);
      }
    }
  }

  HomeCenterCache getHomeCenterCache(String uuid) {
    if (_homeCenterCaches.containsKey(uuid)) {
      return _homeCenterCaches[uuid];
    }
    return null;
  }

  HomeCenter getHomeCenter(String uuid) {
    if (_homeCenters.containsKey(uuid)) {
      return _homeCenters[uuid];
    }
    return null;
  }

  HomeCenterCache get defaultHomeCenterCache {
    if (_defaultHomeCenterUuid == null ||
        _defaultHomeCenterUuid.isEmpty ||
        !_homeCenterCaches.containsKey(_defaultHomeCenterUuid)) {
      //_homeCenterCaches['box-98-84-e3-a4-2d-7b'] = new HomeCenterCache('box-98-84-e3-a4-2d-7b');
      return null;
    }
    //_defaultHomeCenterUuid = 'box-98-84-e3-a4-2d-7b';
    return _homeCenterCaches[_defaultHomeCenterUuid];
  }

  HomeCenter get defaultHomeCenter {
    if (_defaultHomeCenterUuid != null &&
        _homeCenters.containsKey(_defaultHomeCenterUuid)) {
      return _homeCenters[_defaultHomeCenterUuid];
    }
    return null;
  }

  void addHomeCenter(HomeCenter homeCenter) {
    if (!_homeCenters.containsKey(homeCenter.uuid)) {
      print('add a home center, uuid: ${homeCenter.uuid}');
      _homeCenters[homeCenter.uuid] = homeCenter;

      final HomeCenterCache homeCenterCache = HomeCenterCache(homeCenter.uuid);
      _homeCenterCaches[homeCenter.uuid] = homeCenterCache;

      if (_defaultHomeCenterUuid == null &&
          homeCenter.state == ASSOCIATION_TYPE_BOTH) {
        defaultHomeCenterUuid = homeCenter.uuid;
      }
      if (homeCenter.uuid == LoginManager().defaultHomeCenterUuid) {
        defaultHomeCenterUuid = homeCenter.uuid;
      }

      final HomeCenterEvent event =
          HomeCenterEvent(type: HOME_CENTER_NEW, homeCenter: homeCenter);
      RxBus().post(event);
    } else {
      final HomeCenter exist = _homeCenters[homeCenter.uuid];
      exist.state = homeCenter.state;

      if (homeCenter.state == ASSOCIATION_TYPE_BOTH &&
          _defaultHomeCenterUuid == null) {
        defaultHomeCenterUuid = homeCenter.uuid;
      }
      if (homeCenter.uuid == LoginManager().defaultHomeCenterUuid) {
        defaultHomeCenterUuid = homeCenter.uuid;
      }

      final HomeCenterEvent event = HomeCenterEvent(
        type: HOME_CENTER_UPDATE,
        homeCenter: homeCenter,
      );
      RxBus().post(event);
    }
  }

  void removeHomeCenter(String uuid) {
    if (_homeCenters.containsKey(uuid)) {
      _homeCenters.remove(uuid);
    }
    if (_homeCenterCaches.containsKey(uuid)) {
      _homeCenterCaches.remove(uuid);
    }
  }

  void addLocalFoundHomeCenter(HomeCenter homeCenter) {
    _localFoundHomeCenters[homeCenter.uuid] = homeCenter;
    if (!homeCenters.containsKey(homeCenter.uuid)) {
      _homeCenters[homeCenter.uuid] = homeCenter;

      final HomeCenterCache homeCenterCache = HomeCenterCache(homeCenter.uuid);
      _homeCenterCaches[homeCenter.uuid] = homeCenterCache;

      final HomeCenterEvent event = HomeCenterEvent(
        type: HOME_CENTER_LOCAL_FOUND,
        homeCenter: homeCenter,
      );
      RxBus().post(event);
    } else {
      final HomeCenter exist = homeCenters[homeCenter.uuid];
      exist.host = homeCenter.host;
      exist.name = homeCenter.name;

      final HomeCenterEvent event = HomeCenterEvent(
        type: HOME_CENTER_UPDATE,
        homeCenter: homeCenter,
      );
      RxBus().post(event);
    }
  }

  void start() {
    RxBus()
        .toObservable()
        .where((event) => event is LocalServiceEvent)
        .listen((event) {
      if (event is LocalServiceFoundEvent) {
        processLocalServiceFound(event);
      } else if (event is LocalServiceLostEvent) {
        processLocalServiceLost(event);
      }
    });
  }

  void processLocalServiceFound(LocalServiceFoundEvent event) {
    addLocalFoundHomeCenter(event.homeCenter);
  }

  void processLocalServiceLost(LocalServiceLostEvent event) {
    if (_localFoundHomeCenters.containsKey(event.uuid)) {
      final HomeCenter homeCente = _localFoundHomeCenters.remove(event.uuid);

      final HomeCenterEvent evt = HomeCenterEvent(
        type: HOME_CENTER_LOCAL_LOST,
        homeCenter: homeCente,
      );
      RxBus().post(evt);
    }
  }

  void processPresence(PresenceEvent presence) {
    final String uuid = presence.username;
    final String name = presence.name;
    final String resource = presence.resource;
    final bool online = presence.online;

    log.d('presence event -> uuid: $uuid  ****  online: $online',
        'processPresence');

    HomeCenter homeCenter;
    if (_homeCenters.containsKey(uuid)) {
      homeCenter = _homeCenters[uuid];
      final oldStatus = homeCenter.online;
      if (name.length > 0) homeCenter.name = name;
      homeCenter.online = online;
      homeCenter.state = ASSOCIATION_TYPE_BOTH;

      if (oldStatus && !online) {
        log.d('homecenter state change to offline', 'processPresence');
        final HomeCenterEvent evt = HomeCenterEvent(
          type: HOME_CENTER_OFFLINE,
          homeCenter: homeCenter,
        );
        RxBus().post(evt);
      }
      if (!oldStatus && online) {
        log.d('homecenter state change to online', 'processPresence');
        final HomeCenterEvent evt = HomeCenterEvent(
          type: HOME_CENTER_ONLINE,
          homeCenter: homeCenter,
        );
        RxBus().post(evt);
      }
    } else {
      log.d('homecenter state does not change', 'processPresence');
      homeCenter = HomeCenter(uuid: uuid, name: name);
      homeCenter.online = online;
      addHomeCenter(homeCenter);
    }
    if (online) {
      print('Get entities: ${homeCenter.uuid}');
      homeCenter.state = ASSOCIATION_TYPE_BOTH;
      _homeCenterCaches[uuid].getEntities();
    } else {
      _homeCenterCaches[uuid].goOffline();
    }
  }

  int get numberOfAddedHomeCenter {
    int count = 0;
    for (var homeCenter in _homeCenters.values) {
      if (homeCenter.state == ASSOCIATION_TYPE_BOTH) {
        count++;
      }
    }
    return count;
  }

  void clear() {
    for (var cache in _homeCenterCaches.values) {
      cache.clear();
    }
    _homeCenterCaches.clear();
    _homeCenters.clear();
    _defaultHomeCenterUuid = null;
    // _localFoundHomeCenters.clear();
  }

  void logout() {
    clear();

    // for (HomeCenter homeCenter in localFoundHomeCenters) {
    //   homeCenter.state = ASSOCIATION_TYPE_NONE;
    //   addHomeCenter(homeCenter);
    // }
  }
}

class HomeCenterEvent {
  int type;
  HomeCenter homeCenter;

  HomeCenterEvent({this.type, this.homeCenter});
}
