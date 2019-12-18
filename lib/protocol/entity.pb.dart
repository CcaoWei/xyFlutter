///
//  Generated code. Do not modify.
//  source: entity.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'const.pb.dart' as $0;

import 'entity.pbenum.dart';
import 'const.pbenum.dart' as $0;

export 'entity.pbenum.dart';

enum LiveEntity_Entity {
  entityDevice, 
  entityArea, 
  entityBinding, 
  entityScene, 
  entityFirmware, 
  entityZigbeeSystem, 
  entityAutomation, 
  entityAutomationSet, 
  notSet
}

class LiveEntity extends $pb.GeneratedMessage {
  static const Map<int, LiveEntity_Entity> _LiveEntity_EntityByTag = {
    8 : LiveEntity_Entity.entityDevice,
    9 : LiveEntity_Entity.entityArea,
    10 : LiveEntity_Entity.entityBinding,
    11 : LiveEntity_Entity.entityScene,
    12 : LiveEntity_Entity.entityFirmware,
    13 : LiveEntity_Entity.entityZigbeeSystem,
    14 : LiveEntity_Entity.entityAutomation,
    15 : LiveEntity_Entity.entityAutomationSet,
    0 : LiveEntity_Entity.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LiveEntity', package: const $pb.PackageName('xiaoyan.protocol'))
    ..e<EntityBaseType>(1, 'baseType', $pb.PbFieldType.OE, EntityBaseType.BaseTypeUnknown, EntityBaseType.valueOf, EntityBaseType.values)
    ..aOS(2, 'uUID')
    ..aOS(3, 'name')
    ..aOS(4, 'areaUUID')
    ..aOB(5, 'new_5')
    ..e<DeleteState>(6, 'deleteState', $pb.PbFieldType.OE, DeleteState.InUse, DeleteState.valueOf, DeleteState.values)
    ..pc<$0.Attribute>(7, 'attributes', $pb.PbFieldType.PM,$0.Attribute.create)
    ..a<PhysicDevice>(8, 'entityDevice', $pb.PbFieldType.OM, PhysicDevice.getDefault, PhysicDevice.create)
    ..a<Area>(9, 'entityArea', $pb.PbFieldType.OM, Area.getDefault, Area.create)
    ..a<Binding>(10, 'entityBinding', $pb.PbFieldType.OM, Binding.getDefault, Binding.create)
    ..a<Scene>(11, 'entityScene', $pb.PbFieldType.OM, Scene.getDefault, Scene.create)
    ..a<Firmware>(12, 'entityFirmware', $pb.PbFieldType.OM, Firmware.getDefault, Firmware.create)
    ..a<ZigbeeSystem>(13, 'entityZigbeeSystem', $pb.PbFieldType.OM, ZigbeeSystem.getDefault, ZigbeeSystem.create)
    ..a<Automation>(14, 'entityAutomation', $pb.PbFieldType.OM, Automation.getDefault, Automation.create)
    ..a<AutomationSet>(15, 'entityAutomationSet', $pb.PbFieldType.OM, AutomationSet.getDefault, AutomationSet.create)
    ..oo(0, [8, 9, 10, 11, 12, 13, 14, 15])
    ..hasRequiredFields = false
  ;

  LiveEntity() : super();
  LiveEntity.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LiveEntity.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LiveEntity clone() => new LiveEntity()..mergeFromMessage(this);
  LiveEntity copyWith(void Function(LiveEntity) updates) => super.copyWith((message) => updates(message as LiveEntity));
  $pb.BuilderInfo get info_ => _i;
  static LiveEntity create() => new LiveEntity();
  LiveEntity createEmptyInstance() => create();
  static $pb.PbList<LiveEntity> createRepeated() => new $pb.PbList<LiveEntity>();
  static LiveEntity getDefault() => _defaultInstance ??= create()..freeze();
  static LiveEntity _defaultInstance;

  LiveEntity_Entity whichEntity() => _LiveEntity_EntityByTag[$_whichOneof(0)];
  void clearEntity() => clearField($_whichOneof(0));

  EntityBaseType get baseType => $_getN(0);
  set baseType(EntityBaseType v) { setField(1, v); }
  bool hasBaseType() => $_has(0);
  void clearBaseType() => clearField(1);

  String get uUID => $_getS(1, '');
  set uUID(String v) { $_setString(1, v); }
  bool hasUUID() => $_has(1);
  void clearUUID() => clearField(2);

  String get name => $_getS(2, '');
  set name(String v) { $_setString(2, v); }
  bool hasName() => $_has(2);
  void clearName() => clearField(3);

  String get areaUUID => $_getS(3, '');
  set areaUUID(String v) { $_setString(3, v); }
  bool hasAreaUUID() => $_has(3);
  void clearAreaUUID() => clearField(4);

  bool get new_5 => $_get(4, false);
  set new_5(bool v) { $_setBool(4, v); }
  bool hasNew_5() => $_has(4);
  void clearNew_5() => clearField(5);

  DeleteState get deleteState => $_getN(5);
  set deleteState(DeleteState v) { setField(6, v); }
  bool hasDeleteState() => $_has(5);
  void clearDeleteState() => clearField(6);

  List<$0.Attribute> get attributes => $_getList(6);

  PhysicDevice get entityDevice => $_getN(7);
  set entityDevice(PhysicDevice v) { setField(8, v); }
  bool hasEntityDevice() => $_has(7);
  void clearEntityDevice() => clearField(8);

  Area get entityArea => $_getN(8);
  set entityArea(Area v) { setField(9, v); }
  bool hasEntityArea() => $_has(8);
  void clearEntityArea() => clearField(9);

  Binding get entityBinding => $_getN(9);
  set entityBinding(Binding v) { setField(10, v); }
  bool hasEntityBinding() => $_has(9);
  void clearEntityBinding() => clearField(10);

  Scene get entityScene => $_getN(10);
  set entityScene(Scene v) { setField(11, v); }
  bool hasEntityScene() => $_has(10);
  void clearEntityScene() => clearField(11);

  Firmware get entityFirmware => $_getN(11);
  set entityFirmware(Firmware v) { setField(12, v); }
  bool hasEntityFirmware() => $_has(11);
  void clearEntityFirmware() => clearField(12);

  ZigbeeSystem get entityZigbeeSystem => $_getN(12);
  set entityZigbeeSystem(ZigbeeSystem v) { setField(13, v); }
  bool hasEntityZigbeeSystem() => $_has(12);
  void clearEntityZigbeeSystem() => clearField(13);

  Automation get entityAutomation => $_getN(13);
  set entityAutomation(Automation v) { setField(14, v); }
  bool hasEntityAutomation() => $_has(13);
  void clearEntityAutomation() => clearField(14);

  AutomationSet get entityAutomationSet => $_getN(14);
  set entityAutomationSet(AutomationSet v) { setField(15, v); }
  bool hasEntityAutomationSet() => $_has(14);
  void clearEntityAutomationSet() => clearField(15);
}

class LogicDevice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LogicDevice', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..e<$0.DeviceProfile>(2, 'profile', $pb.PbFieldType.OE, $0.DeviceProfile.ProfilePIR, $0.DeviceProfile.valueOf, $0.DeviceProfile.values)
    ..aOS(3, 'name')
    ..pc<$0.Attribute>(4, 'attributes', $pb.PbFieldType.PM,$0.Attribute.create)
    ..aOS(5, 'areaUUID')
    ..hasRequiredFields = false
  ;

