part of data_shared;

class HomeCenterCache {
  Log log = LogFactory().getLogger(Log.DEBUG, 'HomeCenterCache');

  static const int ORIGIN = 0;
  static const int ONGOING = 1;
  static const int COMPLETE = 2;
  static const int ERROR = 3;

  Map<String, Entity> _entities = Map();
  String _homeCenterUuid;

  HomeCenterCache(this._homeCenterUuid);

  int _getEntityState = ORIGIN;

  void processGetEntity(GetEntityResponse response) {
    print('process get entity: $_homeCenterUuid');
    final List<protobuf.LiveEntity> entities = response.entities;

    for (var liveEntity in entities) {
      if (liveEntity.hasEntityDevice()) {
        final PhysicDevice physicDevice =
            EntityParse.parsePhysicDevice(liveEntity);
        _entities[physicDevice.uuid] = physicDevice;
        if (physicDevice.uuid.startsWith('box-')) {
          final HomeCenter homeCenter =
              HomeCenterManager().getHomeCenter(physicDevice.uuid);
          if (homeCenter != null) {
            homeCenter.physicDevice = physicDevice;
          }
        }
        FirmwareManager().addPhysicDevice(_homeCenterUuid, physicDevice);
      } else if (liveEntity.hasEntityArea()) {
        final Room area = EntityParse.parseRoom(liveEntity);
        _entities[area.uuid] = area;
      } else if (liveEntity.hasEntityBinding()) {
        final Binding binding = EntityParse.parseBinding(liveEntity);
        _entities[binding.uuid] = binding;
      } else if (liveEntity.hasEntityScene()) {
        final Scene scene = EntityParse.parseScene(liveEntity);
        _entities[scene.uuid] = scene;
      } else if (liveEntity.hasEntityFirmware()) {
        final Firmware firmware = EntityParse.parseFirmware(liveEntity);
        _entities[firmware.uuid] = firmware;
        FirmwareManager().addFirmware(_homeCenterUuid, firmware);
      } else if (liveEntity.hasEntityZigbeeSystem()) {
        final ZigbeeSystem zigbeeSystem =
            EntityParse.parseZigbeeSystem(liveEntity);
        _entities[zigbeeSystem.uuid] = zigbeeSystem;
      } else if (liveEntity.hasEntityAutomation()) {
        final Automation auto = EntityParse.parseAutomation(liveEntity);
        _entities[auto.uuid] = auto;
        log.w("add new auto ${auto.uuid}  ${_entities.length}",
            "processGetEntity");
      } else if (liveEntity.hasEntityAutomationSet()) {
        final AutomationSet autoset =
            EntityParse.parseAutomationSet(liveEntity);
        _entities[autoset.uuid] = autoset;
        log.w("add new autoset ${autoset.uuid}  ${_entities.length}",
            "processGetEntity");
      }
    }
  }

  void processEntityAvailable(EntityAvailableEvent event) {
    final protobuf.LiveEntity ple = event.entity;
    if (ple.hasEntityDevice()) {
      final PhysicDevice pd = EntityParse.parsePhysicDevice(ple);
      _entities[pd.uuid] = pd;
      final PhysicDeviceAvailableEvent evt = PhysicDeviceAvailableEvent(
        homeCenterUuid: _homeCenterUuid,
        physicDevice: pd,
      );
      RxBus().post(evt);
    } else if (ple.hasEntityFirmware()) {
      final Firmware firmware = EntityParse.parseFirmware(ple);
      _entities[firmware.uuid] = firmware;
      final FirmwareAvailableEvent evt = FirmwareAvailableEvent(
        homeCenterUuid: _homeCenterUuid,
        firmware: firmware,
      );
      RxBus().post(evt);
    } else if (ple.hasEntityZigbeeSystem()) {
      final ZigbeeSystem zs = EntityParse.parseZigbeeSystem(ple);
      _entities[zs.uuid] = zs;
    } else if (ple.hasEntityAutomation()) {
      final Automation auto = EntityParse.parseAutomation(ple);
      _entities[auto.uuid] = auto;
    }
  }

