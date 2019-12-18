import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:xlive/const/const_shared.dart';
import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/channel/event_channel.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'homekit_entity.dart';
import 'wechat_response.dart';

StreamController<WechatAuthResponse> _responseAuthController =
    StreamController.broadcast();
Stream<WechatAuthResponse> get responseFromAuth =>
    _responseAuthController.stream;

StreamController<HomekitAccessory> _homekitEntityController =
    StreamController.broadcast();
Stream<HomekitAccessory> get entityFromHomekit =>
    _homekitEntityController.stream;

final MethodChannel _methodChannel =
    MethodChannel('io.xiaoyan.xlive/method_channel')
      ..setMethodCallHandler(_methodHandler);

Future<dynamic> _methodHandler(MethodCall methodCall) {
  if ('onAuthResponse' == methodCall.method) {
    _responseAuthController
        .add(WechatAuthResponse.fromMap(methodCall.arguments));
  } else if ('onEntityIncoming' == methodCall.method) {
    if (methodCall.arguments == null) {
      _homekitEntityController.close();
    } else {
      _homekitEntityController
          .add(HomekitAccessory.fromMap(methodCall.arguments));
    }
  }
  return Future.value(true);
}

Future isWechatInstalled() async {
  return await _methodChannel.invokeMethod('isWechatInstalled');
}

Future registerWechat(
    {String appId,
    bool doOnIOS: true,
    doOnAndroid: true,
    enableMTA: false}) async {
  return await _methodChannel.invokeMethod('registerWechat', {
    'appId': appId,
    'iOS': doOnIOS,
    'android': doOnAndroid,
    'enableMTA': enableMTA
  });
}

Future wechatLogin(
    {String openId, @required String scope, String state}) async {
  assert(scope != null && scope.trim().isNotEmpty);
  return await _methodChannel.invokeMethod(
      'wechatLogin', {'scope': scope, 'state': state, 'openId': openId});
}

Future isQQInstalled() async {
  return await _methodChannel.invokeMethod('isQQInstalled');
}

Future registerQQ() async {
  final Map args = Map();
  args['appId'] = APP_ID_QQ;
  return await _methodChannel.invokeMethod('registerQQ', args);
}

Future qqLogin() async {
  return await _methodChannel.invokeMethod('qqLogin', Map());
}

Future getPlatform() async {
  return await _methodChannel.invokeMethod('getPlatform', Map());
}

Future getClientType() async {
  return await _methodChannel.invokeMethod('getClientType', Map());
}

Future getClientId() async {
  return await _methodChannel.invokeMethod('getClientId', Map());
}

//获取App版本号
Future getSystemVersion() async {
  return await _methodChannel.invokeMethod('getSystemVersion', Map());
}

Future getAppVersion() async {
  return await _methodChannel.invokeMethod('getAppVersion', Map());
}

Future getHttpAgent() async {
  return await _methodChannel.invokeMethod('getHttpAgent', Map());
}

Future scanQRCode(Map map) async {
  return await _methodChannel.invokeMethod('scanQRCode', map);
}

//map should contains 'url', 'title', 'description', 'appName'
Future downloadApk(Map map) async {
  return await _methodChannel.invokeMethod('downloadApk', map);
}

void dispose(
    {shareResponse: true,
    authResponse: true,
    paymentResponse: true,
    launchMiniProgramResponse: true}) {
  if (authResponse) {
    _responseAuthController.close();
  }
}

//启动本地发现服务
void scanLocalService() async {
  return await _methodChannel.invokeMethod('scanLocalService', Map());
}

//获取通过本地发现的家庭中心
void getFoundedServices() async {
  return await _methodChannel.invokeMethod('getFoundLocalServices', Map());
}

//Homekit
Future getEntities() async {
  print('call get entitiy via method channel');
  //TODO:
  //HomeManager().homes.clear();
  var result = await _methodChannel.invokeMethod('getEntities', Map());
  if (result) {
    RxBus().post(HomekitEntityIncomingCompleteEvent());
  }
  return Future.value(result);
}

//获取某个家庭下所有的设备场景等信息
Future getHomeEntities(String homeIdentifier) async {
  print('get home entities');
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  var result = await _methodChannel.invokeMethod('getHomeEntities', map);
  if (result) {
    RxBus().post(HomekitEntityIncomingCompleteEvent());
  }
  return Future.value(result);
}

//获取某个设备信息
Future getAccessory(String homeIdentifier, String accessoryIdentifier) async {
  print('get accessory');
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['accessoryIdentifier'] = accessoryIdentifier;
  var result = await _methodChannel.invokeMethod('getAccessory', map);
  if (result) {
    RxBus().post(HomekitEntityIncomingCompleteEvent());
  }
  return Future.value(result);
}