  LogicDevice() : super();
  LogicDevice.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LogicDevice.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LogicDevice clone() => new LogicDevice()..mergeFromMessage(this);
  LogicDevice copyWith(void Function(LogicDevice) updates) => super.copyWith((message) => updates(message as LogicDevice));
  $pb.BuilderInfo get info_ => _i;
  static LogicDevice create() => new LogicDevice();
  LogicDevice createEmptyInstance() => create();
  static $pb.PbList<LogicDevice> createRepeated() => new $pb.PbList<LogicDevice>();
  static LogicDevice getDefault() => _defaultInstance ??= create()..freeze();
  static LogicDevice _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  $0.DeviceProfile get profile => $_getN(1);
  set profile($0.DeviceProfile v) { setField(2, v); }
  bool hasProfile() => $_has(1);
  void clearProfile() => clearField(2);

  String get name => $_getS(2, '');
  set name(String v) { $_setString(2, v); }
  bool hasName() => $_has(2);
  void clearName() => clearField(3);

  List<$0.Attribute> get attributes => $_getList(3);

  String get areaUUID => $_getS(4, '');
  set areaUUID(String v) { $_setString(4, v); }
  bool hasAreaUUID() => $_has(4);
  void clearAreaUUID() => clearField(5);
}

class PhysicDevice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PhysicDevice', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'model')
    ..aOB(2, 'online')
    ..aOB(3, 'available')
    ..pc<LogicDevice>(4, 'logicDevices', $pb.PbFieldType.PM,LogicDevice.create)
    ..a<int>(5, 'upgradingPercentage', $pb.PbFieldType.O3)
    ..aOS(6, 'upgradingFirmwareUUID')
    ..aOS(7, 'recommendFirmwareUUID')
    ..a<int>(8, 'recommendFirmwareVersion', $pb.PbFieldType.O3)
    ..aOB(9, 'isNew')
    ..hasRequiredFields = false
  ;

  PhysicDevice() : super();
  PhysicDevice.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PhysicDevice.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PhysicDevice clone() => new PhysicDevice()..mergeFromMessage(this);
  PhysicDevice copyWith(void Function(PhysicDevice) updates) => super.copyWith((message) => updates(message as PhysicDevice));
  $pb.BuilderInfo get info_ => _i;
  static PhysicDevice create() => new PhysicDevice();
  PhysicDevice createEmptyInstance() => create();
  static $pb.PbList<PhysicDevice> createRepeated() => new $pb.PbList<PhysicDevice>();
  static PhysicDevice getDefault() => _defaultInstance ??= create()..freeze();
  static PhysicDevice _defaultInstance;

  String get model => $_getS(0, '');
  set model(String v) { $_setString(0, v); }
  bool hasModel() => $_has(0);
  void clearModel() => clearField(1);

  bool get online => $_get(1, false);
  set online(bool v) { $_setBool(1, v); }
  bool hasOnline() => $_has(1);
  void clearOnline() => clearField(2);

  bool get available => $_get(2, false);
  set available(bool v) { $_setBool(2, v); }
  bool hasAvailable() => $_has(2);
  void clearAvailable() => clearField(3);

  List<LogicDevice> get logicDevices => $_getList(3);

  int get upgradingPercentage => $_get(4, 0);
  set upgradingPercentage(int v) { $_setSignedInt32(4, v); }
  bool hasUpgradingPercentage() => $_has(4);
  void clearUpgradingPercentage() => clearField(5);

  String get upgradingFirmwareUUID => $_getS(5, '');
  set upgradingFirmwareUUID(String v) { $_setString(5, v); }
  bool hasUpgradingFirmwareUUID() => $_has(5);
  void clearUpgradingFirmwareUUID() => clearField(6);

  String get recommendFirmwareUUID => $_getS(6, '');
  set recommendFirmwareUUID(String v) { $_setString(6, v); }
  bool hasRecommendFirmwareUUID() => $_has(6);
  void clearRecommendFirmwareUUID() => clearField(7);

  int get recommendFirmwareVersion => $_get(7, 0);
  set recommendFirmwareVersion(int v) { $_setSignedInt32(7, v); }
  bool hasRecommendFirmwareVersion() => $_has(7);
  void clearRecommendFirmwareVersion() => clearField(8);

  bool get isNew => $_get(8, false);
  set isNew(bool v) { $_setBool(8, v); }
  bool hasIsNew() => $_has(8);
  void clearIsNew() => clearField(9);
}

class Area extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Area', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  Area() : super();
  Area.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Area.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Area clone() => new Area()..mergeFromMessage(this);
  Area copyWith(void Function(Area) updates) => super.copyWith((message) => updates(message as Area));
  $pb.BuilderInfo get info_ => _i;
  static Area create() => new Area();
  Area createEmptyInstance() => create();
  static $pb.PbList<Area> createRepeated() => new $pb.PbList<Area>();
  static Area getDefault() => _defaultInstance ??= create()..freeze();
  static Area _defaultInstance;
}

class Action extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Action', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..e<$0.AttributeID>(2, 'attrID', $pb.PbFieldType.OE, $0.AttributeID.AttrIDOnOffStatus, $0.AttributeID.valueOf, $0.AttributeID.values)
    ..a<int>(3, 'attrValue', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Action() : super();
  Action.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Action.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Action clone() => new Action()..mergeFromMessage(this);
  Action copyWith(void Function(Action) updates) => super.copyWith((message) => updates(message as Action));
  $pb.BuilderInfo get info_ => _i;
  static Action create() => new Action();
  Action createEmptyInstance() => create();
  static $pb.PbList<Action> createRepeated() => new $pb.PbList<Action>();
  static Action getDefault() => _defaultInstance ??= create()..freeze();
  static Action _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  $0.AttributeID get attrID => $_getN(1);
  set attrID($0.AttributeID v) { setField(2, v); }
  bool hasAttrID() => $_has(1);
  void clearAttrID() => clearField(2);

  int get attrValue => $_get(2, 0);
  set attrValue(int v) { $_setSignedInt32(2, v); }
  bool hasAttrValue() => $_has(2);
  void clearAttrValue() => clearField(3);
}

class Binding extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Binding', package: const $pb.PackageName('xiaoyan.protocol'))
    ..e<$0.BindingType>(1, 'type', $pb.PbFieldType.OE, $0.BindingType.Invalid, $0.BindingType.valueOf, $0.BindingType.values)
    ..aOB(2, 'enabled')
    ..aOS(3, 'triggerAddress')
    ..pc<Action>(4, 'actions', $pb.PbFieldType.PM,Action.create)
    ..a<int>(5, 'parameter', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Binding() : super();
  Binding.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Binding.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Binding clone() => new Binding()..mergeFromMessage(this);
  Binding copyWith(void Function(Binding) updates) => super.copyWith((message) => updates(message as Binding));
  $pb.BuilderInfo get info_ => _i;
  static Binding create() => new Binding();
  Binding createEmptyInstance() => create();
  static $pb.PbList<Binding> createRepeated() => new $pb.PbList<Binding>();
  static Binding getDefault() => _defaultInstance ??= create()..freeze();
  static Binding _defaultInstance;

  $0.BindingType get type => $_getN(0);
  set type($0.BindingType v) { setField(1, v); }
  bool hasType() => $_has(0);
  void clearType() => clearField(1);

  bool get enabled => $_get(1, false);
  set enabled(bool v) { $_setBool(1, v); }
  bool hasEnabled() => $_has(1);
  void clearEnabled() => clearField(2);

  String get triggerAddress => $_getS(2, '');
  set triggerAddress(String v) { $_setString(2, v); }
  bool hasTriggerAddress() => $_has(2);
  void clearTriggerAddress() => clearField(3);

  List<Action> get actions => $_getList(3);

  int get parameter => $_get(4, 0);
  set parameter(int v) { $_setSignedInt32(4, v); }
  bool hasParameter() => $_has(4);
  void clearParameter() => clearField(5);
}