  void processUpdateEntityAvailable(UpdateAvailableEntityEvent event) {
    final protobuf.LiveEntity ple = event.entity;
    if (ple.hasEntityDevice()) {
      final PhysicDevice pd = EntityParse.parsePhysicDevice(ple);
      _entities[pd.uuid] = pd;
      final UpdatePhysicDeviceAvailableEvent evt =
          UpdatePhysicDeviceAvailableEvent(
        homeCenterUuid: _homeCenterUuid,
        physicDevice: pd,
      );
      RxBus().post(evt);
    }
  }

  void processEntityUpdated(EntityUpdatedEvent event) {
    final protobuf.LiveEntity ple = event.entity;
    if (ple.hasEntityAutomation()) {
      final Automation auto = EntityParse.parseAutomation(ple);
      _entities[auto.uuid] = auto;
      final AutomationUpdatedEvent evt = AutomationUpdatedEvent(
        homeCenterUuid: _homeCenterUuid,
        auto: auto,
      );
      RxBus().post(evt);
    } else if (ple.hasEntityAutomationSet()) {
      final AutomationSet autoset = EntityParse.parseAutomationSet(ple);
      _entities[autoset.uuid] = autoset;
      final AutomationSetUpdatedEvent evt = AutomationSetUpdatedEvent(
        homeCenterUuid: _homeCenterUuid,
        autoset: autoset,
      );
      RxBus().post(evt);
    } else {
      print("unsupported entity update");
    }
  }

  void processEntityCreated(EntityCreatedEvent event) {
    final protobuf.LiveEntity ple = event.entity;
    if (ple.hasEntityAutomation()) {
      final Automation auto = EntityParse.parseAutomation(ple);
      _entities[auto.uuid] = auto;
      final AutomationCreatedEvent evt = AutomationCreatedEvent(
        homeCenterUuid: _homeCenterUuid,
        auto: auto,
      );
      RxBus().post(evt);
    } else if (ple.hasEntityAutomationSet()) {
      final AutomationSet autoset = EntityParse.parseAutomationSet(ple);
      _entities[autoset.uuid] = autoset;
      final AutomationSetCreatedEvent evt = AutomationSetCreatedEvent(
        homeCenterUuid: _homeCenterUuid,
        autoset: autoset,
      );
      RxBus().post(evt);
    } else {
      print("unsupported entity create");
    }
  }

  void processPhysicDeviceOffline(PhysicDeviceOfflineEvent event) {
    final String uuid = event.uUID;
    print(
        'device offline: uuid <-> $uuid ***** homeCenterUuid <-> $_homeCenterUuid');
    final Entity entity = _entities[uuid];
    if (entity != null && entity is PhysicDevice) {
      entity.available = false;
      for (LogicDevice ld in entity.logicDevices) {
        ld.parent.available = false;
      }
      final DeviceOfflineEvent evt = DeviceOfflineEvent(
        homeCenterUuid: _homeCenterUuid,
        uuid: uuid,
        physicDevice: entity,
      );
      RxBus().post(evt);
    }
  }

  void processDeviceKeyPressed(DeviceKeyPressedEvent event) {
    final String uuid = event.uUID;
    final int rssi = event.rSSI;
    final Entity entity = findEntity(uuid);
    if (entity != null) {
      entity.rssi = rssi;
      final DeviceKeyPresseEvent evt = DeviceKeyPresseEvent(
        homeCenterUuid: _homeCenterUuid,
        uuid: uuid,
        rssi: rssi,
      );
      RxBus().post(evt);
    }
  }

