///
//  Generated code. Do not modify.
//  source: message.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $1;
import 'entity.pb.dart' as $2;

import 'const.pbenum.dart' as $0;

enum Message_Body {
  error, 
  onOff, 
  onOffResult, 
  getEntity, 
  getEntityResult, 
  createScene, 
  createSceneResult, 
  updateScene, 
  updateSceneResult, 
  deleteScene, 
  deleteSceneResult, 
  setSceneOnOff, 
  setSceneOnOffResult, 
  createBinding, 
  createBindingResult, 
  updateBinding, 
  updateBindingResult, 
  deleteBinding, 
  deleteBindingResult, 
  setBindingEnable, 
  setBindingEnableResult, 
  configEntityInfo, 
  configEntityInfoResult, 
  createArea, 
  createAreaResult, 
  deleteArea, 
  deleteAreaResult, 
  setPermitJoin, 
  setPermitJoinResult, 
  setAlertLevel, 
  setAlertLevelResult, 
  readAttribute, 
  readAttributeResult, 
  firmwareUpgrade, 
  firmwareUpgradeResult, 
  identifyDevice, 
  identifyDeviceResult, 
  deleteEntity, 
  deleteEntityResult, 
  controlWindowCovering, 
  controlWindowCoveringResult, 
  getTime, 
  getTimeResult, 
  setTime, 
  setTimeResult, 
  deviceAssociation, 
  checkNewVersion, 
  setUpgradePolicy, 
  setUpgradePolicyResult, 
  getUpgradePolicy, 
  getUpgradePolicyResult, 
  getHomeKitSetting, 
  getHomeKitSettingResult, 
  writeAttribute, 
  writeAttributeResult, 
  checkNewVersionResult, 
  createEntity, 
  createEntityResult, 
  updateEntity, 
  updateEntityResult, 
  allocateLanAccessToken, 
  allocateLanAccessTokenResult, 
  revokeLanAccessToken, 
  revokeLanAccessTokenResult, 
  getAutomationTimeoutMs, 
  getAutomationTimeoutMsResult, 
  notSet
}