class ZigbeeSystem extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ZigbeeSystem', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOB(1, 'available')
    ..a<int>(2, 'panId', $pb.PbFieldType.OU3)
    ..a<int>(3, 'channel', $pb.PbFieldType.OU3)
    ..a<int>(4, 'version', $pb.PbFieldType.OU3)
    ..a<int>(5, 'permitJoinDuration', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  ZigbeeSystem() : super();
  ZigbeeSystem.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ZigbeeSystem.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ZigbeeSystem clone() => new ZigbeeSystem()..mergeFromMessage(this);
  ZigbeeSystem copyWith(void Function(ZigbeeSystem) updates) => super.copyWith((message) => updates(message as ZigbeeSystem));
  $pb.BuilderInfo get info_ => _i;
  static ZigbeeSystem create() => new ZigbeeSystem();
  ZigbeeSystem createEmptyInstance() => create();
  static $pb.PbList<ZigbeeSystem> createRepeated() => new $pb.PbList<ZigbeeSystem>();
  static ZigbeeSystem getDefault() => _defaultInstance ??= create()..freeze();
  static ZigbeeSystem _defaultInstance;

  bool get available => $_get(0, false);
  set available(bool v) { $_setBool(0, v); }
  bool hasAvailable() => $_has(0);
  void clearAvailable() => clearField(1);

  int get panId => $_get(1, 0);
  set panId(int v) { $_setUnsignedInt32(1, v); }
  bool hasPanId() => $_has(1);
  void clearPanId() => clearField(2);

  int get channel => $_get(2, 0);
  set channel(int v) { $_setUnsignedInt32(2, v); }
  bool hasChannel() => $_has(2);
  void clearChannel() => clearField(3);

  int get version => $_get(3, 0);
  set version(int v) { $_setUnsignedInt32(3, v); }
  bool hasVersion() => $_has(3);
  void clearVersion() => clearField(4);

  int get permitJoinDuration => $_get(4, 0);
  set permitJoinDuration(int v) { $_setUnsignedInt32(4, v); }
  bool hasPermitJoinDuration() => $_has(4);
  void clearPermitJoinDuration() => clearField(5);
}

class Firmware extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Firmware', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'systemUUID')
    ..aOS(2, 'imageModel')
    ..a<int>(3, 'version', $pb.PbFieldType.O3)
    ..pPS(4, 'suitableDevices')
    ..hasRequiredFields = false
  ;

  Firmware() : super();
  Firmware.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Firmware.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Firmware clone() => new Firmware()..mergeFromMessage(this);
  Firmware copyWith(void Function(Firmware) updates) => super.copyWith((message) => updates(message as Firmware));
  $pb.BuilderInfo get info_ => _i;
  static Firmware create() => new Firmware();
  Firmware createEmptyInstance() => create();
  static $pb.PbList<Firmware> createRepeated() => new $pb.PbList<Firmware>();
  static Firmware getDefault() => _defaultInstance ??= create()..freeze();
  static Firmware _defaultInstance;

  String get systemUUID => $_getS(0, '');
  set systemUUID(String v) { $_setString(0, v); }
  bool hasSystemUUID() => $_has(0);
  void clearSystemUUID() => clearField(1);

  String get imageModel => $_getS(1, '');
  set imageModel(String v) { $_setString(1, v); }
  bool hasImageModel() => $_has(1);
  void clearImageModel() => clearField(2);

  int get version => $_get(2, 0);
  set version(int v) { $_setSignedInt32(2, v); }
  bool hasVersion() => $_has(2);
  void clearVersion() => clearField(3);

  List<String> get suitableDevices => $_getList(3);
}

class Scene extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Scene', package: const $pb.PackageName('xiaoyan.protocol'))
    ..pc<Action>(1, 'actions', $pb.PbFieldType.PM,Action.create)
    ..hasRequiredFields = false
  ;

  Scene() : super();
  Scene.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Scene.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Scene clone() => new Scene()..mergeFromMessage(this);
  Scene copyWith(void Function(Scene) updates) => super.copyWith((message) => updates(message as Scene));
  $pb.BuilderInfo get info_ => _i;
  static Scene create() => new Scene();
  Scene createEmptyInstance() => create();
  static $pb.PbList<Scene> createRepeated() => new $pb.PbList<Scene>();
  static Scene getDefault() => _defaultInstance ??= create()..freeze();
  static Scene _defaultInstance;

  List<Action> get actions => $_getList(0);
}

class Range extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Range', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<int>(1, 'begin', $pb.PbFieldType.O3)
    ..a<int>(2, 'end', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Range() : super();
  Range.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Range.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Range clone() => new Range()..mergeFromMessage(this);
  Range copyWith(void Function(Range) updates) => super.copyWith((message) => updates(message as Range));
  $pb.BuilderInfo get info_ => _i;
  static Range create() => new Range();
  Range createEmptyInstance() => create();
  static $pb.PbList<Range> createRepeated() => new $pb.PbList<Range>();
  static Range getDefault() => _defaultInstance ??= create()..freeze();
  static Range _defaultInstance;

  int get begin => $_get(0, 0);
  set begin(int v) { $_setSignedInt32(0, v); }
  bool hasBegin() => $_has(0);
  void clearBegin() => clearField(1);

  int get end => $_get(1, 0);
  set end(int v) { $_setSignedInt32(1, v); }
  bool hasEnd() => $_has(1);
  void clearEnd() => clearField(2);
}

class DayTime extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DayTime', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<int>(1, 'hour', $pb.PbFieldType.O3)
    ..a<int>(2, 'min', $pb.PbFieldType.O3)
    ..a<int>(3, 'sec', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  DayTime() : super();
  DayTime.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DayTime.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DayTime clone() => new DayTime()..mergeFromMessage(this);
  DayTime copyWith(void Function(DayTime) updates) => super.copyWith((message) => updates(message as DayTime));
  $pb.BuilderInfo get info_ => _i;
  static DayTime create() => new DayTime();
  DayTime createEmptyInstance() => create();
  static $pb.PbList<DayTime> createRepeated() => new $pb.PbList<DayTime>();
  static DayTime getDefault() => _defaultInstance ??= create()..freeze();
  static DayTime _defaultInstance;

  int get hour => $_get(0, 0);
  set hour(int v) { $_setSignedInt32(0, v); }
  bool hasHour() => $_has(0);
  void clearHour() => clearField(1);

  int get min => $_get(1, 0);
  set min(int v) { $_setSignedInt32(1, v); }
  bool hasMin() => $_has(1);
  void clearMin() => clearField(2);

  int get sec => $_get(2, 0);
  set sec(int v) { $_setSignedInt32(2, v); }
  bool hasSec() => $_has(2);
  void clearSec() => clearField(3);
}

class DayTimeRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DayTimeRange', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<DayTime>(1, 'begin', $pb.PbFieldType.OM, DayTime.getDefault, DayTime.create)
    ..a<DayTime>(2, 'end', $pb.PbFieldType.OM, DayTime.getDefault, DayTime.create)
    ..hasRequiredFields = false
  ;

  DayTimeRange() : super();
  DayTimeRange.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DayTimeRange.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DayTimeRange clone() => new DayTimeRange()..mergeFromMessage(this);
  DayTimeRange copyWith(void Function(DayTimeRange) updates) => super.copyWith((message) => updates(message as DayTimeRange));
  $pb.BuilderInfo get info_ => _i;
  static DayTimeRange create() => new DayTimeRange();
  DayTimeRange createEmptyInstance() => create();
  static $pb.PbList<DayTimeRange> createRepeated() => new $pb.PbList<DayTimeRange>();
  static DayTimeRange getDefault() => _defaultInstance ??= create()..freeze();
  static DayTimeRange _defaultInstance;

  DayTime get begin => $_getN(0);
  set begin(DayTime v) { setField(1, v); }
  bool hasBegin() => $_has(0);
  void clearBegin() => clearField(1);

  DayTime get end => $_getN(1);
  set end(DayTime v) { setField(2, v); }
  bool hasEnd() => $_has(1);
  void clearEnd() => clearField(2);
}

class AngularCondition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AngularCondition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..a<Range>(2, 'angleRange', $pb.PbFieldType.OM, Range.getDefault, Range.create)
    ..hasRequiredFields = false
  ;

  AngularCondition() : super();
  AngularCondition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AngularCondition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AngularCondition clone() => new AngularCondition()..mergeFromMessage(this);
  AngularCondition copyWith(void Function(AngularCondition) updates) => super.copyWith((message) => updates(message as AngularCondition));
  $pb.BuilderInfo get info_ => _i;
  static AngularCondition create() => new AngularCondition();
  AngularCondition createEmptyInstance() => create();
  static $pb.PbList<AngularCondition> createRepeated() => new $pb.PbList<AngularCondition>();
  static AngularCondition getDefault() => _defaultInstance ??= create()..freeze();
  static AngularCondition _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  Range get angleRange => $_getN(1);
  set angleRange(Range v) { setField(2, v); }
  bool hasAngleRange() => $_has(1);
  void clearAngleRange() => clearField(2);
}

class KeypressCondition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('KeypressCondition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..a<int>(2, 'pressedTimes', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  KeypressCondition() : super();
  KeypressCondition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  KeypressCondition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  KeypressCondition clone() => new KeypressCondition()..mergeFromMessage(this);
  KeypressCondition copyWith(void Function(KeypressCondition) updates) => super.copyWith((message) => updates(message as KeypressCondition));
  $pb.BuilderInfo get info_ => _i;
  static KeypressCondition create() => new KeypressCondition();
  KeypressCondition createEmptyInstance() => create();
  static $pb.PbList<KeypressCondition> createRepeated() => new $pb.PbList<KeypressCondition>();
  static KeypressCondition getDefault() => _defaultInstance ??= create()..freeze();
  static KeypressCondition _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  int get pressedTimes => $_get(1, 0);
  set pressedTimes(int v) { $_setSignedInt32(1, v); }
  bool hasPressedTimes() => $_has(1);
  void clearPressedTimes() => clearField(2);
}

class AttributeVariationCondition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AttributeVariationCondition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..e<$0.AttributeID>(2, 'attrID', $pb.PbFieldType.OE, $0.AttributeID.AttrIDOnOffStatus, $0.AttributeID.valueOf, $0.AttributeID.values)
    ..a<Range>(3, 'sourceRange', $pb.PbFieldType.OM, Range.getDefault, Range.create)
    ..a<Range>(4, 'targetRange', $pb.PbFieldType.OM, Range.getDefault, Range.create)
    ..aInt64(5, 'keepTimeMS')
    ..aOB(6, 'needCapture')
    ..hasRequiredFields = false
  ;

  AttributeVariationCondition() : super();
  AttributeVariationCondition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AttributeVariationCondition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AttributeVariationCondition clone() => new AttributeVariationCondition()..mergeFromMessage(this);
  AttributeVariationCondition copyWith(void Function(AttributeVariationCondition) updates) => super.copyWith((message) => updates(message as AttributeVariationCondition));
  $pb.BuilderInfo get info_ => _i;
  static AttributeVariationCondition create() => new AttributeVariationCondition();
  AttributeVariationCondition createEmptyInstance() => create();
  static $pb.PbList<AttributeVariationCondition> createRepeated() => new $pb.PbList<AttributeVariationCondition>();
  static AttributeVariationCondition getDefault() => _defaultInstance ??= create()..freeze();
  static AttributeVariationCondition _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  $0.AttributeID get attrID => $_getN(1);
  set attrID($0.AttributeID v) { setField(2, v); }
  bool hasAttrID() => $_has(1);
  void clearAttrID() => clearField(2);

  Range get sourceRange => $_getN(2);
  set sourceRange(Range v) { setField(3, v); }
  bool hasSourceRange() => $_has(2);
  void clearSourceRange() => clearField(3);

  Range get targetRange => $_getN(3);
  set targetRange(Range v) { setField(4, v); }
  bool hasTargetRange() => $_has(3);
  void clearTargetRange() => clearField(4);

  Int64 get keepTimeMS => $_getI64(4);
  set keepTimeMS(Int64 v) { $_setInt64(4, v); }
  bool hasKeepTimeMS() => $_has(4);
  void clearKeepTimeMS() => clearField(5);

  bool get needCapture => $_get(5, false);
  set needCapture(bool v) { $_setBool(5, v); }
  bool hasNeedCapture() => $_has(5);
  void clearNeedCapture() => clearField(6);
}

class WithinPeriodCondition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('WithinPeriodCondition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aInt64(1, 'periodMS')
    ..hasRequiredFields = false
  ;

  WithinPeriodCondition() : super();
  WithinPeriodCondition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  WithinPeriodCondition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  WithinPeriodCondition clone() => new WithinPeriodCondition()..mergeFromMessage(this);
  WithinPeriodCondition copyWith(void Function(WithinPeriodCondition) updates) => super.copyWith((message) => updates(message as WithinPeriodCondition));
  $pb.BuilderInfo get info_ => _i;
  static WithinPeriodCondition create() => new WithinPeriodCondition();
  WithinPeriodCondition createEmptyInstance() => create();
  static $pb.PbList<WithinPeriodCondition> createRepeated() => new $pb.PbList<WithinPeriodCondition>();
  static WithinPeriodCondition getDefault() => _defaultInstance ??= create()..freeze();
  static WithinPeriodCondition _defaultInstance;

  Int64 get periodMS => $_getI64(0);
  set periodMS(Int64 v) { $_setInt64(0, v); }
  bool hasPeriodMS() => $_has(0);
  void clearPeriodMS() => clearField(1);
}