  void processDeviceAttrReport(DeviceAttrReportEvent event) {
    final String uuid = event.uUID;
    final List<protoc.Attribute> attributes = event.attributes;
    final Entity entity = findEntity(uuid);
    if (entity != null) {
      if (entity is Scene) {
        for (var attr in attributes) {
          if (attr.attrID.value == ATTRIBUTE_ID_ALERT_LEVEL &&
              attributes.length > 1) continue;
          if (attr.attrID.value == ATTRIBUTE_ID_ON_OFF_STATUS) {
            entity.setAttribute(attr.attrID.value, attr.attrValue);
            final SceneOnOffStatusChangedEvent evt =
                SceneOnOffStatusChangedEvent(
              homeCenterUuid: _homeCenterUuid,
              uuid: uuid,
              status: attr.attrValue,
            );
            RxBus().post(evt);
          }
        }
      } else if (uuid.startsWith('box-')) {
        for (var attr in attributes) {
          if (attr.attrID.value == ATTRIBUTE_ID_FIRMWARE_VERSION) {
            entity.setAttribute(attr.attrID.value, attr.attrValue);
            final HomeCenter homeCenter =
                HomeCenterManager().getHomeCenter(uuid);
            if (homeCenter != null) {
              homeCenter.physicDevice
                  .setAttribute(attr.attrID.value, attr.attrValue);
            }
            final DeviceAttributeReportEvent evt = DeviceAttributeReportEvent(
              homeCenterUuid: _homeCenterUuid,
              uuid: uuid,
              attrId: attr.attrID.value,
              attrValue: attr.attrValue,
            );
            RxBus().post(evt);
          }
        }
      } else {
        for (var attr in attributes) {
          if (attr.attrID.value == ATTRIBUTE_ID_ALERT_LEVEL &&
              attributes.length > 1) continue; //暂时当attr个数大于1时不处理alert_level事件
          if (entity is ZigbeeSystem &&
              attr.attrID.value == ATTRIBUTE_ID_ZB_CHANNEL) {
            entity.channel = attr.attrValue;
          }

          entity.setAttribute(attr.attrID.value, attr.attrValue);
          final DeviceAttributeReportEvent evt = DeviceAttributeReportEvent(
            homeCenterUuid: _homeCenterUuid,
            uuid: uuid,
            attrId: attr.attrID.value,
            attrValue: attr.attrValue,
          );
          RxBus().post(evt);
        }
      }
    }
  }

  void processSceneCreate(SceneCreatedEvent event) {
    final protobuf.LiveEntity ple = event.scene;
    if (ple.hasEntityScene()) {
      final Scene scene = EntityParse.parseScene(ple);
      _entities[scene.uuid] = scene;
      final SceneCreateEvent evt = SceneCreateEvent(
        homeCenterUuid: _homeCenterUuid,
        scene: scene,
      );
      RxBus().post(evt);
    }
  }

  void processSceneUpdate(SceneUpdatedEvent event) {
    final protobuf.LiveEntity ple = event.scene;
    if (ple.hasEntityScene()) {
      final Scene scene = EntityParse.parseScene(ple);
      _entities[scene.uuid] = scene;
      final SceneUpdateEvent evt = SceneUpdateEvent(
        homeCenterUuid: _homeCenterUuid,
        scene: scene,
      );
      RxBus().post(evt);
    }
  }

  void processSceneDelete(SceneDeletedEvent event) {
    final String uuid = event.uUID;
    if (_entities.containsKey(uuid)) {
      final Entity entity = _entities[uuid];
      if (entity is Scene) {
        final Scene scene = _entities.remove(uuid);
        final SceneDeleteEvent evt = SceneDeleteEvent(
          homeCenterUuid: _homeCenterUuid,
          scene: scene,
        );
        RxBus().post(evt);
      }
    }
  }

  void processEntityDelete(EntityDeletedEvent event) {
    final String uuid = event.uUID;
    if (_entities.containsKey(uuid)) {
      final Entity entity = _entities[uuid];
      if (entity != null) {
        _entities.remove(uuid);
        final EntityDeleteEvent evt = EntityDeleteEvent(
          homeCenterUuid: _homeCenterUuid,
          entity: entity,
        );
        RxBus().post(evt);
      }
    }
  }

