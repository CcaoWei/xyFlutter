import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:xlive/const/const_shared.dart';

import 'mqtt_shared.dart';
import 'mqtt_connection_io_websocket.dart';

import 'package:xlive/protocol/message.pb.dart';
import 'package:xlive/protocol/event.pb.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;

import 'package:uuid/uuid.dart';

//连接client  云端  建立连接的 订阅消息 接收消息   mseeage消息 和  event消息   final event 和 final Response
class Client {
  Log log = LogFactory().getLogger(Log.DEBUG, 'Client');

  String mac;

  String username;

  MqttClient _mqttClient;

  //存储 home center uuid
  Map<String, String> _cache = Map();
  Map<String, Message> _requestCache = Map();

  Future connected(String server, String username, String password,
      Function onConnectionLost) async {
    final String url = 'wss://$server:443/ws/mqtt';
    var mqttCnx = MqttConnectionIOWebSocket.setOptions(url);
    final String clientType = await methodChannel.getClientType();
    var cliendId = clientType + Uuid().v1().toString().substring(0, 26);
    if (server != CLOUD_SERVER) {
      cliendId =
          "xy_ios_mnkty87sj6HGddf5-" + Uuid().v1().toString().substring(0, 6);
    }
    _mqttClient = MqttClient(mqttCnx,
        clientID: cliendId,
        qos: QOS_1,
        cleanSession: true,
        username: username,
        password: password);
    if (server != CLOUD_SERVER) {
      _mqttClient.setWill(
          'message/' + username + "_will_topic", username + ' will change',
          qos: QOS_1, retain: false);
    } else {
      _mqttClient.setWill('', '', qos: QOS_1, retain: false);
    }
    return _mqttClient.connect(onConnectionLost);
  }

  void disconnected() {
    _mqttClient.disconnect();
    _mqttClient = null;
  }