class CalendarCondition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CalendarCondition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOB(1, 'repeat')
    ..a<DayTime>(2, 'calendarDayTime', $pb.PbFieldType.OM, DayTime.getDefault, DayTime.create)
    ..p<bool>(3, 'enables', $pb.PbFieldType.PB)
    ..hasRequiredFields = false
  ;

  CalendarCondition() : super();
  CalendarCondition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CalendarCondition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CalendarCondition clone() => new CalendarCondition()..mergeFromMessage(this);
  CalendarCondition copyWith(void Function(CalendarCondition) updates) => super.copyWith((message) => updates(message as CalendarCondition));
  $pb.BuilderInfo get info_ => _i;
  static CalendarCondition create() => new CalendarCondition();
  CalendarCondition createEmptyInstance() => create();
  static $pb.PbList<CalendarCondition> createRepeated() => new $pb.PbList<CalendarCondition>();
  static CalendarCondition getDefault() => _defaultInstance ??= create()..freeze();
  static CalendarCondition _defaultInstance;

  bool get repeat => $_get(0, false);
  set repeat(bool v) { $_setBool(0, v); }
  bool hasRepeat() => $_has(0);
  void clearRepeat() => clearField(1);

  DayTime get calendarDayTime => $_getN(1);
  set calendarDayTime(DayTime v) { setField(2, v); }
  bool hasCalendarDayTime() => $_has(1);
  void clearCalendarDayTime() => clearField(2);

  List<bool> get enables => $_getList(2);
}

class CalendarRangeCondition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CalendarRangeCondition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOB(1, 'repeat')
    ..a<DayTime>(2, 'begin', $pb.PbFieldType.OM, DayTime.getDefault, DayTime.create)
    ..a<DayTime>(3, 'end', $pb.PbFieldType.OM, DayTime.getDefault, DayTime.create)
    ..p<bool>(4, 'enables', $pb.PbFieldType.PB)
    ..hasRequiredFields = false
  ;

  CalendarRangeCondition() : super();
  CalendarRangeCondition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CalendarRangeCondition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CalendarRangeCondition clone() => new CalendarRangeCondition()..mergeFromMessage(this);
  CalendarRangeCondition copyWith(void Function(CalendarRangeCondition) updates) => super.copyWith((message) => updates(message as CalendarRangeCondition));
  $pb.BuilderInfo get info_ => _i;
  static CalendarRangeCondition create() => new CalendarRangeCondition();
  CalendarRangeCondition createEmptyInstance() => create();
  static $pb.PbList<CalendarRangeCondition> createRepeated() => new $pb.PbList<CalendarRangeCondition>();
  static CalendarRangeCondition getDefault() => _defaultInstance ??= create()..freeze();
  static CalendarRangeCondition _defaultInstance;

  bool get repeat => $_get(0, false);
  set repeat(bool v) { $_setBool(0, v); }
  bool hasRepeat() => $_has(0);
  void clearRepeat() => clearField(1);

  DayTime get begin => $_getN(1);
  set begin(DayTime v) { setField(2, v); }
  bool hasBegin() => $_has(1);
  void clearBegin() => clearField(2);

  DayTime get end => $_getN(2);
  set end(DayTime v) { setField(3, v); }
  bool hasEnd() => $_has(2);
  void clearEnd() => clearField(3);

  List<bool> get enables => $_getList(3);
}

class TimerCondition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('TimerCondition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aInt64(1, 'timeoutMS')
    ..hasRequiredFields = false
  ;

  TimerCondition() : super();
  TimerCondition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  TimerCondition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  TimerCondition clone() => new TimerCondition()..mergeFromMessage(this);
  TimerCondition copyWith(void Function(TimerCondition) updates) => super.copyWith((message) => updates(message as TimerCondition));
  $pb.BuilderInfo get info_ => _i;
  static TimerCondition create() => new TimerCondition();
  TimerCondition createEmptyInstance() => create();
  static $pb.PbList<TimerCondition> createRepeated() => new $pb.PbList<TimerCondition>();
  static TimerCondition getDefault() => _defaultInstance ??= create()..freeze();
  static TimerCondition _defaultInstance;

  Int64 get timeoutMS => $_getI64(0);
  set timeoutMS(Int64 v) { $_setInt64(0, v); }
  bool hasTimeoutMS() => $_has(0);
  void clearTimeoutMS() => clearField(1);
}

class ComposedCondition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ComposedCondition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..e<ConditionOperator>(1, 'operator', $pb.PbFieldType.OE, ConditionOperator.OP_OR, ConditionOperator.valueOf, ConditionOperator.values)
    ..pc<Condition>(2, 'conditions', $pb.PbFieldType.PM,Condition.create)
    ..hasRequiredFields = false
  ;

  ComposedCondition() : super();
  ComposedCondition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ComposedCondition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ComposedCondition clone() => new ComposedCondition()..mergeFromMessage(this);
  ComposedCondition copyWith(void Function(ComposedCondition) updates) => super.copyWith((message) => updates(message as ComposedCondition));
  $pb.BuilderInfo get info_ => _i;
  static ComposedCondition create() => new ComposedCondition();
  ComposedCondition createEmptyInstance() => create();
  static $pb.PbList<ComposedCondition> createRepeated() => new $pb.PbList<ComposedCondition>();
  static ComposedCondition getDefault() => _defaultInstance ??= create()..freeze();
  static ComposedCondition _defaultInstance;

  ConditionOperator get operator => $_getN(0);
  set operator(ConditionOperator v) { setField(1, v); }
  bool hasOperator() => $_has(0);
  void clearOperator() => clearField(1);

  List<Condition> get conditions => $_getList(1);
}

class TimeLimitCondition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('TimeLimitCondition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<int>(1, 'delayMS', $pb.PbFieldType.O3)
    ..a<int>(2, 'checkMS', $pb.PbFieldType.O3)
    ..a<Condition>(3, 'innerCondition', $pb.PbFieldType.OM, Condition.getDefault, Condition.create)
    ..hasRequiredFields = false
  ;

  TimeLimitCondition() : super();
  TimeLimitCondition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  TimeLimitCondition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  TimeLimitCondition clone() => new TimeLimitCondition()..mergeFromMessage(this);
  TimeLimitCondition copyWith(void Function(TimeLimitCondition) updates) => super.copyWith((message) => updates(message as TimeLimitCondition));
  $pb.BuilderInfo get info_ => _i;
  static TimeLimitCondition create() => new TimeLimitCondition();
  TimeLimitCondition createEmptyInstance() => create();
  static $pb.PbList<TimeLimitCondition> createRepeated() => new $pb.PbList<TimeLimitCondition>();
  static TimeLimitCondition getDefault() => _defaultInstance ??= create()..freeze();
  static TimeLimitCondition _defaultInstance;

  int get delayMS => $_get(0, 0);
  set delayMS(int v) { $_setSignedInt32(0, v); }
  bool hasDelayMS() => $_has(0);
  void clearDelayMS() => clearField(1);

  int get checkMS => $_get(1, 0);
  set checkMS(int v) { $_setSignedInt32(1, v); }
  bool hasCheckMS() => $_has(1);
  void clearCheckMS() => clearField(2);

  Condition get innerCondition => $_getN(2);
  set innerCondition(Condition v) { setField(3, v); }
  bool hasInnerCondition() => $_has(2);
  void clearInnerCondition() => clearField(3);
}