  void processAreaCreate(AreaCreatedEvent event) {
    print('Room create event');
    final protobuf.LiveEntity ple = event.area;
    if (ple.hasEntityArea()) {
      final Room room = EntityParse.parseRoom(ple);
      _entities[room.uuid] = room;
      final RoomCreateEvent evt = RoomCreateEvent(
        homeCenterUuid: _homeCenterUuid,
        room: room,
      );
      RxBus().post(evt);
    }
  }

  void processAreaDelete(AreaDeletedEvent event) {
    final String uuid = event.uUID;
    if (_entities.containsKey(uuid)) {
      final Entity entity = _entities[uuid];
      if (entity is Room) {
        final Room room = _entities.remove(uuid);
        final RoomDeleteEvent evt = RoomDeleteEvent(
          homeCenterUuid: _homeCenterUuid,
          uuid: uuid,
        );
        RxBus().post(evt);
      }
    }
  }

  void processBindingCreate(BindingCreatedEvent event) {
    final protobuf.LiveEntity ple = event.binding;
    if (ple.hasEntityBinding()) {
      final Binding binding = EntityParse.parseBinding(ple);
      _entities[binding.uuid] = binding;
      final BindingCreateEvent evt = BindingCreateEvent(
        homeCenterUuid: _homeCenterUuid,
        binding: binding,
      );
      RxBus().post(evt);
    }
  }

  void processBindingUpdate(BindingUpdatedEvent event) {
    final protobuf.LiveEntity ple = event.binding;
    if (ple.hasEntityBinding()) {
      final Binding binding = EntityParse.parseBinding(ple);
      _entities[binding.uuid] = binding;
      final BindingUpdateEvent evt = BindingUpdateEvent(
        homeCenterUuid: _homeCenterUuid,
        binding: binding,
      );
      RxBus().post(evt);
    }
  }

  void processBindingDeleted(BindingDeletedEvent event) {
    final String uuid = event.uUID;
    if (_entities.containsKey(uuid)) {
      final Entity entity = _entities.remove(uuid);
      if (entity is Scene) {
        final SceneDeleteEvent evt = SceneDeleteEvent(
          homeCenterUuid: _homeCenterUuid,
          scene: entity,
        );
        RxBus().post(evt);
      } else if (entity is Binding) {
        final BindingDeleteEvent evt = BindingDeleteEvent(
          homeCenterUuid: _homeCenterUuid,
          binding: entity,
        );
        RxBus().post(evt);
      }
    }
  }

  void processEntityInfoConfigured(EntityInfoConfiguredEvent event) {
    final String uuid = event.uUID;
    final String name = event.name;
    final String areaUuid = event.areaUUID;
    final bool isNew = event.isNew;
    final Entity entity = findEntity(uuid);
    if (entity != null) {
      if (entity is Room) {
        entity.name = name;
        final RoomRenameEvent evt = RoomRenameEvent(
          homeCenterUuid: _homeCenterUuid,
          uuid: uuid,
          newName: name,
        );
        RxBus().post(evt);
      } else {
        if (name != null && name.isNotEmpty) {
          entity.name = name;
        }
        if (areaUuid != null && areaUuid.isNotEmpty) {
          entity.roomUuid = areaUuid;
        }

        entity.setAttribute(ATTRIBUTE_ID_ENTITY_IS_NEW, 0);
        if (entity is LogicDevice) {
          entity.parent.setAttribute(ATTRIBUTE_ID_ENTITY_IS_NEW, 0);
        }

        final EntityInfoConfigureEvent evt = EntityInfoConfigureEvent(
            homeCenterUuid: _homeCenterUuid,
            uuid: uuid,
            isNew: isNew,
            name: name,
            roomUuid: areaUuid);
        RxBus().post(evt);
      }
    }
  }