  void _onSessionMessageArrived(String topic, List<int> payload) {
    final String methodName = 'onSessionMessageArrived';
    // log.d('message arrived', methodName);
    final List<String> strs = topic.split('/');
    final String topicBody = strs[1];
    final Message message = Message.fromBuffer(payload);
    final Message request = _requestCache[message.correlationID];
    // print("<<<<<<  MESSAGE");
    // print(message);
    if (request == null) {
      // log.d('request is null, is an event', methodName);
      if (message.hasDeviceAssociation()) {
        RxBus().post(DeviceAssociationNotificationMessage(
          username: topicBody,
          message: message,
        ));
      }
    } else if (message.hasError()) {
      log.d('error message, ${message}', methodName);
      final ErrorResponse error = message.error;
      final String homeCenterUuid = _cache[message.correlationID];
      final HomeCenterCache cache =
          HomeCenterManager().getHomeCenterCache(homeCenterUuid);
      if (request.hasGetEntity()) {
        final String homeCenterUuid = _cache[message.correlationID];
        RxBus().post(GetEntityResponse(
          code: error.code.value,
          homeCenterUuid: homeCenterUuid,
          message: message,
        ));
      } else if (request.hasConfigEntityInfo()) {
        final String uuid = request.configEntityInfo.uUID;
        RxBus().post(ConfigInfoResponse(
          code: error.code.value,
          uuid: uuid,
          message: message,
          isNew: false,
        ));
      } else if (request.hasCreateScene()) {
        RxBus().post(
            CreateSceneResponse(code: error.code.value, message: message));
      } else if (request.hasUpdateScene()) {
        RxBus().post(
            UpdateSceneResponse(code: error.code.value, message: message));
      } else if (request.hasDeleteScene()) {
        RxBus().post(
            DeleteSceneResponse(code: error.code.value, message: message));
      } else if (request.hasCreateBinding()) {
        RxBus().post(
            CreateBindingResponse(code: error.code.value, message: message));
      } else if (request.hasUpdateBinding()) {
        RxBus().post(
            UpdateBindingResponse(code: error.code.value, message: message));
      } else if (request.hasSetBindingEnable()) {
        RxBus().post(
            SetBindingEnableResponse(code: error.code.value, message: message));
      } else if (request.hasWriteAttribute()) {
        RxBus().post(
            WriteAttributeResponse(code: error.code.value, message: message));
      } else if (request.hasSetSceneOnOff()) {
        RxBus().post(
            SetSceneOnOffResponse(code: error.code.value, message: message));
      } else if (request.hasFirmwareUpgrade()) {
        RxBus().post(
            UpgradeDeviceResponse(code: error.code.value, message: message));
      } else if (request.hasIdentifyDevice()) {
        RxBus()
            .post(IdentifyResponse(code: error.code.value, message: message));
      } else if (request.hasDeleteEntity()) {
        RxBus().post(
            DeleteDeviceResponse(code: error.code.value, message: message));
      } else if (request.hasSetPermitJoin()) {
        RxBus().post(
            SetPermitJoinResponse(code: error.code.value, message: message));
      } else if (request.hasCheckNewVersionResult()) {
        RxBus().post(
            CheckNewVersionResponse(code: error.code.value, message: message));
      } else if (request.hasCreateArea()) {
        RxBus()
            .post(CreateRoomResponse(code: error.code.value, message: message));
      } else if (request.hasDeleteArea()) {
        RxBus()
            .post(DeleteRoomResponse(code: error.code.value, message: message));
      } else if (request.hasSetUpgradePolicy()) {
        RxBus().post(
            SetUpgradePolicyResponse(code: error.code.value, message: message));
      } else if (request.hasGetAutomationTimeoutMs()) {
        RxBus().post(GetAutomationTimeoutMsResponse(
            code: error.code.value, message: message));
      } else if (request.hasGetUpgradePolicy()) {
        RxBus().post(
            GetUpgradePolicyResponse(code: error.code.value, message: message));
      }
    } else if (message.hasGetEntityResult()) {
      final homeCenterUuid = _cache[message.correlationID];
      RxBus().post(GetEntityResponse(
        code: 0,
        homeCenterUuid: homeCenterUuid,
        message: message,
      ));
    } else if (message.hasConfigEntityInfoResult()) {
      final ConfigEntityInfoResponse response = message.configEntityInfoResult;
      final homeCenterUuid = _cache[message.correlationID];
      final HomeCenterCache cache =
          HomeCenterManager().getHomeCenterCache(homeCenterUuid);
      if (cache != null) {
        final Message request = _requestCache[message.correlationID];
        final String uuid = request.configEntityInfo.uUID;
        RxBus().post(ConfigInfoResponse(
          code: 0,
          uuid: uuid,
          message: message,
          isNew: message.configEntityInfoResult.isNew,
        ));
      }
    } else if (message.hasCreateSceneResult() || request.hasCreateScene()) {
      RxBus().post(CreateSceneResponse(code: 0, message: message));
    } else if (message.hasUpdateSceneResult() || request.hasUpdateScene()) {
      RxBus().post(UpdateSceneResponse(code: 0, message: message));
    } else if (message.hasDeleteSceneResult() || request.hasDeleteScene()) {
      RxBus().post(DeleteSceneResponse(code: 0, message: message));
    } else if (message.hasCreateBindingResult() || request.hasCreateBinding()) {
      RxBus().post(CreateBindingResponse(code: 0, message: message));
    } else if (message.hasUpdateBindingResult() || request.hasUpdateBinding()) {
      RxBus().post(UpdateBindingResponse(code: 0, message: message));
    } else if (message.hasSetBindingEnableResult() ||
        request.hasSetBindingEnable()) {
      RxBus().post(SetBindingEnableResponse(code: 0, message: message));
    } else if (message.hasWriteAttributeResult() ||
        request.hasWriteAttribute()) {
      RxBus().post(WriteAttributeResponse(code: 0, message: message));
    } else if (message.hasSetSceneOnOffResult() || request.hasSetSceneOnOff()) {
      RxBus().post(SetSceneOnOffResponse(code: 0, message: message));
    } else if (message.hasFirmwareUpgradeResult() ||
        request.hasFirmwareUpgrade()) {
      RxBus().post(UpgradeDeviceResponse(code: 0, message: message));
    } else if (message.hasIdentifyDeviceResult() ||
        request.hasIdentifyDevice()) {
      RxBus().post(IdentifyResponse(code: 0, message: message));
    } else if (message.hasDeleteEntityResult() || request.hasDeleteEntity()) {
      RxBus().post(DeleteDeviceResponse(code: 0, message: message));
    } else if (message.hasSetPermitJoinResult() || request.hasSetPermitJoin()) {
      //log.d('set permit join response', methodName);
      RxBus().post(SetPermitJoinResponse(code: 0, message: message));
    } else if (message.hasCheckNewVersionResult() ||
        request.hasCheckNewVersion()) {
      RxBus().post(CheckNewVersionResponse(code: 0, message: message));
    } else if (message.hasCreateAreaResult() || request.hasCreateArea()) {
      RxBus().post(CreateRoomResponse(code: 0, message: message));
    } else if (message.hasDeleteAreaResult() || request.hasDeleteArea()) {
      RxBus().post(DeleteRoomResponse(code: 0, message: message));
    } else if (message.hasSetUpgradePolicyResult() ||
        request.hasSetUpgradePolicy()) {
      RxBus().post(SetUpgradePolicyResponse(code: 0, message: message));
    } else if (message.hasGetAutomationTimeoutMsResult()) {
      RxBus().post(GetAutomationTimeoutMsResponse(
          code: 0,
          message: message,
          timeoutms: message.getAutomationTimeoutMsResult.timeoutMS));
    } else if (message.hasGetUpgradePolicyResult() ||
        request.hasGetUpgradePolicy()) {
      final String channel = message.getUpgradePolicyResult.channel;
      final int interval = message.getUpgradePolicyResult.interval;
      RxBus().post(GetUpgradePolicyResponse(
        code: 0,
        message: message,
        channel: channel,
        interval: interval,
      ));
    } else if (message.hasCreateEntityResult() || request.hasCreateEntity()) {
      if (request.createEntity.entity.hasEntityAutomation())
        RxBus().post(CreateAutomationResponse(
            code: 0, message: message, uuid: message.createEntityResult.uUID));
      if (request.createEntity.entity.hasEntityAutomationSet())
        RxBus().post(CreateAutomationSetResponse(
            code: 0, message: message, uuid: message.createEntityResult.uUID));
    } else if (message.hasUpdateEntityResult() || request.hasUpdateEntity()) {
      if (request.updateEntity.entity.hasEntityAutomation())
        RxBus().post(UpdateAutomationResponse(code: 0, message: message));
      if (request.updateEntity.entity.hasEntityAutomationSet())
        RxBus().post(UpdateAutomationSetResponse(code: 0, message: message));
    }
    if (_cache.containsKey(message.correlationID)) {
      _cache.remove(message.correlationID);
    }
  }