class SequencedCondition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SequencedCondition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..pc<TimeLimitCondition>(1, 'conditions', $pb.PbFieldType.PM,TimeLimitCondition.create)
    ..hasRequiredFields = false
  ;

  SequencedCondition() : super();
  SequencedCondition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SequencedCondition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SequencedCondition clone() => new SequencedCondition()..mergeFromMessage(this);
  SequencedCondition copyWith(void Function(SequencedCondition) updates) => super.copyWith((message) => updates(message as SequencedCondition));
  $pb.BuilderInfo get info_ => _i;
  static SequencedCondition create() => new SequencedCondition();
  SequencedCondition createEmptyInstance() => create();
  static $pb.PbList<SequencedCondition> createRepeated() => new $pb.PbList<SequencedCondition>();
  static SequencedCondition getDefault() => _defaultInstance ??= create()..freeze();
  static SequencedCondition _defaultInstance;

  List<TimeLimitCondition> get conditions => $_getList(0);
}

class LongPressCondition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LongPressCondition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..a<int>(2, 'pressedSeconds', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  LongPressCondition() : super();
  LongPressCondition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LongPressCondition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LongPressCondition clone() => new LongPressCondition()..mergeFromMessage(this);
  LongPressCondition copyWith(void Function(LongPressCondition) updates) => super.copyWith((message) => updates(message as LongPressCondition));
  $pb.BuilderInfo get info_ => _i;
  static LongPressCondition create() => new LongPressCondition();
  LongPressCondition createEmptyInstance() => create();
  static $pb.PbList<LongPressCondition> createRepeated() => new $pb.PbList<LongPressCondition>();
  static LongPressCondition getDefault() => _defaultInstance ??= create()..freeze();
  static LongPressCondition _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  int get pressedSeconds => $_get(1, 0);
  set pressedSeconds(int v) { $_setSignedInt32(1, v); }
  bool hasPressedSeconds() => $_has(1);
  void clearPressedSeconds() => clearField(2);
}

enum Condition_ConditionValue {
  angular, 
  keypress, 
  attributeVariation, 
  withinPeriod, 
  calendar, 
  calendarRange, 
  timer, 
  composed, 
  sequenced, 
  longPress, 
  notSet
}

class Condition extends $pb.GeneratedMessage {
  static const Map<int, Condition_ConditionValue> _Condition_ConditionValueByTag = {
    1 : Condition_ConditionValue.angular,
    2 : Condition_ConditionValue.keypress,
    3 : Condition_ConditionValue.attributeVariation,
    4 : Condition_ConditionValue.withinPeriod,
    5 : Condition_ConditionValue.calendar,
    6 : Condition_ConditionValue.calendarRange,
    7 : Condition_ConditionValue.timer,
    8 : Condition_ConditionValue.composed,
    9 : Condition_ConditionValue.sequenced,
    10 : Condition_ConditionValue.longPress,
    0 : Condition_ConditionValue.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Condition', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<AngularCondition>(1, 'angular', $pb.PbFieldType.OM, AngularCondition.getDefault, AngularCondition.create)
    ..a<KeypressCondition>(2, 'keypress', $pb.PbFieldType.OM, KeypressCondition.getDefault, KeypressCondition.create)
    ..a<AttributeVariationCondition>(3, 'attributeVariation', $pb.PbFieldType.OM, AttributeVariationCondition.getDefault, AttributeVariationCondition.create)
    ..a<WithinPeriodCondition>(4, 'withinPeriod', $pb.PbFieldType.OM, WithinPeriodCondition.getDefault, WithinPeriodCondition.create)
    ..a<CalendarCondition>(5, 'calendar', $pb.PbFieldType.OM, CalendarCondition.getDefault, CalendarCondition.create)
    ..a<CalendarRangeCondition>(6, 'calendarRange', $pb.PbFieldType.OM, CalendarRangeCondition.getDefault, CalendarRangeCondition.create)
    ..a<TimerCondition>(7, 'timer', $pb.PbFieldType.OM, TimerCondition.getDefault, TimerCondition.create)
    ..a<ComposedCondition>(8, 'composed', $pb.PbFieldType.OM, ComposedCondition.getDefault, ComposedCondition.create)
    ..a<SequencedCondition>(9, 'sequenced', $pb.PbFieldType.OM, SequencedCondition.getDefault, SequencedCondition.create)
    ..a<LongPressCondition>(10, 'longPress', $pb.PbFieldType.OM, LongPressCondition.getDefault, LongPressCondition.create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    ..hasRequiredFields = false
  ;

  Condition() : super();
  Condition.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Condition.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Condition clone() => new Condition()..mergeFromMessage(this);
  Condition copyWith(void Function(Condition) updates) => super.copyWith((message) => updates(message as Condition));
  $pb.BuilderInfo get info_ => _i;
  static Condition create() => new Condition();
  Condition createEmptyInstance() => create();
  static $pb.PbList<Condition> createRepeated() => new $pb.PbList<Condition>();
  static Condition getDefault() => _defaultInstance ??= create()..freeze();
  static Condition _defaultInstance;

  Condition_ConditionValue whichConditionValue() => _Condition_ConditionValueByTag[$_whichOneof(0)];
  void clearConditionValue() => clearField($_whichOneof(0));

  AngularCondition get angular => $_getN(0);
  set angular(AngularCondition v) { setField(1, v); }
  bool hasAngular() => $_has(0);
  void clearAngular() => clearField(1);

  KeypressCondition get keypress => $_getN(1);
  set keypress(KeypressCondition v) { setField(2, v); }
  bool hasKeypress() => $_has(1);
  void clearKeypress() => clearField(2);

  AttributeVariationCondition get attributeVariation => $_getN(2);
  set attributeVariation(AttributeVariationCondition v) { setField(3, v); }
  bool hasAttributeVariation() => $_has(2);
  void clearAttributeVariation() => clearField(3);

  WithinPeriodCondition get withinPeriod => $_getN(3);
  set withinPeriod(WithinPeriodCondition v) { setField(4, v); }
  bool hasWithinPeriod() => $_has(3);
  void clearWithinPeriod() => clearField(4);

  CalendarCondition get calendar => $_getN(4);
  set calendar(CalendarCondition v) { setField(5, v); }
  bool hasCalendar() => $_has(4);
  void clearCalendar() => clearField(5);

  CalendarRangeCondition get calendarRange => $_getN(5);
  set calendarRange(CalendarRangeCondition v) { setField(6, v); }
  bool hasCalendarRange() => $_has(5);
  void clearCalendarRange() => clearField(6);

  TimerCondition get timer => $_getN(6);
  set timer(TimerCondition v) { setField(7, v); }
  bool hasTimer() => $_has(6);
  void clearTimer() => clearField(7);

  ComposedCondition get composed => $_getN(7);
  set composed(ComposedCondition v) { setField(8, v); }
  bool hasComposed() => $_has(7);
  void clearComposed() => clearField(8);

  SequencedCondition get sequenced => $_getN(8);
  set sequenced(SequencedCondition v) { setField(9, v); }
  bool hasSequenced() => $_has(8);
  void clearSequenced() => clearField(9);

  LongPressCondition get longPress => $_getN(9);
  set longPress(LongPressCondition v) { setField(10, v); }
  bool hasLongPress() => $_has(9);
  void clearLongPress() => clearField(10);
}

class TimerExecution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('TimerExecution', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aInt64(1, 'timeoutMS')
    ..hasRequiredFields = false
  ;

  TimerExecution() : super();
  TimerExecution.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  TimerExecution.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  TimerExecution clone() => new TimerExecution()..mergeFromMessage(this);
  TimerExecution copyWith(void Function(TimerExecution) updates) => super.copyWith((message) => updates(message as TimerExecution));
  $pb.BuilderInfo get info_ => _i;
  static TimerExecution create() => new TimerExecution();
  TimerExecution createEmptyInstance() => create();
  static $pb.PbList<TimerExecution> createRepeated() => new $pb.PbList<TimerExecution>();
  static TimerExecution getDefault() => _defaultInstance ??= create()..freeze();
  static TimerExecution _defaultInstance;

  Int64 get timeoutMS => $_getI64(0);
  set timeoutMS(Int64 v) { $_setInt64(0, v); }
  bool hasTimeoutMS() => $_has(0);
  void clearTimeoutMS() => clearField(1);
}

class SceneExecution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SceneExecution', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..e<ExecutionMethod>(2, 'method', $pb.PbFieldType.OE, ExecutionMethod.EM_ILLEGAL, ExecutionMethod.valueOf, ExecutionMethod.values)
    ..a<int>(3, 'parameter', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  SceneExecution() : super();
  SceneExecution.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SceneExecution.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SceneExecution clone() => new SceneExecution()..mergeFromMessage(this);
  SceneExecution copyWith(void Function(SceneExecution) updates) => super.copyWith((message) => updates(message as SceneExecution));
  $pb.BuilderInfo get info_ => _i;
  static SceneExecution create() => new SceneExecution();
  SceneExecution createEmptyInstance() => create();
  static $pb.PbList<SceneExecution> createRepeated() => new $pb.PbList<SceneExecution>();
  static SceneExecution getDefault() => _defaultInstance ??= create()..freeze();
  static SceneExecution _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  ExecutionMethod get method => $_getN(1);
  set method(ExecutionMethod v) { setField(2, v); }
  bool hasMethod() => $_has(1);
  void clearMethod() => clearField(2);

  int get parameter => $_get(2, 0);
  set parameter(int v) { $_setSignedInt32(2, v); }
  bool hasParameter() => $_has(2);
  void clearParameter() => clearField(3);
}

class AtomicAction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AtomicAction', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..e<$0.AttributeID>(2, 'attrID', $pb.PbFieldType.OE, $0.AttributeID.AttrIDOnOffStatus, $0.AttributeID.valueOf, $0.AttributeID.values)
    ..a<int>(3, 'attrValue', $pb.PbFieldType.O3)
    ..p<int>(4, 'attrParams', $pb.PbFieldType.P3)
    ..hasRequiredFields = false
  ;

  AtomicAction() : super();
  AtomicAction.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AtomicAction.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AtomicAction clone() => new AtomicAction()..mergeFromMessage(this);
  AtomicAction copyWith(void Function(AtomicAction) updates) => super.copyWith((message) => updates(message as AtomicAction));
  $pb.BuilderInfo get info_ => _i;
  static AtomicAction create() => new AtomicAction();
  AtomicAction createEmptyInstance() => create();
  static $pb.PbList<AtomicAction> createRepeated() => new $pb.PbList<AtomicAction>();
  static AtomicAction getDefault() => _defaultInstance ??= create()..freeze();
  static AtomicAction _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  $0.AttributeID get attrID => $_getN(1);
  set attrID($0.AttributeID v) { setField(2, v); }
  bool hasAttrID() => $_has(1);
  void clearAttrID() => clearField(2);

  int get attrValue => $_get(2, 0);
  set attrValue(int v) { $_setSignedInt32(2, v); }
  bool hasAttrValue() => $_has(2);
  void clearAttrValue() => clearField(3);

  List<int> get attrParams => $_getList(3);
}

class ComposedAction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ComposedAction', package: const $pb.PackageName('xiaoyan.protocol'))
    ..e<ExecutionMethod>(1, 'method', $pb.PbFieldType.OE, ExecutionMethod.EM_ILLEGAL, ExecutionMethod.valueOf, ExecutionMethod.values)
    ..a<int>(2, 'parameter', $pb.PbFieldType.O3)
    ..pc<AtomicAction>(3, 'actions', $pb.PbFieldType.PM,AtomicAction.create)
    ..hasRequiredFields = false
  ;