class Message extends $pb.GeneratedMessage {
  static const Map<int, Message_Body> _Message_BodyByTag = {
    10 : Message_Body.error,
    11 : Message_Body.onOff,
    12 : Message_Body.onOffResult,
    13 : Message_Body.getEntity,
    14 : Message_Body.getEntityResult,
    15 : Message_Body.createScene,
    16 : Message_Body.createSceneResult,
    17 : Message_Body.updateScene,
    18 : Message_Body.updateSceneResult,
    19 : Message_Body.deleteScene,
    20 : Message_Body.deleteSceneResult,
    21 : Message_Body.setSceneOnOff,
    22 : Message_Body.setSceneOnOffResult,
    23 : Message_Body.createBinding,
    24 : Message_Body.createBindingResult,
    25 : Message_Body.updateBinding,
    26 : Message_Body.updateBindingResult,
    27 : Message_Body.deleteBinding,
    28 : Message_Body.deleteBindingResult,
    29 : Message_Body.setBindingEnable,
    30 : Message_Body.setBindingEnableResult,
    31 : Message_Body.configEntityInfo,
    32 : Message_Body.configEntityInfoResult,
    33 : Message_Body.createArea,
    34 : Message_Body.createAreaResult,
    35 : Message_Body.deleteArea,
    36 : Message_Body.deleteAreaResult,
    37 : Message_Body.setPermitJoin,
    38 : Message_Body.setPermitJoinResult,
    39 : Message_Body.setAlertLevel,
    40 : Message_Body.setAlertLevelResult,
    41 : Message_Body.readAttribute,
    42 : Message_Body.readAttributeResult,
    43 : Message_Body.firmwareUpgrade,
    44 : Message_Body.firmwareUpgradeResult,
    45 : Message_Body.identifyDevice,
    46 : Message_Body.identifyDeviceResult,
    47 : Message_Body.deleteEntity,
    48 : Message_Body.deleteEntityResult,
    49 : Message_Body.controlWindowCovering,
    50 : Message_Body.controlWindowCoveringResult,
    51 : Message_Body.getTime,
    52 : Message_Body.getTimeResult,
    53 : Message_Body.setTime,
    54 : Message_Body.setTimeResult,
    55 : Message_Body.deviceAssociation,
    56 : Message_Body.checkNewVersion,
    57 : Message_Body.setUpgradePolicy,
    58 : Message_Body.setUpgradePolicyResult,
    59 : Message_Body.getUpgradePolicy,
    60 : Message_Body.getUpgradePolicyResult,
    61 : Message_Body.getHomeKitSetting,
    62 : Message_Body.getHomeKitSettingResult,
    63 : Message_Body.writeAttribute,
    64 : Message_Body.writeAttributeResult,
    65 : Message_Body.checkNewVersionResult,
    66 : Message_Body.createEntity,
    67 : Message_Body.createEntityResult,
    68 : Message_Body.updateEntity,
    69 : Message_Body.updateEntityResult,
    70 : Message_Body.allocateLanAccessToken,
    71 : Message_Body.allocateLanAccessTokenResult,
    72 : Message_Body.revokeLanAccessToken,
    73 : Message_Body.revokeLanAccessTokenResult,
    74 : Message_Body.getAutomationTimeoutMs,
    75 : Message_Body.getAutomationTimeoutMsResult,
    0 : Message_Body.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Message', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'messageID')
    ..aOS(2, 'correlationID')
    ..aOS(3, 'sender')
    ..a<$1.Timestamp>(4, 'time', $pb.PbFieldType.OM, $1.Timestamp.getDefault, $1.Timestamp.create)
    ..a<ErrorResponse>(10, 'error', $pb.PbFieldType.OM, ErrorResponse.getDefault, ErrorResponse.create)
    ..a<OnOffRequest>(11, 'onOff', $pb.PbFieldType.OM, OnOffRequest.getDefault, OnOffRequest.create)
    ..a<OnOffResponse>(12, 'onOffResult', $pb.PbFieldType.OM, OnOffResponse.getDefault, OnOffResponse.create)
    ..a<GetEntityRequest>(13, 'getEntity', $pb.PbFieldType.OM, GetEntityRequest.getDefault, GetEntityRequest.create)
    ..a<GetEntityResponse>(14, 'getEntityResult', $pb.PbFieldType.OM, GetEntityResponse.getDefault, GetEntityResponse.create)
    ..a<CreateSceneRequest>(15, 'createScene', $pb.PbFieldType.OM, CreateSceneRequest.getDefault, CreateSceneRequest.create)
    ..a<CreateSceneResponse>(16, 'createSceneResult', $pb.PbFieldType.OM, CreateSceneResponse.getDefault, CreateSceneResponse.create)
    ..a<UpdateSceneRequest>(17, 'updateScene', $pb.PbFieldType.OM, UpdateSceneRequest.getDefault, UpdateSceneRequest.create)
    ..a<UpdateSceneResponse>(18, 'updateSceneResult', $pb.PbFieldType.OM, UpdateSceneResponse.getDefault, UpdateSceneResponse.create)
    ..a<DeleteSceneRequest>(19, 'deleteScene', $pb.PbFieldType.OM, DeleteSceneRequest.getDefault, DeleteSceneRequest.create)
    ..a<DeleteSceneResponse>(20, 'deleteSceneResult', $pb.PbFieldType.OM, DeleteSceneResponse.getDefault, DeleteSceneResponse.create)
    ..a<SetSceneOnOffRequest>(21, 'setSceneOnOff', $pb.PbFieldType.OM, SetSceneOnOffRequest.getDefault, SetSceneOnOffRequest.create)
    ..a<SetSceneOnOffResponse>(22, 'setSceneOnOffResult', $pb.PbFieldType.OM, SetSceneOnOffResponse.getDefault, SetSceneOnOffResponse.create)
    ..a<CreateBindingRequest>(23, 'createBinding', $pb.PbFieldType.OM, CreateBindingRequest.getDefault, CreateBindingRequest.create)
    ..a<CreateBindingResponse>(24, 'createBindingResult', $pb.PbFieldType.OM, CreateBindingResponse.getDefault, CreateBindingResponse.create)
    ..a<UpdateBindingRequest>(25, 'updateBinding', $pb.PbFieldType.OM, UpdateBindingRequest.getDefault, UpdateBindingRequest.create)
    ..a<UpdateBindingResponse>(26, 'updateBindingResult', $pb.PbFieldType.OM, UpdateBindingResponse.getDefault, UpdateBindingResponse.create)
    ..a<DeleteBindingRequest>(27, 'deleteBinding', $pb.PbFieldType.OM, DeleteBindingRequest.getDefault, DeleteBindingRequest.create)
    ..a<DeleteBindingResponse>(28, 'deleteBindingResult', $pb.PbFieldType.OM, DeleteBindingResponse.getDefault, DeleteBindingResponse.create)
    ..a<SetBindingEnableRequest>(29, 'setBindingEnable', $pb.PbFieldType.OM, SetBindingEnableRequest.getDefault, SetBindingEnableRequest.create)
    ..a<SetBindingEnableResponse>(30, 'setBindingEnableResult', $pb.PbFieldType.OM, SetBindingEnableResponse.getDefault, SetBindingEnableResponse.create)
    ..a<ConfigEntityInfoRequest>(31, 'configEntityInfo', $pb.PbFieldType.OM, ConfigEntityInfoRequest.getDefault, ConfigEntityInfoRequest.create)
    ..a<ConfigEntityInfoResponse>(32, 'configEntityInfoResult', $pb.PbFieldType.OM, ConfigEntityInfoResponse.getDefault, ConfigEntityInfoResponse.create)
    ..a<CreateAreaRequest>(33, 'createArea', $pb.PbFieldType.OM, CreateAreaRequest.getDefault, CreateAreaRequest.create)
    ..a<CreateAreaResponse>(34, 'createAreaResult', $pb.PbFieldType.OM, CreateAreaResponse.getDefault, CreateAreaResponse.create)
    ..a<DeleteAreaRequest>(35, 'deleteArea', $pb.PbFieldType.OM, DeleteAreaRequest.getDefault, DeleteAreaRequest.create)
    ..a<DeleteAreaResponse>(36, 'deleteAreaResult', $pb.PbFieldType.OM, DeleteAreaResponse.getDefault, DeleteAreaResponse.create)
    ..a<SetPermitJoinRequest>(37, 'setPermitJoin', $pb.PbFieldType.OM, SetPermitJoinRequest.getDefault, SetPermitJoinRequest.create)
    ..a<SetPermitJoinResponse>(38, 'setPermitJoinResult', $pb.PbFieldType.OM, SetPermitJoinResponse.getDefault, SetPermitJoinResponse.create)
    ..a<SetAlertLevelRequest>(39, 'setAlertLevel', $pb.PbFieldType.OM, SetAlertLevelRequest.getDefault, SetAlertLevelRequest.create)
    ..a<SetAlertLevelResponse>(40, 'setAlertLevelResult', $pb.PbFieldType.OM, SetAlertLevelResponse.getDefault, SetAlertLevelResponse.create)
    ..a<ReadAttributeRequest>(41, 'readAttribute', $pb.PbFieldType.OM, ReadAttributeRequest.getDefault, ReadAttributeRequest.create)
    ..a<ReadAttributeResponse>(42, 'readAttributeResult', $pb.PbFieldType.OM, ReadAttributeResponse.getDefault, ReadAttributeResponse.create)
    ..a<FirmwareUpgradeRequest>(43, 'firmwareUpgrade', $pb.PbFieldType.OM, FirmwareUpgradeRequest.getDefault, FirmwareUpgradeRequest.create)
    ..a<FirmwareUpgradeResponse>(44, 'firmwareUpgradeResult', $pb.PbFieldType.OM, FirmwareUpgradeResponse.getDefault, FirmwareUpgradeResponse.create)
    ..a<IdentifyDeviceRequest>(45, 'identifyDevice', $pb.PbFieldType.OM, IdentifyDeviceRequest.getDefault, IdentifyDeviceRequest.create)
    ..a<IdentifyDeviceResponse>(46, 'identifyDeviceResult', $pb.PbFieldType.OM, IdentifyDeviceResponse.getDefault, IdentifyDeviceResponse.create)
    ..a<DeleteEntityRequest>(47, 'deleteEntity', $pb.PbFieldType.OM, DeleteEntityRequest.getDefault, DeleteEntityRequest.create)
    ..a<DeleteEntityResponse>(48, 'deleteEntityResult', $pb.PbFieldType.OM, DeleteEntityResponse.getDefault, DeleteEntityResponse.create)
    ..a<ControlWindowCoveringRequest>(49, 'controlWindowCovering', $pb.PbFieldType.OM, ControlWindowCoveringRequest.getDefault, ControlWindowCoveringRequest.create)
    ..a<ControlWindowCoveringResponse>(50, 'controlWindowCoveringResult', $pb.PbFieldType.OM, ControlWindowCoveringResponse.getDefault, ControlWindowCoveringResponse.create)
    ..a<GetTimeRequest>(51, 'getTime', $pb.PbFieldType.OM, GetTimeRequest.getDefault, GetTimeRequest.create)
    ..a<GetTimeResponse>(52, 'getTimeResult', $pb.PbFieldType.OM, GetTimeResponse.getDefault, GetTimeResponse.create)
    ..a<SetTimeRequest>(53, 'setTime', $pb.PbFieldType.OM, SetTimeRequest.getDefault, SetTimeRequest.create)
    ..a<SetTimeResponse>(54, 'setTimeResult', $pb.PbFieldType.OM, SetTimeResponse.getDefault, SetTimeResponse.create)
    ..a<DeviceAssociationNotification>(55, 'deviceAssociation', $pb.PbFieldType.OM, DeviceAssociationNotification.getDefault, DeviceAssociationNotification.create)
    ..a<CheckNewVersionRequest>(56, 'checkNewVersion', $pb.PbFieldType.OM, CheckNewVersionRequest.getDefault, CheckNewVersionRequest.create)
    ..a<SetUpgradePolicyRequest>(57, 'setUpgradePolicy', $pb.PbFieldType.OM, SetUpgradePolicyRequest.getDefault, SetUpgradePolicyRequest.create)
    ..a<SetUpgradePolicyResponse>(58, 'setUpgradePolicyResult', $pb.PbFieldType.OM, SetUpgradePolicyResponse.getDefault, SetUpgradePolicyResponse.create)
    ..a<GetUpgradePolicyRequest>(59, 'getUpgradePolicy', $pb.PbFieldType.OM, GetUpgradePolicyRequest.getDefault, GetUpgradePolicyRequest.create)
    ..a<GetUpgradePolicyResponse>(60, 'getUpgradePolicyResult', $pb.PbFieldType.OM, GetUpgradePolicyResponse.getDefault, GetUpgradePolicyResponse.create)
    ..a<GetHomeKitSettingRequest>(61, 'getHomeKitSetting', $pb.PbFieldType.OM, GetHomeKitSettingRequest.getDefault, GetHomeKitSettingRequest.create)
    ..a<GetHomeKitSettingResponse>(62, 'getHomeKitSettingResult', $pb.PbFieldType.OM, GetHomeKitSettingResponse.getDefault, GetHomeKitSettingResponse.create)
    ..a<WriteAttributeRequest>(63, 'writeAttribute', $pb.PbFieldType.OM, WriteAttributeRequest.getDefault, WriteAttributeRequest.create)
    ..a<WriteAttributeResponse>(64, 'writeAttributeResult', $pb.PbFieldType.OM, WriteAttributeResponse.getDefault, WriteAttributeResponse.create)
    ..a<CheckNewVersionResponse>(65, 'checkNewVersionResult', $pb.PbFieldType.OM, CheckNewVersionResponse.getDefault, CheckNewVersionResponse.create)
    ..a<CreateEntityRequest>(66, 'createEntity', $pb.PbFieldType.OM, CreateEntityRequest.getDefault, CreateEntityRequest.create)
    ..a<CreateEntityResponse>(67, 'createEntityResult', $pb.PbFieldType.OM, CreateEntityResponse.getDefault, CreateEntityResponse.create)
    ..a<UpdateEntityRequest>(68, 'updateEntity', $pb.PbFieldType.OM, UpdateEntityRequest.getDefault, UpdateEntityRequest.create)
    ..a<UpdateEntityResponse>(69, 'updateEntityResult', $pb.PbFieldType.OM, UpdateEntityResponse.getDefault, UpdateEntityResponse.create)
    ..a<AllocateLanAccessTokenRequest>(70, 'allocateLanAccessToken', $pb.PbFieldType.OM, AllocateLanAccessTokenRequest.getDefault, AllocateLanAccessTokenRequest.create)
    ..a<AllocateLanAccessTokenResponse>(71, 'allocateLanAccessTokenResult', $pb.PbFieldType.OM, AllocateLanAccessTokenResponse.getDefault, AllocateLanAccessTokenResponse.create)
    ..a<RevokeLanAccessTokenRequest>(72, 'revokeLanAccessToken', $pb.PbFieldType.OM, RevokeLanAccessTokenRequest.getDefault, RevokeLanAccessTokenRequest.create)
    ..a<RevokeLanAccessTokenResponse>(73, 'revokeLanAccessTokenResult', $pb.PbFieldType.OM, RevokeLanAccessTokenResponse.getDefault, RevokeLanAccessTokenResponse.create)
    ..a<GetAutomationTimeoutMsRequest>(74, 'getAutomationTimeoutMs', $pb.PbFieldType.OM, GetAutomationTimeoutMsRequest.getDefault, GetAutomationTimeoutMsRequest.create)
    ..a<GetAutomationTimeoutMsResponse>(75, 'getAutomationTimeoutMsResult', $pb.PbFieldType.OM, GetAutomationTimeoutMsResponse.getDefault, GetAutomationTimeoutMsResponse.create)
    ..oo(0, [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75])
    ..hasRequiredFields = false
  ;

  Message() : super();
  Message.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Message.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Message clone() => new Message()..mergeFromMessage(this);
  Message copyWith(void Function(Message) updates) => super.copyWith((message) => updates(message as Message));
  $pb.BuilderInfo get info_ => _i;
  static Message create() => new Message();
  Message createEmptyInstance() => create();
  static $pb.PbList<Message> createRepeated() => new $pb.PbList<Message>();
  static Message getDefault() => _defaultInstance ??= create()..freeze();
  static Message _defaultInstance;

  Message_Body whichBody() => _Message_BodyByTag[$_whichOneof(0)];
  void clearBody() => clearField($_whichOneof(0));

  String get messageID => $_getS(0, '');
  set messageID(String v) { $_setString(0, v); }
  bool hasMessageID() => $_has(0);
  void clearMessageID() => clearField(1);

  String get correlationID => $_getS(1, '');
  set correlationID(String v) { $_setString(1, v); }
  bool hasCorrelationID() => $_has(1);
  void clearCorrelationID() => clearField(2);

  String get sender => $_getS(2, '');
  set sender(String v) { $_setString(2, v); }
  bool hasSender() => $_has(2);
  void clearSender() => clearField(3);

  $1.Timestamp get time => $_getN(3);
  set time($1.Timestamp v) { setField(4, v); }
  bool hasTime() => $_has(3);
  void clearTime() => clearField(4);

  ErrorResponse get error => $_getN(4);
  set error(ErrorResponse v) { setField(10, v); }
  bool hasError() => $_has(4);
  void clearError() => clearField(10);

  OnOffRequest get onOff => $_getN(5);
  set onOff(OnOffRequest v) { setField(11, v); }
  bool hasOnOff() => $_has(5);
  void clearOnOff() => clearField(11);

  OnOffResponse get onOffResult => $_getN(6);
  set onOffResult(OnOffResponse v) { setField(12, v); }
  bool hasOnOffResult() => $_has(6);
  void clearOnOffResult() => clearField(12);

  GetEntityRequest get getEntity => $_getN(7);
  set getEntity(GetEntityRequest v) { setField(13, v); }
  bool hasGetEntity() => $_has(7);
  void clearGetEntity() => clearField(13);

  GetEntityResponse get getEntityResult => $_getN(8);
  set getEntityResult(GetEntityResponse v) { setField(14, v); }
  bool hasGetEntityResult() => $_has(8);
  void clearGetEntityResult() => clearField(14);

  CreateSceneRequest get createScene => $_getN(9);
  set createScene(CreateSceneRequest v) { setField(15, v); }
  bool hasCreateScene() => $_has(9);
  void clearCreateScene() => clearField(15);

  CreateSceneResponse get createSceneResult => $_getN(10);
  set createSceneResult(CreateSceneResponse v) { setField(16, v); }
  bool hasCreateSceneResult() => $_has(10);
  void clearCreateSceneResult() => clearField(16);

  UpdateSceneRequest get updateScene => $_getN(11);
  set updateScene(UpdateSceneRequest v) { setField(17, v); }
  bool hasUpdateScene() => $_has(11);
  void clearUpdateScene() => clearField(17);

  UpdateSceneResponse get updateSceneResult => $_getN(12);
  set updateSceneResult(UpdateSceneResponse v) { setField(18, v); }
  bool hasUpdateSceneResult() => $_has(12);
  void clearUpdateSceneResult() => clearField(18);

  DeleteSceneRequest get deleteScene => $_getN(13);
  set deleteScene(DeleteSceneRequest v) { setField(19, v); }
  bool hasDeleteScene() => $_has(13);
  void clearDeleteScene() => clearField(19);

  DeleteSceneResponse get deleteSceneResult => $_getN(14);
  set deleteSceneResult(DeleteSceneResponse v) { setField(20, v); }
  bool hasDeleteSceneResult() => $_has(14);
  void clearDeleteSceneResult() => clearField(20);

  SetSceneOnOffRequest get setSceneOnOff => $_getN(15);
  set setSceneOnOff(SetSceneOnOffRequest v) { setField(21, v); }
  bool hasSetSceneOnOff() => $_has(15);
  void clearSetSceneOnOff() => clearField(21);

  SetSceneOnOffResponse get setSceneOnOffResult => $_getN(16);
  set setSceneOnOffResult(SetSceneOnOffResponse v) { setField(22, v); }
  bool hasSetSceneOnOffResult() => $_has(16);
  void clearSetSceneOnOffResult() => clearField(22);

  CreateBindingRequest get createBinding => $_getN(17);
  set createBinding(CreateBindingRequest v) { setField(23, v); }
  bool hasCreateBinding() => $_has(17);
  void clearCreateBinding() => clearField(23);

  CreateBindingResponse get createBindingResult => $_getN(18);
  set createBindingResult(CreateBindingResponse v) { setField(24, v); }
  bool hasCreateBindingResult() => $_has(18);
  void clearCreateBindingResult() => clearField(24);

  UpdateBindingRequest get updateBinding => $_getN(19);
  set updateBinding(UpdateBindingRequest v) { setField(25, v); }
  bool hasUpdateBinding() => $_has(19);
  void clearUpdateBinding() => clearField(25);

  UpdateBindingResponse get updateBindingResult => $_getN(20);
  set updateBindingResult(UpdateBindingResponse v) { setField(26, v); }
  bool hasUpdateBindingResult() => $_has(20);
  void clearUpdateBindingResult() => clearField(26);

  DeleteBindingRequest get deleteBinding => $_getN(21);
  set deleteBinding(DeleteBindingRequest v) { setField(27, v); }
  bool hasDeleteBinding() => $_has(21);
  void clearDeleteBinding() => clearField(27);

  DeleteBindingResponse get deleteBindingResult => $_getN(22);
  set deleteBindingResult(DeleteBindingResponse v) { setField(28, v); }
  bool hasDeleteBindingResult() => $_has(22);
  void clearDeleteBindingResult() => clearField(28);

  SetBindingEnableRequest get setBindingEnable => $_getN(23);
  set setBindingEnable(SetBindingEnableRequest v) { setField(29, v); }
  bool hasSetBindingEnable() => $_has(23);
  void clearSetBindingEnable() => clearField(29);

  SetBindingEnableResponse get setBindingEnableResult => $_getN(24);
  set setBindingEnableResult(SetBindingEnableResponse v) { setField(30, v); }
  bool hasSetBindingEnableResult() => $_has(24);
  void clearSetBindingEnableResult() => clearField(30);

  ConfigEntityInfoRequest get configEntityInfo => $_getN(25);
  set configEntityInfo(ConfigEntityInfoRequest v) { setField(31, v); }
  bool hasConfigEntityInfo() => $_has(25);
  void clearConfigEntityInfo() => clearField(31);

  ConfigEntityInfoResponse get configEntityInfoResult => $_getN(26);
  set configEntityInfoResult(ConfigEntityInfoResponse v) { setField(32, v); }
  bool hasConfigEntityInfoResult() => $_has(26);
  void clearConfigEntityInfoResult() => clearField(32);

  CreateAreaRequest get createArea => $_getN(27);
  set createArea(CreateAreaRequest v) { setField(33, v); }
  bool hasCreateArea() => $_has(27);
  void clearCreateArea() => clearField(33);

  CreateAreaResponse get createAreaResult => $_getN(28);
  set createAreaResult(CreateAreaResponse v) { setField(34, v); }
  bool hasCreateAreaResult() => $_has(28);
  void clearCreateAreaResult() => clearField(34);

  DeleteAreaRequest get deleteArea => $_getN(29);
  set deleteArea(DeleteAreaRequest v) { setField(35, v); }
  bool hasDeleteArea() => $_has(29);
  void clearDeleteArea() => clearField(35);

  DeleteAreaResponse get deleteAreaResult => $_getN(30);
  set deleteAreaResult(DeleteAreaResponse v) { setField(36, v); }
  bool hasDeleteAreaResult() => $_has(30);
  void clearDeleteAreaResult() => clearField(36);

  SetPermitJoinRequest get setPermitJoin => $_getN(31);
  set setPermitJoin(SetPermitJoinRequest v) { setField(37, v); }
  bool hasSetPermitJoin() => $_has(31);
  void clearSetPermitJoin() => clearField(37);

  SetPermitJoinResponse get setPermitJoinResult => $_getN(32);
  set setPermitJoinResult(SetPermitJoinResponse v) { setField(38, v); }
  bool hasSetPermitJoinResult() => $_has(32);
  void clearSetPermitJoinResult() => clearField(38);

  SetAlertLevelRequest get setAlertLevel => $_getN(33);
  set setAlertLevel(SetAlertLevelRequest v) { setField(39, v); }
  bool hasSetAlertLevel() => $_has(33);
  void clearSetAlertLevel() => clearField(39);

  SetAlertLevelResponse get setAlertLevelResult => $_getN(34);
  set setAlertLevelResult(SetAlertLevelResponse v) { setField(40, v); }
  bool hasSetAlertLevelResult() => $_has(34);
  void clearSetAlertLevelResult() => clearField(40);

  ReadAttributeRequest get readAttribute => $_getN(35);
  set readAttribute(ReadAttributeRequest v) { setField(41, v); }
  bool hasReadAttribute() => $_has(35);
  void clearReadAttribute() => clearField(41);

  ReadAttributeResponse get readAttributeResult => $_getN(36);
  set readAttributeResult(ReadAttributeResponse v) { setField(42, v); }
  bool hasReadAttributeResult() => $_has(36);
  void clearReadAttributeResult() => clearField(42);

  FirmwareUpgradeRequest get firmwareUpgrade => $_getN(37);
  set firmwareUpgrade(FirmwareUpgradeRequest v) { setField(43, v); }
  bool hasFirmwareUpgrade() => $_has(37);
  void clearFirmwareUpgrade() => clearField(43);

  FirmwareUpgradeResponse get firmwareUpgradeResult => $_getN(38);
  set firmwareUpgradeResult(FirmwareUpgradeResponse v) { setField(44, v); }
  bool hasFirmwareUpgradeResult() => $_has(38);
  void clearFirmwareUpgradeResult() => clearField(44);

  IdentifyDeviceRequest get identifyDevice => $_getN(39);
  set identifyDevice(IdentifyDeviceRequest v) { setField(45, v); }
  bool hasIdentifyDevice() => $_has(39);
  void clearIdentifyDevice() => clearField(45);

  IdentifyDeviceResponse get identifyDeviceResult => $_getN(40);
  set identifyDeviceResult(IdentifyDeviceResponse v) { setField(46, v); }
  bool hasIdentifyDeviceResult() => $_has(40);
  void clearIdentifyDeviceResult() => clearField(46);

  DeleteEntityRequest get deleteEntity => $_getN(41);
  set deleteEntity(DeleteEntityRequest v) { setField(47, v); }
  bool hasDeleteEntity() => $_has(41);
  void clearDeleteEntity() => clearField(47);

  DeleteEntityResponse get deleteEntityResult => $_getN(42);
  set deleteEntityResult(DeleteEntityResponse v) { setField(48, v); }
  bool hasDeleteEntityResult() => $_has(42);
  void clearDeleteEntityResult() => clearField(48);

  ControlWindowCoveringRequest get controlWindowCovering => $_getN(43);
  set controlWindowCovering(ControlWindowCoveringRequest v) { setField(49, v); }
  bool hasControlWindowCovering() => $_has(43);
  void clearControlWindowCovering() => clearField(49);

  ControlWindowCoveringResponse get controlWindowCoveringResult => $_getN(44);
  set controlWindowCoveringResult(ControlWindowCoveringResponse v) { setField(50, v); }
  bool hasControlWindowCoveringResult() => $_has(44);
  void clearControlWindowCoveringResult() => clearField(50);

  GetTimeRequest get getTime => $_getN(45);
  set getTime(GetTimeRequest v) { setField(51, v); }
  bool hasGetTime() => $_has(45);
  void clearGetTime() => clearField(51);

  GetTimeResponse get getTimeResult => $_getN(46);
  set getTimeResult(GetTimeResponse v) { setField(52, v); }
  bool hasGetTimeResult() => $_has(46);
  void clearGetTimeResult() => clearField(52);

  SetTimeRequest get setTime => $_getN(47);
  set setTime(SetTimeRequest v) { setField(53, v); }
  bool hasSetTime() => $_has(47);
  void clearSetTime() => clearField(53);

  SetTimeResponse get setTimeResult => $_getN(48);
  set setTimeResult(SetTimeResponse v) { setField(54, v); }
  bool hasSetTimeResult() => $_has(48);
  void clearSetTimeResult() => clearField(54);

  DeviceAssociationNotification get deviceAssociation => $_getN(49);
  set deviceAssociation(DeviceAssociationNotification v) { setField(55, v); }
  bool hasDeviceAssociation() => $_has(49);
  void clearDeviceAssociation() => clearField(55);

  CheckNewVersionRequest get checkNewVersion => $_getN(50);
  set checkNewVersion(CheckNewVersionRequest v) { setField(56, v); }
  bool hasCheckNewVersion() => $_has(50);
  void clearCheckNewVersion() => clearField(56);

  SetUpgradePolicyRequest get setUpgradePolicy => $_getN(51);
  set setUpgradePolicy(SetUpgradePolicyRequest v) { setField(57, v); }
  bool hasSetUpgradePolicy() => $_has(51);
  void clearSetUpgradePolicy() => clearField(57);

  SetUpgradePolicyResponse get setUpgradePolicyResult => $_getN(52);
  set setUpgradePolicyResult(SetUpgradePolicyResponse v) { setField(58, v); }
  bool hasSetUpgradePolicyResult() => $_has(52);
  void clearSetUpgradePolicyResult() => clearField(58);

  GetUpgradePolicyRequest get getUpgradePolicy => $_getN(53);
  set getUpgradePolicy(GetUpgradePolicyRequest v) { setField(59, v); }
  bool hasGetUpgradePolicy() => $_has(53);
  void clearGetUpgradePolicy() => clearField(59);

  GetUpgradePolicyResponse get getUpgradePolicyResult => $_getN(54);
  set getUpgradePolicyResult(GetUpgradePolicyResponse v) { setField(60, v); }
  bool hasGetUpgradePolicyResult() => $_has(54);
  void clearGetUpgradePolicyResult() => clearField(60);

  GetHomeKitSettingRequest get getHomeKitSetting => $_getN(55);
  set getHomeKitSetting(GetHomeKitSettingRequest v) { setField(61, v); }
  bool hasGetHomeKitSetting() => $_has(55);
  void clearGetHomeKitSetting() => clearField(61);

  GetHomeKitSettingResponse get getHomeKitSettingResult => $_getN(56);
  set getHomeKitSettingResult(GetHomeKitSettingResponse v) { setField(62, v); }
  bool hasGetHomeKitSettingResult() => $_has(56);
  void clearGetHomeKitSettingResult() => clearField(62);

  WriteAttributeRequest get writeAttribute => $_getN(57);
  set writeAttribute(WriteAttributeRequest v) { setField(63, v); }
  bool hasWriteAttribute() => $_has(57);
  void clearWriteAttribute() => clearField(63);

  WriteAttributeResponse get writeAttributeResult => $_getN(58);
  set writeAttributeResult(WriteAttributeResponse v) { setField(64, v); }
  bool hasWriteAttributeResult() => $_has(58);
  void clearWriteAttributeResult() => clearField(64);

  CheckNewVersionResponse get checkNewVersionResult => $_getN(59);
  set checkNewVersionResult(CheckNewVersionResponse v) { setField(65, v); }
  bool hasCheckNewVersionResult() => $_has(59);
  void clearCheckNewVersionResult() => clearField(65);

  CreateEntityRequest get createEntity => $_getN(60);
  set createEntity(CreateEntityRequest v) { setField(66, v); }
  bool hasCreateEntity() => $_has(60);
  void clearCreateEntity() => clearField(66);

  CreateEntityResponse get createEntityResult => $_getN(61);
  set createEntityResult(CreateEntityResponse v) { setField(67, v); }
  bool hasCreateEntityResult() => $_has(61);
  void clearCreateEntityResult() => clearField(67);

  UpdateEntityRequest get updateEntity => $_getN(62);
  set updateEntity(UpdateEntityRequest v) { setField(68, v); }
  bool hasUpdateEntity() => $_has(62);
  void clearUpdateEntity() => clearField(68);

  UpdateEntityResponse get updateEntityResult => $_getN(63);
  set updateEntityResult(UpdateEntityResponse v) { setField(69, v); }
  bool hasUpdateEntityResult() => $_has(63);
  void clearUpdateEntityResult() => clearField(69);

  AllocateLanAccessTokenRequest get allocateLanAccessToken => $_getN(64);
  set allocateLanAccessToken(AllocateLanAccessTokenRequest v) { setField(70, v); }
  bool hasAllocateLanAccessToken() => $_has(64);
  void clearAllocateLanAccessToken() => clearField(70);

  AllocateLanAccessTokenResponse get allocateLanAccessTokenResult => $_getN(65);
  set allocateLanAccessTokenResult(AllocateLanAccessTokenResponse v) { setField(71, v); }
  bool hasAllocateLanAccessTokenResult() => $_has(65);
  void clearAllocateLanAccessTokenResult() => clearField(71);

  RevokeLanAccessTokenRequest get revokeLanAccessToken => $_getN(66);
  set revokeLanAccessToken(RevokeLanAccessTokenRequest v) { setField(72, v); }
  bool hasRevokeLanAccessToken() => $_has(66);
  void clearRevokeLanAccessToken() => clearField(72);

  RevokeLanAccessTokenResponse get revokeLanAccessTokenResult => $_getN(67);
  set revokeLanAccessTokenResult(RevokeLanAccessTokenResponse v) { setField(73, v); }
  bool hasRevokeLanAccessTokenResult() => $_has(67);
  void clearRevokeLanAccessTokenResult() => clearField(73);

  GetAutomationTimeoutMsRequest get getAutomationTimeoutMs => $_getN(68);
  set getAutomationTimeoutMs(GetAutomationTimeoutMsRequest v) { setField(74, v); }
  bool hasGetAutomationTimeoutMs() => $_has(68);
  void clearGetAutomationTimeoutMs() => clearField(74);

  GetAutomationTimeoutMsResponse get getAutomationTimeoutMsResult => $_getN(69);
  set getAutomationTimeoutMsResult(GetAutomationTimeoutMsResponse v) { setField(75, v); }
  bool hasGetAutomationTimeoutMsResult() => $_has(69);
  void clearGetAutomationTimeoutMsResult() => clearField(75);
}

class ErrorResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ErrorResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..e<$0.ErrorCode>(1, 'code', $pb.PbFieldType.OE, $0.ErrorCode.EC_OK, $0.ErrorCode.valueOf, $0.ErrorCode.values)
    ..aOS(2, 'description')
    ..hasRequiredFields = false
  ;