//Homekit - HomeManager
//设置默认家庭
Future updatePrimaryHome(String identifier) async {
  final Map map = Map();
  map['identifier'] = identifier;
  var response = await _methodChannel.invokeMethod('updatePrimaryHome', map);
  final int code = response['code'];
  if (code == 0) {
    final List<Home> homes = HomeManager().homes;
    for (var home in homes) {
      if (home.identifier == identifier) {
        home.primary = true;
      } else {
        home.primary = false;
      }
    }
    RxBus().post(PrimaryHomeUpdatedEvent(
      primaryHomeIdentifier: identifier,
    ));
  }
  return Future.value(response);
}

//添加家庭
Future addHome(String name) async {
  final Map map = Map();
  map['name'] = name;
  var response = await _methodChannel.invokeMethod('addHome', map);
  final int code = response['code'];
  if (code == 0) {
    getEntities();
  }
  return Future.value(response);
}

//删除家庭
Future removeHome(String identifier) async {
  final Map map = Map();
  map['identifier'] = identifier;
  var response = await _methodChannel.invokeMethod('removeHome', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(identifier);
    if (home != null) {
      HomeManager().homes.remove(home);
    }
  }
  return Future.value(response);
}

//Homekit - Home
//更改家庭名称
Future updateHomeName(String homeIdentifier, String name) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['name'] = name;
  var response = await _methodChannel.invokeMethod('updateHomeName', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      home.name = name;
    }
  }
  return Future.value(response);
}

//删除设备
Future removeAccessory(
    String homeIdentifier, String accessoryIdentifier) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['accessoryIdentifier'] = accessoryIdentifier;
  var response = await _methodChannel.invokeMethod('removeAccessory', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      final Accessory accessory = home.findAccessory(accessoryIdentifier);
      if (accessory != null) {
        if (accessory.model == DEVICE_MODEL_HOME_CENTER) {
          home.accessories.clear();
        } else {
          home.accessories.remove(accessory);
        }
      }
    }
  }
  return Future.value(response);
}

//修改房间
Future updateAccessoryRoom(String homeIdentifier, String accessoryIdentifier,
    String roomIdentifier) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['accessoryIdentifier'] = accessoryIdentifier;
  map['roomIdentifier'] = roomIdentifier;
  var response = await _methodChannel.invokeMethod('updateAccessoryRoom', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      final Accessory accessory = home.findAccessory(accessoryIdentifier);
      if (accessory != null) {
        accessory.roomIdentifier = roomIdentifier;
      }
    }
  }
  return Future.value(response);
}

//添加房间
Future addRoom(String homeIdentifier, String name) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['name'] = name;
  var response = await _methodChannel.invokeMethod('addRoom', map);
  final int code = response['code'];
  if (code == 0) {
    getEntities();
  }
  return Future.value(response);
}

//删除房间
Future removeRoom(String homeIdentifier, String roomIdentifier) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['roomIdentifier'] = roomIdentifier;
  var response = await _methodChannel.invokeMethod('removeRoom', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      final Room room = home.findRoom(roomIdentifier);
      if (room != null) {
        home.rooms.remove(room);
      }
    }
  }
  return Future.value(response);
}

//修改房间名称
Future updateRoomName(
    String homeIdentifier, String roomIdentifier, String newName) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['roomIdentifier'] = roomIdentifier;
  map['name'] = newName;
  var response = await _methodChannel.invokeMethod('updateRoomName', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      final Room room = home.findRoom(roomIdentifier);
      if (room != null) {
        room.name = newName;
      }
    }
  }
  return Future.value(response);
}

//添加场景
Future addActionSet(String homeIdentifier, String name) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['name'] = name;
  var response = await _methodChannel.invokeMethod('addActionSet', map);
  final int code = response['code'];
  if (code == 0) {
    getHomeEntities(homeIdentifier);
  }
  return Future.value(response);
}

//删除场景
Future removeActionSet(
    String homeIdentifier, String actionSetIdentifier) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['actionSetIdentifier'] = actionSetIdentifier;
  var response = await _methodChannel.invokeMethod('removeActionSet', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      final ActionSet actionSet = home.findActionSet(actionSetIdentifier);
      if (actionSet != null) {
        home.actionSets.remove(actionSet);
      }
    }
  }
  return Future.value(response);
}

//执行场景
Future excuteActionSet(
    String homeIdentifier, String actionSetIdentifier) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['actionSetIdentifier'] = actionSetIdentifier;
  var response = await _methodChannel.invokeMethod('excuteActionSet', map);
  //TODO:
  return Future.value(response);
}

Future addHomeCenter(String homeIdentifier) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  return await _methodChannel.invokeMethod('addHomeCenter', map);
}