  ComposedAction() : super();
  ComposedAction.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ComposedAction.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ComposedAction clone() => new ComposedAction()..mergeFromMessage(this);
  ComposedAction copyWith(void Function(ComposedAction) updates) => super.copyWith((message) => updates(message as ComposedAction));
  $pb.BuilderInfo get info_ => _i;
  static ComposedAction create() => new ComposedAction();
  ComposedAction createEmptyInstance() => create();
  static $pb.PbList<ComposedAction> createRepeated() => new $pb.PbList<ComposedAction>();
  static ComposedAction getDefault() => _defaultInstance ??= create()..freeze();
  static ComposedAction _defaultInstance;

  ExecutionMethod get method => $_getN(0);
  set method(ExecutionMethod v) { setField(1, v); }
  bool hasMethod() => $_has(0);
  void clearMethod() => clearField(1);

  int get parameter => $_get(1, 0);
  set parameter(int v) { $_setSignedInt32(1, v); }
  bool hasParameter() => $_has(1);
  void clearParameter() => clearField(2);

  List<AtomicAction> get actions => $_getList(2);
}

class ActionExecution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ActionExecution', package: const $pb.PackageName('xiaoyan.protocol'))
    ..e<ExecutionMethod>(1, 'method', $pb.PbFieldType.OE, ExecutionMethod.EM_ILLEGAL, ExecutionMethod.valueOf, ExecutionMethod.values)
    ..a<int>(2, 'parameter', $pb.PbFieldType.O3)
    ..a<ComposedAction>(3, 'action', $pb.PbFieldType.OM, ComposedAction.getDefault, ComposedAction.create)
    ..hasRequiredFields = false
  ;

  ActionExecution() : super();
  ActionExecution.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ActionExecution.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ActionExecution clone() => new ActionExecution()..mergeFromMessage(this);
  ActionExecution copyWith(void Function(ActionExecution) updates) => super.copyWith((message) => updates(message as ActionExecution));
  $pb.BuilderInfo get info_ => _i;
  static ActionExecution create() => new ActionExecution();
  ActionExecution createEmptyInstance() => create();
  static $pb.PbList<ActionExecution> createRepeated() => new $pb.PbList<ActionExecution>();
  static ActionExecution getDefault() => _defaultInstance ??= create()..freeze();
  static ActionExecution _defaultInstance;

  ExecutionMethod get method => $_getN(0);
  set method(ExecutionMethod v) { setField(1, v); }
  bool hasMethod() => $_has(0);
  void clearMethod() => clearField(1);

  int get parameter => $_get(1, 0);
  set parameter(int v) { $_setSignedInt32(1, v); }
  bool hasParameter() => $_has(1);
  void clearParameter() => clearField(2);

  ComposedAction get action => $_getN(2);
  set action(ComposedAction v) { setField(3, v); }
  bool hasAction() => $_has(2);
  void clearAction() => clearField(3);
}