  ErrorResponse() : super();
  ErrorResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ErrorResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ErrorResponse clone() => new ErrorResponse()..mergeFromMessage(this);
  ErrorResponse copyWith(void Function(ErrorResponse) updates) => super.copyWith((message) => updates(message as ErrorResponse));
  $pb.BuilderInfo get info_ => _i;
  static ErrorResponse create() => new ErrorResponse();
  ErrorResponse createEmptyInstance() => create();
  static $pb.PbList<ErrorResponse> createRepeated() => new $pb.PbList<ErrorResponse>();
  static ErrorResponse getDefault() => _defaultInstance ??= create()..freeze();
  static ErrorResponse _defaultInstance;

  $0.ErrorCode get code => $_getN(0);
  set code($0.ErrorCode v) { setField(1, v); }
  bool hasCode() => $_has(0);
  void clearCode() => clearField(1);

  String get description => $_getS(1, '');
  set description(String v) { $_setString(1, v); }
  bool hasDescription() => $_has(1);
  void clearDescription() => clearField(2);
}

class OnOffRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OnOffRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..e<$0.OnOffCommand>(2, 'command', $pb.PbFieldType.OE, $0.OnOffCommand.Off, $0.OnOffCommand.valueOf, $0.OnOffCommand.values)
    ..hasRequiredFields = false
  ;

  OnOffRequest() : super();
  OnOffRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OnOffRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OnOffRequest clone() => new OnOffRequest()..mergeFromMessage(this);
  OnOffRequest copyWith(void Function(OnOffRequest) updates) => super.copyWith((message) => updates(message as OnOffRequest));
  $pb.BuilderInfo get info_ => _i;
  static OnOffRequest create() => new OnOffRequest();
  OnOffRequest createEmptyInstance() => create();
  static $pb.PbList<OnOffRequest> createRepeated() => new $pb.PbList<OnOffRequest>();
  static OnOffRequest getDefault() => _defaultInstance ??= create()..freeze();
  static OnOffRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  $0.OnOffCommand get command => $_getN(1);
  set command($0.OnOffCommand v) { setField(2, v); }
  bool hasCommand() => $_has(1);
  void clearCommand() => clearField(2);
}

class OnOffResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OnOffResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOB(1, 'status')
    ..hasRequiredFields = false
  ;

  OnOffResponse() : super();
  OnOffResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OnOffResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OnOffResponse clone() => new OnOffResponse()..mergeFromMessage(this);
  OnOffResponse copyWith(void Function(OnOffResponse) updates) => super.copyWith((message) => updates(message as OnOffResponse));
  $pb.BuilderInfo get info_ => _i;
  static OnOffResponse create() => new OnOffResponse();
  OnOffResponse createEmptyInstance() => create();
  static $pb.PbList<OnOffResponse> createRepeated() => new $pb.PbList<OnOffResponse>();
  static OnOffResponse getDefault() => _defaultInstance ??= create()..freeze();
  static OnOffResponse _defaultInstance;

  bool get status => $_get(0, false);
  set status(bool v) { $_setBool(0, v); }
  bool hasStatus() => $_has(0);
  void clearStatus() => clearField(1);
}

class GetEntityRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetEntityRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..e<$0.EntityType>(1, 'type', $pb.PbFieldType.OE, $0.EntityType.EntityDevice, $0.EntityType.valueOf, $0.EntityType.values)
    ..a<int>(2, 'commit', $pb.PbFieldType.OU3)
    ..a<int>(3, 'count', $pb.PbFieldType.OU3)
    ..a<int>(4, 'index', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  GetEntityRequest() : super();
  GetEntityRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetEntityRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetEntityRequest clone() => new GetEntityRequest()..mergeFromMessage(this);
  GetEntityRequest copyWith(void Function(GetEntityRequest) updates) => super.copyWith((message) => updates(message as GetEntityRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetEntityRequest create() => new GetEntityRequest();
  GetEntityRequest createEmptyInstance() => create();
  static $pb.PbList<GetEntityRequest> createRepeated() => new $pb.PbList<GetEntityRequest>();
  static GetEntityRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetEntityRequest _defaultInstance;

  $0.EntityType get type => $_getN(0);
  set type($0.EntityType v) { setField(1, v); }
  bool hasType() => $_has(0);
  void clearType() => clearField(1);

  int get commit => $_get(1, 0);
  set commit(int v) { $_setUnsignedInt32(1, v); }
  bool hasCommit() => $_has(1);
  void clearCommit() => clearField(2);

  int get count => $_get(2, 0);
  set count(int v) { $_setUnsignedInt32(2, v); }
  bool hasCount() => $_has(2);
  void clearCount() => clearField(3);

  int get index => $_get(3, 0);
  set index(int v) { $_setUnsignedInt32(3, v); }
  bool hasIndex() => $_has(3);
  void clearIndex() => clearField(4);
}

class GetEntityResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetEntityResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..pc<$2.LiveEntity>(1, 'entities', $pb.PbFieldType.PM,$2.LiveEntity.create)
    ..a<int>(2, 'countRemaining', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  GetEntityResponse() : super();
  GetEntityResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetEntityResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetEntityResponse clone() => new GetEntityResponse()..mergeFromMessage(this);
  GetEntityResponse copyWith(void Function(GetEntityResponse) updates) => super.copyWith((message) => updates(message as GetEntityResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetEntityResponse create() => new GetEntityResponse();
  GetEntityResponse createEmptyInstance() => create();
  static $pb.PbList<GetEntityResponse> createRepeated() => new $pb.PbList<GetEntityResponse>();
  static GetEntityResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetEntityResponse _defaultInstance;

  List<$2.LiveEntity> get entities => $_getList(0);

  int get countRemaining => $_get(1, 0);
  set countRemaining(int v) { $_setUnsignedInt32(1, v); }
  bool hasCountRemaining() => $_has(1);
  void clearCountRemaining() => clearField(2);
}

class CreateSceneRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateSceneRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'scene', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  CreateSceneRequest() : super();
  CreateSceneRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateSceneRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateSceneRequest clone() => new CreateSceneRequest()..mergeFromMessage(this);
  CreateSceneRequest copyWith(void Function(CreateSceneRequest) updates) => super.copyWith((message) => updates(message as CreateSceneRequest));
  $pb.BuilderInfo get info_ => _i;
  static CreateSceneRequest create() => new CreateSceneRequest();
  CreateSceneRequest createEmptyInstance() => create();
  static $pb.PbList<CreateSceneRequest> createRepeated() => new $pb.PbList<CreateSceneRequest>();
  static CreateSceneRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CreateSceneRequest _defaultInstance;

  $2.LiveEntity get scene => $_getN(0);
  set scene($2.LiveEntity v) { setField(1, v); }
  bool hasScene() => $_has(0);
  void clearScene() => clearField(1);
}

class CreateSceneResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateSceneResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  CreateSceneResponse() : super();
  CreateSceneResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateSceneResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateSceneResponse clone() => new CreateSceneResponse()..mergeFromMessage(this);
  CreateSceneResponse copyWith(void Function(CreateSceneResponse) updates) => super.copyWith((message) => updates(message as CreateSceneResponse));
  $pb.BuilderInfo get info_ => _i;
  static CreateSceneResponse create() => new CreateSceneResponse();
  CreateSceneResponse createEmptyInstance() => create();
  static $pb.PbList<CreateSceneResponse> createRepeated() => new $pb.PbList<CreateSceneResponse>();
  static CreateSceneResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CreateSceneResponse _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class UpdateSceneRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateSceneRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'scene', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  UpdateSceneRequest() : super();
  UpdateSceneRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateSceneRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateSceneRequest clone() => new UpdateSceneRequest()..mergeFromMessage(this);
  UpdateSceneRequest copyWith(void Function(UpdateSceneRequest) updates) => super.copyWith((message) => updates(message as UpdateSceneRequest));
  $pb.BuilderInfo get info_ => _i;
  static UpdateSceneRequest create() => new UpdateSceneRequest();
  UpdateSceneRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateSceneRequest> createRepeated() => new $pb.PbList<UpdateSceneRequest>();
  static UpdateSceneRequest getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateSceneRequest _defaultInstance;

  $2.LiveEntity get scene => $_getN(0);
  set scene($2.LiveEntity v) { setField(1, v); }
  bool hasScene() => $_has(0);
  void clearScene() => clearField(1);
}

class UpdateSceneResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateSceneResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOB(2, 'onOff')
    ..hasRequiredFields = false
  ;

  UpdateSceneResponse() : super();
  UpdateSceneResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateSceneResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateSceneResponse clone() => new UpdateSceneResponse()..mergeFromMessage(this);
  UpdateSceneResponse copyWith(void Function(UpdateSceneResponse) updates) => super.copyWith((message) => updates(message as UpdateSceneResponse));
  $pb.BuilderInfo get info_ => _i;
  static UpdateSceneResponse create() => new UpdateSceneResponse();
  UpdateSceneResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateSceneResponse> createRepeated() => new $pb.PbList<UpdateSceneResponse>();
  static UpdateSceneResponse getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateSceneResponse _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  bool get onOff => $_get(1, false);
  set onOff(bool v) { $_setBool(1, v); }
  bool hasOnOff() => $_has(1);
  void clearOnOff() => clearField(2);
}

class DeleteSceneRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeleteSceneRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  DeleteSceneRequest() : super();
  DeleteSceneRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeleteSceneRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeleteSceneRequest clone() => new DeleteSceneRequest()..mergeFromMessage(this);
  DeleteSceneRequest copyWith(void Function(DeleteSceneRequest) updates) => super.copyWith((message) => updates(message as DeleteSceneRequest));
  $pb.BuilderInfo get info_ => _i;
  static DeleteSceneRequest create() => new DeleteSceneRequest();
  DeleteSceneRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteSceneRequest> createRepeated() => new $pb.PbList<DeleteSceneRequest>();
  static DeleteSceneRequest getDefault() => _defaultInstance ??= create()..freeze();
  static DeleteSceneRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class DeleteSceneResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeleteSceneResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  DeleteSceneResponse() : super();
  DeleteSceneResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeleteSceneResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeleteSceneResponse clone() => new DeleteSceneResponse()..mergeFromMessage(this);
  DeleteSceneResponse copyWith(void Function(DeleteSceneResponse) updates) => super.copyWith((message) => updates(message as DeleteSceneResponse));
  $pb.BuilderInfo get info_ => _i;
  static DeleteSceneResponse create() => new DeleteSceneResponse();
  DeleteSceneResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteSceneResponse> createRepeated() => new $pb.PbList<DeleteSceneResponse>();
  static DeleteSceneResponse getDefault() => _defaultInstance ??= create()..freeze();
  static DeleteSceneResponse _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class SetSceneOnOffRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetSceneOnOffRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..e<$0.OnOffCommand>(2, 'command', $pb.PbFieldType.OE, $0.OnOffCommand.Off, $0.OnOffCommand.valueOf, $0.OnOffCommand.values)
    ..hasRequiredFields = false
  ;

  SetSceneOnOffRequest() : super();
  SetSceneOnOffRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetSceneOnOffRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetSceneOnOffRequest clone() => new SetSceneOnOffRequest()..mergeFromMessage(this);
  SetSceneOnOffRequest copyWith(void Function(SetSceneOnOffRequest) updates) => super.copyWith((message) => updates(message as SetSceneOnOffRequest));
  $pb.BuilderInfo get info_ => _i;
  static SetSceneOnOffRequest create() => new SetSceneOnOffRequest();
  SetSceneOnOffRequest createEmptyInstance() => create();
  static $pb.PbList<SetSceneOnOffRequest> createRepeated() => new $pb.PbList<SetSceneOnOffRequest>();
  static SetSceneOnOffRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SetSceneOnOffRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  $0.OnOffCommand get command => $_getN(1);
  set command($0.OnOffCommand v) { setField(2, v); }
  bool hasCommand() => $_has(1);
  void clearCommand() => clearField(2);
}

class SetSceneOnOffResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetSceneOnOffResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOB(2, 'onOff')
    ..e<$0.SceneStage>(3, 'stage', $pb.PbFieldType.OE, $0.SceneStage.INVALIDSTAGE, $0.SceneStage.valueOf, $0.SceneStage.values)
    ..hasRequiredFields = false
  ;

  SetSceneOnOffResponse() : super();
  SetSceneOnOffResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetSceneOnOffResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetSceneOnOffResponse clone() => new SetSceneOnOffResponse()..mergeFromMessage(this);
  SetSceneOnOffResponse copyWith(void Function(SetSceneOnOffResponse) updates) => super.copyWith((message) => updates(message as SetSceneOnOffResponse));
  $pb.BuilderInfo get info_ => _i;
  static SetSceneOnOffResponse create() => new SetSceneOnOffResponse();
  SetSceneOnOffResponse createEmptyInstance() => create();
  static $pb.PbList<SetSceneOnOffResponse> createRepeated() => new $pb.PbList<SetSceneOnOffResponse>();
  static SetSceneOnOffResponse getDefault() => _defaultInstance ??= create()..freeze();
  static SetSceneOnOffResponse _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  bool get onOff => $_get(1, false);
  set onOff(bool v) { $_setBool(1, v); }
  bool hasOnOff() => $_has(1);
  void clearOnOff() => clearField(2);

  $0.SceneStage get stage => $_getN(2);
  set stage($0.SceneStage v) { setField(3, v); }
  bool hasStage() => $_has(2);
  void clearStage() => clearField(3);
}

class CreateBindingRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateBindingRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'binding', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  CreateBindingRequest() : super();
  CreateBindingRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateBindingRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateBindingRequest clone() => new CreateBindingRequest()..mergeFromMessage(this);
  CreateBindingRequest copyWith(void Function(CreateBindingRequest) updates) => super.copyWith((message) => updates(message as CreateBindingRequest));
  $pb.BuilderInfo get info_ => _i;
  static CreateBindingRequest create() => new CreateBindingRequest();
  CreateBindingRequest createEmptyInstance() => create();
  static $pb.PbList<CreateBindingRequest> createRepeated() => new $pb.PbList<CreateBindingRequest>();
  static CreateBindingRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CreateBindingRequest _defaultInstance;

  $2.LiveEntity get binding => $_getN(0);
  set binding($2.LiveEntity v) { setField(1, v); }
  bool hasBinding() => $_has(0);
  void clearBinding() => clearField(1);
}

class CreateBindingResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateBindingResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  CreateBindingResponse() : super();
  CreateBindingResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateBindingResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateBindingResponse clone() => new CreateBindingResponse()..mergeFromMessage(this);
  CreateBindingResponse copyWith(void Function(CreateBindingResponse) updates) => super.copyWith((message) => updates(message as CreateBindingResponse));
  $pb.BuilderInfo get info_ => _i;
  static CreateBindingResponse create() => new CreateBindingResponse();
  CreateBindingResponse createEmptyInstance() => create();
  static $pb.PbList<CreateBindingResponse> createRepeated() => new $pb.PbList<CreateBindingResponse>();
  static CreateBindingResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CreateBindingResponse _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class UpdateBindingRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateBindingRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'binding', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  UpdateBindingRequest() : super();
  UpdateBindingRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateBindingRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateBindingRequest clone() => new UpdateBindingRequest()..mergeFromMessage(this);
  UpdateBindingRequest copyWith(void Function(UpdateBindingRequest) updates) => super.copyWith((message) => updates(message as UpdateBindingRequest));
  $pb.BuilderInfo get info_ => _i;
  static UpdateBindingRequest create() => new UpdateBindingRequest();
  UpdateBindingRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateBindingRequest> createRepeated() => new $pb.PbList<UpdateBindingRequest>();
  static UpdateBindingRequest getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateBindingRequest _defaultInstance;

  $2.LiveEntity get binding => $_getN(0);
  set binding($2.LiveEntity v) { setField(1, v); }
  bool hasBinding() => $_has(0);
  void clearBinding() => clearField(1);
}

class UpdateBindingResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateBindingResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  UpdateBindingResponse() : super();
  UpdateBindingResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateBindingResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateBindingResponse clone() => new UpdateBindingResponse()..mergeFromMessage(this);
  UpdateBindingResponse copyWith(void Function(UpdateBindingResponse) updates) => super.copyWith((message) => updates(message as UpdateBindingResponse));
  $pb.BuilderInfo get info_ => _i;
  static UpdateBindingResponse create() => new UpdateBindingResponse();
  UpdateBindingResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateBindingResponse> createRepeated() => new $pb.PbList<UpdateBindingResponse>();
  static UpdateBindingResponse getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateBindingResponse _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class DeleteBindingRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeleteBindingRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  DeleteBindingRequest() : super();
  DeleteBindingRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeleteBindingRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeleteBindingRequest clone() => new DeleteBindingRequest()..mergeFromMessage(this);
  DeleteBindingRequest copyWith(void Function(DeleteBindingRequest) updates) => super.copyWith((message) => updates(message as DeleteBindingRequest));
  $pb.BuilderInfo get info_ => _i;
  static DeleteBindingRequest create() => new DeleteBindingRequest();
  DeleteBindingRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteBindingRequest> createRepeated() => new $pb.PbList<DeleteBindingRequest>();
  static DeleteBindingRequest getDefault() => _defaultInstance ??= create()..freeze();
  static DeleteBindingRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class DeleteBindingResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeleteBindingResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  DeleteBindingResponse() : super();
  DeleteBindingResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeleteBindingResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeleteBindingResponse clone() => new DeleteBindingResponse()..mergeFromMessage(this);
  DeleteBindingResponse copyWith(void Function(DeleteBindingResponse) updates) => super.copyWith((message) => updates(message as DeleteBindingResponse));
  $pb.BuilderInfo get info_ => _i;
  static DeleteBindingResponse create() => new DeleteBindingResponse();
  DeleteBindingResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteBindingResponse> createRepeated() => new $pb.PbList<DeleteBindingResponse>();
  static DeleteBindingResponse getDefault() => _defaultInstance ??= create()..freeze();
  static DeleteBindingResponse _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class SetBindingEnableRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetBindingEnableRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOB(2, 'enabled')
    ..hasRequiredFields = false
  ;

  SetBindingEnableRequest() : super();
  SetBindingEnableRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetBindingEnableRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetBindingEnableRequest clone() => new SetBindingEnableRequest()..mergeFromMessage(this);
  SetBindingEnableRequest copyWith(void Function(SetBindingEnableRequest) updates) => super.copyWith((message) => updates(message as SetBindingEnableRequest));
  $pb.BuilderInfo get info_ => _i;
  static SetBindingEnableRequest create() => new SetBindingEnableRequest();
  SetBindingEnableRequest createEmptyInstance() => create();
  static $pb.PbList<SetBindingEnableRequest> createRepeated() => new $pb.PbList<SetBindingEnableRequest>();
  static SetBindingEnableRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SetBindingEnableRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  bool get enabled => $_get(1, false);
  set enabled(bool v) { $_setBool(1, v); }
  bool hasEnabled() => $_has(1);
  void clearEnabled() => clearField(2);
}

class SetBindingEnableResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetBindingEnableResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  SetBindingEnableResponse() : super();
  SetBindingEnableResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetBindingEnableResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetBindingEnableResponse clone() => new SetBindingEnableResponse()..mergeFromMessage(this);
  SetBindingEnableResponse copyWith(void Function(SetBindingEnableResponse) updates) => super.copyWith((message) => updates(message as SetBindingEnableResponse));
  $pb.BuilderInfo get info_ => _i;
  static SetBindingEnableResponse create() => new SetBindingEnableResponse();
  SetBindingEnableResponse createEmptyInstance() => create();
  static $pb.PbList<SetBindingEnableResponse> createRepeated() => new $pb.PbList<SetBindingEnableResponse>();
  static SetBindingEnableResponse getDefault() => _defaultInstance ??= create()..freeze();
  static SetBindingEnableResponse _defaultInstance;
}

class ConfigEntityInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigEntityInfoRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..aOS(2, 'name')
    ..aOS(3, 'areaUUID')
    ..hasRequiredFields = false
  ;

  ConfigEntityInfoRequest() : super();
  ConfigEntityInfoRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConfigEntityInfoRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConfigEntityInfoRequest clone() => new ConfigEntityInfoRequest()..mergeFromMessage(this);
  ConfigEntityInfoRequest copyWith(void Function(ConfigEntityInfoRequest) updates) => super.copyWith((message) => updates(message as ConfigEntityInfoRequest));
  $pb.BuilderInfo get info_ => _i;
  static ConfigEntityInfoRequest create() => new ConfigEntityInfoRequest();
  ConfigEntityInfoRequest createEmptyInstance() => create();
  static $pb.PbList<ConfigEntityInfoRequest> createRepeated() => new $pb.PbList<ConfigEntityInfoRequest>();
  static ConfigEntityInfoRequest getDefault() => _defaultInstance ??= create()..freeze();
  static ConfigEntityInfoRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  String get name => $_getS(1, '');
  set name(String v) { $_setString(1, v); }
  bool hasName() => $_has(1);
  void clearName() => clearField(2);

  String get areaUUID => $_getS(2, '');
  set areaUUID(String v) { $_setString(2, v); }
  bool hasAreaUUID() => $_has(2);
  void clearAreaUUID() => clearField(3);
}

class ConfigEntityInfoResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigEntityInfoResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOB(1, 'isNew')
    ..hasRequiredFields = false
  ;

  ConfigEntityInfoResponse() : super();
  ConfigEntityInfoResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConfigEntityInfoResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConfigEntityInfoResponse clone() => new ConfigEntityInfoResponse()..mergeFromMessage(this);
  ConfigEntityInfoResponse copyWith(void Function(ConfigEntityInfoResponse) updates) => super.copyWith((message) => updates(message as ConfigEntityInfoResponse));
  $pb.BuilderInfo get info_ => _i;
  static ConfigEntityInfoResponse create() => new ConfigEntityInfoResponse();
  ConfigEntityInfoResponse createEmptyInstance() => create();
  static $pb.PbList<ConfigEntityInfoResponse> createRepeated() => new $pb.PbList<ConfigEntityInfoResponse>();
  static ConfigEntityInfoResponse getDefault() => _defaultInstance ??= create()..freeze();
  static ConfigEntityInfoResponse _defaultInstance;

  bool get isNew => $_get(0, false);
  set isNew(bool v) { $_setBool(0, v); }
  bool hasIsNew() => $_has(0);
  void clearIsNew() => clearField(1);
}

class CreateAreaRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateAreaRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'name')
    ..hasRequiredFields = false
  ;

  CreateAreaRequest() : super();
  CreateAreaRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateAreaRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateAreaRequest clone() => new CreateAreaRequest()..mergeFromMessage(this);
  CreateAreaRequest copyWith(void Function(CreateAreaRequest) updates) => super.copyWith((message) => updates(message as CreateAreaRequest));
  $pb.BuilderInfo get info_ => _i;
  static CreateAreaRequest create() => new CreateAreaRequest();
  CreateAreaRequest createEmptyInstance() => create();
  static $pb.PbList<CreateAreaRequest> createRepeated() => new $pb.PbList<CreateAreaRequest>();
  static CreateAreaRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CreateAreaRequest _defaultInstance;

  String get name => $_getS(0, '');
  set name(String v) { $_setString(0, v); }
  bool hasName() => $_has(0);
  void clearName() => clearField(1);
}

class CreateAreaResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateAreaResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  CreateAreaResponse() : super();
  CreateAreaResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateAreaResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateAreaResponse clone() => new CreateAreaResponse()..mergeFromMessage(this);
  CreateAreaResponse copyWith(void Function(CreateAreaResponse) updates) => super.copyWith((message) => updates(message as CreateAreaResponse));
  $pb.BuilderInfo get info_ => _i;
  static CreateAreaResponse create() => new CreateAreaResponse();
  CreateAreaResponse createEmptyInstance() => create();
  static $pb.PbList<CreateAreaResponse> createRepeated() => new $pb.PbList<CreateAreaResponse>();
  static CreateAreaResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CreateAreaResponse _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class DeleteAreaRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeleteAreaRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  DeleteAreaRequest() : super();
  DeleteAreaRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeleteAreaRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeleteAreaRequest clone() => new DeleteAreaRequest()..mergeFromMessage(this);
  DeleteAreaRequest copyWith(void Function(DeleteAreaRequest) updates) => super.copyWith((message) => updates(message as DeleteAreaRequest));
  $pb.BuilderInfo get info_ => _i;
  static DeleteAreaRequest create() => new DeleteAreaRequest();
  DeleteAreaRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteAreaRequest> createRepeated() => new $pb.PbList<DeleteAreaRequest>();
  static DeleteAreaRequest getDefault() => _defaultInstance ??= create()..freeze();
  static DeleteAreaRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class DeleteAreaResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeleteAreaResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  DeleteAreaResponse() : super();
  DeleteAreaResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeleteAreaResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeleteAreaResponse clone() => new DeleteAreaResponse()..mergeFromMessage(this);
  DeleteAreaResponse copyWith(void Function(DeleteAreaResponse) updates) => super.copyWith((message) => updates(message as DeleteAreaResponse));
  $pb.BuilderInfo get info_ => _i;
  static DeleteAreaResponse create() => new DeleteAreaResponse();
  DeleteAreaResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteAreaResponse> createRepeated() => new $pb.PbList<DeleteAreaResponse>();
  static DeleteAreaResponse getDefault() => _defaultInstance ??= create()..freeze();
  static DeleteAreaResponse _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class SetPermitJoinRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetPermitJoinRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..a<int>(2, 'duration', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  SetPermitJoinRequest() : super();
  SetPermitJoinRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetPermitJoinRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetPermitJoinRequest clone() => new SetPermitJoinRequest()..mergeFromMessage(this);
  SetPermitJoinRequest copyWith(void Function(SetPermitJoinRequest) updates) => super.copyWith((message) => updates(message as SetPermitJoinRequest));
  $pb.BuilderInfo get info_ => _i;
  static SetPermitJoinRequest create() => new SetPermitJoinRequest();
  SetPermitJoinRequest createEmptyInstance() => create();
  static $pb.PbList<SetPermitJoinRequest> createRepeated() => new $pb.PbList<SetPermitJoinRequest>();
  static SetPermitJoinRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SetPermitJoinRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  int get duration => $_get(1, 0);
  set duration(int v) { $_setUnsignedInt32(1, v); }
  bool hasDuration() => $_has(1);
  void clearDuration() => clearField(2);
}

class SetPermitJoinResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetPermitJoinResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<int>(1, 'duration', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  SetPermitJoinResponse() : super();
  SetPermitJoinResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetPermitJoinResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetPermitJoinResponse clone() => new SetPermitJoinResponse()..mergeFromMessage(this);
  SetPermitJoinResponse copyWith(void Function(SetPermitJoinResponse) updates) => super.copyWith((message) => updates(message as SetPermitJoinResponse));
  $pb.BuilderInfo get info_ => _i;
  static SetPermitJoinResponse create() => new SetPermitJoinResponse();
  SetPermitJoinResponse createEmptyInstance() => create();
  static $pb.PbList<SetPermitJoinResponse> createRepeated() => new $pb.PbList<SetPermitJoinResponse>();
  static SetPermitJoinResponse getDefault() => _defaultInstance ??= create()..freeze();
  static SetPermitJoinResponse _defaultInstance;

  int get duration => $_get(0, 0);
  set duration(int v) { $_setUnsignedInt32(0, v); }
  bool hasDuration() => $_has(0);
  void clearDuration() => clearField(1);
}

class SetAlertLevelRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetAlertLevelRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..a<int>(2, 'level', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  SetAlertLevelRequest() : super();
  SetAlertLevelRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetAlertLevelRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetAlertLevelRequest clone() => new SetAlertLevelRequest()..mergeFromMessage(this);
  SetAlertLevelRequest copyWith(void Function(SetAlertLevelRequest) updates) => super.copyWith((message) => updates(message as SetAlertLevelRequest));
  $pb.BuilderInfo get info_ => _i;
  static SetAlertLevelRequest create() => new SetAlertLevelRequest();
  SetAlertLevelRequest createEmptyInstance() => create();
  static $pb.PbList<SetAlertLevelRequest> createRepeated() => new $pb.PbList<SetAlertLevelRequest>();
  static SetAlertLevelRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SetAlertLevelRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  int get level => $_get(1, 0);
  set level(int v) { $_setUnsignedInt32(1, v); }
  bool hasLevel() => $_has(1);
  void clearLevel() => clearField(2);
}

class SetAlertLevelResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetAlertLevelResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<int>(1, 'level', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  SetAlertLevelResponse() : super();
  SetAlertLevelResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetAlertLevelResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetAlertLevelResponse clone() => new SetAlertLevelResponse()..mergeFromMessage(this);
  SetAlertLevelResponse copyWith(void Function(SetAlertLevelResponse) updates) => super.copyWith((message) => updates(message as SetAlertLevelResponse));
  $pb.BuilderInfo get info_ => _i;
  static SetAlertLevelResponse create() => new SetAlertLevelResponse();
  SetAlertLevelResponse createEmptyInstance() => create();
  static $pb.PbList<SetAlertLevelResponse> createRepeated() => new $pb.PbList<SetAlertLevelResponse>();
  static SetAlertLevelResponse getDefault() => _defaultInstance ??= create()..freeze();
  static SetAlertLevelResponse _defaultInstance;

  int get level => $_get(0, 0);
  set level(int v) { $_setUnsignedInt32(0, v); }
  bool hasLevel() => $_has(0);
  void clearLevel() => clearField(1);
}

class ReadAttributeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ReadAttributeRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..e<$0.AttributeID>(2, 'attrID', $pb.PbFieldType.OE, $0.AttributeID.AttrIDOnOffStatus, $0.AttributeID.valueOf, $0.AttributeID.values)
    ..aOB(3, 'realtime')
    ..a<int>(4, 'timeoutMS', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ReadAttributeRequest() : super();
  ReadAttributeRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ReadAttributeRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ReadAttributeRequest clone() => new ReadAttributeRequest()..mergeFromMessage(this);
  ReadAttributeRequest copyWith(void Function(ReadAttributeRequest) updates) => super.copyWith((message) => updates(message as ReadAttributeRequest));
  $pb.BuilderInfo get info_ => _i;
  static ReadAttributeRequest create() => new ReadAttributeRequest();
  ReadAttributeRequest createEmptyInstance() => create();
  static $pb.PbList<ReadAttributeRequest> createRepeated() => new $pb.PbList<ReadAttributeRequest>();
  static ReadAttributeRequest getDefault() => _defaultInstance ??= create()..freeze();
  static ReadAttributeRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  $0.AttributeID get attrID => $_getN(1);
  set attrID($0.AttributeID v) { setField(2, v); }
  bool hasAttrID() => $_has(1);
  void clearAttrID() => clearField(2);

  bool get realtime => $_get(2, false);
  set realtime(bool v) { $_setBool(2, v); }
  bool hasRealtime() => $_has(2);
  void clearRealtime() => clearField(3);

  int get timeoutMS => $_get(3, 0);
  set timeoutMS(int v) { $_setSignedInt32(3, v); }
  bool hasTimeoutMS() => $_has(3);
  void clearTimeoutMS() => clearField(4);
}

class ReadAttributeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ReadAttributeResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<int>(1, 'code', $pb.PbFieldType.O3)
    ..a<int>(2, 'value', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ReadAttributeResponse() : super();
  ReadAttributeResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ReadAttributeResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ReadAttributeResponse clone() => new ReadAttributeResponse()..mergeFromMessage(this);
  ReadAttributeResponse copyWith(void Function(ReadAttributeResponse) updates) => super.copyWith((message) => updates(message as ReadAttributeResponse));
  $pb.BuilderInfo get info_ => _i;
  static ReadAttributeResponse create() => new ReadAttributeResponse();
  ReadAttributeResponse createEmptyInstance() => create();
  static $pb.PbList<ReadAttributeResponse> createRepeated() => new $pb.PbList<ReadAttributeResponse>();
  static ReadAttributeResponse getDefault() => _defaultInstance ??= create()..freeze();
  static ReadAttributeResponse _defaultInstance;

  int get code => $_get(0, 0);
  set code(int v) { $_setSignedInt32(0, v); }
  bool hasCode() => $_has(0);
  void clearCode() => clearField(1);

  int get value => $_get(1, 0);
  set value(int v) { $_setSignedInt32(1, v); }
  bool hasValue() => $_has(1);
  void clearValue() => clearField(2);
}

class WriteAttributeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('WriteAttributeRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..e<$0.AttributeID>(2, 'attrID', $pb.PbFieldType.OE, $0.AttributeID.AttrIDOnOffStatus, $0.AttributeID.valueOf, $0.AttributeID.values)
    ..a<int>(3, 'value', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  WriteAttributeRequest() : super();
  WriteAttributeRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  WriteAttributeRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  WriteAttributeRequest clone() => new WriteAttributeRequest()..mergeFromMessage(this);
  WriteAttributeRequest copyWith(void Function(WriteAttributeRequest) updates) => super.copyWith((message) => updates(message as WriteAttributeRequest));
  $pb.BuilderInfo get info_ => _i;
  static WriteAttributeRequest create() => new WriteAttributeRequest();
  WriteAttributeRequest createEmptyInstance() => create();
  static $pb.PbList<WriteAttributeRequest> createRepeated() => new $pb.PbList<WriteAttributeRequest>();
  static WriteAttributeRequest getDefault() => _defaultInstance ??= create()..freeze();
  static WriteAttributeRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  $0.AttributeID get attrID => $_getN(1);
  set attrID($0.AttributeID v) { setField(2, v); }
  bool hasAttrID() => $_has(1);
  void clearAttrID() => clearField(2);

  int get value => $_get(2, 0);
  set value(int v) { $_setSignedInt32(2, v); }
  bool hasValue() => $_has(2);
  void clearValue() => clearField(3);
}

class WriteAttributeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('WriteAttributeResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<int>(1, 'code', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  WriteAttributeResponse() : super();
  WriteAttributeResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  WriteAttributeResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  WriteAttributeResponse clone() => new WriteAttributeResponse()..mergeFromMessage(this);
  WriteAttributeResponse copyWith(void Function(WriteAttributeResponse) updates) => super.copyWith((message) => updates(message as WriteAttributeResponse));
  $pb.BuilderInfo get info_ => _i;
  static WriteAttributeResponse create() => new WriteAttributeResponse();
  WriteAttributeResponse createEmptyInstance() => create();
  static $pb.PbList<WriteAttributeResponse> createRepeated() => new $pb.PbList<WriteAttributeResponse>();
  static WriteAttributeResponse getDefault() => _defaultInstance ??= create()..freeze();
  static WriteAttributeResponse _defaultInstance;

  int get code => $_get(0, 0);
  set code(int v) { $_setSignedInt32(0, v); }
  bool hasCode() => $_has(0);
  void clearCode() => clearField(1);
}

class FirmwareUpgradeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FirmwareUpgradeRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'firmwareUUID')
    ..aOS(2, 'devices')
    ..hasRequiredFields = false
  ;

  FirmwareUpgradeRequest() : super();
  FirmwareUpgradeRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FirmwareUpgradeRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FirmwareUpgradeRequest clone() => new FirmwareUpgradeRequest()..mergeFromMessage(this);
  FirmwareUpgradeRequest copyWith(void Function(FirmwareUpgradeRequest) updates) => super.copyWith((message) => updates(message as FirmwareUpgradeRequest));
  $pb.BuilderInfo get info_ => _i;
  static FirmwareUpgradeRequest create() => new FirmwareUpgradeRequest();
  FirmwareUpgradeRequest createEmptyInstance() => create();
  static $pb.PbList<FirmwareUpgradeRequest> createRepeated() => new $pb.PbList<FirmwareUpgradeRequest>();
  static FirmwareUpgradeRequest getDefault() => _defaultInstance ??= create()..freeze();
  static FirmwareUpgradeRequest _defaultInstance;

  String get firmwareUUID => $_getS(0, '');
  set firmwareUUID(String v) { $_setString(0, v); }
  bool hasFirmwareUUID() => $_has(0);
  void clearFirmwareUUID() => clearField(1);

  String get devices => $_getS(1, '');
  set devices(String v) { $_setString(1, v); }
  bool hasDevices() => $_has(1);
  void clearDevices() => clearField(2);
}

class FirmwareUpgradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FirmwareUpgradeResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  FirmwareUpgradeResponse() : super();
  FirmwareUpgradeResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FirmwareUpgradeResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FirmwareUpgradeResponse clone() => new FirmwareUpgradeResponse()..mergeFromMessage(this);
  FirmwareUpgradeResponse copyWith(void Function(FirmwareUpgradeResponse) updates) => super.copyWith((message) => updates(message as FirmwareUpgradeResponse));
  $pb.BuilderInfo get info_ => _i;
  static FirmwareUpgradeResponse create() => new FirmwareUpgradeResponse();
  FirmwareUpgradeResponse createEmptyInstance() => create();
  static $pb.PbList<FirmwareUpgradeResponse> createRepeated() => new $pb.PbList<FirmwareUpgradeResponse>();
  static FirmwareUpgradeResponse getDefault() => _defaultInstance ??= create()..freeze();
  static FirmwareUpgradeResponse _defaultInstance;
}

class IdentifyDeviceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('IdentifyDeviceRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..a<int>(2, 'duration', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  IdentifyDeviceRequest() : super();
  IdentifyDeviceRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  IdentifyDeviceRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  IdentifyDeviceRequest clone() => new IdentifyDeviceRequest()..mergeFromMessage(this);
  IdentifyDeviceRequest copyWith(void Function(IdentifyDeviceRequest) updates) => super.copyWith((message) => updates(message as IdentifyDeviceRequest));
  $pb.BuilderInfo get info_ => _i;
  static IdentifyDeviceRequest create() => new IdentifyDeviceRequest();
  IdentifyDeviceRequest createEmptyInstance() => create();
  static $pb.PbList<IdentifyDeviceRequest> createRepeated() => new $pb.PbList<IdentifyDeviceRequest>();
  static IdentifyDeviceRequest getDefault() => _defaultInstance ??= create()..freeze();
  static IdentifyDeviceRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  int get duration => $_get(1, 0);
  set duration(int v) { $_setSignedInt32(1, v); }
  bool hasDuration() => $_has(1);
  void clearDuration() => clearField(2);
}

class IdentifyDeviceResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('IdentifyDeviceResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  IdentifyDeviceResponse() : super();
  IdentifyDeviceResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  IdentifyDeviceResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  IdentifyDeviceResponse clone() => new IdentifyDeviceResponse()..mergeFromMessage(this);
  IdentifyDeviceResponse copyWith(void Function(IdentifyDeviceResponse) updates) => super.copyWith((message) => updates(message as IdentifyDeviceResponse));
  $pb.BuilderInfo get info_ => _i;
  static IdentifyDeviceResponse create() => new IdentifyDeviceResponse();
  IdentifyDeviceResponse createEmptyInstance() => create();
  static $pb.PbList<IdentifyDeviceResponse> createRepeated() => new $pb.PbList<IdentifyDeviceResponse>();
  static IdentifyDeviceResponse getDefault() => _defaultInstance ??= create()..freeze();
  static IdentifyDeviceResponse _defaultInstance;
}

class DeleteEntityRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeleteEntityRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  DeleteEntityRequest() : super();
  DeleteEntityRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeleteEntityRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeleteEntityRequest clone() => new DeleteEntityRequest()..mergeFromMessage(this);
  DeleteEntityRequest copyWith(void Function(DeleteEntityRequest) updates) => super.copyWith((message) => updates(message as DeleteEntityRequest));
  $pb.BuilderInfo get info_ => _i;
  static DeleteEntityRequest create() => new DeleteEntityRequest();
  DeleteEntityRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteEntityRequest> createRepeated() => new $pb.PbList<DeleteEntityRequest>();
  static DeleteEntityRequest getDefault() => _defaultInstance ??= create()..freeze();
  static DeleteEntityRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class DeleteEntityResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeleteEntityResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  DeleteEntityResponse() : super();
  DeleteEntityResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeleteEntityResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeleteEntityResponse clone() => new DeleteEntityResponse()..mergeFromMessage(this);
  DeleteEntityResponse copyWith(void Function(DeleteEntityResponse) updates) => super.copyWith((message) => updates(message as DeleteEntityResponse));
  $pb.BuilderInfo get info_ => _i;
  static DeleteEntityResponse create() => new DeleteEntityResponse();
  DeleteEntityResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteEntityResponse> createRepeated() => new $pb.PbList<DeleteEntityResponse>();
  static DeleteEntityResponse getDefault() => _defaultInstance ??= create()..freeze();
  static DeleteEntityResponse _defaultInstance;
}

class ControlWindowCoveringRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ControlWindowCoveringRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..a<int>(2, 'percent', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  ControlWindowCoveringRequest() : super();
  ControlWindowCoveringRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ControlWindowCoveringRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ControlWindowCoveringRequest clone() => new ControlWindowCoveringRequest()..mergeFromMessage(this);
  ControlWindowCoveringRequest copyWith(void Function(ControlWindowCoveringRequest) updates) => super.copyWith((message) => updates(message as ControlWindowCoveringRequest));
  $pb.BuilderInfo get info_ => _i;
  static ControlWindowCoveringRequest create() => new ControlWindowCoveringRequest();
  ControlWindowCoveringRequest createEmptyInstance() => create();
  static $pb.PbList<ControlWindowCoveringRequest> createRepeated() => new $pb.PbList<ControlWindowCoveringRequest>();
  static ControlWindowCoveringRequest getDefault() => _defaultInstance ??= create()..freeze();
  static ControlWindowCoveringRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);

  int get percent => $_get(1, 0);
  set percent(int v) { $_setUnsignedInt32(1, v); }
  bool hasPercent() => $_has(1);
  void clearPercent() => clearField(2);
}

class ControlWindowCoveringResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ControlWindowCoveringResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  ControlWindowCoveringResponse() : super();
  ControlWindowCoveringResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ControlWindowCoveringResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ControlWindowCoveringResponse clone() => new ControlWindowCoveringResponse()..mergeFromMessage(this);
  ControlWindowCoveringResponse copyWith(void Function(ControlWindowCoveringResponse) updates) => super.copyWith((message) => updates(message as ControlWindowCoveringResponse));
  $pb.BuilderInfo get info_ => _i;
  static ControlWindowCoveringResponse create() => new ControlWindowCoveringResponse();
  ControlWindowCoveringResponse createEmptyInstance() => create();
  static $pb.PbList<ControlWindowCoveringResponse> createRepeated() => new $pb.PbList<ControlWindowCoveringResponse>();
  static ControlWindowCoveringResponse getDefault() => _defaultInstance ??= create()..freeze();
  static ControlWindowCoveringResponse _defaultInstance;
}

class GetTimeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetTimeRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  GetTimeRequest() : super();
  GetTimeRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetTimeRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetTimeRequest clone() => new GetTimeRequest()..mergeFromMessage(this);
  GetTimeRequest copyWith(void Function(GetTimeRequest) updates) => super.copyWith((message) => updates(message as GetTimeRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetTimeRequest create() => new GetTimeRequest();
  GetTimeRequest createEmptyInstance() => create();
  static $pb.PbList<GetTimeRequest> createRepeated() => new $pb.PbList<GetTimeRequest>();
  static GetTimeRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetTimeRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class GetTimeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetTimeResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'time')
    ..aOS(2, 'timeZone')
    ..hasRequiredFields = false
  ;

  GetTimeResponse() : super();
  GetTimeResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetTimeResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetTimeResponse clone() => new GetTimeResponse()..mergeFromMessage(this);
  GetTimeResponse copyWith(void Function(GetTimeResponse) updates) => super.copyWith((message) => updates(message as GetTimeResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetTimeResponse create() => new GetTimeResponse();
  GetTimeResponse createEmptyInstance() => create();
  static $pb.PbList<GetTimeResponse> createRepeated() => new $pb.PbList<GetTimeResponse>();
  static GetTimeResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetTimeResponse _defaultInstance;

  String get time => $_getS(0, '');
  set time(String v) { $_setString(0, v); }
  bool hasTime() => $_has(0);
  void clearTime() => clearField(1);

  String get timeZone => $_getS(1, '');
  set timeZone(String v) { $_setString(1, v); }
  bool hasTimeZone() => $_has(1);
  void clearTimeZone() => clearField(2);
}

class SetTimeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetTimeRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'time')
    ..aOS(2, 'timeZone')
    ..hasRequiredFields = false
  ;

  SetTimeRequest() : super();
  SetTimeRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetTimeRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetTimeRequest clone() => new SetTimeRequest()..mergeFromMessage(this);
  SetTimeRequest copyWith(void Function(SetTimeRequest) updates) => super.copyWith((message) => updates(message as SetTimeRequest));
  $pb.BuilderInfo get info_ => _i;
  static SetTimeRequest create() => new SetTimeRequest();
  SetTimeRequest createEmptyInstance() => create();
  static $pb.PbList<SetTimeRequest> createRepeated() => new $pb.PbList<SetTimeRequest>();
  static SetTimeRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SetTimeRequest _defaultInstance;

  String get time => $_getS(0, '');
  set time(String v) { $_setString(0, v); }
  bool hasTime() => $_has(0);
  void clearTime() => clearField(1);

  String get timeZone => $_getS(1, '');
  set timeZone(String v) { $_setString(1, v); }
  bool hasTimeZone() => $_has(1);
  void clearTimeZone() => clearField(2);
}

class SetTimeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetTimeResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  SetTimeResponse() : super();
  SetTimeResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetTimeResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetTimeResponse clone() => new SetTimeResponse()..mergeFromMessage(this);
  SetTimeResponse copyWith(void Function(SetTimeResponse) updates) => super.copyWith((message) => updates(message as SetTimeResponse));
  $pb.BuilderInfo get info_ => _i;
  static SetTimeResponse create() => new SetTimeResponse();
  SetTimeResponse createEmptyInstance() => create();
  static $pb.PbList<SetTimeResponse> createRepeated() => new $pb.PbList<SetTimeResponse>();
  static SetTimeResponse getDefault() => _defaultInstance ??= create()..freeze();
  static SetTimeResponse _defaultInstance;
}

class DeviceAssociationNotification extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeviceAssociationNotification', package: const $pb.PackageName('xiaoyan.protocol'))
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

  DeviceAssociationNotification() : super();
  DeviceAssociationNotification.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeviceAssociationNotification.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeviceAssociationNotification clone() => new DeviceAssociationNotification()..mergeFromMessage(this);
  DeviceAssociationNotification copyWith(void Function(DeviceAssociationNotification) updates) => super.copyWith((message) => updates(message as DeviceAssociationNotification));
  $pb.BuilderInfo get info_ => _i;
  static DeviceAssociationNotification create() => new DeviceAssociationNotification();
  DeviceAssociationNotification createEmptyInstance() => create();
  static $pb.PbList<DeviceAssociationNotification> createRepeated() => new $pb.PbList<DeviceAssociationNotification>();
  static DeviceAssociationNotification getDefault() => _defaultInstance ??= create()..freeze();
  static DeviceAssociationNotification _defaultInstance;

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

class CheckNewVersionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CheckNewVersionRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  CheckNewVersionRequest() : super();
  CheckNewVersionRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CheckNewVersionRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CheckNewVersionRequest clone() => new CheckNewVersionRequest()..mergeFromMessage(this);
  CheckNewVersionRequest copyWith(void Function(CheckNewVersionRequest) updates) => super.copyWith((message) => updates(message as CheckNewVersionRequest));
  $pb.BuilderInfo get info_ => _i;
  static CheckNewVersionRequest create() => new CheckNewVersionRequest();
  CheckNewVersionRequest createEmptyInstance() => create();
  static $pb.PbList<CheckNewVersionRequest> createRepeated() => new $pb.PbList<CheckNewVersionRequest>();
  static CheckNewVersionRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CheckNewVersionRequest _defaultInstance;
}

class CheckNewVersionResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CheckNewVersionResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  CheckNewVersionResponse() : super();
  CheckNewVersionResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CheckNewVersionResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CheckNewVersionResponse clone() => new CheckNewVersionResponse()..mergeFromMessage(this);
  CheckNewVersionResponse copyWith(void Function(CheckNewVersionResponse) updates) => super.copyWith((message) => updates(message as CheckNewVersionResponse));
  $pb.BuilderInfo get info_ => _i;
  static CheckNewVersionResponse create() => new CheckNewVersionResponse();
  CheckNewVersionResponse createEmptyInstance() => create();
  static $pb.PbList<CheckNewVersionResponse> createRepeated() => new $pb.PbList<CheckNewVersionResponse>();
  static CheckNewVersionResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CheckNewVersionResponse _defaultInstance;
}

class SetUpgradePolicyRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetUpgradePolicyRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'channel')
    ..a<int>(2, 'interval', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  SetUpgradePolicyRequest() : super();
  SetUpgradePolicyRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetUpgradePolicyRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetUpgradePolicyRequest clone() => new SetUpgradePolicyRequest()..mergeFromMessage(this);
  SetUpgradePolicyRequest copyWith(void Function(SetUpgradePolicyRequest) updates) => super.copyWith((message) => updates(message as SetUpgradePolicyRequest));
  $pb.BuilderInfo get info_ => _i;
  static SetUpgradePolicyRequest create() => new SetUpgradePolicyRequest();
  SetUpgradePolicyRequest createEmptyInstance() => create();
  static $pb.PbList<SetUpgradePolicyRequest> createRepeated() => new $pb.PbList<SetUpgradePolicyRequest>();
  static SetUpgradePolicyRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SetUpgradePolicyRequest _defaultInstance;

  String get channel => $_getS(0, '');
  set channel(String v) { $_setString(0, v); }
  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);

  int get interval => $_get(1, 0);
  set interval(int v) { $_setUnsignedInt32(1, v); }
  bool hasInterval() => $_has(1);
  void clearInterval() => clearField(2);
}

class SetUpgradePolicyResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SetUpgradePolicyResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  SetUpgradePolicyResponse() : super();
  SetUpgradePolicyResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SetUpgradePolicyResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SetUpgradePolicyResponse clone() => new SetUpgradePolicyResponse()..mergeFromMessage(this);
  SetUpgradePolicyResponse copyWith(void Function(SetUpgradePolicyResponse) updates) => super.copyWith((message) => updates(message as SetUpgradePolicyResponse));
  $pb.BuilderInfo get info_ => _i;
  static SetUpgradePolicyResponse create() => new SetUpgradePolicyResponse();
  SetUpgradePolicyResponse createEmptyInstance() => create();
  static $pb.PbList<SetUpgradePolicyResponse> createRepeated() => new $pb.PbList<SetUpgradePolicyResponse>();
  static SetUpgradePolicyResponse getDefault() => _defaultInstance ??= create()..freeze();
  static SetUpgradePolicyResponse _defaultInstance;
}

class GetUpgradePolicyRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetUpgradePolicyRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  GetUpgradePolicyRequest() : super();
  GetUpgradePolicyRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetUpgradePolicyRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetUpgradePolicyRequest clone() => new GetUpgradePolicyRequest()..mergeFromMessage(this);
  GetUpgradePolicyRequest copyWith(void Function(GetUpgradePolicyRequest) updates) => super.copyWith((message) => updates(message as GetUpgradePolicyRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetUpgradePolicyRequest create() => new GetUpgradePolicyRequest();
  GetUpgradePolicyRequest createEmptyInstance() => create();
  static $pb.PbList<GetUpgradePolicyRequest> createRepeated() => new $pb.PbList<GetUpgradePolicyRequest>();
  static GetUpgradePolicyRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetUpgradePolicyRequest _defaultInstance;
}

class GetUpgradePolicyResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetUpgradePolicyResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'channel')
    ..a<int>(2, 'interval', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  GetUpgradePolicyResponse() : super();
  GetUpgradePolicyResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetUpgradePolicyResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetUpgradePolicyResponse clone() => new GetUpgradePolicyResponse()..mergeFromMessage(this);
  GetUpgradePolicyResponse copyWith(void Function(GetUpgradePolicyResponse) updates) => super.copyWith((message) => updates(message as GetUpgradePolicyResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetUpgradePolicyResponse create() => new GetUpgradePolicyResponse();
  GetUpgradePolicyResponse createEmptyInstance() => create();
  static $pb.PbList<GetUpgradePolicyResponse> createRepeated() => new $pb.PbList<GetUpgradePolicyResponse>();
  static GetUpgradePolicyResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetUpgradePolicyResponse _defaultInstance;

  String get channel => $_getS(0, '');
  set channel(String v) { $_setString(0, v); }
  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);

  int get interval => $_get(1, 0);
  set interval(int v) { $_setUnsignedInt32(1, v); }
  bool hasInterval() => $_has(1);
  void clearInterval() => clearField(2);
}

class GetHomeKitSettingRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetHomeKitSettingRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  GetHomeKitSettingRequest() : super();
  GetHomeKitSettingRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetHomeKitSettingRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetHomeKitSettingRequest clone() => new GetHomeKitSettingRequest()..mergeFromMessage(this);
  GetHomeKitSettingRequest copyWith(void Function(GetHomeKitSettingRequest) updates) => super.copyWith((message) => updates(message as GetHomeKitSettingRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetHomeKitSettingRequest create() => new GetHomeKitSettingRequest();
  GetHomeKitSettingRequest createEmptyInstance() => create();
  static $pb.PbList<GetHomeKitSettingRequest> createRepeated() => new $pb.PbList<GetHomeKitSettingRequest>();
  static GetHomeKitSettingRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetHomeKitSettingRequest _defaultInstance;
}

class GetHomeKitSettingResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetHomeKitSettingResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'setupCode')
    ..hasRequiredFields = false
  ;

  GetHomeKitSettingResponse() : super();
  GetHomeKitSettingResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetHomeKitSettingResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetHomeKitSettingResponse clone() => new GetHomeKitSettingResponse()..mergeFromMessage(this);
  GetHomeKitSettingResponse copyWith(void Function(GetHomeKitSettingResponse) updates) => super.copyWith((message) => updates(message as GetHomeKitSettingResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetHomeKitSettingResponse create() => new GetHomeKitSettingResponse();
  GetHomeKitSettingResponse createEmptyInstance() => create();
  static $pb.PbList<GetHomeKitSettingResponse> createRepeated() => new $pb.PbList<GetHomeKitSettingResponse>();
  static GetHomeKitSettingResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetHomeKitSettingResponse _defaultInstance;

  String get setupCode => $_getS(0, '');
  set setupCode(String v) { $_setString(0, v); }
  bool hasSetupCode() => $_has(0);
  void clearSetupCode() => clearField(1);
}

class CreateEntityRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateEntityRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'entity', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  CreateEntityRequest() : super();
  CreateEntityRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateEntityRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateEntityRequest clone() => new CreateEntityRequest()..mergeFromMessage(this);
  CreateEntityRequest copyWith(void Function(CreateEntityRequest) updates) => super.copyWith((message) => updates(message as CreateEntityRequest));
  $pb.BuilderInfo get info_ => _i;
  static CreateEntityRequest create() => new CreateEntityRequest();
  CreateEntityRequest createEmptyInstance() => create();
  static $pb.PbList<CreateEntityRequest> createRepeated() => new $pb.PbList<CreateEntityRequest>();
  static CreateEntityRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CreateEntityRequest _defaultInstance;

  $2.LiveEntity get entity => $_getN(0);
  set entity($2.LiveEntity v) { setField(1, v); }
  bool hasEntity() => $_has(0);
  void clearEntity() => clearField(1);
}

class CreateEntityResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateEntityResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  CreateEntityResponse() : super();
  CreateEntityResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateEntityResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateEntityResponse clone() => new CreateEntityResponse()..mergeFromMessage(this);
  CreateEntityResponse copyWith(void Function(CreateEntityResponse) updates) => super.copyWith((message) => updates(message as CreateEntityResponse));
  $pb.BuilderInfo get info_ => _i;
  static CreateEntityResponse create() => new CreateEntityResponse();
  CreateEntityResponse createEmptyInstance() => create();
  static $pb.PbList<CreateEntityResponse> createRepeated() => new $pb.PbList<CreateEntityResponse>();
  static CreateEntityResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CreateEntityResponse _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class UpdateEntityRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateEntityRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..a<$2.LiveEntity>(1, 'entity', $pb.PbFieldType.OM, $2.LiveEntity.getDefault, $2.LiveEntity.create)
    ..hasRequiredFields = false
  ;

  UpdateEntityRequest() : super();
  UpdateEntityRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateEntityRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateEntityRequest clone() => new UpdateEntityRequest()..mergeFromMessage(this);
  UpdateEntityRequest copyWith(void Function(UpdateEntityRequest) updates) => super.copyWith((message) => updates(message as UpdateEntityRequest));
  $pb.BuilderInfo get info_ => _i;
  static UpdateEntityRequest create() => new UpdateEntityRequest();
  UpdateEntityRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateEntityRequest> createRepeated() => new $pb.PbList<UpdateEntityRequest>();
  static UpdateEntityRequest getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateEntityRequest _defaultInstance;

  $2.LiveEntity get entity => $_getN(0);
  set entity($2.LiveEntity v) { setField(1, v); }
  bool hasEntity() => $_has(0);
  void clearEntity() => clearField(1);
}

class UpdateEntityResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateEntityResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  UpdateEntityResponse() : super();
  UpdateEntityResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateEntityResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateEntityResponse clone() => new UpdateEntityResponse()..mergeFromMessage(this);
  UpdateEntityResponse copyWith(void Function(UpdateEntityResponse) updates) => super.copyWith((message) => updates(message as UpdateEntityResponse));
  $pb.BuilderInfo get info_ => _i;
  static UpdateEntityResponse create() => new UpdateEntityResponse();
  UpdateEntityResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateEntityResponse> createRepeated() => new $pb.PbList<UpdateEntityResponse>();
  static UpdateEntityResponse getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateEntityResponse _defaultInstance;
}

class AllocateLanAccessTokenRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AllocateLanAccessTokenRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'clientID')
    ..a<int>(2, 'expirationSeconds', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  AllocateLanAccessTokenRequest() : super();
  AllocateLanAccessTokenRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AllocateLanAccessTokenRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AllocateLanAccessTokenRequest clone() => new AllocateLanAccessTokenRequest()..mergeFromMessage(this);
  AllocateLanAccessTokenRequest copyWith(void Function(AllocateLanAccessTokenRequest) updates) => super.copyWith((message) => updates(message as AllocateLanAccessTokenRequest));
  $pb.BuilderInfo get info_ => _i;
  static AllocateLanAccessTokenRequest create() => new AllocateLanAccessTokenRequest();
  AllocateLanAccessTokenRequest createEmptyInstance() => create();
  static $pb.PbList<AllocateLanAccessTokenRequest> createRepeated() => new $pb.PbList<AllocateLanAccessTokenRequest>();
  static AllocateLanAccessTokenRequest getDefault() => _defaultInstance ??= create()..freeze();
  static AllocateLanAccessTokenRequest _defaultInstance;

  String get clientID => $_getS(0, '');
  set clientID(String v) { $_setString(0, v); }
  bool hasClientID() => $_has(0);
  void clearClientID() => clearField(1);

  int get expirationSeconds => $_get(1, 0);
  set expirationSeconds(int v) { $_setSignedInt32(1, v); }
  bool hasExpirationSeconds() => $_has(1);
  void clearExpirationSeconds() => clearField(2);
}

class AllocateLanAccessTokenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AllocateLanAccessTokenResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'accessToken')
    ..hasRequiredFields = false
  ;

  AllocateLanAccessTokenResponse() : super();
  AllocateLanAccessTokenResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AllocateLanAccessTokenResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AllocateLanAccessTokenResponse clone() => new AllocateLanAccessTokenResponse()..mergeFromMessage(this);
  AllocateLanAccessTokenResponse copyWith(void Function(AllocateLanAccessTokenResponse) updates) => super.copyWith((message) => updates(message as AllocateLanAccessTokenResponse));
  $pb.BuilderInfo get info_ => _i;
  static AllocateLanAccessTokenResponse create() => new AllocateLanAccessTokenResponse();
  AllocateLanAccessTokenResponse createEmptyInstance() => create();
  static $pb.PbList<AllocateLanAccessTokenResponse> createRepeated() => new $pb.PbList<AllocateLanAccessTokenResponse>();
  static AllocateLanAccessTokenResponse getDefault() => _defaultInstance ??= create()..freeze();
  static AllocateLanAccessTokenResponse _defaultInstance;

  String get accessToken => $_getS(0, '');
  set accessToken(String v) { $_setString(0, v); }
  bool hasAccessToken() => $_has(0);
  void clearAccessToken() => clearField(1);
}

class RevokeLanAccessTokenRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RevokeLanAccessTokenRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'clientID')
    ..hasRequiredFields = false
  ;

  RevokeLanAccessTokenRequest() : super();
  RevokeLanAccessTokenRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RevokeLanAccessTokenRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RevokeLanAccessTokenRequest clone() => new RevokeLanAccessTokenRequest()..mergeFromMessage(this);
  RevokeLanAccessTokenRequest copyWith(void Function(RevokeLanAccessTokenRequest) updates) => super.copyWith((message) => updates(message as RevokeLanAccessTokenRequest));
  $pb.BuilderInfo get info_ => _i;
  static RevokeLanAccessTokenRequest create() => new RevokeLanAccessTokenRequest();
  RevokeLanAccessTokenRequest createEmptyInstance() => create();
  static $pb.PbList<RevokeLanAccessTokenRequest> createRepeated() => new $pb.PbList<RevokeLanAccessTokenRequest>();
  static RevokeLanAccessTokenRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RevokeLanAccessTokenRequest _defaultInstance;

  String get clientID => $_getS(0, '');
  set clientID(String v) { $_setString(0, v); }
  bool hasClientID() => $_has(0);
  void clearClientID() => clearField(1);
}

class RevokeLanAccessTokenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RevokeLanAccessTokenResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..hasRequiredFields = false
  ;

  RevokeLanAccessTokenResponse() : super();
  RevokeLanAccessTokenResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RevokeLanAccessTokenResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RevokeLanAccessTokenResponse clone() => new RevokeLanAccessTokenResponse()..mergeFromMessage(this);
  RevokeLanAccessTokenResponse copyWith(void Function(RevokeLanAccessTokenResponse) updates) => super.copyWith((message) => updates(message as RevokeLanAccessTokenResponse));
  $pb.BuilderInfo get info_ => _i;
  static RevokeLanAccessTokenResponse create() => new RevokeLanAccessTokenResponse();
  RevokeLanAccessTokenResponse createEmptyInstance() => create();
  static $pb.PbList<RevokeLanAccessTokenResponse> createRepeated() => new $pb.PbList<RevokeLanAccessTokenResponse>();
  static RevokeLanAccessTokenResponse getDefault() => _defaultInstance ??= create()..freeze();
  static RevokeLanAccessTokenResponse _defaultInstance;
}

class GetAutomationTimeoutMsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetAutomationTimeoutMsRequest', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aOS(1, 'uUID')
    ..hasRequiredFields = false
  ;

  GetAutomationTimeoutMsRequest() : super();
  GetAutomationTimeoutMsRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetAutomationTimeoutMsRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetAutomationTimeoutMsRequest clone() => new GetAutomationTimeoutMsRequest()..mergeFromMessage(this);
  GetAutomationTimeoutMsRequest copyWith(void Function(GetAutomationTimeoutMsRequest) updates) => super.copyWith((message) => updates(message as GetAutomationTimeoutMsRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetAutomationTimeoutMsRequest create() => new GetAutomationTimeoutMsRequest();
  GetAutomationTimeoutMsRequest createEmptyInstance() => create();
  static $pb.PbList<GetAutomationTimeoutMsRequest> createRepeated() => new $pb.PbList<GetAutomationTimeoutMsRequest>();
  static GetAutomationTimeoutMsRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetAutomationTimeoutMsRequest _defaultInstance;

  String get uUID => $_getS(0, '');
  set uUID(String v) { $_setString(0, v); }
  bool hasUUID() => $_has(0);
  void clearUUID() => clearField(1);
}

class GetAutomationTimeoutMsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetAutomationTimeoutMsResponse', package: const $pb.PackageName('xiaoyan.protocol'))
    ..aInt64(1, 'timeoutMS')
    ..hasRequiredFields = false
  ;

  GetAutomationTimeoutMsResponse() : super();
  GetAutomationTimeoutMsResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetAutomationTimeoutMsResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetAutomationTimeoutMsResponse clone() => new GetAutomationTimeoutMsResponse()..mergeFromMessage(this);
  GetAutomationTimeoutMsResponse copyWith(void Function(GetAutomationTimeoutMsResponse) updates) => super.copyWith((message) => updates(message as GetAutomationTimeoutMsResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetAutomationTimeoutMsResponse create() => new GetAutomationTimeoutMsResponse();
  GetAutomationTimeoutMsResponse createEmptyInstance() => create();
  static $pb.PbList<GetAutomationTimeoutMsResponse> createRepeated() => new $pb.PbList<GetAutomationTimeoutMsResponse>();
  static GetAutomationTimeoutMsResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetAutomationTimeoutMsResponse _defaultInstance;

  Int64 get timeoutMS => $_getI64(0);
  set timeoutMS(Int64 v) { $_setInt64(0, v); }
  bool hasTimeoutMS() => $_has(0);
  void clearTimeoutMS() => clearField(1);
}