  void _onPeerEventArrived(String topic, List<int> payload) {
    final String methodName = 'onPeerEventArrived';
    //log.d('peer event arrived', methodName);
    final List<String> strs = topic.split('/');
    final String uuid = strs[1];
    final HomeCenterCache cache = HomeCenterManager().getHomeCenterCache(uuid);
    if (cache == null) {
      print('no cache associate with this event -> ${uuid}');
      return;
    }
    final Event event = Event.fromBuffer(payload);
    print("<<<<<<  EVENT");
    print(event);
    if (event.hasPresence()) {
      final PresenceEvent presence = event.presence;
      HomeCenterManager().processPresence(presence);
    } else if (event.hasEntityAvailable()) {
      final EntityAvailableEvent entityAvailable = event.entityAvailable;
      cache.processEntityAvailable(entityAvailable);
    } else if (event.hasUpdateAvailableEntity()) {
      final UpdateAvailableEntityEvent entityAvailable =
          event.updateAvailableEntity;
      cache.processUpdateEntityAvailable(entityAvailable);
    } else if (event.hasEntityUpdated()) {
      final EntityUpdatedEvent entityUpdated = event.entityUpdated;
      cache.processEntityUpdated(entityUpdated);
    } else if (event.hasEntityCreated()) {
      // print("<<<<<< entity created EVENT");
      // print(event);
      final EntityCreatedEvent entityCreated = event.entityCreated;
      cache.processEntityCreated(entityCreated);
    } else if (event.hasPhysicDeviceOffline()) {
      final PhysicDeviceOfflineEvent deviceOffline = event.physicDeviceOffline;
      cache.processPhysicDeviceOffline(deviceOffline);
    } else if (event.hasDeviceKeyPressed()) {
      final DeviceKeyPressedEvent keyPressed = event.deviceKeyPressed;
      cache.processDeviceKeyPressed(keyPressed);
    } else if (event.hasDeviceAttrReport()) {
      final DeviceAttrReportEvent attrReport = event.deviceAttrReport;
      // for (var attr in attrReport.attributes) {
      //   print('Device attr report event, attr id: ${attr.attrID}');
      // }
      // print("<<<<<<  EVENT");
      // print(event);
      cache.processDeviceAttrReport(attrReport);
    } else if (event.hasSceneCreated()) {
      final SceneCreatedEvent sceneCreate = event.sceneCreated;
      cache.processSceneCreate(sceneCreate);
    } else if (event.hasSceneUpdated()) {
      final SceneUpdatedEvent sceneUpdate = event.sceneUpdated;
      cache.processSceneUpdate(sceneUpdate);
    } else if (event.hasSceneDeleted()) {
      final SceneDeletedEvent sceneDelete = event.sceneDeleted;
      cache.processSceneDelete(sceneDelete);
    } else if (event.hasBindingCreated()) {
      final BindingCreatedEvent bindingCreate = event.bindingCreated;
      cache.processBindingCreate(bindingCreate);
    } else if (event.hasBindingUpdated()) {
      final BindingUpdatedEvent bindingUpdate = event.bindingUpdated;
      cache.processBindingUpdate(bindingUpdate);
    } else if (event.hasBindingDeleted()) {
      final BindingDeletedEvent bindingDelete = event.bindingDeleted;
      cache.processBindingDeleted(bindingDelete);
    } else if (event.hasEntityInfoConfigured()) {
      final EntityInfoConfiguredEvent infoConfigured =
          event.entityInfoConfigured;
      cache.processEntityInfoConfigured(infoConfigured);
    } else if (event.hasBindingEnableChanged()) {
      final BindingEnableChangedEvent bindingEnableChanged =
          event.bindingEnableChanged;
      cache.processBindingEnableChanged(bindingEnableChanged);
    } else if (event.hasDeviceAssociation()) {
      final DeviceAssociationEvent deviceAssociation = event.deviceAssociation;
      cache.processDeviceAssociation(deviceAssociation);
    } else if (event.hasFirmwareAvailable()) {
    } else if (event.hasFirmwareUpgradeStatusChanged()) {
      final FirmwareUpgradeStatusChangedEvent statusChanged =
          event.firmwareUpgradeStatusChanged;
      cache.processFirmwareUpgradeStatusChanged(statusChanged);
    } else if (event.hasDeviceDeleted()) {
      final DeviceDeletedEvent deviceDelete = event.deviceDeleted;
      cache.processDeviceDelete(deviceDelete);
    } else if (event.hasAreaCreated()) {
      final AreaCreatedEvent roomCreate = event.areaCreated;
      cache.processAreaCreate(roomCreate);
    } else if (event.hasAreaDeleted()) {
      final AreaDeletedEvent roomDelete = event.areaDeleted;
      cache.processAreaDelete(roomDelete);
    } else if (event.hasEntityDeleted()) {
      cache.processEntityDelete(event.entityDeleted);
    }
  }