//调起Homekit用户管理页面
Future manageUsers(String homeIdentifier) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  return await _methodChannel.invokeMethod('managerUsers', map);
}

// Homekit - Accessory
//更改设备名称
Future updateAccessoryName(
    String homeIdentifier, String accessoryIdentifier, String name) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['accessoryIdentifier'] = accessoryIdentifier;
  map['name'] = name;
  var response = await _methodChannel.invokeMethod('updateAccessoryName', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      final Accessory accessory = home.findAccessory(accessoryIdentifier);
      if (accessory != null) {
        accessory.name = name;
      }
    }
  }
  return Future.value(response);
}

// Homekit - Service
// 更改Service名称
Future updateServiceName(String homeIdentifier, String accessoryIdentifier,
    String serviceIdentifier, String name) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['accessoryIdentifier'] = accessoryIdentifier;
  map['serviceIdentifier'] = serviceIdentifier;
  map['name'] = name;
  var response = await _methodChannel.invokeMethod('updateServiceName', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      final Accessory accessory = home.findAccessory(accessoryIdentifier);
      if (accessory != null) {
        final Service service = accessory.findService(serviceIdentifier);
        if (service != null) {
          service.name = name;
        }
      }
    }
  }
  return Future.value(response);
}

// Homekit - Characteristic
// set authorization data
Future setAuthorizationData(String homeIdentifier, String accessoryIdentifier,
    String serviceIdentifier, String characteristicIdentifier, value) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['accessoryIdentifier'] = accessoryIdentifier;
  map['serviceIdentifier'] = serviceIdentifier;
  map['characteristicIdentifier'] = characteristicIdentifier;
  map['value'] = value;
  var response = await _methodChannel.invokeMethod('setAuthorizationData', map);
  print("setAuthorizationData response : ${response}, \n ${map}");
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      final Accessory accessory = home.findAccessory(accessoryIdentifier);
      if (accessory != null) {
        final Service service = accessory.findService(serviceIdentifier);
        if (service != null) {
          final Characteristic characteristic =
              service.findCharacteristic(characteristicIdentifier);
        }
      }
    }
  }
  return Future.value(response);
}

// Homekit - Characteristic
// 写
Future writeValue(String homeIdentifier, String accessoryIdentifier,
    String serviceIdentifier, String characteristicIdentifier, value) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['accessoryIdentifier'] = accessoryIdentifier;
  map['serviceIdentifier'] = serviceIdentifier;
  map['characteristicIdentifier'] = characteristicIdentifier;
  map['value'] = value;
  var response = await _methodChannel.invokeMethod('writeValue', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      final Accessory accessory = home.findAccessory(accessoryIdentifier);
      if (accessory != null) {
        final Service service = accessory.findService(serviceIdentifier);
        if (service != null) {
          final Characteristic characteristic =
              service.findCharacteristic(characteristicIdentifier);
          if (characteristic != null) {
            characteristic.value = value;

            if (characteristic.type == C_DELETE) {
              home.accessories.remove(accessory);
            }
          }
        }
      }
    }
  }
  return Future.value(response);
}

// 读
Future readValue(String homeIdentifier, String accessoryIdentifier,
    String serviceIdentifier, String characteristicIdentifier) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['accessoryIdentifier'] = accessoryIdentifier;
  map['serviceIdentifier'] = serviceIdentifier;
  map['characteristicIdentifier'] = characteristicIdentifier;
  return await _methodChannel.invokeMethod('readValue', map);
}

// 设置是否接收事件消息
Future enableNotification(
    String homeIdentifier,
    String accessoryIdentifier,
    String serviceIdentifier,
    String characteristicIdentifier,
    bool enable) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['accessoryIdentifier'] = accessoryIdentifier;
  map['serviceIdentifier'] = serviceIdentifier;
  map['characteristicIdentifer'] = characteristicIdentifier;
  map['enable'] = enable;
  var response = await _methodChannel.invokeMethod('enableNotification', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      final Accessory accessory = home.findAccessory(accessoryIdentifier);
      if (accessory != null) {
        final Service service = accessory.findService(serviceIdentifier);
        if (service != null) {
          final Characteristic characteristic =
              service.findCharacteristic(characteristicIdentifier);
          if (characteristic != null) {
            characteristic.isNotificationEnabled = enable;
          }
        }
      }
    }
  }
  return Future.value(response);
}

// Homekit - ActionSet
// 更改场景名称
Future updateActionSetName(
    String homeIdentifier, String actionSetIdentifier, String name) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['actionSetIdentifier'] = actionSetIdentifier;
  map['name'] = name;
  var response = await _methodChannel.invokeMethod('updateActionSetName', map);
  final int code = response['code'];
  if (code == 0) {
    final Home home = HomeManager().findHome(homeIdentifier);
    if (home != null) {
      final ActionSet actionSet = home.findActionSet(actionSetIdentifier);
      if (actionSet != null) {
        actionSet.name = name;
      }
    }
  }
  return Future.value(response);
}

