import 'dart:async';

import 'package:xlive/protocol/message.pb.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/protocol/const.pb.dart' as pbconst;
import 'package:xlive/protocol/const.pb.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/session/session.dart';
import 'package:xlive/session/session_manager.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'client.dart';

import 'package:uuid/uuid.dart';
import 'package:rxdart/rxdart.dart';

//网关发送命令之类的
class MqttProxy {
  static Future _publish(String homeCenterUuid, Message message) {
    final Session session = SessionManager().defaultSession;
    assert(session != null);
    return session.publishMessage(homeCenterUuid, message);
  }

  static Observable<Response> _publishAsObservable(
      String homeCenterUuid, Message message) {
    final StreamController<Response> controller = StreamController();
    RxBus()
        .toObservable()
        .where((e) => e is Response)
        .where((e) {
          //print('message id: ${message.messageID} --- col id: ${e.message.correlationID}');
          return true;
        })
        .where((event) =>
            event is Response &&
            event.message.correlationID == message.messageID)
        .listen((event) {
          if (!controller.isClosed) {
            controller.add(event as Response);
            controller.close();
          }
        });
    return Observable(controller.stream).doOnListen(() {
      _publish(homeCenterUuid, message);
    });
  }

  static Observable<Response> createScene(String homeCenterUuid, Scene scene) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final CreateSceneRequest createScene = CreateSceneRequest.create();
    final protobuf.LiveEntity ple = protobuf.LiveEntity.create();
    ple.baseType = protobuf.EntityBaseType.valueOf(BASE_TYPE_ACTION_GROUP);
    ple.uUID = scene.uuid;
    ple.name = scene.getName();

    final protobuf.Scene ps = protobuf.Scene.create();
    for (var action in scene.actions) {
      final protobuf.Action pa = protobuf.Action.create();
      pa.uUID = action.uuid;
      pa.attrID = AttributeID.valueOf(action.attrId);
      pa.attrValue = action.attrValue;
      ps.actions.add(pa);
    }

    ple.entityScene = ps;
    createScene.scene = ple;
    message.createScene = createScene;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> updateScene(String homeCenterUuid, Scene scene) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final UpdateSceneRequest updateScene = UpdateSceneRequest.create();
    final protobuf.LiveEntity ple = protobuf.LiveEntity.create();
    ple.baseType = protobuf.EntityBaseType.valueOf(BASE_TYPE_ACTION_GROUP);
    ple.uUID = scene.uuid;
    ple.name = scene.getName();

    final protobuf.Scene ps = protobuf.Scene.create();
    for (var action in scene.actions) {
      final protobuf.Action pa = protobuf.Action.create();
      pa.uUID = action.uuid;
      pa.attrID = AttributeID.valueOf(action.attrId);
      pa.attrValue = action.attrValue;
      ps.actions.add(pa);
    }

    ple.entityScene = ps;
    updateScene.scene = ple;
    message.updateScene = updateScene;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> deleteScene(
      String homeCenterUuid, String sceneUuid) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final DeleteSceneRequest deleteScene = DeleteSceneRequest.create();
    deleteScene.uUID = sceneUuid;

    message.deleteScene = deleteScene;
    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> createRoom(
      String homeCenterUuid, String roomName) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final CreateAreaRequest createRoom = CreateAreaRequest.create();
    createRoom.name = roomName;
    message.createArea = createRoom;
    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> deleteRoom(
      String homeCenterUuid, String roomUuid) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final DeleteAreaRequest deleteRoom = DeleteAreaRequest.create();
    deleteRoom.uUID = roomUuid;
    message.deleteArea = deleteRoom;
    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> createBinding(
      String homeCenterUuid, Binding binding) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();
    //message.sender = sender;

    final CreateBindingRequest createBinding = CreateBindingRequest.create();
    final protobuf.LiveEntity ple = protobuf.LiveEntity.create();
    ple.baseType = protobuf.EntityBaseType.valueOf(BASE_TYPE_ACTION_GROUP);
    ple.uUID = binding.uuid;

    final protobuf.Binding pb = protobuf.Binding.create();
    pb.type = BindingType.valueOf(binding.bindingType);
    pb.enabled = true;
    pb.triggerAddress = binding.triggerAddress;
    pb.parameter = binding.parameter;

    for (var action in binding.actions) {
      final protobuf.Action pa = protobuf.Action.create();
      pa.uUID = action.uuid;
      pa.attrID = AttributeID.valueOf(action.attrId);
      pa.attrValue = action.attrValue;
      pb.actions.add(pa);
    }

    ple.entityBinding = pb;
    createBinding.binding = ple;
    message.createBinding = createBinding;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> updateBinding(
      String homeCenterUuid, Binding binding) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final UpdateBindingRequest updateBinding = UpdateBindingRequest.create();
    final protobuf.LiveEntity ple = protobuf.LiveEntity.create();
    ple.baseType = protobuf.EntityBaseType.valueOf(BASE_TYPE_ACTION_GROUP);
    ple.uUID = binding.uuid;