class SequencedExecution extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SequencedExecution', package: const $pb.PackageName('xiaoyan.protocol'))
    ..e<ExecutionMethod>(1, 'method', $pb.PbFieldType.OE, ExecutionMethod.EM_ILLEGAL, ExecutionMethod.valueOf, ExecutionMethod.values)
    ..a<int>(2, 'parameter', $pb.PbFieldType.O3)
    ..e<ExecutionLoopType>(3, 'loopType', $pb.PbFieldType.OE, ExecutionLoopType.ELT_LOOP_TIMES, ExecutionLoopType.valueOf, ExecutionLoopType.values)
    ..aInt64(4, 'loopParameter')
    ..pc<Execution>(5, 'executions', $pb.PbFieldType.PM,Execution.create)
    ..hasRequiredFields = false
  ;

  SequencedExecution() : super();
  SequencedExecution.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SequencedExecution.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SequencedExecution clone() => new SequencedExecution()..mergeFromMessage(this);
  SequencedExecution copyWith(void Function(SequencedExecution) updates) => super.copyWith((message) => updates(message as SequencedExecution));
  $pb.BuilderInfo get info_ => _i;
  static SequencedExecution create() => new SequencedExecution();
  SequencedExecution createEmptyInstance() => create();
  static $pb.PbList<SequencedExecution> createRepeated() => new $pb.PbList<SequencedExecution>();
  static SequencedExecution getDefault() => _defaultInstance ??= create()..freeze();
  static SequencedExecution _defaultInstance;

  ExecutionMethod get method => $_getN(0);
  set method(ExecutionMethod v) { setField(1, v); }
  bool hasMethod() => $_has(0);
  void clearMethod() => clearField(1);

  int get parameter => $_get(1, 0);
  set parameter(int v) { $_setSignedInt32(1, v); }
  bool hasParameter() => $_has(1);
  void clearParameter() => clearField(2);

  ExecutionLoopType get loopType => $_getN(2);
  set loopType(ExecutionLoopType v) { setField(3, v); }
  bool hasLoopType() => $_has(2);
  void clearLoopType() => clearField(3);

  Int64 get loopParameter => $_getI64(3);
  set loopParameter(Int64 v) { $_setInt64(3, v); }
  bool hasLoopParameter() => $_has(3);
  void clearLoopParameter() => clearField(4);

  List<Execution> get executions => $_getList(4);
}

enum Execution_ExecutionValue {
  timer, 
  scene, 
  action, 
  sequenced, 
  notSet
}

class Execution extends $pb.GeneratedMessage {
  static const Map<int, Execution_ExecutionValue> _Execution_ExecutionValueByTag = {
    1 : Execution_ExecutionValue.timer,
    2 : Execution_ExecutionValue.scene,
    3 : Execution_ExecutionValue.action,
    4 : Execution_ExecutionValue.sequenced,
    0 : Execution_ExecutionValue.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Execution', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<TimerExecution>(1, 'timer', $pb.PbFieldType.OM, TimerExecution.getDefault, TimerExecution.create)
    ..a<SceneExecution>(2, 'scene', $pb.PbFieldType.OM, SceneExecution.getDefault, SceneExecution.create)
    ..a<ActionExecution>(3, 'action', $pb.PbFieldType.OM, ActionExecution.getDefault, ActionExecution.create)
    ..a<SequencedExecution>(4, 'sequenced', $pb.PbFieldType.OM, SequencedExecution.getDefault, SequencedExecution.create)
    ..oo(0, [1, 2, 3, 4])
    ..hasRequiredFields = false
  ;

  Execution() : super();
  Execution.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Execution.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Execution clone() => new Execution()..mergeFromMessage(this);
  Execution copyWith(void Function(Execution) updates) => super.copyWith((message) => updates(message as Execution));
  $pb.BuilderInfo get info_ => _i;
  static Execution create() => new Execution();
  Execution createEmptyInstance() => create();
  static $pb.PbList<Execution> createRepeated() => new $pb.PbList<Execution>();
  static Execution getDefault() => _defaultInstance ??= create()..freeze();
  static Execution _defaultInstance;

  Execution_ExecutionValue whichExecutionValue() => _Execution_ExecutionValueByTag[$_whichOneof(0)];
  void clearExecutionValue() => clearField($_whichOneof(0));

  TimerExecution get timer => $_getN(0);
  set timer(TimerExecution v) { setField(1, v); }
  bool hasTimer() => $_has(0);
  void clearTimer() => clearField(1);

  SceneExecution get scene => $_getN(1);
  set scene(SceneExecution v) { setField(2, v); }
  bool hasScene() => $_has(1);
  void clearScene() => clearField(2);

  ActionExecution get action => $_getN(2);
  set action(ActionExecution v) { setField(3, v); }
  bool hasAction() => $_has(2);
  void clearAction() => clearField(3);

  SequencedExecution get sequenced => $_getN(3);
  set sequenced(SequencedExecution v) { setField(4, v); }
  bool hasSequenced() => $_has(3);
  void clearSequenced() => clearField(4);
}

class Automation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Automation', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<Condition>(1, 'cond', $pb.PbFieldType.OM, Condition.getDefault, Condition.create)
    ..a<Execution>(2, 'exec', $pb.PbFieldType.OM, Execution.getDefault, Execution.create)
    ..a<Automation>(3, 'next', $pb.PbFieldType.OM, Automation.getDefault, Automation.create)
    ..hasRequiredFields = false
  ;

  Automation() : super();
  Automation.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Automation.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Automation clone() => new Automation()..mergeFromMessage(this);
  Automation copyWith(void Function(Automation) updates) => super.copyWith((message) => updates(message as Automation));
  $pb.BuilderInfo get info_ => _i;
  static Automation create() => new Automation();
  Automation createEmptyInstance() => create();
  static $pb.PbList<Automation> createRepeated() => new $pb.PbList<Automation>();
  static Automation getDefault() => _defaultInstance ??= create()..freeze();
  static Automation _defaultInstance;

  Condition get cond => $_getN(0);
  set cond(Condition v) { setField(1, v); }
  bool hasCond() => $_has(0);
  void clearCond() => clearField(1);

  Execution get exec => $_getN(1);
  set exec(Execution v) { setField(2, v); }
  bool hasExec() => $_has(1);
  void clearExec() => clearField(2);

  Automation get next => $_getN(2);
  set next(Automation v) { setField(3, v); }
  bool hasNext() => $_has(2);
  void clearNext() => clearField(3);
}

class AutomationSet extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AutomationSet', package: const $pb.PackageName('xiaoyan.protocol'))
    ..pc<Automation>(1, 'set', $pb.PbFieldType.PM,Automation.create)
    ..hasRequiredFields = false
  ;

  AutomationSet() : super();
  AutomationSet.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AutomationSet.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AutomationSet clone() => new AutomationSet()..mergeFromMessage(this);
  AutomationSet copyWith(void Function(AutomationSet) updates) => super.copyWith((message) => updates(message as AutomationSet));
  $pb.BuilderInfo get info_ => _i;
  static AutomationSet create() => new AutomationSet();
  AutomationSet createEmptyInstance() => create();
  static $pb.PbList<AutomationSet> createRepeated() => new $pb.PbList<AutomationSet>();
  static AutomationSet getDefault() => _defaultInstance ??= create()..freeze();
  static AutomationSet _defaultInstance;

  List<Automation> get set => $_getList(0);
}

