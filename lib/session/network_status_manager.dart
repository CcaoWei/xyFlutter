import 'package:xlive/rxbus/rxbus.dart';

import 'package:connectivity/connectivity.dart';

import 'dart:async';

//断网的问题
const int NETWORK_TYPE_NONE = 0;
const int NETWORK_TYPE_WIFI = 1;
const int NETWORK_TYPE_MOBILE = 2;

class NetworkStatusManager {
  static final NetworkStatusManager _manager = NetworkStatusManager._internal();

  NetworkStatusManager._internal();

  factory NetworkStatusManager() => _manager;

  final Connectivity connectivity = Connectivity();

  StreamSubscription subscription;

  int _networkType;

  void start() {
    connectivity.checkConnectivity().then((result) {
      if (result == ConnectivityResult.none) {
        _networkType = NETWORK_TYPE_NONE;
      } else if (result == ConnectivityResult.mobile) {
        _networkType = NETWORK_TYPE_MOBILE;
      } else if (result == ConnectivityResult.wifi) {
        _networkType = NETWORK_TYPE_WIFI;
      }
    });

    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        _networkType = NETWORK_TYPE_MOBILE;
      } else if (result == ConnectivityResult.wifi) {
        _networkType = NETWORK_TYPE_WIFI;
      } else if (result == ConnectivityResult.none) {
        _networkType = NETWORK_TYPE_NONE;
      }
      final NetworkStatusChangedEvent event = NetworkStatusChangedEvent(
        networkType: _networkType,
      );
      RxBus().post(event);
    });
  }

  void stop() {
    if (subscription != null) {
      subscription.cancel();
    }
  }
}

class NetworkStatusChangedEvent {
  final int networkType;

  NetworkStatusChangedEvent({
    this.networkType,
  });
}