//添加场景Action
void addAction(
    String homeIdentifier,
    String actionSetIdentifier,
    String accessoryIdentifier,
    String serviceIdentifier,
    String characteristicIdentifier,
    targetValue) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['actionSetIdentifier'] = actionSetIdentifier;
  map['accessoryIdentifier'] = accessoryIdentifier;
  map['serviceIdentifier'] = serviceIdentifier;
  map['characteristicIdentifier'] = characteristicIdentifier;
  map['targetValue'] = targetValue;

  _methodChannel.invokeMethod('addAction', map);
  // .then((response) {
  //   final int code = response['code'];
  //   print('AAA 2 -> $code');
  //   if (code == 0) {
  //     final Home home = HomeManager().findHome(homeIdentifier);
  //     if (home != null) {
  //       print('AAA 3');
  //       final ActionSet actionSet = home.findActionSet(actionSetIdentifier);
  //       final Accessory accessory = home.findAccessory(accessoryIdentifier);
  //       Characteristic characteristic;
  //       if (accessory != null) {
  //         print('AAA 4');
  //         final Service service = accessory.findService(serviceIdentifier);
  //         if (service != null) {
  //           print('AAA 5');
  //           characteristic = service.findCharacteristic(characteristicIdentifier);
  //         }
  //       }
  //       if (actionSet != null) {
  //         print('AAA 6');
  //         final Action action =Action.fromMap(map);
  //         action.targetValue = targetValue;
  //         action.characteristic = characteristic;
  //         actionSet.actions.add(action);
  //       }
  //     }
  //   }
  // });

  // var response = await _methodChannel.invokeMethod('addAction', map);
  // final int code = response['code'];
  // print('AAA 2 -> $code');
  // if (code == 0) {
  //   //getEntities();
  //   final Home home = HomeManager().findHome(homeIdentifier);
  //   if (home != null) {
  //     print('AAA 3');
  //     final ActionSet actionSet = home.findActionSet(actionSetIdentifier);
  //     final Accessory accessory = home.findAccessory(accessoryIdentifier);
  //     Characteristic characteristic;
  //     if (accessory != null) {
  //       print('AAA 4');
  //       final Service service = accessory.findService(serviceIdentifier);
  //       if (service != null) {
  //         print('AAA 5');
  //         characteristic = service.findCharacteristic(characteristicIdentifier);
  //       }
  //     }
  //     if (actionSet != null) {
  //       print('AAA 6');
  //       final Action action = Action.fromMap(map);
  //       action.targetValue = targetValue;
  //       action.characteristic = characteristic;
  //       actionSet.actions.add(action);
  //     }
  //   }
  // }
  // return Future.value(response);
}

//删除场景Action
void removeAction(String homeIdentifier, String actionSetIdentifier,
    String actionIdentifier) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['actionSetIdentifier'] = actionSetIdentifier;
  map['actionIdentifier'] = actionIdentifier;
  var response = await _methodChannel.invokeMethod('removeAction', map);
  // final int code = response['code'];
  // print('BBB 2');
  // if (code == 0) {
  //   print('BBB 3');
  //   final Home home = HomeManager().findHome(homeIdentifier);
  //   if (home != null) {
  //     print('BBB 4');
  //     final ActionSet actionSet = home.findActionSet(actionSetIdentifier);
  //     if (actionSet != null) {
  //       print('BBB 5');
  //       actionSet.removeAction(actionIdentifier);
  //     }
  //   }
  //   //TODO: May need fix
  //   //getHomeEntities(homeIdentifier);
  // }
  // return Future.value(response);
}

//Homekit - Action
void updateTargetValue(String homeIdentifier, String actionSetIdentifier,
    String actionIdentifier, targetValue) async {
  final Map map = Map();
  map['homeIdentifier'] = homeIdentifier;
  map['actionSetIdentifier'] = actionSetIdentifier;
  map['actionIdentifier'] = actionIdentifier;
  map['targetValue'] = targetValue;
  var response = await _methodChannel.invokeMethod('updateTargetValue', map);
  // final int code = response['code'];
  // if (code == 0) {
  //   //getEntities();
  //   final Home home =HomeManager().findHome(homeIdentifier);
  //   if (home != null) {
  //     final ActionSet actionSet =home.findActionSet(actionSetIdentifier);
  //     if (actionSet != null) {
  //       final Action action =actionSet.findAction(actionIdentifier);
  //       if (action != null) {
  //         action.targetValue = targetValue;
  //       }
  //     }
  //   }
  // }
  //return Future.value(response);
}
