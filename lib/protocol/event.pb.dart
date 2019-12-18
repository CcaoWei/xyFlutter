///
//  Generated code. Do not modify.
//  source: event.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $1;
import 'entity.pb.dart' as $2;
import 'const.pb.dart' as $0;

import 'const.pbenum.dart' as $0;
import 'event.pbenum.dart';

export 'event.pbenum.dart';

enum Event_Body {
  entityAvailable, 
  physicDeviceOnline, 
  physicDeviceOffline, 
  deviceKeyPressed, 
  deviceAttrReport, 
  onOffStatusChanged, 
  sceneCreated, 
  sceneUpdated, 
  sceneDeleted, 
  bindingCreated, 
  bindingUpdated, 
  bindingDeleted, 
  entityInfoConfigured, 
  areaCreated, 
  areaRenamed, 
  areaDeleted, 
  permitJoinChanged, 
  bindingEnableChanged, 
  firmwareUpgradeStatusChanged, 
  updateRecommendFirmware, 
  firmwareAvailable, 
  deviceAdded, 
  deviceAssociation, 
  presence, 
  deviceDeleted, 
  entityUpdated, 
  entityCreated, 
  entityDeleted, 
  updateAvailableEntity, 
  notSet
}

class Event extends $pb.GeneratedMessage {
  static const Map<int, Event_Body> _Event_BodyByTag = {
    4 : Event_Body.entityAvailable,
    5 : Event_Body.physicDeviceOnline,
    6 : Event_Body.physicDeviceOffline,
    7 : Event_Body.deviceKeyPressed,
    8 : Event_Body.deviceAttrReport,
    9 : Event_Body.onOffStatusChanged,
    10 : Event_Body.sceneCreated,
    11 : Event_Body.sceneUpdated,
    12 : Event_Body.sceneDeleted,
    13 : Event_Body.bindingCreated,
    14 : Event_Body.bindingUpdated,
    15 : Event_Body.bindingDeleted,
    16 : Event_Body.entityInfoConfigured,
    17 : Event_Body.areaCreated,
    18 : Event_Body.areaRenamed,
    19 : Event_Body.areaDeleted,
    20 : Event_Body.permitJoinChanged,
    21 : Event_Body.bindingEnableChanged,
    22 : Event_Body.firmwareUpgradeStatusChanged,
    23 : Event_Body.updateRecommendFirmware,
    24 : Event_Body.firmwareAvailable,
    25 : Event_Body.deviceAdded,
    26 : Event_Body.deviceAssociation,
    27 : Event_Body.presence,
    28 : Event_Body.deviceDeleted,
    29 : Event_Body.entityUpdated,
    30 : Event_Body.entityCreated,
    31 : Event_Body.entityDeleted,
    32 : Event_Body.updateAvailableEntity,
    0 : Event_Body.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Event', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'messageID')
    ..aOS(2, 'sender')
    ..a<$1.Timestamp>(3, 'time', $pb.PbFieldType.OM, $1.Timestamp.getDefault, $1.Timestamp.create)
    ..a<EntityAvailableEvent>(4, 'entityAvailable', $pb.PbFieldType.OM, EntityAvailableEvent.getDefault, EntityAvailableEvent.create)
    ..a<PhysicDeviceOnlineEvent>(5, 'physicDeviceOnline', $pb.PbFieldType.OM, PhysicDeviceOnlineEvent.getDefault, PhysicDeviceOnlineEvent.create)
    ..a<PhysicDeviceOfflineEvent>(6, 'physicDeviceOffline', $pb.PbFieldType.OM, PhysicDeviceOfflineEvent.getDefault, PhysicDeviceOfflineEvent.create)
    ..a<DeviceKeyPressedEvent>(7, 'deviceKeyPressed', $pb.PbFieldType.OM, DeviceKeyPressedEvent.getDefault, DeviceKeyPressedEvent.create)
    ..a<DeviceAttrReportEvent>(8, 'deviceAttrReport', $pb.PbFieldType.OM, DeviceAttrReportEvent.getDefault, DeviceAttrReportEvent.create)
    ..a<OnOffStatusChangedEvent>(9, 'onOffStatusChanged', $pb.PbFieldType.OM, OnOffStatusChangedEvent.getDefault, OnOffStatusChangedEvent.create)
    ..a<SceneCreatedEvent>(10, 'sceneCreated', $pb.PbFieldType.OM, SceneCreatedEvent.getDefault, SceneCreatedEvent.create)
    ..a<SceneUpdatedEvent>(11, 'sceneUpdated', $pb.PbFieldType.OM, SceneUpdatedEvent.getDefault, SceneUpdatedEvent.create)
    ..a<SceneDeletedEvent>(12, 'sceneDeleted', $pb.PbFieldType.OM, SceneDeletedEvent.getDefault, SceneDeletedEvent.create)
    ..a<BindingCreatedEvent>(13, 'bindingCreated', $pb.PbFieldType.OM, BindingCreatedEvent.getDefault, BindingCreatedEvent.create)
    ..a<BindingUpdatedEvent>(14, 'bindingUpdated', $pb.PbFieldType.OM, BindingUpdatedEvent.getDefault, BindingUpdatedEvent.create)
    ..a<BindingDeletedEvent>(15, 'bindingDeleted', $pb.PbFieldType.OM, BindingDeletedEvent.getDefault, BindingDeletedEvent.create)
    ..a<EntityInfoConfiguredEvent>(16, 'entityInfoConfigured', $pb.PbFieldType.OM, EntityInfoConfiguredEvent.getDefault, EntityInfoConfiguredEvent.create)
    ..a<AreaCreatedEvent>(17, 'areaCreated', $pb.PbFieldType.OM, AreaCreatedEvent.getDefault, AreaCreatedEvent.create)
    ..a<AreaRenamedEvent>(18, 'areaRenamed', $pb.PbFieldType.OM, AreaRenamedEvent.getDefault, AreaRenamedEvent.create)
    ..a<AreaDeletedEvent>(19, 'areaDeleted', $pb.PbFieldType.OM, AreaDeletedEvent.getDefault, AreaDeletedEvent.create)
    ..a<PermitJoinChangedEvent>(20, 'permitJoinChanged', $pb.PbFieldType.OM, PermitJoinChangedEvent.getDefault, PermitJoinChangedEvent.create)
    ..a<BindingEnableChangedEvent>(21, 'bindingEnableChanged', $pb.PbFieldType.OM, BindingEnableChangedEvent.getDefault, BindingEnableChangedEvent.create)
    ..a<FirmwareUpgradeStatusChangedEvent>(22, 'firmwareUpgradeStatusChanged', $pb.PbFieldType.OM, FirmwareUpgradeStatusChangedEvent.getDefault, FirmwareUpgradeStatusChangedEvent.create)
    ..a<UpdateRecommendFirmwareEvent>(23, 'updateRecommendFirmware', $pb.PbFieldType.OM, UpdateRecommendFirmwareEvent.getDefault, UpdateRecommendFirmwareEvent.create)
    ..a<FirmwareAvailableEvent>(24, 'firmwareAvailable', $pb.PbFieldType.OM, FirmwareAvailableEvent.getDefault, FirmwareAvailableEvent.create)
    ..a<DeviceAddedEvent>(25, 'deviceAdded', $pb.PbFieldType.OM, DeviceAddedEvent.getDefault, DeviceAddedEvent.create)
    ..a<DeviceAssociationEvent>(26, 'deviceAssociation', $pb.PbFieldType.OM, DeviceAssociationEvent.getDefault, DeviceAssociationEvent.create)
    ..a<PresenceEvent>(27, 'presence', $pb.PbFieldType.OM, PresenceEvent.getDefault, PresenceEvent.create)
    ..a<DeviceDeletedEvent>(28, 'deviceDeleted', $pb.PbFieldType.OM, DeviceDeletedEvent.getDefault, DeviceDeletedEvent.create)
    ..a<EntityUpdatedEvent>(29, 'entityUpdated', $pb.PbFieldType.OM, EntityUpdatedEvent.getDefault, EntityUpdatedEvent.create)
    ..a<EntityCreatedEvent>(30, 'entityCreated', $pb.PbFieldType.OM, EntityCreatedEvent.getDefault, EntityCreatedEvent.create)
    ..a<EntityDeletedEvent>(31, 'entityDeleted', $pb.PbFieldType.OM, EntityDeletedEvent.getDefault, EntityDeletedEvent.create)
    ..a<UpdateAvailableEntityEvent>(32, 'updateAvailableEntity', $pb.PbFieldType.OM, UpdateAvailableEntityEvent.getDefault, UpdateAvailableEntityEvent.create)
    ..oo(0, [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32])
    ..hasRequiredFields = false
  ;

  Event() : super();
  Event.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Event.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Event clone() => new Event()..mergeFromMessage(this);
  Event copyWith(void Function(Event) updates) => super.copyWith((message) => updates(message as Event));
  $pb.BuilderInfo get info_ => _i;
  static Event create() => new Event();
  Event createEmptyInstance() => create();
  static $pb.PbList<Event> createRepeated() => new $pb.PbList<Event>();
  static Event getDefault() => _defaultInstance ??= create()..freeze();
  static Event _defaultInstance;

  Event_Body whichBody() => _Event_BodyByTag[$_whichOneof(0)];
  void clearBody() => clearField($_whichOneof(0));

  String get messageID => $_getS(0, '');
  set messageID(String v) { $_setString(0, v); }
  bool hasMessageID() => $_has(0);
  void clearMessageID() => clearField(1);

  String get sender => $_getS(1, '');
  set sender(String v) { $_setString(1, v); }
  bool hasSender() => $_has(1);
  void clearSender() => clearField(2);

  $1.Timestamp get time => $_getN(2);
  set time($1.Timestamp v) { setField(3, v); }
  bool hasTime() => $_has(2);
  void clearTime() => clearField(3);

  EntityAvailableEvent get entityAvailable => $_getN(3);
  set entityAvailable(EntityAvailableEvent v) { setField(4, v); }
  bool hasEntityAvailable() => $_has(3);
  void clearEntityAvailable() => clearField(4);

  PhysicDeviceOnlineEvent get physicDeviceOnline => $_getN(4);
  set physicDeviceOnline(PhysicDeviceOnlineEvent v) { setField(5, v); }
  bool hasPhysicDeviceOnline() => $_has(4);
  void clearPhysicDeviceOnline() => clearField(5);

  PhysicDeviceOfflineEvent get physicDeviceOffline => $_getN(5);
  set physicDeviceOffline(PhysicDeviceOfflineEvent v) { setField(6, v); }
  bool hasPhysicDeviceOffline() => $_has(5);
  void clearPhysicDeviceOffline() => clearField(6);

  DeviceKeyPressedEvent get deviceKeyPressed => $_getN(6);
  set deviceKeyPressed(DeviceKeyPressedEvent v) { setField(7, v); }
  bool hasDeviceKeyPressed() => $_has(6);
  void clearDeviceKeyPressed() => clearField(7);

  DeviceAttrReportEvent get deviceAttrReport => $_getN(7);
  set deviceAttrReport(DeviceAttrReportEvent v) { setField(8, v); }
  bool hasDeviceAttrReport() => $_has(7);
  void clearDeviceAttrReport() => clearField(8);

  OnOffStatusChangedEvent get onOffStatusChanged => $_getN(8);
  set onOffStatusChanged(OnOffStatusChangedEvent v) { setField(9, v); }
  bool hasOnOffStatusChanged() => $_has(8);
  void clearOnOffStatusChanged() => clearField(9);

  SceneCreatedEvent get sceneCreated => $_getN(9);
  set sceneCreated(SceneCreatedEvent v) { setField(10, v); }
  bool hasSceneCreated() => $_has(9);
  void clearSceneCreated() => clearField(10);

  SceneUpdatedEvent get sceneUpdated => $_getN(10);
  set sceneUpdated(SceneUpdatedEvent v) { setField(11, v); }
  bool hasSceneUpdated() => $_has(10);
  void clearSceneUpdated() => clearField(11);

  SceneDeletedEvent get sceneDeleted => $_getN(11);
  set sceneDeleted(SceneDeletedEvent v) { setField(12, v); }
  bool hasSceneDeleted() => $_has(11);
  void clearSceneDeleted() => clearField(12);

  BindingCreatedEvent get bindingCreated => $_getN(12);
  set bindingCreated(BindingCreatedEvent v) { setField(13, v); }
  bool hasBindingCreated() => $_has(12);
  void clearBindingCreated() => clearField(13);

  BindingUpdatedEvent get bindingUpdated => $_getN(13);
  set bindingUpdated(BindingUpdatedEvent v) { setField(14, v); }
  bool hasBindingUpdated() => $_has(13);
  void clearBindingUpdated() => clearField(14);

  BindingDeletedEvent get bindingDeleted => $_getN(14);
  set bindingDeleted(BindingDeletedEvent v) { setField(15, v); }
  bool hasBindingDeleted() => $_has(14);
  void clearBindingDeleted() => clearField(15);

  EntityInfoConfiguredEvent get entityInfoConfigured => $_getN(15);
  set entityInfoConfigured(EntityInfoConfiguredEvent v) { setField(16, v); }
  bool hasEntityInfoConfigured() => $_has(15);
  void clearEntityInfoConfigured() => clearField(16);

  AreaCreatedEvent get areaCreated => $_getN(16);
  set areaCreated(AreaCreatedEvent v) { setField(17, v); }
  bool hasAreaCreated() => $_has(16);
  void clearAreaCreated() => clearField(17);

  AreaRenamedEvent get areaRenamed => $_getN(17);
  set areaRenamed(AreaRenamedEvent v) { setField(18, v); }
  bool hasAreaRenamed() => $_has(17);
  void clearAreaRenamed() => clearField(18);

  AreaDeletedEvent get areaDeleted => $_getN(18);
  set areaDeleted(AreaDeletedEvent v) { setField(19, v); }
  bool hasAreaDeleted() => $_has(18);
  void clearAreaDeleted() => clearField(19);

  PermitJoinChangedEvent get permitJoinChanged => $_getN(19);
  set permitJoinChanged(PermitJoinChangedEvent v) { setField(20, v); }
  bool hasPermitJoinChanged() => $_has(19);
  void clearPermitJoinChanged() => clearField(20);

  BindingEnableChangedEvent get bindingEnableChanged => $_getN(20);
  set bindingEnableChanged(BindingEnableChangedEvent v) { setField(21, v); }
  bool hasBindingEnableChanged() => $_has(20);
  void clearBindingEnableChanged() => clearField(21);

  FirmwareUpgradeStatusChangedEvent get firmwareUpgradeStatusChanged => $_getN(21);
  set firmwareUpgradeStatusChanged(FirmwareUpgradeStatusChangedEvent v) { setField(22, v); }
  bool hasFirmwareUpgradeStatusChanged() => $_has(21);
  void clearFirmwareUpgradeStatusChanged() => clearField(22);

  UpdateRecommendFirmwareEvent get updateRecommendFirmware => $_getN(22);
  set updateRecommendFirmware(UpdateRecommendFirmwareEvent v) { setField(23, v); }
  bool hasUpdateRecommendFirmware() => $_has(22);
  void clearUpdateRecommendFirmware() => clearField(23);

  FirmwareAvailableEvent get firmwareAvailable => $_getN(23);
  set firmwareAvailable(FirmwareAvailableEvent v) { setField(24, v); }
  bool hasFirmwareAvailable() => $_has(23);
  void clearFirmwareAvailable() => clearField(24);

  DeviceAddedEvent get deviceAdded => $_getN(24);
  set deviceAdded(DeviceAddedEvent v) { setField(25, v); }
  bool hasDeviceAdded() => $_has(24);
  void clearDeviceAdded() => clearField(25);

  DeviceAssociationEvent get deviceAssociation => $_getN(25);
  set deviceAssociation(DeviceAssociationEvent v) { setField(26, v); }
  bool hasDeviceAssociation() => $_has(25);
  void clearDeviceAssociation() => clearField(26);

  PresenceEvent get presence => $_getN(26);
  set presence(PresenceEvent v) { setField(27, v); }
  bool hasPresence() => $_has(26);
  void clearPresence() => clearField(27);

  DeviceDeletedEvent get deviceDeleted => $_getN(27);
  set deviceDeleted(DeviceDeletedEvent v) { setField(28, v); }
  bool hasDeviceDeleted() => $_has(27);
  void clearDeviceDeleted() => clearField(28);

  EntityUpdatedEvent get entityUpdated => $_getN(28);
  set entityUpdated(EntityUpdatedEvent v) { setField(29, v); }
  bool hasEntityUpdated() => $_has(28);
  void clearEntityUpdated() => clearField(29);

  EntityCreatedEvent get entityCreated => $_getN(29);
  set entityCreated(EntityCreatedEvent v) { setField(30, v); }
  bool hasEntityCreated() => $_has(29);
  void clearEntityCreated() => clearField(30);

  EntityDeletedEvent get entityDeleted => $_getN(30);
  set entityDeleted(EntityDeletedEvent v) { setField(31, v); }
  bool hasEntityDeleted() => $_has(30);
  void clearEntityDeleted() => clearField(31);

  UpdateAvailableEntityEvent get updateAvailableEntity => $_getN(31);
  set updateAvailableEntity(UpdateAvailableEntityEvent v) { setField(32, v); }
  bool hasUpdateAvailableEntity() => $_has(31);
  void clearUpdateAvailableEntity() => clearField(32);
}

class EntityAvailableEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('EntityAvailableEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'entity', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  EntityAvailableEvent() : super();
  EntityAvailableEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EntityAvailableEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EntityAvailableEvent clone() => new EntityAvailableEvent()..mergeFromMessage(this);
  EntityAvailableEvent copyWith(void Function(EntityAvailableEvent) updates) => super.copyWith((message) => updates(message as EntityAvailableEvent));
  $pb.BuilderInfo get info_ => _i;
  static EntityAvailableEvent create() => new EntityAvailableEvent();
  EntityAvailableEvent createEmptyInstance() => create();
  static $pb.PbList<EntityAvailableEvent> createRepeated() => new $pb.PbList<EntityAvailableEvent>();
  static EntityAvailableEvent getDefault() => _defaultInstance ??= create()..freeze();
  static EntityAvailableEvent _defaultInstance;

  $2.LiveEntity get entity => $_getN(0);
  set entity($2.LiveEntity v) { setField(1, v); }
  bool hasEntity() => $_has(0);
  void clearEntity() => clearField(1);
}

class UpdateAvailableEntityEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateAvailableEntityEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'entity', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  UpdateAvailableEntityEvent() : super();
  UpdateAvailableEntityEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateAvailableEntityEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateAvailableEntityEvent clone() => new UpdateAvailableEntityEvent()..mergeFromMessage(this);
  UpdateAvailableEntityEvent copyWith(void Function(UpdateAvailableEntityEvent) updates) => super.copyWith((message) => updates(message as UpdateAvailableEntityEvent));
  $pb.BuilderInfo get info_ => _i;
  static UpdateAvailableEntityEvent create() => new UpdateAvailableEntityEvent();
  UpdateAvailableEntityEvent createEmptyInstance() => create();
  static $pb.PbList<UpdateAvailableEntityEvent> createRepeated() => new $pb.PbList<UpdateAvailableEntityEvent>();
  static UpdateAvailableEntityEvent getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateAvailableEntityEvent _defaultInstance;