  void processBindingEnableChanged(BindingEnableChangedEvent event) {
    final String uuid = event.uUID;
    final bool enabled = event.enabled;
    final Entity entity = findEntity(uuid);
    if (entity is Binding) {
      entity.enabled = enabled;
      final BindingEnableChanegeEvent evt = BindingEnableChanegeEvent(
        homeCenterUuid: _homeCenterUuid,
        uuid: uuid,
        triggerAddress: entity.triggerAddress,
        enabled: enabled,
        parameter: entity.parameter,
      );
      RxBus().post(evt);
    }
  }

  void processFirmwareUpgradeStatusChanged(
      FirmwareUpgradeStatusChangedEvent event) {
    final String uuid = event.deviceUUID;
    final String firmwareUuid = event.firmwareUUID;
    final String firmwareVersion = event.firmwareVersion;
    final int upgradeStatus = event.status.value;
    final int percent = event.percent;

    log.d(
        'uuid: $uuid *** firmware version: $firmwareVersion *** percent: $percent',
        'processFirmwareUpgradeStatusChanged');

    final Entity entity = findEntity(uuid);
    if (entity == null) return;
    if (entity is PhysicDevice) {
      //FIXME: 此属性能work?
      if (upgradeStatus == UPGRADE_STATUS_FINISHED) {
        entity.setAttribute(
            ATTRIBUTE_ID_FIRMWARE_VERSION, int.parse(firmwareVersion));
      }

      final FirmwareUpgradeStatusChangeEvent evt =
          FirmwareUpgradeStatusChangeEvent(
        homeCenterUuid: _homeCenterUuid,
        uuid: uuid,
        firmwareUuid: firmwareUuid,
        firmwareVersion: firmwareVersion,
        upgradeStatus: upgradeStatus,
        percent: percent,
        physicDevice: entity,
      );
      RxBus().post(evt);
    }
  }

  void processDeviceDelete(DeviceDeletedEvent event) {
    final String uuid = event.uUID;
    if (_entities.containsKey(uuid)) {
      var entity = _entities.remove(uuid);
      final DeviceDeleteEvent evt = DeviceDeleteEvent(
        homeCenterUuid: _homeCenterUuid,
        uuid: uuid,
        entity: entity,
      );
      RxBus().post(evt);
    }
  }

  void processDeviceAssociation(DeviceAssociationEvent event) {
    final DeviceAssociationNotificationEvent evt =
        DeviceAssociationNotificationEvent(
      homeCenterUuid: _homeCenterUuid,
      event: event,
    );
    RxBus().post(evt);
  }

  Entity findEntity(String uuid) {
    if (_entities.containsKey(uuid)) {
      return _entities[uuid];
    }
    for (var entity in _entities.values) {
      if (!(entity is PhysicDevice)) continue;
      final PhysicDevice pd = entity as PhysicDevice;
      for (var logicDevice in pd.logicDevices) {
        if (logicDevice.uuid == uuid) {
          return logicDevice;
        }
      }
    }
    return null;
  }

  List<PhysicDevice> get addedDevices {
    final List<PhysicDevice> temp = List();
    for (var entity in _entities.values) {
      if (!(entity is PhysicDevice)) continue;
      final PhysicDevice physicDevice = entity as PhysicDevice;
      if (physicDevice.isCurtain && physicDevice.isNew) continue;
      temp.add(physicDevice);
    }
    return temp;
  }

  List<PhysicDevice> get newDevices {
    final List<PhysicDevice> temp = List();
    for (var entity in _entities.values) {
      if (entity is PhysicDevice) {
        if (entity.isNew && entity.available) {
          temp.add(entity);
        }
      }
    }
    return temp;
  }

  List<Room> get rooms {
    final List<Room> temp = List();
    for (var entity in _entities.values) {
      if (!(entity is Room)) continue;
      temp.add(entity);
    }
    return temp;
  }

  List<Binding> get bindings {
    final List<Binding> temp = List();
    for (var entity in _entities.values) {
      if (!(entity is Binding)) continue;
      temp.add(entity);
    }
    return temp;
  }

  List<Scene> get scenes {
    final List<Scene> temp = List();
    for (var entity in _entities.values) {
      if (entity is Scene) {
        temp.add(entity);
      }
    }
    return temp;
  }