  Future publish(String uuid, Message message) {
    final String topic = 'message/$uuid';
    assert(_mqttClient != null);
    // print('Message ID request -> ${message.messageID}');
    print('>>>>>>>  PUBLISH');
    print(message);
    _cache[message.messageID] = uuid;
    _requestCache[message.messageID] = message;
    return _mqttClient.publishProtobuf(topic, message.writeToBuffer().toList());
  }

  void subscribePeerMessage(String uuid) {
    final String topic = 'event/$uuid';
    assert(_mqttClient != null);
    _mqttClient.subscribe(topic, QOS_1, _onPeerEventArrived);
  }

  void subscribeSessionMessage(String username) {
    final String topic = 'message/$username';
    assert(_mqttClient != null);
    _mqttClient.subscribe(topic, QOS_1, _onSessionMessageArrived);
  }
}

abstract class Response {
  final int code;
  final Message message;

  Response({
    this.code,
    this.message,
  });

  bool get success => code == 0;
}

class GetEntityResponse extends Response {
  final String homeCenterUuid;

  GetEntityResponse({
    int code,
    Message message,
    this.homeCenterUuid,
  }) : super(code: code, message: message);
}

class ConfigInfoResponse extends Response {
  final bool isNew;
  final String uuid;

  ConfigInfoResponse({
    int code,
    Message message,
    this.uuid,
    this.isNew, //message.configEntityInfoResult.isNew,
  }) : super(code: code, message: message);
}