  $2.LiveEntity get entity => $_getN(0);
  set entity($2.LiveEntity v) { setField(1, v); }
  bool hasEntity() => $_has(0);
  void clearEntity() => clearField(1);
}

class EntityUpdatedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('EntityUpdatedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'entity', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  EntityUpdatedEvent() : super();
  EntityUpdatedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EntityUpdatedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EntityUpdatedEvent clone() => new EntityUpdatedEvent()..mergeFromMessage(this);
  EntityUpdatedEvent copyWith(void Function(EntityUpdatedEvent) updates) => super.copyWith((message) => updates(message as EntityUpdatedEvent));
  $pb.BuilderInfo get info_ => _i;
  static EntityUpdatedEvent create() => new EntityUpdatedEvent();
  EntityUpdatedEvent createEmptyInstance() => create();
  static $pb.PbList<EntityUpdatedEvent> createRepeated() => new $pb.PbList<EntityUpdatedEvent>();
  static EntityUpdatedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static EntityUpdatedEvent _defaultInstance;

  $2.LiveEntity get entity => $_getN(0);
  set entity($2.LiveEntity v) { setField(1, v); }
  bool hasEntity() => $_has(0);
  void clearEntity() => clearField(1);
}

class EntityCreatedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('EntityCreatedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'entity', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  EntityCreatedEvent() : super();
  EntityCreatedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EntityCreatedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EntityCreatedEvent clone() => new EntityCreatedEvent()..mergeFromMessage(this);
  EntityCreatedEvent copyWith(void Function(EntityCreatedEvent) updates) => super.copyWith((message) => updates(message as EntityCreatedEvent));
  $pb.BuilderInfo get info_ => _i;
  static EntityCreatedEvent create() => new EntityCreatedEvent();
  EntityCreatedEvent createEmptyInstance() => create();
  static $pb.PbList<EntityCreatedEvent> createRepeated() => new $pb.PbList<EntityCreatedEvent>();
  static EntityCreatedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static EntityCreatedEvent _defaultInstance;

  $2.LiveEntity get entity => $_getN(0);
  set entity($2.LiveEntity v) { setField(1, v); }
  bool hasEntity() => $_has(0);
  void clearEntity() => clearField(1);
}

class PhysicDeviceOnlineEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PhysicDeviceOnlineEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  PhysicDeviceOnlineEvent() : super();
  PhysicDeviceOnlineEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PhysicDeviceOnlineEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PhysicDeviceOnlineEvent clone() => new PhysicDeviceOnlineEvent()..mergeFromMessage(this);
  PhysicDeviceOnlineEvent copyWith(void Function(PhysicDeviceOnlineEvent) updates) => super.copyWith((message) => updates(message as PhysicDeviceOnlineEvent));
  $pb.BuilderInfo get info_ => _i;
  static PhysicDeviceOnlineEvent create() => new PhysicDeviceOnlineEvent();
  PhysicDeviceOnlineEvent createEmptyInstance() => create();
  static $pb.PbList<PhysicDeviceOnlineEvent> createRepeated() => new $pb.PbList<PhysicDeviceOnlineEvent>();
  static PhysicDeviceOnlineEvent getDefault() => _defaultInstance ??= create()..freeze();
  static PhysicDeviceOnlineEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class PhysicDeviceOfflineEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PhysicDeviceOfflineEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOB(2, 'gone')
    ..aOS(3, 'model')
    ..aOS(4, 'name')
    ..aOS(5, 'homeCenter')
    ..hasRequiredFields = false
  ;

  PhysicDeviceOfflineEvent() : super();
  PhysicDeviceOfflineEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PhysicDeviceOfflineEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PhysicDeviceOfflineEvent clone() => new PhysicDeviceOfflineEvent()..mergeFromMessage(this);
  PhysicDeviceOfflineEvent copyWith(void Function(PhysicDeviceOfflineEvent) updates) => super.copyWith((message) => updates(message as PhysicDeviceOfflineEvent));
  $pb.BuilderInfo get info_ => _i;
  static PhysicDeviceOfflineEvent create() => new PhysicDeviceOfflineEvent();
  PhysicDeviceOfflineEvent createEmptyInstance() => create();
  static $pb.PbList<PhysicDeviceOfflineEvent> createRepeated() => new $pb.PbList<PhysicDeviceOfflineEvent>();
  static PhysicDeviceOfflineEvent getDefault() => _defaultInstance ??= create()..freeze();
  static PhysicDeviceOfflineEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  bool get gone => $_get(1, false);
  set gone(bool v) { $_setBool(1, v); }
  bool hasGone() => $_has(1);
  void clearGone() => clearField(2);

  String get model => $_getS(2, '');
  set model(String v) { $_setString(2, v); }
  bool hasModel() => $_has(2);
  void clearModel() => clearField(3);

  String get name => $_getS(3, '');
  set name(String v) { $_setString(3, v); }
  bool hasName() => $_has(3);
  void clearName() => clearField(4);

  String get homeCenter => $_getS(4, '');
  set homeCenter(String v) { $_setString(4, v); }
  bool hasHomeCenter() => $_has(4);
  void clearHomeCenter() => clearField(5);
}

class DeviceKeyPressedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeviceKeyPressedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..a<int>(2, 'sEQ', $pb.PbFieldType.O3)
    ..a<int>(3, 'times', $pb.PbFieldType.O3)
    ..e<$0.DeviceProfile>(4, 'profile', $pb.PbFieldType.OE, $0.DeviceProfile.ProfilePIR, $0.DeviceProfile.valueOf, $0.DeviceProfile.values)
    ..aOS(5, 'name')
    ..a<int>(6, 'rSSI', $pb.PbFieldType.O3)
    ..a<int>(7, 'alertLevel', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  DeviceKeyPressedEvent() : super();
  DeviceKeyPressedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeviceKeyPressedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeviceKeyPressedEvent clone() => new DeviceKeyPressedEvent()..mergeFromMessage(this);
  DeviceKeyPressedEvent copyWith(void Function(DeviceKeyPressedEvent) updates) => super.copyWith((message) => updates(message as DeviceKeyPressedEvent));
  $pb.BuilderInfo get info_ => _i;
  static DeviceKeyPressedEvent create() => new DeviceKeyPressedEvent();
  DeviceKeyPressedEvent createEmptyInstance() => create();
  static $pb.PbList<DeviceKeyPressedEvent> createRepeated() => new $pb.PbList<DeviceKeyPressedEvent>();
  static DeviceKeyPressedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static DeviceKeyPressedEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  int get sEQ => $_get(1, 0);
  set sEQ(int v) { $_setSignedInt32(1, v); }
  bool hasSEQ() => $_has(1);
  void clearSEQ() => clearField(2);

  int get times => $_get(2, 0);
  set times(int v) { $_setSignedInt32(2, v); }
  bool hasTimes() => $_has(2);
  void clearTimes() => clearField(3);

  $0.DeviceProfile get profile => $_getN(3);
  set profile($0.DeviceProfile v) { setField(4, v); }
  bool hasProfile() => $_has(3);
  void clearProfile() => clearField(4);

  String get name => $_getS(4, '');
  set name(String v) { $_setString(4, v); }
  bool hasName() => $_has(4);
  void clearName() => clearField(5);

  int get rSSI => $_get(5, 0);
  set rSSI(int v) { $_setSignedInt32(5, v); }
  bool hasRSSI() => $_has(5);
  void clearRSSI() => clearField(6);

  int get alertLevel => $_get(6, 0);
  set alertLevel(int v) { $_setSignedInt32(6, v); }
  bool hasAlertLevel() => $_has(6);
  void clearAlertLevel() => clearField(7);
}

class DeviceAttrReportEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeviceAttrReportEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..pc<$0.Attribute>(2, 'attributes', $pb.PbFieldType.PM,$0.Attribute.create)
    ..e<$0.DeviceProfile>(3, 'profile', $pb.PbFieldType.OE, $0.DeviceProfile.ProfilePIR, $0.DeviceProfile.valueOf, $0.DeviceProfile.values)
    ..aOS(4, 'name')
    ..a<int>(5, 'rSSI', $pb.PbFieldType.O3)
    ..a<int>(6, 'alertLevel', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  DeviceAttrReportEvent() : super();
  DeviceAttrReportEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeviceAttrReportEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeviceAttrReportEvent clone() => new DeviceAttrReportEvent()..mergeFromMessage(this);
  DeviceAttrReportEvent copyWith(void Function(DeviceAttrReportEvent) updates) => super.copyWith((message) => updates(message as DeviceAttrReportEvent));
  $pb.BuilderInfo get info_ => _i;
  static DeviceAttrReportEvent create() => new DeviceAttrReportEvent();
  DeviceAttrReportEvent createEmptyInstance() => create();
  static $pb.PbList<DeviceAttrReportEvent> createRepeated() => new $pb.PbList<DeviceAttrReportEvent>();
  static DeviceAttrReportEvent getDefault() => _defaultInstance ??= create()..freeze();
  static DeviceAttrReportEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  List<$0.Attribute> get attributes => $_getList(1);

  $0.DeviceProfile get profile => $_getN(2);
  set profile($0.DeviceProfile v) { setField(3, v); }
  bool hasProfile() => $_has(2);
  void clearProfile() => clearField(3);

  String get name => $_getS(3, '');
  set name(String v) { $_setString(3, v); }
  bool hasName() => $_has(3);
  void clearName() => clearField(4);

  int get rSSI => $_get(4, 0);
  set rSSI(int v) { $_setSignedInt32(4, v); }
  bool hasRSSI() => $_has(4);
  void clearRSSI() => clearField(5);

  int get alertLevel => $_get(5, 0);
  set alertLevel(int v) { $_setSignedInt32(5, v); }
  bool hasAlertLevel() => $_has(5);
  void clearAlertLevel() => clearField(6);
}

class OnOffStatusChangedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OnOffStatusChangedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOB(2, 'onOff')
    ..aOS(3, 'causer')
    ..hasRequiredFields = false
  ;

  OnOffStatusChangedEvent() : super();
  OnOffStatusChangedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OnOffStatusChangedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OnOffStatusChangedEvent clone() => new OnOffStatusChangedEvent()..mergeFromMessage(this);
  OnOffStatusChangedEvent copyWith(void Function(OnOffStatusChangedEvent) updates) => super.copyWith((message) => updates(message as OnOffStatusChangedEvent));
  $pb.BuilderInfo get info_ => _i;
  static OnOffStatusChangedEvent create() => new OnOffStatusChangedEvent();
  OnOffStatusChangedEvent createEmptyInstance() => create();
  static $pb.PbList<OnOffStatusChangedEvent> createRepeated() => new $pb.PbList<OnOffStatusChangedEvent>();
  static OnOffStatusChangedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static OnOffStatusChangedEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  bool get onOff => $_get(1, false);
  set onOff(bool v) { $_setBool(1, v); }
  bool hasOnOff() => $_has(1);
  void clearOnOff() => clearField(2);

  String get causer => $_getS(2, '');
  set causer(String v) { $_setString(2, v); }
  bool hasCauser() => $_has(2);
  void clearCauser() => clearField(3);
}

class SceneCreatedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SceneCreatedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'causer')
    ..a<$2.LiveEntity>(2, 'scene', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  SceneCreatedEvent() : super();
  SceneCreatedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SceneCreatedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SceneCreatedEvent clone() => new SceneCreatedEvent()..mergeFromMessage(this);
  SceneCreatedEvent copyWith(void Function(SceneCreatedEvent) updates) => super.copyWith((message) => updates(message as SceneCreatedEvent));
  $pb.BuilderInfo get info_ => _i;
  static SceneCreatedEvent create() => new SceneCreatedEvent();
  SceneCreatedEvent createEmptyInstance() => create();
  static $pb.PbList<SceneCreatedEvent> createRepeated() => new $pb.PbList<SceneCreatedEvent>();
  static SceneCreatedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static SceneCreatedEvent _defaultInstance;

  String get causer => $_getS(0, '');
  set causer(String v) { $_setString(0, v); }
  bool hasCauser() => $_has(0);
  void clearCauser() => clearField(1);

  $2.LiveEntity get scene => $_getN(1);
  set scene($2.LiveEntity v) { setField(2, v); }
  bool hasScene() => $_has(1);
  void clearScene() => clearField(2);
}

class SceneUpdatedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SceneUpdatedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'causer')
    ..a<$2.LiveEntity>(2, 'scene', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  SceneUpdatedEvent() : super();
  SceneUpdatedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SceneUpdatedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SceneUpdatedEvent clone() => new SceneUpdatedEvent()..mergeFromMessage(this);
  SceneUpdatedEvent copyWith(void Function(SceneUpdatedEvent) updates) => super.copyWith((message) => updates(message as SceneUpdatedEvent));
  $pb.BuilderInfo get info_ => _i;
  static SceneUpdatedEvent create() => new SceneUpdatedEvent();
  SceneUpdatedEvent createEmptyInstance() => create();
  static $pb.PbList<SceneUpdatedEvent> createRepeated() => new $pb.PbList<SceneUpdatedEvent>();
  static SceneUpdatedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static SceneUpdatedEvent _defaultInstance;

  String get causer => $_getS(0, '');
  set causer(String v) { $_setString(0, v); }
  bool hasCauser() => $_has(0);
  void clearCauser() => clearField(1);

  $2.LiveEntity get scene => $_getN(1);
  set scene($2.LiveEntity v) { setField(2, v); }
  bool hasScene() => $_has(1);
  void clearScene() => clearField(2);
}

class SceneDeletedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SceneDeletedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOS(2, 'causer')
    ..hasRequiredFields = false
  ;

  SceneDeletedEvent() : super();
  SceneDeletedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SceneDeletedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SceneDeletedEvent clone() => new SceneDeletedEvent()..mergeFromMessage(this);
  SceneDeletedEvent copyWith(void Function(SceneDeletedEvent) updates) => super.copyWith((message) => updates(message as SceneDeletedEvent));
  $pb.BuilderInfo get info_ => _i;
  static SceneDeletedEvent create() => new SceneDeletedEvent();
  SceneDeletedEvent createEmptyInstance() => create();
  static $pb.PbList<SceneDeletedEvent> createRepeated() => new $pb.PbList<SceneDeletedEvent>();
  static SceneDeletedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static SceneDeletedEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  String get causer => $_getS(1, '');
  set causer(String v) { $_setString(1, v); }
  bool hasCauser() => $_has(1);
  void clearCauser() => clearField(2);
}

class BindingCreatedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('BindingCreatedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'causer')
    ..a<$2.LiveEntity>(2, 'binding', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  BindingCreatedEvent() : super();
  BindingCreatedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  BindingCreatedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  BindingCreatedEvent clone() => new BindingCreatedEvent()..mergeFromMessage(this);
  BindingCreatedEvent copyWith(void Function(BindingCreatedEvent) updates) => super.copyWith((message) => updates(message as BindingCreatedEvent));
  $pb.BuilderInfo get info_ => _i;
  static BindingCreatedEvent create() => new BindingCreatedEvent();
  BindingCreatedEvent createEmptyInstance() => create();
  static $pb.PbList<BindingCreatedEvent> createRepeated() => new $pb.PbList<BindingCreatedEvent>();
  static BindingCreatedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static BindingCreatedEvent _defaultInstance;

  String get causer => $_getS(0, '');
  set causer(String v) { $_setString(0, v); }
  bool hasCauser() => $_has(0);
  void clearCauser() => clearField(1);

  $2.LiveEntity get binding => $_getN(1);
  set binding($2.LiveEntity v) { setField(2, v); }
  bool hasBinding() => $_has(1);
  void clearBinding() => clearField(2);
}

class BindingUpdatedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('BindingUpdatedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'causer')
    ..a<$2.LiveEntity>(2, 'binding', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  BindingUpdatedEvent() : super();
  BindingUpdatedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  BindingUpdatedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  BindingUpdatedEvent clone() => new BindingUpdatedEvent()..mergeFromMessage(this);
  BindingUpdatedEvent copyWith(void Function(BindingUpdatedEvent) updates) => super.copyWith((message) => updates(message as BindingUpdatedEvent));
  $pb.BuilderInfo get info_ => _i;
  static BindingUpdatedEvent create() => new BindingUpdatedEvent();
  BindingUpdatedEvent createEmptyInstance() => create();
  static $pb.PbList<BindingUpdatedEvent> createRepeated() => new $pb.PbList<BindingUpdatedEvent>();
  static BindingUpdatedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static BindingUpdatedEvent _defaultInstance;

  String get causer => $_getS(0, '');
  set causer(String v) { $_setString(0, v); }
  bool hasCauser() => $_has(0);
  void clearCauser() => clearField(1);

  $2.LiveEntity get binding => $_getN(1);
  set binding($2.LiveEntity v) { setField(2, v); }
  bool hasBinding() => $_has(1);
  void clearBinding() => clearField(2);
}

class BindingDeletedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('BindingDeletedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOS(2, 'causer')
    ..hasRequiredFields = false
  ;

  BindingDeletedEvent() : super();
  BindingDeletedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  BindingDeletedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  BindingDeletedEvent clone() => new BindingDeletedEvent()..mergeFromMessage(this);
  BindingDeletedEvent copyWith(void Function(BindingDeletedEvent) updates) => super.copyWith((message) => updates(message as BindingDeletedEvent));
  $pb.BuilderInfo get info_ => _i;
  static BindingDeletedEvent create() => new BindingDeletedEvent();
  BindingDeletedEvent createEmptyInstance() => create();
  static $pb.PbList<BindingDeletedEvent> createRepeated() => new $pb.PbList<BindingDeletedEvent>();
  static BindingDeletedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static BindingDeletedEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  String get causer => $_getS(1, '');
  set causer(String v) { $_setString(1, v); }
  bool hasCauser() => $_has(1);
  void clearCauser() => clearField(2);
}

class EntityInfoConfiguredEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('EntityInfoConfiguredEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOS(2, 'causer')
    ..aOS(3, 'name')
    ..aOB(4, 'isNew')
    ..aOS(5, 'areaUUID')
    ..hasRequiredFields = false
  ;

  EntityInfoConfiguredEvent() : super();
  EntityInfoConfiguredEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EntityInfoConfiguredEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EntityInfoConfiguredEvent clone() => new EntityInfoConfiguredEvent()..mergeFromMessage(this);
  EntityInfoConfiguredEvent copyWith(void Function(EntityInfoConfiguredEvent) updates) => super.copyWith((message) => updates(message as EntityInfoConfiguredEvent));
  $pb.BuilderInfo get info_ => _i;
  static EntityInfoConfiguredEvent create() => new EntityInfoConfiguredEvent();
  EntityInfoConfiguredEvent createEmptyInstance() => create();
  static $pb.PbList<EntityInfoConfiguredEvent> createRepeated() => new $pb.PbList<EntityInfoConfiguredEvent>();
  static EntityInfoConfiguredEvent getDefault() => _defaultInstance ??= create()..freeze();
  static EntityInfoConfiguredEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  String get causer => $_getS(1, '');
  set causer(String v) { $_setString(1, v); }
  bool hasCauser() => $_has(1);
  void clearCauser() => clearField(2);

  String get name => $_getS(2, '');
  set name(String v) { $_setString(2, v); }
  bool hasName() => $_has(2);
  void clearName() => clearField(3);

  bool get isNew => $_get(3, false);
  set isNew(bool v) { $_setBool(3, v); }
  bool hasIsNew() => $_has(3);
  void clearIsNew() => clearField(4);

  String get areaUUID => $_getS(4, '');
  set areaUUID(String v) { $_setString(4, v); }
  bool hasAreaUUID() => $_has(4);
  void clearAreaUUID() => clearField(5);
}

class AreaCreatedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AreaCreatedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'area', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..aOS(2, 'causer')
    ..hasRequiredFields = false
  ;

  AreaCreatedEvent() : super();
  AreaCreatedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AreaCreatedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AreaCreatedEvent clone() => new AreaCreatedEvent()..mergeFromMessage(this);
  AreaCreatedEvent copyWith(void Function(AreaCreatedEvent) updates) => super.copyWith((message) => updates(message as AreaCreatedEvent));
  $pb.BuilderInfo get info_ => _i;
  static AreaCreatedEvent create() => new AreaCreatedEvent();
  AreaCreatedEvent createEmptyInstance() => create();
  static $pb.PbList<AreaCreatedEvent> createRepeated() => new $pb.PbList<AreaCreatedEvent>();
  static AreaCreatedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static AreaCreatedEvent _defaultInstance;

  $2.LiveEntity get area => $_getN(0);
  set area($2.LiveEntity v) { setField(1, v); }
  bool hasArea() => $_has(0);
  void clearArea() => clearField(1);

  String get causer => $_getS(1, '');
  set causer(String v) { $_setString(1, v); }
  bool hasCauser() => $_has(1);
  void clearCauser() => clearField(2);
}

class AreaRenamedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AreaRenamedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'area', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..aOS(2, 'causer')
    ..hasRequiredFields = false
  ;

  AreaRenamedEvent() : super();
  AreaRenamedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AreaRenamedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AreaRenamedEvent clone() => new AreaRenamedEvent()..mergeFromMessage(this);
  AreaRenamedEvent copyWith(void Function(AreaRenamedEvent) updates) => super.copyWith((message) => updates(message as AreaRenamedEvent));
  $pb.BuilderInfo get info_ => _i;
  static AreaRenamedEvent create() => new AreaRenamedEvent();
  AreaRenamedEvent createEmptyInstance() => create();
  static $pb.PbList<AreaRenamedEvent> createRepeated() => new $pb.PbList<AreaRenamedEvent>();
  static AreaRenamedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static AreaRenamedEvent _defaultInstance;

  $2.LiveEntity get area => $_getN(0);
  set area($2.LiveEntity v) { setField(1, v); }
  bool hasArea() => $_has(0);
  void clearArea() => clearField(1);

  String get causer => $_getS(1, '');
  set causer(String v) { $_setString(1, v); }
  bool hasCauser() => $_has(1);
  void clearCauser() => clearField(2);
}

class AreaDeletedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AreaDeletedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOS(2, 'causer')
    ..hasRequiredFields = false
  ;

  AreaDeletedEvent() : super();
  AreaDeletedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AreaDeletedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AreaDeletedEvent clone() => new AreaDeletedEvent()..mergeFromMessage(this);
  AreaDeletedEvent copyWith(void Function(AreaDeletedEvent) updates) => super.copyWith((message) => updates(message as AreaDeletedEvent));
  $pb.BuilderInfo get info_ => _i;
  static AreaDeletedEvent create() => new AreaDeletedEvent();
  AreaDeletedEvent createEmptyInstance() => create();
  static $pb.PbList<AreaDeletedEvent> createRepeated() => new $pb.PbList<AreaDeletedEvent>();
  static AreaDeletedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static AreaDeletedEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  String get causer => $_getS(1, '');
  set causer(String v) { $_setString(1, v); }
  bool hasCauser() => $_has(1);
  void clearCauser() => clearField(2);
}

class DeviceAddedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeviceAddedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOS(2, 'causer')
    ..hasRequiredFields = false
  ;

  DeviceAddedEvent() : super();
  DeviceAddedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeviceAddedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeviceAddedEvent clone() => new DeviceAddedEvent()..mergeFromMessage(this);
  DeviceAddedEvent copyWith(void Function(DeviceAddedEvent) updates) => super.copyWith((message) => updates(message as DeviceAddedEvent));
  $pb.BuilderInfo get info_ => _i;
  static DeviceAddedEvent create() => new DeviceAddedEvent();
  DeviceAddedEvent createEmptyInstance() => create();
  static $pb.PbList<DeviceAddedEvent> createRepeated() => new $pb.PbList<DeviceAddedEvent>();
  static DeviceAddedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static DeviceAddedEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  String get causer => $_getS(1, '');
  set causer(String v) { $_setString(1, v); }
  bool hasCauser() => $_has(1);
  void clearCauser() => clearField(2);
}

class PermitJoinChangedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PermitJoinChangedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..a<int>(2, 'duration', $pb.PbFieldType.OU3)
    ..aOS(3, 'causer')
    ..hasRequiredFields = false
  ;

  PermitJoinChangedEvent() : super();
  PermitJoinChangedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PermitJoinChangedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PermitJoinChangedEvent clone() => new PermitJoinChangedEvent()..mergeFromMessage(this);
  PermitJoinChangedEvent copyWith(void Function(PermitJoinChangedEvent) updates) => super.copyWith((message) => updates(message as PermitJoinChangedEvent));
  $pb.BuilderInfo get info_ => _i;
  static PermitJoinChangedEvent create() => new PermitJoinChangedEvent();
  PermitJoinChangedEvent createEmptyInstance() => create();
  static $pb.PbList<PermitJoinChangedEvent> createRepeated() => new $pb.PbList<PermitJoinChangedEvent>();
  static PermitJoinChangedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static PermitJoinChangedEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  int get duration => $_get(1, 0);
  set duration(int v) { $_setUnsignedInt32(1, v); }
  bool hasDuration() => $_has(1);
  void clearDuration() => clearField(2);

  String get causer => $_getS(2, '');
  set causer(String v) { $_setString(2, v); }
  bool hasCauser() => $_has(2);
  void clearCauser() => clearField(3);
}

class BindingEnableChangedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('BindingEnableChangedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOB(2, 'enabled')
    ..aOS(3, 'causer')
    ..hasRequiredFields = false
  ;

  BindingEnableChangedEvent() : super();
  BindingEnableChangedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  BindingEnableChangedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  BindingEnableChangedEvent clone() => new BindingEnableChangedEvent()..mergeFromMessage(this);
  BindingEnableChangedEvent copyWith(void Function(BindingEnableChangedEvent) updates) => super.copyWith((message) => updates(message as BindingEnableChangedEvent));
  $pb.BuilderInfo get info_ => _i;
  static BindingEnableChangedEvent create() => new BindingEnableChangedEvent();
  BindingEnableChangedEvent createEmptyInstance() => create();
  static $pb.PbList<BindingEnableChangedEvent> createRepeated() => new $pb.PbList<BindingEnableChangedEvent>();
  static BindingEnableChangedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static BindingEnableChangedEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  bool get enabled => $_get(1, false);
  set enabled(bool v) { $_setBool(1, v); }
  bool hasEnabled() => $_has(1);
  void clearEnabled() => clearField(2);

  String get causer => $_getS(2, '');
  set causer(String v) { $_setString(2, v); }
  bool hasCauser() => $_has(2);
  void clearCauser() => clearField(3);
}

class DeviceAssociationEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeviceAssociationEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'user')
    ..aOS(2, 'by')
    ..aOS(3, 'deviceName')
    ..aOS(4, 'deviceUUID')
    ..e<$0.AssociationAction>(5, 'action', $pb.PbFieldType.OE, $0.AssociationAction.ActionShare, $0.AssociationAction.valueOf, $0.AssociationAction.values)
    ..e<$0.SubscriptionType>(6, 'status', $pb.PbFieldType.OE, $0.SubscriptionType.Unknown, $0.SubscriptionType.valueOf, $0.SubscriptionType.values)
    ..aOS(7, 'userDisplayName')
    ..aOS(8, 'byDisplayName')
    ..hasRequiredFields = false
  ;

  DeviceAssociationEvent() : super();
  DeviceAssociationEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeviceAssociationEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeviceAssociationEvent clone() => new DeviceAssociationEvent()..mergeFromMessage(this);
  DeviceAssociationEvent copyWith(void Function(DeviceAssociationEvent) updates) => super.copyWith((message) => updates(message as DeviceAssociationEvent));
  $pb.BuilderInfo get info_ => _i;
  static DeviceAssociationEvent create() => new DeviceAssociationEvent();
  DeviceAssociationEvent createEmptyInstance() => create();
  static $pb.PbList<DeviceAssociationEvent> createRepeated() => new $pb.PbList<DeviceAssociationEvent>();
  static DeviceAssociationEvent getDefault() => _defaultInstance ??= create()..freeze();
  static DeviceAssociationEvent _defaultInstance;

  String get user => $_getS(0, '');
  set user(String v) { $_setString(0, v); }
  bool hasUser() => $_has(0);
  void clearUser() => clearField(1);

  String get by => $_getS(1, '');
  set by(String v) { $_setString(1, v); }
  bool hasBy() => $_has(1);
  void clearBy() => clearField(2);

  String get deviceName => $_getS(2, '');
  set deviceName(String v) { $_setString(2, v); }
  bool hasDeviceName() => $_has(2);
  void clearDeviceName() => clearField(3);

  String get deviceUUID => $_getS(3, '');
  set deviceUUID(String v) { $_setString(3, v); }
  bool hasDeviceUUID() => $_has(3);
  void clearDeviceUUID() => clearField(4);

  $0.AssociationAction get action => $_getN(4);
  set action($0.AssociationAction v) { setField(5, v); }
  bool hasAction() => $_has(4);
  void clearAction() => clearField(5);

  $0.SubscriptionType get status => $_getN(5);
  set status($0.SubscriptionType v) { setField(6, v); }
  bool hasStatus() => $_has(5);
  void clearStatus() => clearField(6);

  String get userDisplayName => $_getS(6, '');
  set userDisplayName(String v) { $_setString(6, v); }
  bool hasUserDisplayName() => $_has(6);
  void clearUserDisplayName() => clearField(7);

  String get byDisplayName => $_getS(7, '');
  set byDisplayName(String v) { $_setString(7, v); }
  bool hasByDisplayName() => $_has(7);
  void clearByDisplayName() => clearField(8);
}

class FirmwareAvailableEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FirmwareAvailableEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  FirmwareAvailableEvent() : super();
  FirmwareAvailableEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FirmwareAvailableEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FirmwareAvailableEvent clone() => new FirmwareAvailableEvent()..mergeFromMessage(this);
  FirmwareAvailableEvent copyWith(void Function(FirmwareAvailableEvent) updates) => super.copyWith((message) => updates(message as FirmwareAvailableEvent));
  $pb.BuilderInfo get info_ => _i;
  static FirmwareAvailableEvent create() => new FirmwareAvailableEvent();
  FirmwareAvailableEvent createEmptyInstance() => create();
  static $pb.PbList<FirmwareAvailableEvent> createRepeated() => new $pb.PbList<FirmwareAvailableEvent>();
  static FirmwareAvailableEvent getDefault() => _defaultInstance ??= create()..freeze();
  static FirmwareAvailableEvent _defaultInstance;
}

class FirmwareUpgradeStatusChangedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FirmwareUpgradeStatusChangedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'deviceUUID')
    ..aOS(2, 'firmwareUUID')
    ..aOS(3, 'firmwareVersion')
    ..e<UpgradeStatus>(4, 'status', $pb.PbFieldType.OE, UpgradeStatus.UpgradeStarted, UpgradeStatus.valueOf, UpgradeStatus.values)
    ..a<int>(5, 'percent', $pb.PbFieldType.OU3)
    ..e<$0.ErrorCode>(6, 'code', $pb.PbFieldType.OE, $0.ErrorCode.EC_OK, $0.ErrorCode.valueOf, $0.ErrorCode.values)
    ..hasRequiredFields = false
  ;

  FirmwareUpgradeStatusChangedEvent() : super();
  FirmwareUpgradeStatusChangedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FirmwareUpgradeStatusChangedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FirmwareUpgradeStatusChangedEvent clone() => new FirmwareUpgradeStatusChangedEvent()..mergeFromMessage(this);
  FirmwareUpgradeStatusChangedEvent copyWith(void Function(FirmwareUpgradeStatusChangedEvent) updates) => super.copyWith((message) => updates(message as FirmwareUpgradeStatusChangedEvent));
  $pb.BuilderInfo get info_ => _i;
  static FirmwareUpgradeStatusChangedEvent create() => new FirmwareUpgradeStatusChangedEvent();
  FirmwareUpgradeStatusChangedEvent createEmptyInstance() => create();
  static $pb.PbList<FirmwareUpgradeStatusChangedEvent> createRepeated() => new $pb.PbList<FirmwareUpgradeStatusChangedEvent>();
  static FirmwareUpgradeStatusChangedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static FirmwareUpgradeStatusChangedEvent _defaultInstance;

  String get deviceUUID => $_getS(0, '');
  set deviceUUID(String v) { $_setString(0, v); }
  bool hasDeviceUUID() => $_has(0);
  void clearDeviceUUID() => clearField(1);

  String get firmwareUUID => $_getS(1, '');
  set firmwareUUID(String v) { $_setString(1, v); }
  bool hasFirmwareUUID() => $_has(1);
  void clearFirmwareUUID() => clearField(2);

  String get firmwareVersion => $_getS(2, '');
  set firmwareVersion(String v) { $_setString(2, v); }
  bool hasFirmwareVersion() => $_has(2);
  void clearFirmwareVersion() => clearField(3);

  UpgradeStatus get status => $_getN(3);
  set status(UpgradeStatus v) { setField(4, v); }
  bool hasStatus() => $_has(3);
  void clearStatus() => clearField(4);

  int get percent => $_get(4, 0);
  set percent(int v) { $_setUnsignedInt32(4, v); }
  bool hasPercent() => $_has(4);
  void clearPercent() => clearField(5);

  $0.ErrorCode get code => $_getN(5);
  set code($0.ErrorCode v) { setField(6, v); }
  bool hasCode() => $_has(5);
  void clearCode() => clearField(6);
}

class UpdateRecommendFirmwareEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateRecommendFirmwareEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'firmwareUUID')
    ..aOS(2, 'deviceUUID')
    ..hasRequiredFields = false
  ;

  UpdateRecommendFirmwareEvent() : super();
  UpdateRecommendFirmwareEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateRecommendFirmwareEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateRecommendFirmwareEvent clone() => new UpdateRecommendFirmwareEvent()..mergeFromMessage(this);
  UpdateRecommendFirmwareEvent copyWith(void Function(UpdateRecommendFirmwareEvent) updates) => super.copyWith((message) => updates(message as UpdateRecommendFirmwareEvent));
  $pb.BuilderInfo get info_ => _i;
  static UpdateRecommendFirmwareEvent create() => new UpdateRecommendFirmwareEvent();
  UpdateRecommendFirmwareEvent createEmptyInstance() => create();
  static $pb.PbList<UpdateRecommendFirmwareEvent> createRepeated() => new $pb.PbList<UpdateRecommendFirmwareEvent>();
  static UpdateRecommendFirmwareEvent getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateRecommendFirmwareEvent _defaultInstance;

  String get firmwareUUID => $_getS(0, '');
  set firmwareUUID(String v) { $_setString(0, v); }
  bool hasFirmwareUUID() => $_has(0);
  void clearFirmwareUUID() => clearField(1);

  String get deviceUUID => $_getS(1, '');
  set deviceUUID(String v) { $_setString(1, v); }
  bool hasDeviceUUID() => $_has(1);
  void clearDeviceUUID() => clearField(2);
}

class PresenceEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PresenceEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'username')
    ..aOB(2, 'online')
    ..aOS(3, 'resource')
    ..aOS(4, 'name')
    ..hasRequiredFields = false
  ;

  PresenceEvent() : super();
  PresenceEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PresenceEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PresenceEvent clone() => new PresenceEvent()..mergeFromMessage(this);
  PresenceEvent copyWith(void Function(PresenceEvent) updates) => super.copyWith((message) => updates(message as PresenceEvent));
  $pb.BuilderInfo get info_ => _i;
  static PresenceEvent create() => new PresenceEvent();
  PresenceEvent createEmptyInstance() => create();
  static $pb.PbList<PresenceEvent> createRepeated() => new $pb.PbList<PresenceEvent>();
  static PresenceEvent getDefault() => _defaultInstance ??= create()..freeze();
  static PresenceEvent _defaultInstance;

  String get username => $_getS(0, '');
  set username(String v) { $_setString(0, v); }
  bool hasUsername() => $_has(0);
  void clearUsername() => clearField(1);

  bool get online => $_get(1, false);
  set online(bool v) { $_setBool(1, v); }
  bool hasOnline() => $_has(1);
  void clearOnline() => clearField(2);

  String get resource => $_getS(2, '');
  set resource(String v) { $_setString(2, v); }
  bool hasResource() => $_has(2);
  void clearResource() => clearField(3);

  String get name => $_getS(3, '');
  set name(String v) { $_setString(3, v); }
  bool hasName() => $_has(3);
  void clearName() => clearField(4);
}

class DeviceDeletedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeviceDeletedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOS(2, 'causer')
    ..hasRequiredFields = false
  ;

  DeviceDeletedEvent() : super();
  DeviceDeletedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeviceDeletedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeviceDeletedEvent clone() => new DeviceDeletedEvent()..mergeFromMessage(this);
  DeviceDeletedEvent copyWith(void Function(DeviceDeletedEvent) updates) => super.copyWith((message) => updates(message as DeviceDeletedEvent));
  $pb.BuilderInfo get info_ => _i;
  static DeviceDeletedEvent create() => new DeviceDeletedEvent();
  DeviceDeletedEvent createEmptyInstance() => create();
  static $pb.PbList<DeviceDeletedEvent> createRepeated() => new $pb.PbList<DeviceDeletedEvent>();
  static DeviceDeletedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static DeviceDeletedEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  String get causer => $_getS(1, '');
  set causer(String v) { $_setString(1, v); }
  bool hasCauser() => $_has(1);
  void clearCauser() => clearField(2);
}

class EntityDeletedEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('EntityDeletedEvent', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOS(2, 'causer')
    ..hasRequiredFields = false
  ;

  EntityDeletedEvent() : super();
  EntityDeletedEvent.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EntityDeletedEvent.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EntityDeletedEvent clone() => new EntityDeletedEvent()..mergeFromMessage(this);
  EntityDeletedEvent copyWith(void Function(EntityDeletedEvent) updates) => super.copyWith((message) => updates(message as EntityDeletedEvent));
  $pb.BuilderInfo get info_ => _i;
  static EntityDeletedEvent create() => new EntityDeletedEvent();
  EntityDeletedEvent createEmptyInstance() => create();
  static $pb.PbList<EntityDeletedEvent> createRepeated() => new $pb.PbList<EntityDeletedEvent>();
  static EntityDeletedEvent getDefault() => _defaultInstance ??= create()..freeze();
  static EntityDeletedEvent _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  String get causer => $_getS(1, '');
  set causer(String v) { $_setString(1, v); }
  bool hasCauser() => $_has(1);
  void clearCauser() => clearField(2);
}