  List<Firmware> get firmwares {
    final List<Firmware> temp = List();
    for (var entity in _entities.values) {
      if (entity is Firmware) {
        temp.add(entity);
      }
    }
    return temp;
  }

  List<Automation> get automations {
    final List<Automation> temp = List();
    for (var entity in _entities.values) {
      if (!(entity is Automation)) continue;
      temp.add(entity);
    }
    return temp;
  }

  List<AutomationSet> get automationsets {
    final List<AutomationSet> temp = List();
    for (var entity in _entities.values) {
      if (!(entity is AutomationSet)) continue;
      temp.add(entity);
    }
    return temp;
  }

  ZigbeeSystem get system {
    for (var entity in _entities.values) {
      if (entity is ZigbeeSystem) {
        return entity;
      }
    }
    return null;
  }

  int get numberOfLightsOn {
    int number = 0;
    for (var entity in _entities.values) {
      if (entity is PhysicDevice) {
        if (!entity.available) continue;
        if (entity.isWallSwitch || entity.isWallSwitchUS) {
          for (var ld in entity.logicDevices) {
            if (ld.isOnOffLight && ld.onOffStatus == 1) {
              number++;
            }
          }
        } else if (entity.isLightSocket) {
          for (var ld in entity.logicDevices) {
            if (ld.onOffStatus == 1) {
              number++;
            }
          }
        }
      }
    }
    return number;
  }

  int get numberOfDevicesArming {
    int number = 0;
    for (var entity in _entities.values) {
      if (entity is PhysicDevice) {
        if (!entity.available) continue;
        if (entity.isAwarenessSwitch || entity.isDoorContact) {
          for (var ld in entity.logicDevices) {
            if (ld.alertLevel == 1) {
              number++;
            }
          }
        }
      }
    }
    return number;
  }

  //default -999
  double get currentTemperature {
    double temperature = -999.0;
    for (var entity in _entities.values) {
      if (entity is PhysicDevice) {
        if (!entity.available) continue;
        if (entity.isAwarenessSwitch || entity.isDoorContact) {
          for (var ld in entity.logicDevices) {
            if (ld.temperature != -99) {
              return temperature = ld.temperature + 0.0;
            }
          }
        }
      }
    }
    return temperature;
  }

  bool get hasNewDevices {
    for (var entity in _entities.values) {
      if (entity is PhysicDevice) {
        if (entity.available && entity.isNew) return true;
      }
    }
    return false;
  }

  bool get hasDevices {
    for (Entity entity in _entities.values) {
      if (entity is PhysicDevice) {
        if (entity.isNew && entity.isCurtain) continue;
        return true;
      }
    }
    return false;
  }

  void getEntity(int node) {
    final String methodName = 'getEntity';
    MqttProxy.getEntity(_homeCenterUuid, node)
        .timeout(const Duration(seconds: 3), onTimeout: (sink) {
      log.w(
          'Get entity time out, uuid:$_homeCenterUuid  node:$node', methodName);
      _getEntityState = ERROR;
      //TODO:
      //LoginManager().isGetDataComplete = true;
      LoginManager().stage = LoginManager.STAGE_GET_DATA_FAILED;
      RxBus().post(LoginEvent(LoginEvent.GET_DATA_COMPLETE));
    }).listen((response) {
      log.d(
          'Complete get entity, uuid:$_homeCenterUuid  node:$node', methodName);
      processGetEntity(response.message.getEntityResult);
      node++;
      if (node < BASE_TYPE_AUTOMATION) {
        getEntity(node);
      } else {
        _getEntityState = COMPLETE;
        //LoginManager().isGetDataComplete = true;
        LoginManager().stage = LoginManager.STAGE_GET_DATA_SUCCEED;
        RxBus().post(LoginEvent(LoginEvent.GET_DATA_COMPLETE));
        RxBus().post(GetEntityCompletedEvent(homeCenterUuid: _homeCenterUuid));
      }
    }).onError((e) {
      log.e('Get entity error, uuid:$_homeCenterUuid  node:$node', methodName);
      _getEntityState = ERROR;
      //TODO:是否要区分 COMPLETE 与 ERROR
      //LoginManager().isGetDataComplete = true;
      LoginManager().stage = LoginManager.STAGE_GET_DATA_FAILED;
      RxBus().post(LoginEvent(LoginEvent.GET_DATA_COMPLETE));
    });
  }