class UpdateSceneResponse extends Response {
  UpdateSceneResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class CreateSceneResponse extends Response {
  CreateSceneResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class DeleteSceneResponse extends Response {
  DeleteSceneResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class CreateRoomResponse extends Response {
  CreateRoomResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class DeleteRoomResponse extends Response {
  DeleteRoomResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class CreateBindingResponse extends Response {
  CreateBindingResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);

  bool get isIllegalArgument => code == 130;
}

class UpdateBindingResponse extends Response {
  UpdateBindingResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class SetBindingEnableResponse extends Response {
  SetBindingEnableResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class WriteAttributeResponse extends Response {
  WriteAttributeResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class SetSceneOnOffResponse extends Response {
  SetSceneOnOffResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);

  bool get isSceneEmpty => code == 45;
}

class UpgradeDeviceResponse extends Response {
  UpgradeDeviceResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class IdentifyResponse extends Response {
  IdentifyResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class DeleteDeviceResponse extends Response {
  DeleteDeviceResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class SetPermitJoinResponse extends Response {
  SetPermitJoinResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class CheckNewVersionResponse extends Response {
  CheckNewVersionResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class SetUpgradePolicyResponse extends Response {
  SetUpgradePolicyResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class GetUpgradePolicyResponse extends Response {
  final String channel;
  final int interval;

  GetUpgradePolicyResponse({
    int code,
    Message message,
    this.channel,
    this.interval,
  }) : super(code: code, message: message);
}

class DeviceAssociationNotificationMessage {
  final String username;
  final Message message;

  DeviceAssociationNotificationMessage({
    this.username,
    this.message,
  });
}

class CreateAutomationResponse extends Response {
  CreateAutomationResponse({
    int code,
    Message message,
    String uuid,
  }) : super(code: code, message: message);
}

class UpdateAutomationResponse extends Response {
  UpdateAutomationResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class CreateAutomationSetResponse extends Response {
  CreateAutomationSetResponse({
    int code,
    Message message,
    String uuid,
  }) : super(code: code, message: message);
}

class UpdateAutomationSetResponse extends Response {
  UpdateAutomationSetResponse({
    int code,
    Message message,
  }) : super(code: code, message: message);
}

class GetAutomationTimeoutMsResponse extends Response {
  Int64 timeoutms;
  GetAutomationTimeoutMsResponse({
    int code,
    Message message,
    Int64 timeoutms,
  }) : super(code: code, message: message) {
    this.timeoutms = timeoutms;
  }
}