    final protobuf.Binding pb = protobuf.Binding.create();
    pb.type = BindingType.valueOf(binding.bindingType);
    pb.enabled = binding.enabled;
    pb.triggerAddress = binding.triggerAddress;
    pb.parameter = binding.parameter;

    for (var action in binding.actions) {
      final protobuf.Action pa = protobuf.Action.create();
      pa.uUID = action.uuid;
      pa.attrID = AttributeID.valueOf(action.attrId);
      pa.attrValue = action.attrValue;
      pb.actions.add(pa);
    }

    ple.entityBinding = pb;
    updateBinding.binding = ple;
    message.updateBinding = updateBinding;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> setBindingEnable(
      String homeCenterUuid, String uuid, bool enabled) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final SetBindingEnableRequest setBindingEnable =
        SetBindingEnableRequest.create();
    setBindingEnable.uUID = uuid;
    setBindingEnable.enabled = enabled;

    message.setBindingEnable = setBindingEnable;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> configEntityInfo(
      String homeCenterUuid, String uuid, String name, String areaUuid) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final ConfigEntityInfoRequest configEntityInfo =
        ConfigEntityInfoRequest.create();
    configEntityInfo.uUID = uuid;
    configEntityInfo.name = name;
    configEntityInfo.areaUUID = areaUuid;

    message.configEntityInfo = configEntityInfo;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> setRoom(
      String homeCenterUuid, String uuid, String roomUuid) {
    return configEntityInfo(homeCenterUuid, uuid, '', roomUuid);
  }

  static Observable<Response> setName(
      String homeCenterUuid, String uuid, String name) {
    return configEntityInfo(homeCenterUuid, uuid, name, '');
  }

  static Observable<Response> reatAttribute(
      String sender, String homeCenterUuid, String uuid, int attrId) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();
    message.sender = sender;

    final ReadAttributeRequest readAttribute = ReadAttributeRequest.create();
    readAttribute.uUID = uuid;
    readAttribute.attrID = AttributeID.valueOf(attrId);

    message.readAttribute = readAttribute;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> setSceneOnOff(
      String homeCenterUuid, String uuid, int commond) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final SetSceneOnOffRequest setSceneOnOff = SetSceneOnOffRequest.create();
    setSceneOnOff.uUID = uuid;
    setSceneOnOff.command = OnOffCommand.valueOf(commond);

    message.setSceneOnOff = setSceneOnOff;
    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> writeAttribute(
      String homeCenterUuid, String uuid, int attrId, int attrValue) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final WriteAttributeRequest writeAttribute = WriteAttributeRequest.create();
    writeAttribute.uUID = uuid;
    writeAttribute.attrID = AttributeID.valueOf(attrId);
    writeAttribute.value = attrValue;

    message.writeAttribute = writeAttribute;
    print(
        'write attribute: homeCenterUuid: $homeCenterUuid <==> uuid: $uuid <==> attrId: $attrId <==> $attrValue');
    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> upgradeDevice(
      String homeCenterUuid, String firmwareUuid, String uuid) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final FirmwareUpgradeRequest firmwareUpgrade =
        FirmwareUpgradeRequest.create();
    firmwareUpgrade.firmwareUUID = firmwareUuid;
    firmwareUpgrade.devices = uuid;

    message.firmwareUpgrade = firmwareUpgrade;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> identifyDevice(
      String homeCenterUuid, String uuid, int duration) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final IdentifyDeviceRequest identifyDevice = IdentifyDeviceRequest.create();
    identifyDevice.uUID = uuid;
    identifyDevice.duration = duration;

    message.identifyDevice = identifyDevice;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> deleteEntity(String homeCenterUuid, String uuid) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final DeleteEntityRequest deleteEntity = DeleteEntityRequest.create();
    deleteEntity.uUID = uuid;

    message.deleteEntity = deleteEntity;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> checkNewVersion(String homeCenterUuid) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final CheckNewVersionRequest checkNewVersion =
        CheckNewVersionRequest.create();