  void goOffline() {
    _getEntityState = ORIGIN;
    print("${_homeCenterUuid} goes offline, mark all entities unavailable");
    _entities.forEach((k, v) {
      if (v is PhysicDevice) {
        v.available = false;
      }
    });
  }

  void getEntities() {
    if (_getEntityState == ONGOING) return;
    _getEntityState = ONGOING;
    getEntity(GET_ENTITY_DEVICE);
  }

  void getEntityFromHomekit() {
    channel.entityFromHomekit.listen((entity) {});
  }

  void clear() {
    _entities.clear();
  }
}

class HomeCenterCacheEvent {
  final String homeCenterUuid;
  final String uuid;

  HomeCenterCacheEvent({this.homeCenterUuid, this.uuid});
}

class DeviceAttributeReportEvent extends HomeCenterCacheEvent {
  final int attrId;
  final int attrValue;

  DeviceAttributeReportEvent({
    String homeCenterUuid,
    String uuid,
    this.attrId,
    this.attrValue,
  }) : super(homeCenterUuid: homeCenterUuid, uuid: uuid);
}

class SceneOnOffStatusChangedEvent extends HomeCenterCacheEvent {
  final int status;

  SceneOnOffStatusChangedEvent({
    String homeCenterUuid,
    String uuid,
    this.status,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: uuid,
        );
}

class BindingEnableChanegeEvent extends HomeCenterCacheEvent {
  final bool enabled;
  final String triggerAddress;
  final int parameter;

  BindingEnableChanegeEvent({
    String homeCenterUuid,
    String uuid,
    this.triggerAddress,
    this.enabled,
    this.parameter,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: uuid,
        );
}

class PhysicDeviceAvailableEvent extends HomeCenterCacheEvent {
  final PhysicDevice physicDevice;

  PhysicDeviceAvailableEvent({
    String homeCenterUuid,
    this.physicDevice,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: physicDevice.uuid,
        );
}

class UpdatePhysicDeviceAvailableEvent extends HomeCenterCacheEvent {
  final PhysicDevice physicDevice;

  UpdatePhysicDeviceAvailableEvent({
    String homeCenterUuid,
    this.physicDevice,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: physicDevice.uuid,
        );
}

class AutomationCreatedEvent extends HomeCenterCacheEvent {
  final Automation auto;

  AutomationCreatedEvent({
    String homeCenterUuid,
    this.auto,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: auto.uuid,
        );
}

class AutomationUpdatedEvent extends HomeCenterCacheEvent {
  final Automation auto;

  AutomationUpdatedEvent({
    String homeCenterUuid,
    this.auto,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: auto.uuid,
        );
}

class AutomationSetCreatedEvent extends HomeCenterCacheEvent {
  final AutomationSet autoset;
  AutomationSetCreatedEvent({
    String homeCenterUuid,
    this.autoset,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: autoset.uuid,
        );
}

class AutomationSetUpdatedEvent extends HomeCenterCacheEvent {
  final AutomationSet autoset;

  AutomationSetUpdatedEvent({
    String homeCenterUuid,
    this.autoset,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: autoset.uuid,
        );
}

class FirmwareAvailableEvent extends HomeCenterCacheEvent {
  final Firmware firmware;

  FirmwareAvailableEvent({
    String homeCenterUuid,
    this.firmware,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: firmware.uuid,
        );
}

class DeviceOfflineEvent extends HomeCenterCacheEvent {
  final PhysicDevice physicDevice;

