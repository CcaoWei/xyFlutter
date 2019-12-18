import 'package:xlive/const/const_shared.dart';

import 'data_shared.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;

class EntityParse {
  static PhysicDevice parsePhysicDevice(protobuf.LiveEntity ple) {
    if (!ple.hasEntityDevice()) return null;
    final protobuf.PhysicDevice ppd = ple.entityDevice;
    PhysicDevice physicDevice = PhysicDevice(
      uuid: ple.uUID,
      roomUuid: ple.areaUUID,
      name: ple.name,
      model: ppd.model,
      available: ppd.available,
    );

    List<LogicDevice> logicDevices = List<LogicDevice>();
    for (var pld in ppd.logicDevices) {
      final LogicDevice logicDevice = _parseLogicDevice(pld);
      logicDevice.parent = physicDevice;
      logicDevices.add(logicDevice);
    }
    physicDevice.logicDevices = logicDevices;

    for (var attr in ple.attributes) {
      physicDevice.setAttribute(attr.attrID.value, attr.attrValue);
    }

    return physicDevice;
  }

  static LogicDevice _parseLogicDevice(protobuf.LogicDevice pld) {
    LogicDevice logicDevice = LogicDevice(
      uuid: pld.uUID,
      profile: pld.profile.value,
      roomUuid: pld.areaUUID,
      name: pld.name,
    );
    for (var attr in pld.attributes) {
      logicDevice.setAttribute(attr.attrID.value, attr.attrValue);
    }
    return logicDevice;
  }

  static Room parseRoom(protobuf.LiveEntity ple) {
    if (!ple.hasEntityArea()) return null;
    return Room(uuid: ple.uUID, name: ple.name);
  }

  static Binding parseBinding(protobuf.LiveEntity ple) {
    if (!ple.hasEntityBinding()) return null;
    final protobuf.Binding pb = ple.entityBinding;
    final Binding binding = Binding(
        uuid: ple.uUID,
        bindingType: pb.type.value,
        triggerAddress: pb.triggerAddress,
        enabled: pb.enabled,
        parameter: pb.parameter);
    binding.actions = _parseActions(pb.actions);

    for (var attr in ple.attributes) {
      binding.setAttribute(attr.attrID.value, attr.attrValue);
    }

    return binding;
  }

  static Scene parseScene(protobuf.LiveEntity ple) {
    if (!ple.hasEntityScene()) return null;
    final protobuf.Scene ps = ple.entityScene;
    final Scene scene = Scene(uuid: ple.uUID, name: ple.name);
    scene.actions = _parseActions(ps.actions);

    for (var attr in ple.attributes) {
      scene.setAttribute(attr.attrID.value, attr.attrValue);
    }

    return scene;
  }

  static List<xyAction> _parseActions(List<protobuf.Action> pas) {
    final List<xyAction> actions = List<xyAction>();
    for (var pa in pas) {
      actions.add(xyAction(
        uuid: pa.uUID,
        attrId: pa.attrID.value,
        attrValue: pa.attrValue,
      ));
    }
    return actions;
  }

  static Firmware parseFirmware(protobuf.LiveEntity ple) {
    if (!ple.hasEntityFirmware()) return null;
    final protobuf.Firmware pf = ple.entityFirmware;
    return Firmware(
        uuid: ple.uUID,
        systemUuid: pf.systemUUID,
        imageModel: pf.imageModel,
        version: pf.version);
  }

  static ZigbeeSystem parseZigbeeSystem(protobuf.LiveEntity ple) {
    if (!ple.hasEntityZigbeeSystem()) return null;
    final protobuf.ZigbeeSystem pzs = ple.entityZigbeeSystem;
    final ZigbeeSystem zigbeeSystem = ZigbeeSystem(
        uuid: ple.uUID,
        name: ple.name,
        available: pzs.available,
        panId: pzs.panId,
        channel: pzs.channel,
        version: pzs.version);
    for (var attr in ple.attributes) {
      zigbeeSystem.setAttribute(attr.attrID.value, attr.attrValue);
    }

    return zigbeeSystem;
  }

  static Automation parseAutomation(protobuf.LiveEntity ple) {
    if (!ple.hasEntityAutomation()) return null;
    final protobuf.Automation auto = ple.entityAutomation;
    Automation ent = Automation(auto, ple.name);
    ent.uuid = ple.uUID;
    ent.name = ple.name;
    for (var attr in ple.attributes) {
      ent.setAttribute(attr.attrID.value, attr.attrValue);
    }
    ent.baseType = BASE_TYPE_AUTOMATION;
    for (var attr in ple.attributes) {
      ent.setAttribute(attr.attrID.value, attr.attrValue);
    }
    return ent;
  }

  static AutomationSet parseAutomationSet(protobuf.LiveEntity ple) {
    if (!ple.hasEntityAutomationSet()) return null;
    final protobuf.AutomationSet autoset = ple.entityAutomationSet;
    AutomationSet ent = AutomationSet(autoset, ple.name);
    ent.uuid = ple.uUID;
    ent.name = ple.name;
    for (var attr in ple.attributes) {
      ent.setAttribute(attr.attrID.value, attr.attrValue);
    }
    ent.baseType = BASE_TYPE_AUTOMATIONSET;
    for (var attr in ple.attributes) {
      ent.setAttribute(attr.attrID.value, attr.attrValue);
    }
    return ent;
  }
}