    message.checkNewVersion = checkNewVersion;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> getEntity(String homeCenterUuid, int node) {
    if (node > GET_ENTITY_AUTOMATION_SET) {
      return Observable.empty();
    }
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final GetEntityRequest getEntity = GetEntityRequest.create();
    switch (node) {
      case GET_ENTITY_DEVICE:
        getEntity.type = EntityType.EntityDevice;
        break;
      case GET_ENTITY_SCENE:
        getEntity.type = EntityType.EntityScene;
        break;
      case GET_ENTITY_AREA:
        getEntity.type = EntityType.EntityArea;
        break;
      case GET_ENTITY_BINDING:
        getEntity.type = EntityType.EntityBinding;
        break;
      case GET_ENTITY_SYSTEM:
        getEntity.type = EntityType.EntitySystem;
        break;
      case GET_ENTITY_AUTOMATION:
        getEntity.type = EntityType.EntityAutomation;
        break;
      case GET_ENTITY_AUTOMATION_SET:
        getEntity.type = EntityType.EntityAutomationSet;
        break;
      default:
        getEntity.type = EntityType.EntityFirmware;
        break;
    }

    message.getEntity = getEntity;
    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> setPermitJoin(
      String homeCenterUuid, String systemUuid, int duration) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final SetPermitJoinRequest setPermitJoin = SetPermitJoinRequest.create();
    setPermitJoin.uUID = systemUuid;
    setPermitJoin.duration = duration;

    message.setPermitJoin = setPermitJoin;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> setUpgradePolicy(
      String homeCenterUuid, String channel) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final SetUpgradePolicyRequest setUpgradePolicy =
        SetUpgradePolicyRequest.create();
    setUpgradePolicy.channel = channel;
    setUpgradePolicy.interval = 604800;

    message.setUpgradePolicy = setUpgradePolicy;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> getUpgradePolicy(String homeCenterUuid) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final GetUpgradePolicyRequest getUpgradePolicy =
        GetUpgradePolicyRequest.create();

    message.getUpgradePolicy = getUpgradePolicy;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> getAutomationTimeoutMs(
      String homeCenterUuid, uuid) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final GetAutomationTimeoutMsRequest getAutoTimeout =
        GetAutomationTimeoutMsRequest.create();
    getAutoTimeout.uUID = uuid;
    message.getAutomationTimeoutMs = getAutoTimeout;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> createAutomation(
      String homeCenterUuid, Automation auto) {
    print(">>>>>>>>>>>>>地方撒计划防守打法");
    print(auto.auto);
    print(auto.name);
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final CreateEntityRequest create = CreateEntityRequest.create();
    final protobuf.LiveEntity ple = protobuf.LiveEntity.create();
    ple.baseType = protobuf.EntityBaseType.valueOf(BASE_TYPE_AUTOMATION);
    // ple.uUID = auto.uuid;
    ple.name = auto.name;
    auto.attributes.forEach((k, v) {
      if (k == ATTRIBUTE_ID_AUTO_ENABLED) {
        var att = pbconst.Attribute.create();
        att.attrID = pbconst.AttributeID.AttrIDAutoEnabled;
        att.attrValue = v.value;
        ple.attributes.add(att);
      }
    });

    ple.entityAutomation = auto.auto;

    create.entity = ple;
    message.createEntity = create;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> updateAutomation(
      String homeCenterUuid, Automation auto) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();

    final UpdateEntityRequest update = UpdateEntityRequest.create();
    final protobuf.LiveEntity ple = protobuf.LiveEntity.create();
    ple.baseType = protobuf.EntityBaseType.valueOf(BASE_TYPE_AUTOMATION);
    ple.uUID = auto.uuid;
    ple.name = auto.name;
    auto.attributes.forEach((k, v) {
      if (k == ATTRIBUTE_ID_AUTO_ENABLED) {
        var att = pbconst.Attribute.create();
        att.attrID = pbconst.AttributeID.AttrIDAutoEnabled;
        att.attrValue = v.value;
        ple.attributes.add(att);
      }
    });
    ple.entityAutomation = auto.auto;

    update.entity = ple;
    message.updateEntity = update;

    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> createAutomationSet(
      String homeCenterUuid, AutomationSet autoset) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();
    // for (var auto in autoset.autoset) {
    //   auto.convertConditionToUTCTime();
    // }

    final CreateEntityRequest create = CreateEntityRequest.create();
    final protobuf.LiveEntity ple = protobuf.LiveEntity.create();
    ple.baseType = protobuf.EntityBaseType.valueOf(BASE_TYPE_AUTOMATIONSET);
    // ple.uUID = auto.uuid;
    ple.name = autoset.getName();
    autoset.attributes.forEach((k, v) {
      if (k == ATTRIBUTE_ID_AUTO_ENABLED) {
        var att = pbconst.Attribute.create();
        att.attrID = pbconst.AttributeID.AttrIDAutoEnabled;
        att.attrValue = v.value;
        ple.attributes.add(att);
      }
    });

    autoset.resetAutoset();
    ple.entityAutomationSet = autoset.innerAutoSet;

    create.entity = ple;
    message.createEntity = create;
    print(message);
    return _publishAsObservable(homeCenterUuid, message);
  }

  static Observable<Response> updateAutomationSet(
      String homeCenterUuid, AutomationSet autoset) {
    final Message message = Message.create();
    message.messageID = Uuid().v1();
    // for (var auto in autoset.autoset) {
    //   auto.convertConditionToUTCTime();
    // }

    final UpdateEntityRequest update = UpdateEntityRequest.create();
    final protobuf.LiveEntity ple = protobuf.LiveEntity.create();
    ple.baseType = protobuf.EntityBaseType.valueOf(BASE_TYPE_AUTOMATION);
    ple.uUID = autoset.uuid;
    ple.name = autoset.getName();
    autoset.attributes.forEach((k, v) {
      if (k == ATTRIBUTE_ID_AUTO_ENABLED) {
        var att = pbconst.Attribute.create();
        att.attrID = pbconst.AttributeID.AttrIDAutoEnabled;
        att.attrValue = v.value;
        ple.attributes.add(att);
      }
    });

    autoset.resetAutoset();
    ple.entityAutomationSet = autoset.innerAutoSet;

    update.entity = ple;
    message.updateEntity = update;

    return _publishAsObservable(homeCenterUuid, message);
  }
}