  DeviceOfflineEvent({
    String homeCenterUuid,
    String uuid,
    this.physicDevice,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: uuid,
        );
}

class DeviceKeyPresseEvent extends HomeCenterCacheEvent {
  final int rssi;

  DeviceKeyPresseEvent({
    String homeCenterUuid,
    String uuid,
    this.rssi,
  }) : super(homeCenterUuid: homeCenterUuid, uuid: uuid);
}

class SceneCreateEvent extends HomeCenterCacheEvent {
  final Scene scene;

  SceneCreateEvent({
    String homeCenterUuid,
    this.scene,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: scene.uuid,
        );
}

class SceneUpdateEvent extends HomeCenterCacheEvent {
  final Scene scene;

  SceneUpdateEvent({
    String homeCenterUuid,
    this.scene,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: scene.uuid,
        );
}

class SceneDeleteEvent extends HomeCenterCacheEvent {
  final Scene scene;

  SceneDeleteEvent({
    String homeCenterUuid,
    this.scene,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: scene.uuid,
        );
}

class RoomCreateEvent extends HomeCenterCacheEvent {
  final Room room;

  RoomCreateEvent({
    String homeCenterUuid,
    this.room,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: room.uuid,
        );
}

class RoomDeleteEvent extends HomeCenterCacheEvent {
  RoomDeleteEvent({
    String homeCenterUuid,
    String uuid,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: uuid,
        );
}

class RoomRenameEvent extends HomeCenterCacheEvent {
  final String newName;

  RoomRenameEvent({
    String homeCenterUuid,
    String uuid,
    this.newName,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: uuid,
        );
}

class BindingCreateEvent extends HomeCenterCacheEvent {
  final Binding binding;

  BindingCreateEvent({
    String homeCenterUuid,
    @required this.binding,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: binding.uuid,
        );
}

class BindingUpdateEvent extends HomeCenterCacheEvent {
  final Binding binding;

  BindingUpdateEvent({
    String homeCenterUuid,
    @required this.binding,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: binding.uuid,
        );
}

class BindingDeleteEvent extends HomeCenterCacheEvent {
  final Binding binding;

  BindingDeleteEvent({
    @required String homeCenterUuid,
    @required this.binding,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: binding.uuid,
        );
}

class EntityInfoConfigureEvent extends HomeCenterCacheEvent {
  final bool isNew;
  final String name;
  final String roomUuid;

  EntityInfoConfigureEvent({
    String homeCenterUuid,
    String uuid,
    this.isNew,
    this.name,
    this.roomUuid,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: uuid,
        );
}

class FirmwareUpgradeStatusChangeEvent extends HomeCenterCacheEvent {
  final String firmwareUuid;
  final String firmwareVersion;
  final int upgradeStatus;
  final int percent;
  final PhysicDevice physicDevice;

  FirmwareUpgradeStatusChangeEvent({
    String homeCenterUuid,
    String uuid,
    this.firmwareUuid,
    this.firmwareVersion,
    this.upgradeStatus,
    this.percent,
    this.physicDevice,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: uuid,
        );
}

class DeviceDeleteEvent extends HomeCenterCacheEvent {
  final Entity entity;

  DeviceDeleteEvent({
    String homeCenterUuid,
    String uuid,
    this.entity,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: uuid,
        );
}

class DeviceAssociationNotificationEvent extends HomeCenterCacheEvent {
  final DeviceAssociationEvent event;

  DeviceAssociationNotificationEvent({
    String homeCenterUuid,
    this.event,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: homeCenterUuid,
        );
}

class GetEntityCompletedEvent extends HomeCenterCacheEvent {
  GetEntityCompletedEvent({String homeCenterUuid})
      : super(
          homeCenterUuid: homeCenterUuid,
          uuid: homeCenterUuid,
        );
}

class EntityDeleteEvent extends HomeCenterCacheEvent {
  final Entity entity;

  EntityDeleteEvent({
    String homeCenterUuid,
    String uuid,
    this.entity,
  }) : super(
          homeCenterUuid: homeCenterUuid,
          uuid: uuid,
        );
}
