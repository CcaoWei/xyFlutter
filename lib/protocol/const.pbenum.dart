///
//  Generated code. Do not modify.
//  source: const.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class EntityType extends $pb.ProtobufEnum {
  static const EntityType EntityDevice = const EntityType._(0, 'EntityDevice');
  static const EntityType EntityScene = const EntityType._(1, 'EntityScene');
  static const EntityType EntityArea = const EntityType._(2, 'EntityArea');
  static const EntityType EntityBinding = const EntityType._(3, 'EntityBinding');
  static const EntityType EntitySystem = const EntityType._(4, 'EntitySystem');
  static const EntityType EntityFirmware = const EntityType._(5, 'EntityFirmware');
  static const EntityType EntityAutomation = const EntityType._(6, 'EntityAutomation');
  static const EntityType EntityAutomationSet = const EntityType._(7, 'EntityAutomationSet');

  static const List<EntityType> values = const <EntityType> [
    EntityDevice,
    EntityScene,
    EntityArea,
    EntityBinding,
    EntitySystem,
    EntityFirmware,
    EntityAutomation,
    EntityAutomationSet,
  ];

  static final Map<int, EntityType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EntityType valueOf(int value) => _byValue[value];

  const EntityType._(int v, String n) : super(v, n);
}

class AttributeID extends $pb.ProtobufEnum {
  static const AttributeID AttrIDOnOffStatus = const AttributeID._(0, 'AttrIDOnOffStatus');
  static const AttributeID AttrIDTotalPower = const AttributeID._(1, 'AttrIDTotalPower');
  static const AttributeID AttrIDActivePower = const AttributeID._(2, 'AttrIDActivePower');
  static const AttributeID AttrIDInsertExtractStatus = const AttributeID._(3, 'AttrIDInsertExtractStatus');
  static const AttributeID AttrIDOccupancy = const AttributeID._(4, 'AttrIDOccupancy');
  static const AttributeID AttrIDLuminance = const AttributeID._(5, 'AttrIDLuminance');
  static const AttributeID AttrIDTemperature = const AttributeID._(6, 'AttrIDTemperature');
  static const AttributeID AttrIDBinInputStatus = const AttributeID._(7, 'AttrIDBinInputStatus');
  static const AttributeID AttrIDBatteryPercent = const AttributeID._(8, 'AttrIDBatteryPercent');
  static const AttributeID AttrIDFirmwareVersion = const AttributeID._(9, 'AttrIDFirmwareVersion');
  static const AttributeID AttrIDZBPermitJoin = const AttributeID._(10, 'AttrIDZBPermitJoin');
  static const AttributeID AttrIDWindowCoveringDirection = const AttributeID._(11, 'AttrIDWindowCoveringDirection');
  static const AttributeID AttrIDWindowTargetLiftPercent = const AttributeID._(12, 'AttrIDWindowTargetLiftPercent');
  static const AttributeID AttrIDWindowCurrentLiftPercent = const AttributeID._(13, 'AttrIDWindowCurrentLiftPercent');
  static const AttributeID AttrIDSupportOTA = const AttributeID._(14, 'AttrIDSupportOTA');
  static const AttributeID AttrIDAlertLevel = const AttributeID._(15, 'AttrIDAlertLevel');
  static const AttributeID AttrIDWindowCoveringMotorStatus = const AttributeID._(16, 'AttrIDWindowCoveringMotorStatus');
  static const AttributeID AttrIDWindowCoveringMotorTripConfigured = const AttributeID._(17, 'AttrIDWindowCoveringMotorTripConfigured');
  static const AttributeID AttrIDWindowCoveringUserType = const AttributeID._(18, 'AttrIDWindowCoveringUserType');
  static const AttributeID AttrIDWindowCoveringMotorTripAdjusting = const AttributeID._(19, 'AttrIDWindowCoveringMotorTripAdjusting');
  static const AttributeID AttrIDEntityIsNew = const AttributeID._(20, 'AttrIDEntityIsNew');
  static const AttributeID AttrIDDeviceJoinedTime = const AttributeID._(21, 'AttrIDDeviceJoinedTime');
  static const AttributeID AttrIDDeviceConnectedTime = const AttributeID._(22, 'AttrIDDeviceConnectedTime');
  static const AttributeID AttrIDOccupancyLeft = const AttributeID._(23, 'AttrIDOccupancyLeft');
  static const AttributeID AttrIDOccupancyRight = const AttributeID._(24, 'AttrIDOccupancyRight');
  static const AttributeID AttrIDCfgIndicatorLED = const AttributeID._(25, 'AttrIDCfgIndicatorLED');
  static const AttributeID AttrIDCfgDisableRelay = const AttributeID._(26, 'AttrIDCfgDisableRelay');
  static const AttributeID AttrIDCfgButtonBindingType = const AttributeID._(27, 'AttrIDCfgButtonBindingType');
  static const AttributeID AttrIDCfgLEDIllumThreshold = const AttributeID._(28, 'AttrIDCfgLEDIllumThreshold');
  static const AttributeID AttrIDFirmwareUpgradingVersion = const AttributeID._(29, 'AttrIDFirmwareUpgradingVersion');
  static const AttributeID AttrIDFirmwareUpgradingPercent = const AttributeID._(30, 'AttrIDFirmwareUpgradingPercent');
  static const AttributeID AttrIDEnableKeepOnOffStatus = const AttributeID._(31, 'AttrIDEnableKeepOnOffStatus');
  static const AttributeID AttrIDFirmwareRecommandVersion = const AttributeID._(32, 'AttrIDFirmwareRecommandVersion');
  static const AttributeID AttrIDLastKnobAngle = const AttributeID._(33, 'AttrIDLastKnobAngle');
  static const AttributeID AttrIDLastKnobUsedMS = const AttributeID._(34, 'AttrIDLastKnobUsedMS');
  static const AttributeID AttrIDAutoEnabled = const AttributeID._(35, 'AttrIDAutoEnabled');
  static const AttributeID AttrIDAutoRenderType = const AttributeID._(36, 'AttrIDAutoRenderType');
  static const AttributeID AttrIDAutoSetID = const AttributeID._(37, 'AttrIDAutoSetID');
  static const AttributeID AttrIDCFGSWPureInput = const AttributeID._(38, 'AttrIDCFGSWPureInput');
  static const AttributeID AttrIDCFGSWInputMode = const AttributeID._(39, 'AttrIDCFGSWInputMode');
  static const AttributeID AttrIDCFGSWPolarity = const AttributeID._(40, 'AttrIDCFGSWPolarity');
  static const AttributeID AttrIDCFGButtonLEDStatus = const AttributeID._(41, 'AttrIDCFGButtonLEDStatus');
  static const AttributeID AttrIDAutoVersion = const AttributeID._(42, 'AttrIDAutoVersion');
  static const AttributeID AttrIDLCTargetLevel = const AttributeID._(43, 'AttrIDLCTargetLevel');
  static const AttributeID AttrIDLCCurrentLevel = const AttributeID._(44, 'AttrIDLCCurrentLevel');
  static const AttributeID AttrIDDisabledRelayStatus = const AttributeID._(45, 'AttrIDDisabledRelayStatus');
  static const AttributeID AttrIDNumOfTimeoutControls = const AttributeID._(46, 'AttrIDNumOfTimeoutControls');
  static const AttributeID AttrIDZHHIsOnline = const AttributeID._(47, 'AttrIDZHHIsOnline');
  static const AttributeID AttrIDZHHIsRunning = const AttributeID._(48, 'AttrIDZHHIsRunning');
  static const AttributeID AttrIDACTargetTemperature = const AttributeID._(49, 'AttrIDACTargetTemperature');
  static const AttributeID AttrIDACCurrentTemperature = const AttributeID._(50, 'AttrIDACCurrentTemperature');
  static const AttributeID AttrIDACFanSpeed = const AttributeID._(51, 'AttrIDACFanSpeed');
  static const AttributeID AttrIDACWorkMode = const AttributeID._(52, 'AttrIDACWorkMode');
  static const AttributeID AttrIDZHHErrorCode = const AttributeID._(53, 'AttrIDZHHErrorCode');
  static const AttributeID AttrIDCFGMutexedIndex = const AttributeID._(54, 'AttrIDCFGMutexedIndex');
  static const AttributeID AttrIDCFGMutexedDelayMs = const AttributeID._(55, 'AttrIDCFGMutexedDelayMs');
  static const AttributeID AttrIDCFGButtonLEDPolarity = const AttributeID._(56, 'AttrIDCFGButtonLEDPolarity');
  static const AttributeID AttrIDCFGLoopHasRelay = const AttributeID._(57, 'AttrIDCFGLoopHasRelay');
  static const AttributeID AttrIDCFGSelfBindingID = const AttributeID._(58, 'AttrIDCFGSelfBindingID');
  static const AttributeID AttrIDAutoSetClass = const AttributeID._(59, 'AttrIDAutoSetClass');
  static const AttributeID AttrIDWindowCoveringMotorType = const AttributeID._(60, 'AttrIDWindowCoveringMotorType');
  static const AttributeID AttrIDColorTemperature = const AttributeID._(61, 'AttrIDColorTemperature');
  static const AttributeID AttrIDColorCurrentX = const AttributeID._(62, 'AttrIDColorCurrentX');
  static const AttributeID AttrIDColorCurrentY = const AttributeID._(63, 'AttrIDColorCurrentY');
  static const AttributeID AttrIDColorCIEYXY = const AttributeID._(64, 'AttrIDColorCIEYXY');
  static const AttributeID AttrIDColorCIERGB = const AttributeID._(65, 'AttrIDColorCIERGB');
  static const AttributeID AttrIDZBChannel = const AttributeID._(66, 'AttrIDZBChannel');
  static const AttributeID AttrIDCFGTurnOnOnly = const AttributeID._(67, 'AttrIDCFGTurnOnOnly');
  static const AttributeID AttrIDCFGTurnOffDelayMs = const AttributeID._(68, 'AttrIDCFGTurnOffDelayMs');
  static const AttributeID AttrIDCFGSwitchDirection = const AttributeID._(69, 'AttrIDCFGSwitchDirection');
  static const AttributeID AttrIDAutoTimerState = const AttributeID._(70, 'AttrIDAutoTimerState');
  static const AttributeID AttrIDAutoTimerRemainedTimeMs = const AttributeID._(71, 'AttrIDAutoTimerRemainedTimeMs');
  static const AttributeID AttrIDAutoExecState = const AttributeID._(72, 'AttrIDAutoExecState');
  static const AttributeID AttrIDDoorLockState = const AttributeID._(73, 'AttrIDDoorLockState');
  static const AttributeID AttrIDWindowConveringControlState = const AttributeID._(74, 'AttrIDWindowConveringControlState');
  static const AttributeID AttrIDZBChannelUpdateState = const AttributeID._(75, 'AttrIDZBChannelUpdateState');

  static const List<AttributeID> values = const <AttributeID> [
    AttrIDOnOffStatus,
    AttrIDTotalPower,
    AttrIDActivePower,
    AttrIDInsertExtractStatus,
    AttrIDOccupancy,
    AttrIDLuminance,
    AttrIDTemperature,
    AttrIDBinInputStatus,
    AttrIDBatteryPercent,
    AttrIDFirmwareVersion,
    AttrIDZBPermitJoin,
    AttrIDWindowCoveringDirection,
    AttrIDWindowTargetLiftPercent,
    AttrIDWindowCurrentLiftPercent,
    AttrIDSupportOTA,
    AttrIDAlertLevel,
    AttrIDWindowCoveringMotorStatus,
    AttrIDWindowCoveringMotorTripConfigured,
    AttrIDWindowCoveringUserType,
    AttrIDWindowCoveringMotorTripAdjusting,
    AttrIDEntityIsNew,
    AttrIDDeviceJoinedTime,
    AttrIDDeviceConnectedTime,
    AttrIDOccupancyLeft,
    AttrIDOccupancyRight,
    AttrIDCfgIndicatorLED,
    AttrIDCfgDisableRelay,
    AttrIDCfgButtonBindingType,
    AttrIDCfgLEDIllumThreshold,
    AttrIDFirmwareUpgradingVersion,
    AttrIDFirmwareUpgradingPercent,
    AttrIDEnableKeepOnOffStatus,
    AttrIDFirmwareRecommandVersion,
    AttrIDLastKnobAngle,
    AttrIDLastKnobUsedMS,
    AttrIDAutoEnabled,
    AttrIDAutoRenderType,
    AttrIDAutoSetID,
    AttrIDCFGSWPureInput,
    AttrIDCFGSWInputMode,
    AttrIDCFGSWPolarity,
    AttrIDCFGButtonLEDStatus,
    AttrIDAutoVersion,
    AttrIDLCTargetLevel,
    AttrIDLCCurrentLevel,
    AttrIDDisabledRelayStatus,
    AttrIDNumOfTimeoutControls,
    AttrIDZHHIsOnline,
    AttrIDZHHIsRunning,
    AttrIDACTargetTemperature,
    AttrIDACCurrentTemperature,
    AttrIDACFanSpeed,
    AttrIDACWorkMode,
    AttrIDZHHErrorCode,
    AttrIDCFGMutexedIndex,
    AttrIDCFGMutexedDelayMs,
    AttrIDCFGButtonLEDPolarity,
    AttrIDCFGLoopHasRelay,
    AttrIDCFGSelfBindingID,
    AttrIDAutoSetClass,
    AttrIDWindowCoveringMotorType,
    AttrIDColorTemperature,
    AttrIDColorCurrentX,
    AttrIDColorCurrentY,
    AttrIDColorCIEYXY,
    AttrIDColorCIERGB,
    AttrIDZBChannel,
    AttrIDCFGTurnOnOnly,
    AttrIDCFGTurnOffDelayMs,
    AttrIDCFGSwitchDirection,
    AttrIDAutoTimerState,
    AttrIDAutoTimerRemainedTimeMs,
    AttrIDAutoExecState,
    AttrIDDoorLockState,
    AttrIDWindowConveringControlState,
    AttrIDZBChannelUpdateState,
  ];

  static final Map<int, AttributeID> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AttributeID valueOf(int value) => _byValue[value];

  const AttributeID._(int v, String n) : super(v, n);
}

class DeviceProfile extends $pb.ProtobufEnum {
  static const DeviceProfile ProfilePIR = const DeviceProfile._(0, 'ProfilePIR');
  static const DeviceProfile SmartPlug = const DeviceProfile._(1, 'SmartPlug');
  static const DeviceProfile OnOffLight = const DeviceProfile._(2, 'OnOffLight');
  static const DeviceProfile DoorContact = const DeviceProfile._(3, 'DoorContact');
  static const DeviceProfile OnOffSwitch = const DeviceProfile._(4, 'OnOffSwitch');
  static const DeviceProfile WindowCovering = const DeviceProfile._(5, 'WindowCovering');
  static const DeviceProfile YanButton = const DeviceProfile._(6, 'YanButton');
  static const DeviceProfile SmartDial = const DeviceProfile._(7, 'SmartDial');
  static const DeviceProfile ColorLight = const DeviceProfile._(8, 'ColorLight');
  static const DeviceProfile HAZHHGateway = const DeviceProfile._(9, 'HAZHHGateway');
  static const DeviceProfile HAZHHUnitMachine = const DeviceProfile._(10, 'HAZHHUnitMachine');
  static const DeviceProfile HADoorLock = const DeviceProfile._(11, 'HADoorLock');
  static const DeviceProfile ZLLExtendedColorLight = const DeviceProfile._(12, 'ZLLExtendedColorLight');
  static const DeviceProfile ZLLColorTemperatureLight = const DeviceProfile._(13, 'ZLLColorTemperatureLight');

  static const List<DeviceProfile> values = const <DeviceProfile> [
    ProfilePIR,
    SmartPlug,
    OnOffLight,
    DoorContact,
    OnOffSwitch,
    WindowCovering,
    YanButton,
    SmartDial,
    ColorLight,
    HAZHHGateway,
    HAZHHUnitMachine,
    HADoorLock,
    ZLLExtendedColorLight,
    ZLLColorTemperatureLight,
  ];

  static final Map<int, DeviceProfile> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DeviceProfile valueOf(int value) => _byValue[value];

  const DeviceProfile._(int v, String n) : super(v, n);
}

class BindingType extends $pb.ProtobufEnum {
  static const BindingType Invalid = const BindingType._(0, 'Invalid');
  static const BindingType Keypress = const BindingType._(1, 'Keypress');
  static const BindingType OpenClose = const BindingType._(2, 'OpenClose');
  static const BindingType PIR = const BindingType._(3, 'PIR');
  static const BindingType SmartDialBinding = const BindingType._(4, 'SmartDialBinding');

  static const List<BindingType> values = const <BindingType> [
    Invalid,
    Keypress,
    OpenClose,
    PIR,
    SmartDialBinding,
  ];

  static final Map<int, BindingType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static BindingType valueOf(int value) => _byValue[value];

  const BindingType._(int v, String n) : super(v, n);
}

class SceneStage extends $pb.ProtobufEnum {
  static const SceneStage INVALIDSTAGE = const SceneStage._(0, 'INVALIDSTAGE');
  static const SceneStage SceneStarted = const SceneStage._(1, 'SceneStarted');
  static const SceneStage SceneFinished = const SceneStage._(2, 'SceneFinished');

  static const List<SceneStage> values = const <SceneStage> [
    INVALIDSTAGE,
    SceneStarted,
    SceneFinished,
  ];

  static final Map<int, SceneStage> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SceneStage valueOf(int value) => _byValue[value];

  const SceneStage._(int v, String n) : super(v, n);
}

class ActionStage extends $pb.ProtobufEnum {
  static const ActionStage ActionStarted = const ActionStage._(0, 'ActionStarted');
  static const ActionStage ActionFinsihed = const ActionStage._(1, 'ActionFinsihed');

  static const List<ActionStage> values = const <ActionStage> [
    ActionStarted,
    ActionFinsihed,
  ];

  static final Map<int, ActionStage> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ActionStage valueOf(int value) => _byValue[value];

  const ActionStage._(int v, String n) : super(v, n);
}

class OnOffCommand extends $pb.ProtobufEnum {
  static const OnOffCommand Off = const OnOffCommand._(0, 'Off');
  static const OnOffCommand On = const OnOffCommand._(1, 'On');
  static const OnOffCommand Toggle = const OnOffCommand._(2, 'Toggle');

  static const List<OnOffCommand> values = const <OnOffCommand> [
    Off,
    On,
    Toggle,
  ];

  static final Map<int, OnOffCommand> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OnOffCommand valueOf(int value) => _byValue[value];

  const OnOffCommand._(int v, String n) : super(v, n);
}

class WindowCoveringMotorStatus extends $pb.ProtobufEnum {
  static const WindowCoveringMotorStatus Quiet = const WindowCoveringMotorStatus._(0, 'Quiet');
  static const WindowCoveringMotorStatus Opening = const WindowCoveringMotorStatus._(1, 'Opening');
  static const WindowCoveringMotorStatus Closing = const WindowCoveringMotorStatus._(2, 'Closing');
  static const WindowCoveringMotorStatus Setting = const WindowCoveringMotorStatus._(3, 'Setting');
  static const WindowCoveringMotorStatus Hijacked = const WindowCoveringMotorStatus._(4, 'Hijacked');

  static const List<WindowCoveringMotorStatus> values = const <WindowCoveringMotorStatus> [
    Quiet,
    Opening,
    Closing,
    Setting,
    Hijacked,
  ];

  static final Map<int, WindowCoveringMotorStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WindowCoveringMotorStatus valueOf(int value) => _byValue[value];

  const WindowCoveringMotorStatus._(int v, String n) : super(v, n);
}

class WindowCoveringUserType extends $pb.ProtobufEnum {
  static const WindowCoveringUserType TypeLeft = const WindowCoveringUserType._(0, 'TypeLeft');
  static const WindowCoveringUserType TypeRight = const WindowCoveringUserType._(1, 'TypeRight');
  static const WindowCoveringUserType TypeBoth = const WindowCoveringUserType._(2, 'TypeBoth');

  static const List<WindowCoveringUserType> values = const <WindowCoveringUserType> [
    TypeLeft,
    TypeRight,
    TypeBoth,
  ];

  static final Map<int, WindowCoveringUserType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WindowCoveringUserType valueOf(int value) => _byValue[value];

  const WindowCoveringUserType._(int v, String n) : super(v, n);
}

class WindowCoveringTripConfigured extends $pb.ProtobufEnum {
  static const WindowCoveringTripConfigured Unconfigured = const WindowCoveringTripConfigured._(0, 'Unconfigured');
  static const WindowCoveringTripConfigured Configured = const WindowCoveringTripConfigured._(1, 'Configured');
  static const WindowCoveringTripConfigured UnknownStatus = const WindowCoveringTripConfigured._(-1, 'UnknownStatus');

  static const List<WindowCoveringTripConfigured> values = const <WindowCoveringTripConfigured> [
    Unconfigured,
    Configured,
    UnknownStatus,
  ];

  static final Map<int, WindowCoveringTripConfigured> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WindowCoveringTripConfigured valueOf(int value) => _byValue[value];

  const WindowCoveringTripConfigured._(int v, String n) : super(v, n);
}

class WindowCoveringMotorDirection extends $pb.ProtobufEnum {
  static const WindowCoveringMotorDirection DirDefault = const WindowCoveringMotorDirection._(0, 'DirDefault');
  static const WindowCoveringMotorDirection DirReverse = const WindowCoveringMotorDirection._(1, 'DirReverse');
  static const WindowCoveringMotorDirection DirUnknown = const WindowCoveringMotorDirection._(2, 'DirUnknown');

  static const List<WindowCoveringMotorDirection> values = const <WindowCoveringMotorDirection> [
    DirDefault,
    DirReverse,
    DirUnknown,
  ];

  static final Map<int, WindowCoveringMotorDirection> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WindowCoveringMotorDirection valueOf(int value) => _byValue[value];

  const WindowCoveringMotorDirection._(int v, String n) : super(v, n);
}

class AssociationAction extends $pb.ProtobufEnum {
  static const AssociationAction ActionShare = const AssociationAction._(0, 'ActionShare');
  static const AssociationAction ActionRequest = const AssociationAction._(1, 'ActionRequest');
  static const AssociationAction ActionAccept = const AssociationAction._(2, 'ActionAccept');
  static const AssociationAction ActionDecline = const AssociationAction._(3, 'ActionDecline');
  static const AssociationAction ActionApprove = const AssociationAction._(4, 'ActionApprove');
  static const AssociationAction ActionReject = const AssociationAction._(5, 'ActionReject');
  static const AssociationAction ActionCancelShare = const AssociationAction._(6, 'ActionCancelShare');
  static const AssociationAction ActionCancelRequest = const AssociationAction._(7, 'ActionCancelRequest');
  static const AssociationAction ActionRemove = const AssociationAction._(8, 'ActionRemove');

  static const List<AssociationAction> values = const <AssociationAction> [
    ActionShare,
    ActionRequest,
    ActionAccept,
    ActionDecline,
    ActionApprove,
    ActionReject,
    ActionCancelShare,
    ActionCancelRequest,
    ActionRemove,
  ];

  static final Map<int, AssociationAction> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AssociationAction valueOf(int value) => _byValue[value];

  const AssociationAction._(int v, String n) : super(v, n);
}

class SubscriptionType extends $pb.ProtobufEnum {
  static const SubscriptionType Unknown = const SubscriptionType._(0, 'Unknown');
  static const SubscriptionType From = const SubscriptionType._(1, 'From');
  static const SubscriptionType To = const SubscriptionType._(2, 'To');
  static const SubscriptionType Both = const SubscriptionType._(3, 'Both');

  static const List<SubscriptionType> values = const <SubscriptionType> [
    Unknown,
    From,
    To,
    Both,
  ];

  static final Map<int, SubscriptionType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SubscriptionType valueOf(int value) => _byValue[value];

  const SubscriptionType._(int v, String n) : super(v, n);
}

class ErrorCode extends $pb.ProtobufEnum {
  static const ErrorCode EC_OK = const ErrorCode._(0, 'EC_OK');
  static const ErrorCode EC_BADREQUEST = const ErrorCode._(-1, 'EC_BADREQUEST');
  static const ErrorCode EC_INVALIDRESPONSE = const ErrorCode._(-2, 'EC_INVALIDRESPONSE');
  static const ErrorCode EC_REQUEST_TIMEOUT = const ErrorCode._(1, 'EC_REQUEST_TIMEOUT');
  static const ErrorCode EC_DEVICE_NOT_EXIST = const ErrorCode._(2, 'EC_DEVICE_NOT_EXIST');
  static const ErrorCode EC_SCENE_NOT_EXIST = const ErrorCode._(3, 'EC_SCENE_NOT_EXIST');
  static const ErrorCode EC_SCENE_ALREADY_ON = const ErrorCode._(4, 'EC_SCENE_ALREADY_ON');
  static const ErrorCode EC_INVALID_DEVICE_TYPE = const ErrorCode._(5, 'EC_INVALID_DEVICE_TYPE');
  static const ErrorCode EC_INVALID_DEVICE_PROFILE = const ErrorCode._(6, 'EC_INVALID_DEVICE_PROFILE');
  static const ErrorCode EC_SCENE_ALREAY_EXIST = const ErrorCode._(7, 'EC_SCENE_ALREAY_EXIST');
  static const ErrorCode EC_SCENE_NOT_TURNED_ON = const ErrorCode._(8, 'EC_SCENE_NOT_TURNED_ON');
  static const ErrorCode EC_SCENE_ALREADY_TURNED_ON = const ErrorCode._(9, 'EC_SCENE_ALREADY_TURNED_ON');
  static const ErrorCode EC_SCENE_ALREADY_TURNED_OFF = const ErrorCode._(10, 'EC_SCENE_ALREADY_TURNED_OFF');
  static const ErrorCode EC_DEVICE_BINDING_TIMEOUT = const ErrorCode._(11, 'EC_DEVICE_BINDING_TIMEOUT');
  static const ErrorCode EC_BIND_INVALID_DEVICE = const ErrorCode._(12, 'EC_BIND_INVALID_DEVICE');
  static const ErrorCode EC_BINDING_ALREADY_EXIST = const ErrorCode._(13, 'EC_BINDING_ALREADY_EXIST');
  static const ErrorCode EC_BINDING_NOT_EXIST = const ErrorCode._(14, 'EC_BINDING_NOT_EXIST');
  static const ErrorCode EC_DELETE_NON_EXIST_BINDING = const ErrorCode._(15, 'EC_DELETE_NON_EXIST_BINDING');
  static const ErrorCode EC_BINDING_UPDATE_SAME_SCENE = const ErrorCode._(16, 'EC_BINDING_UPDATE_SAME_SCENE');
  static const ErrorCode EC_DEVICE_NOT_ONLINE = const ErrorCode._(17, 'EC_DEVICE_NOT_ONLINE');
  static const ErrorCode EC_FAILED_PARSE_JSON_FILE = const ErrorCode._(18, 'EC_FAILED_PARSE_JSON_FILE');
  static const ErrorCode EC_INVALID_SCENE_CONFIG_FILE = const ErrorCode._(19, 'EC_INVALID_SCENE_CONFIG_FILE');
  static const ErrorCode EC_SCENE_EXEC_ALREADY_FINISHED = const ErrorCode._(20, 'EC_SCENE_EXEC_ALREADY_FINISHED');
  static const ErrorCode EC_SCENE_EXEC_WAITING_FOR_ACK = const ErrorCode._(21, 'EC_SCENE_EXEC_WAITING_FOR_ACK');
  static const ErrorCode EC_SCENE_EXEC_TRIED_MAXMUM_TIMES = const ErrorCode._(22, 'EC_SCENE_EXEC_TRIED_MAXMUM_TIMES');
  static const ErrorCode EC_FAILED_OPEN_CONFIG_DIR = const ErrorCode._(23, 'EC_FAILED_OPEN_CONFIG_DIR');
  static const ErrorCode EC_FAILED_FOPEN_FILE = const ErrorCode._(24, 'EC_FAILED_FOPEN_FILE');
  static const ErrorCode EC_DUPLICATE_AREA_NAME = const ErrorCode._(25, 'EC_DUPLICATE_AREA_NAME');
  static const ErrorCode EC_RENAME_NON_EXISTED_AREA = const ErrorCode._(26, 'EC_RENAME_NON_EXISTED_AREA');
  static const ErrorCode EC_DELETE_NON_EXISTED_AREA = const ErrorCode._(27, 'EC_DELETE_NON_EXISTED_AREA');
  static const ErrorCode EC_AREA_NOT_EXIST = const ErrorCode._(28, 'EC_AREA_NOT_EXIST');
  static const ErrorCode EC_DUPLICATE_SCENE_NAME = const ErrorCode._(29, 'EC_DUPLICATE_SCENE_NAME');
  static const ErrorCode EC_DEVICE_ALREADY_ADDED = const ErrorCode._(30, 'EC_DEVICE_ALREADY_ADDED');
  static const ErrorCode EC_SET_SAME_ALERT_LEVEL = const ErrorCode._(31, 'EC_SET_SAME_ALERT_LEVEL');
  static const ErrorCode EC_NO_DEVICE_ADDED = const ErrorCode._(32, 'EC_NO_DEVICE_ADDED');
  static const ErrorCode EC_GLOBAL_SCENE_ON_RUNING = const ErrorCode._(33, 'EC_GLOBAL_SCENE_ON_RUNING');
  static const ErrorCode EC_GLOBAL_SCENE_ALREADY_ON = const ErrorCode._(34, 'EC_GLOBAL_SCENE_ALREADY_ON');
  static const ErrorCode EC_TOGGLE_GLOBAL_SCENE = const ErrorCode._(35, 'EC_TOGGLE_GLOBAL_SCENE');
  static const ErrorCode EC_SCENE_UPDATE_INVALID_PARAMS = const ErrorCode._(36, 'EC_SCENE_UPDATE_INVALID_PARAMS');
  static const ErrorCode EC_MISSED_PARAMETER = const ErrorCode._(37, 'EC_MISSED_PARAMETER');
  static const ErrorCode EC_SCENE_IS_NULL = const ErrorCode._(38, 'EC_SCENE_IS_NULL');
  static const ErrorCode EC_INVALID_PARAMETER = const ErrorCode._(39, 'EC_INVALID_PARAMETER');
  static const ErrorCode EC_INVALID_COMMAND_PARAM = const ErrorCode._(40, 'EC_INVALID_COMMAND_PARAM');
  static const ErrorCode EC_DEVICE_STATUS_ALREADY_SET = const ErrorCode._(41, 'EC_DEVICE_STATUS_ALREADY_SET');
  static const ErrorCode EC_NO_NEED_EXEC_SCENE = const ErrorCode._(42, 'EC_NO_NEED_EXEC_SCENE');
  static const ErrorCode EC_NO_NEED_EXEC_ACTION = const ErrorCode._(43, 'EC_NO_NEED_EXEC_ACTION');
  static const ErrorCode EC_NO_ACTIONS = const ErrorCode._(44, 'EC_NO_ACTIONS');
  static const ErrorCode EC_NO_VALID_ACTION = const ErrorCode._(45, 'EC_NO_VALID_ACTION');
  static const ErrorCode EC_ACTION_PARTLY_VALID = const ErrorCode._(46, 'EC_ACTION_PARTLY_VALID');
  static const ErrorCode EC_INVALID_SCENE = const ErrorCode._(47, 'EC_INVALID_SCENE');
  static const ErrorCode EC_INVALID_ADDRESS = const ErrorCode._(48, 'EC_INVALID_ADDRESS');
  static const ErrorCode EC_SCENE_CONTAINS_NO_DEVICES = const ErrorCode._(49, 'EC_SCENE_CONTAINS_NO_DEVICES');
  static const ErrorCode EC_PERMIT_JOIN_ALREADY_DISABLED = const ErrorCode._(50, 'EC_PERMIT_JOIN_ALREADY_DISABLED');
  static const ErrorCode EC_PERMIT_JOIN_ALREADY_ENABLED = const ErrorCode._(51, 'EC_PERMIT_JOIN_ALREADY_ENABLED');
  static const ErrorCode EC_SAME_REQUEST_ALREADY_STARTED = const ErrorCode._(52, 'EC_SAME_REQUEST_ALREADY_STARTED');
  static const ErrorCode EC_SCENE_EXECUTION_ALREADY_STARTED = const ErrorCode._(53, 'EC_SCENE_EXECUTION_ALREADY_STARTED');
  static const ErrorCode EC_UNKNOWN_PUBSUB_NODE = const ErrorCode._(54, 'EC_UNKNOWN_PUBSUB_NODE');
  static const ErrorCode EC_BINDING_DUPLICATED = const ErrorCode._(55, 'EC_BINDING_DUPLICATED');
  static const ErrorCode EC_BINDING_ALREADY_ENABLED = const ErrorCode._(56, 'EC_BINDING_ALREADY_ENABLED');
  static const ErrorCode EC_ASH_RESET_FAILED = const ErrorCode._(57, 'EC_ASH_RESET_FAILED');
  static const ErrorCode EC_NO_ACTION_TO_RUN = const ErrorCode._(58, 'EC_NO_ACTION_TO_RUN');
  static const ErrorCode EC_SYSTEM_NOT_AVAILABLE = const ErrorCode._(59, 'EC_SYSTEM_NOT_AVAILABLE');
  static const ErrorCode EC_NCP_ERROR_FRAME = const ErrorCode._(60, 'EC_NCP_ERROR_FRAME');
  static const ErrorCode EC_NCP_NOT_EXIST = const ErrorCode._(61, 'EC_NCP_NOT_EXIST');
  static const ErrorCode EC_UN_SUPPORTED = const ErrorCode._(62, 'EC_UN_SUPPORTED');
  static const ErrorCode EC_ENTITY_NOT_AVAILABLE = const ErrorCode._(63, 'EC_ENTITY_NOT_AVAILABLE');
  static const ErrorCode EC_ENGINE_DISCONNECTED = const ErrorCode._(64, 'EC_ENGINE_DISCONNECTED');
  static const ErrorCode EC_FAILED_OPEN_IMAGES_DIR = const ErrorCode._(65, 'EC_FAILED_OPEN_IMAGES_DIR');
  static const ErrorCode EC_UPGRADE_ALREADY_IN_PROGRESS = const ErrorCode._(66, 'EC_UPGRADE_ALREADY_IN_PROGRESS');
  static const ErrorCode EC_UPGRADE_FAIL_TO_LOCK = const ErrorCode._(67, 'EC_UPGRADE_FAIL_TO_LOCK');
  static const ErrorCode EC_UPGRADE_PACKAGE_NOT_FOUND = const ErrorCode._(68, 'EC_UPGRADE_PACKAGE_NOT_FOUND');
  static const ErrorCode EC_UPGRADE_PACKAGE_CORRUPTED = const ErrorCode._(69, 'EC_UPGRADE_PACKAGE_CORRUPTED');
  static const ErrorCode EC_UPGRADE_FAIL_TO_ENABLE_RECOVERY = const ErrorCode._(70, 'EC_UPGRADE_FAIL_TO_ENABLE_RECOVERY');
  static const ErrorCode EC_INVALID_OTA_IMAGE_PATH = const ErrorCode._(71, 'EC_INVALID_OTA_IMAGE_PATH');
  static const ErrorCode EC_INVALID_OTA_IMAGE_DATA = const ErrorCode._(72, 'EC_INVALID_OTA_IMAGE_DATA');
  static const ErrorCode EC_SAME_OTA_IMAGE_ALREADY_LOADED = const ErrorCode._(73, 'EC_SAME_OTA_IMAGE_ALREADY_LOADED');
  static const ErrorCode EC_OTA_IMAGE_NOT_EXIST = const ErrorCode._(74, 'EC_OTA_IMAGE_NOT_EXIST');
  static const ErrorCode EC_FIRMWARE_NOT_EXIST = const ErrorCode._(75, 'EC_FIRMWARE_NOT_EXIST');
  static const ErrorCode EC_INVALID_OTA_IMAGE_TYPE = const ErrorCode._(76, 'EC_INVALID_OTA_IMAGE_TYPE');
  static const ErrorCode EC_NO_DEVICE_MATCHED = const ErrorCode._(77, 'EC_NO_DEVICE_MATCHED');
  static const ErrorCode EC_OTA_TASK_ALREADY_RUNNING = const ErrorCode._(78, 'EC_OTA_TASK_ALREADY_RUNNING');
  static const ErrorCode EC_NO_VALID_OTA_IMAGE = const ErrorCode._(79, 'EC_NO_VALID_OTA_IMAGE');
  static const ErrorCode EC_FEATURE_UNSUPPORTED = const ErrorCode._(80, 'EC_FEATURE_UNSUPPORTED');
  static const ErrorCode EC_INCORRECT_FIRMWARE_VERSION = const ErrorCode._(81, 'EC_INCORRECT_FIRMWARE_VERSION');
  static const ErrorCode EC_OTA_UPGRADE_END_STATUS_ERROR = const ErrorCode._(82, 'EC_OTA_UPGRADE_END_STATUS_ERROR');
  static const ErrorCode EC_OTA_UPGRADE_END_TYPE_ERROR = const ErrorCode._(83, 'EC_OTA_UPGRADE_END_TYPE_ERROR');
  static const ErrorCode EC_OTA_UPGRADE_END_MANU_CODE_ERROR = const ErrorCode._(84, 'EC_OTA_UPGRADE_END_MANU_CODE_ERROR');
  static const ErrorCode EC_OTA_UPGRADE_END_VERSION_ERROR = const ErrorCode._(85, 'EC_OTA_UPGRADE_END_VERSION_ERROR');
  static const ErrorCode EC_OTA_UPGRADE_END_REMAINED_DATA = const ErrorCode._(86, 'EC_OTA_UPGRADE_END_REMAINED_DATA');
  static const ErrorCode EC_FEATURE_ATTRIBUTE_READ_ERROR = const ErrorCode._(87, 'EC_FEATURE_ATTRIBUTE_READ_ERROR');
  static const ErrorCode EC_UNSUPPORTED_ATTR_KEY = const ErrorCode._(88, 'EC_UNSUPPORTED_ATTR_KEY');
  static const ErrorCode EC_ENDPOINT_NOT_EXIST = const ErrorCode._(89, 'EC_ENDPOINT_NOT_EXIST');
  static const ErrorCode EC_ENDPOINT_MISSED_ATTR = const ErrorCode._(90, 'EC_ENDPOINT_MISSED_ATTR');
  static const ErrorCode EC_READ_ATTR_DATA_SIZE_TOO_BIG = const ErrorCode._(91, 'EC_READ_ATTR_DATA_SIZE_TOO_BIG');
  static const ErrorCode EC_READ_ATTR_RESPONSE_ERROR = const ErrorCode._(92, 'EC_READ_ATTR_RESPONSE_ERROR');
  static const ErrorCode EC_OTA_IMAGE_DATA_DAMAGED = const ErrorCode._(93, 'EC_OTA_IMAGE_DATA_DAMAGED');
  static const ErrorCode EC_UNSUPPORTED_READ_ATTR_KEY = const ErrorCode._(94, 'EC_UNSUPPORTED_READ_ATTR_KEY');
  static const ErrorCode EC_OTA_DEVICE_OFFLINE = const ErrorCode._(95, 'EC_OTA_DEVICE_OFFLINE');
  static const ErrorCode EC_ENTITY_NOT_EXIST = const ErrorCode._(96, 'EC_ENTITY_NOT_EXIST');
  static const ErrorCode EC_OTA_START_OFFLINE = const ErrorCode._(97, 'EC_OTA_START_OFFLINE');
  static const ErrorCode EC_DEVICE_UNAVAILABLE = const ErrorCode._(98, 'EC_DEVICE_UNAVAILABLE');
  static const ErrorCode EC_ENTITY_NOT_DEVICE = const ErrorCode._(99, 'EC_ENTITY_NOT_DEVICE');
  static const ErrorCode EC_ENTITY_ALREADY_DELETED = const ErrorCode._(100, 'EC_ENTITY_ALREADY_DELETED');
  static const ErrorCode EC_ENTITY_ALREADY_DELETING = const ErrorCode._(101, 'EC_ENTITY_ALREADY_DELETING');
  static const ErrorCode EC_DELETE_OFFLINE_DEVICE = const ErrorCode._(102, 'EC_DELETE_OFFLINE_DEVICE');
  static const ErrorCode EC_TRIED_DELETE_MAX_TIMES = const ErrorCode._(103, 'EC_TRIED_DELETE_MAX_TIMES');
  static const ErrorCode EC_DELETE_ALREADY_SCHEDULED = const ErrorCode._(104, 'EC_DELETE_ALREADY_SCHEDULED');
  static const ErrorCode EC_ON_SCHEDULE_DELETE_TASK = const ErrorCode._(105, 'EC_ON_SCHEDULE_DELETE_TASK');
  static const ErrorCode EC_ENTITY_UNDELETABLE_DEVICE = const ErrorCode._(106, 'EC_ENTITY_UNDELETABLE_DEVICE');
  static const ErrorCode EC_DEVICE_WITHOUT_ON_OFF_FEATURE = const ErrorCode._(107, 'EC_DEVICE_WITHOUT_ON_OFF_FEATURE');
  static const ErrorCode EC_OTA_IMAGE_NOTIFY_RESPONE = const ErrorCode._(108, 'EC_OTA_IMAGE_NOTIFY_RESPONE');
  static const ErrorCode EC_SYSTEM_UNAVAILABLE = const ErrorCode._(109, 'EC_SYSTEM_UNAVAILABLE');
  static const ErrorCode EC_ZB_ENGINE_DISCONNECTED = const ErrorCode._(110, 'EC_ZB_ENGINE_DISCONNECTED');
  static const ErrorCode EC_VD_ENGINE_DISCONNECTED = const ErrorCode._(111, 'EC_VD_ENGINE_DISCONNECTED');
  static const ErrorCode EC_TARGET_STATUS_CHANGED = const ErrorCode._(112, 'EC_TARGET_STATUS_CHANGED');
  static const ErrorCode EC_ACTION_UNEXECUTABLE = const ErrorCode._(113, 'EC_ACTION_UNEXECUTABLE');
  static const ErrorCode EC_ACTION_TASK_FINISHED = const ErrorCode._(114, 'EC_ACTION_TASK_FINISHED');
  static const ErrorCode EC_FAILED_TOO_MANY_TIMES = const ErrorCode._(115, 'EC_FAILED_TOO_MANY_TIMES');
  static const ErrorCode EC_FAST_POLL_TASK_STOPPED = const ErrorCode._(116, 'EC_FAST_POLL_TASK_STOPPED');
  static const ErrorCode EC_NCP_RESET_FAILURE = const ErrorCode._(117, 'EC_NCP_RESET_FAILURE');
  static const ErrorCode EC_ASH_NOT_WORKING = const ErrorCode._(118, 'EC_ASH_NOT_WORKING');
  static const ErrorCode EC_ASH_INVALID_FRAME = const ErrorCode._(119, 'EC_ASH_INVALID_FRAME');
  static const ErrorCode EC_NCP_UART_WRITE = const ErrorCode._(120, 'EC_NCP_UART_WRITE');
  static const ErrorCode EC_INVALID_ASH_CRC = const ErrorCode._(121, 'EC_INVALID_ASH_CRC');
  static const ErrorCode EC_INVALID_ASH_LENGTH = const ErrorCode._(122, 'EC_INVALID_ASH_LENGTH');
  static const ErrorCode EC_EZSP_INVALID_COMMAND = const ErrorCode._(123, 'EC_EZSP_INVALID_COMMAND');
  static const ErrorCode EC_TASK_FINISHED_DIRECTLY = const ErrorCode._(124, 'EC_TASK_FINISHED_DIRECTLY');
  static const ErrorCode EC_INVALID_ACTION_GROUP_TYPE = const ErrorCode._(125, 'EC_INVALID_ACTION_GROUP_TYPE');
  static const ErrorCode EC_CREATE_NULL_ACTION = const ErrorCode._(126, 'EC_CREATE_NULL_ACTION');
  static const ErrorCode EC_UPDATE_BINDING_DEVICE = const ErrorCode._(127, 'EC_UPDATE_BINDING_DEVICE');
  static const ErrorCode EC_ENTITY_IS_NULL = const ErrorCode._(128, 'EC_ENTITY_IS_NULL');
  static const ErrorCode EC_CONTAINS_DELETED = const ErrorCode._(129, 'EC_CONTAINS_DELETED');
  static const ErrorCode EC_ILLEGAL_ARGUMENT = const ErrorCode._(130, 'EC_ILLEGAL_ARGUMENT');
  static const ErrorCode EC_INVALID_TASK_STATE = const ErrorCode._(131, 'EC_INVALID_TASK_STATE');
  static const ErrorCode EC_DEVICE_HAS_GONE = const ErrorCode._(132, 'EC_DEVICE_HAS_GONE');
  static const ErrorCode EC_ADJUST_TRIP_FAILED_OPENING = const ErrorCode._(133, 'EC_ADJUST_TRIP_FAILED_OPENING');
  static const ErrorCode EC_ADJUST_TRIP_FAILED_CLOSING = const ErrorCode._(134, 'EC_ADJUST_TRIP_FAILED_CLOSING');
  static const ErrorCode EC_ADJUST_TRIP_FAILED_SETTING = const ErrorCode._(135, 'EC_ADJUST_TRIP_FAILED_SETTING');
  static const ErrorCode EC_ADJUST_TRIP_FAILED_TIMEOUT = const ErrorCode._(136, 'EC_ADJUST_TRIP_FAILED_TIMEOUT');
  static const ErrorCode EC_CONTROL_ON_TRIP_ADJUSTING = const ErrorCode._(137, 'EC_CONTROL_ON_TRIP_ADJUSTING');
  static const ErrorCode EC_TRIP_ADJUSTING_NODE_OFFLINE = const ErrorCode._(138, 'EC_TRIP_ADJUSTING_NODE_OFFLINE');
  static const ErrorCode EC_VDS_SUBSCRIBE_INDEX_TOO_BIG = const ErrorCode._(139, 'EC_VDS_SUBSCRIBE_INDEX_TOO_BIG');
  static const ErrorCode EC_ADJUST_TRIP_FAILED_REBOOTING = const ErrorCode._(140, 'EC_ADJUST_TRIP_FAILED_REBOOTING');
  static const ErrorCode EC_ADJUST_TRIP_EXPECT_FINISHED = const ErrorCode._(141, 'EC_ADJUST_TRIP_EXPECT_FINISHED');
  static const ErrorCode EC_ACTION_ENTITY_IS_NULL = const ErrorCode._(142, 'EC_ACTION_ENTITY_IS_NULL');
  static const ErrorCode EC_WRITE_ATTR_FAILED = const ErrorCode._(143, 'EC_WRITE_ATTR_FAILED');
  static const ErrorCode EC_SAME_WRITE_ATTR_TASK = const ErrorCode._(144, 'EC_SAME_WRITE_ATTR_TASK');
  static const ErrorCode EC_PERMIT_JOIN_RESTARTED = const ErrorCode._(145, 'EC_PERMIT_JOIN_RESTARTED');
  static const ErrorCode EC_PERMIT_JOIN_TASK_CANCELED = const ErrorCode._(146, 'EC_PERMIT_JOIN_TASK_CANCELED');
  static const ErrorCode EC_ON_OFF_RELAY_DISABLED = const ErrorCode._(147, 'EC_ON_OFF_RELAY_DISABLED');
  static const ErrorCode EC_EXEC_AUTO_FAILURE = const ErrorCode._(148, 'EC_EXEC_AUTO_FAILURE');
  static const ErrorCode EC_EXEC_AUTO_TIMEOUT = const ErrorCode._(149, 'EC_EXEC_AUTO_TIMEOUT');
  static const ErrorCode EC_PERMIT_JOIN_DURATION_TOO_LONG = const ErrorCode._(150, 'EC_PERMIT_JOIN_DURATION_TOO_LONG');
  static const ErrorCode EC_EMBER_NO_BUFFERS = const ErrorCode._(151, 'EC_EMBER_NO_BUFFERS');
  static const ErrorCode EC_KNOB_ACTION_INVALID_ANGLE = const ErrorCode._(152, 'EC_KNOB_ACTION_INVALID_ANGLE');
  static const ErrorCode EC_ASH_WRITE_FRAME_FAILURE = const ErrorCode._(153, 'EC_ASH_WRITE_FRAME_FAILURE');
  static const ErrorCode EC_ASH_REWRITE_FRAME_FAILURE = const ErrorCode._(154, 'EC_ASH_REWRITE_FRAME_FAILURE');
  static const ErrorCode EC_ASH_NOT_WORKING_TIMEOUT = const ErrorCode._(155, 'EC_ASH_NOT_WORKING_TIMEOUT');
  static const ErrorCode EC_INVALID_METHOD = const ErrorCode._(156, 'EC_INVALID_METHOD');
  static const ErrorCode EC_RECORD_CURRENT_VALUE = const ErrorCode._(157, 'EC_RECORD_CURRENT_VALUE');
  static const ErrorCode EC_NO_EXECUTIONS = const ErrorCode._(158, 'EC_NO_EXECUTIONS');
  static const ErrorCode EC_ACTION_TASK_STOPPED = const ErrorCode._(159, 'EC_ACTION_TASK_STOPPED');
  static const ErrorCode EC_FAILED_ENABLE_AUTO = const ErrorCode._(160, 'EC_FAILED_ENABLE_AUTO');
  static const ErrorCode EC_NEVER_MATCHED = const ErrorCode._(161, 'EC_NEVER_MATCHED');
  static const ErrorCode EC_INVALID_CONFIG_FILE = const ErrorCode._(162, 'EC_INVALID_CONFIG_FILE');
  static const ErrorCode EC_ENTITY_HAS_NO_ATTR = const ErrorCode._(163, 'EC_ENTITY_HAS_NO_ATTR');
  static const ErrorCode EC_UPDATE_ACTION_ENTITY = const ErrorCode._(164, 'EC_UPDATE_ACTION_ENTITY');
  static const ErrorCode EC_EMPTY_COMPOSED_ACTION = const ErrorCode._(165, 'EC_EMPTY_COMPOSED_ACTION');
  static const ErrorCode EC_STOP_MOTOR_ON_ADJUSTING = const ErrorCode._(166, 'EC_STOP_MOTOR_ON_ADJUSTING');
  static const ErrorCode EC_INTERFACE_DISABLED = const ErrorCode._(167, 'EC_INTERFACE_DISABLED');
  static const ErrorCode EC_TIMER_NOT_RUNNING = const ErrorCode._(168, 'EC_TIMER_NOT_RUNNING');
  static const ErrorCode EC_CONFLICTED_CONDITIONS = const ErrorCode._(169, 'EC_CONFLICTED_CONDITIONS');
  static const ErrorCode EC_NOT_AUTO_TIMER = const ErrorCode._(170, 'EC_NOT_AUTO_TIMER');
  static const ErrorCode EC_FAILED_PAUSE_TIMER = const ErrorCode._(171, 'EC_FAILED_PAUSE_TIMER');
  static const ErrorCode EC_FAILED_CONTINUE_TIMER = const ErrorCode._(172, 'EC_FAILED_CONTINUE_TIMER');
  static const ErrorCode EC_INVALID_TIMER_STATE = const ErrorCode._(173, 'EC_INVALID_TIMER_STATE');
  static const ErrorCode EC_FAILED_CONTROL_TIMER = const ErrorCode._(174, 'EC_FAILED_CONTROL_TIMER');

  static const List<ErrorCode> values = const <ErrorCode> [
    EC_OK,
    EC_BADREQUEST,
    EC_INVALIDRESPONSE,
    EC_REQUEST_TIMEOUT,
    EC_DEVICE_NOT_EXIST,
    EC_SCENE_NOT_EXIST,
    EC_SCENE_ALREADY_ON,
    EC_INVALID_DEVICE_TYPE,
    EC_INVALID_DEVICE_PROFILE,
    EC_SCENE_ALREAY_EXIST,
    EC_SCENE_NOT_TURNED_ON,
    EC_SCENE_ALREADY_TURNED_ON,
    EC_SCENE_ALREADY_TURNED_OFF,
    EC_DEVICE_BINDING_TIMEOUT,
    EC_BIND_INVALID_DEVICE,
    EC_BINDING_ALREADY_EXIST,
    EC_BINDING_NOT_EXIST,
    EC_DELETE_NON_EXIST_BINDING,
    EC_BINDING_UPDATE_SAME_SCENE,
    EC_DEVICE_NOT_ONLINE,
    EC_FAILED_PARSE_JSON_FILE,
    EC_INVALID_SCENE_CONFIG_FILE,
    EC_SCENE_EXEC_ALREADY_FINISHED,
    EC_SCENE_EXEC_WAITING_FOR_ACK,
    EC_SCENE_EXEC_TRIED_MAXMUM_TIMES,
    EC_FAILED_OPEN_CONFIG_DIR,
    EC_FAILED_FOPEN_FILE,
    EC_DUPLICATE_AREA_NAME,
    EC_RENAME_NON_EXISTED_AREA,
    EC_DELETE_NON_EXISTED_AREA,
    EC_AREA_NOT_EXIST,
    EC_DUPLICATE_SCENE_NAME,
    EC_DEVICE_ALREADY_ADDED,
    EC_SET_SAME_ALERT_LEVEL,
    EC_NO_DEVICE_ADDED,
    EC_GLOBAL_SCENE_ON_RUNING,
    EC_GLOBAL_SCENE_ALREADY_ON,
    EC_TOGGLE_GLOBAL_SCENE,
    EC_SCENE_UPDATE_INVALID_PARAMS,
    EC_MISSED_PARAMETER,
    EC_SCENE_IS_NULL,
    EC_INVALID_PARAMETER,
    EC_INVALID_COMMAND_PARAM,
    EC_DEVICE_STATUS_ALREADY_SET,
    EC_NO_NEED_EXEC_SCENE,
    EC_NO_NEED_EXEC_ACTION,
    EC_NO_ACTIONS,
    EC_NO_VALID_ACTION,
    EC_ACTION_PARTLY_VALID,
    EC_INVALID_SCENE,
    EC_INVALID_ADDRESS,
    EC_SCENE_CONTAINS_NO_DEVICES,
    EC_PERMIT_JOIN_ALREADY_DISABLED,
    EC_PERMIT_JOIN_ALREADY_ENABLED,
    EC_SAME_REQUEST_ALREADY_STARTED,
    EC_SCENE_EXECUTION_ALREADY_STARTED,
    EC_UNKNOWN_PUBSUB_NODE,
    EC_BINDING_DUPLICATED,
    EC_BINDING_ALREADY_ENABLED,
    EC_ASH_RESET_FAILED,
    EC_NO_ACTION_TO_RUN,
    EC_SYSTEM_NOT_AVAILABLE,
    EC_NCP_ERROR_FRAME,
    EC_NCP_NOT_EXIST,
    EC_UN_SUPPORTED,
    EC_ENTITY_NOT_AVAILABLE,
    EC_ENGINE_DISCONNECTED,
    EC_FAILED_OPEN_IMAGES_DIR,
    EC_UPGRADE_ALREADY_IN_PROGRESS,
    EC_UPGRADE_FAIL_TO_LOCK,
    EC_UPGRADE_PACKAGE_NOT_FOUND,
    EC_UPGRADE_PACKAGE_CORRUPTED,
    EC_UPGRADE_FAIL_TO_ENABLE_RECOVERY,
    EC_INVALID_OTA_IMAGE_PATH,
    EC_INVALID_OTA_IMAGE_DATA,
    EC_SAME_OTA_IMAGE_ALREADY_LOADED,
    EC_OTA_IMAGE_NOT_EXIST,
    EC_FIRMWARE_NOT_EXIST,
    EC_INVALID_OTA_IMAGE_TYPE,
    EC_NO_DEVICE_MATCHED,
    EC_OTA_TASK_ALREADY_RUNNING,
    EC_NO_VALID_OTA_IMAGE,
    EC_FEATURE_UNSUPPORTED,
    EC_INCORRECT_FIRMWARE_VERSION,
    EC_OTA_UPGRADE_END_STATUS_ERROR,
    EC_OTA_UPGRADE_END_TYPE_ERROR,
    EC_OTA_UPGRADE_END_MANU_CODE_ERROR,
    EC_OTA_UPGRADE_END_VERSION_ERROR,
    EC_OTA_UPGRADE_END_REMAINED_DATA,
    EC_FEATURE_ATTRIBUTE_READ_ERROR,
    EC_UNSUPPORTED_ATTR_KEY,
    EC_ENDPOINT_NOT_EXIST,
    EC_ENDPOINT_MISSED_ATTR,
    EC_READ_ATTR_DATA_SIZE_TOO_BIG,
    EC_READ_ATTR_RESPONSE_ERROR,
    EC_OTA_IMAGE_DATA_DAMAGED,
    EC_UNSUPPORTED_READ_ATTR_KEY,
    EC_OTA_DEVICE_OFFLINE,
    EC_ENTITY_NOT_EXIST,
    EC_OTA_START_OFFLINE,
    EC_DEVICE_UNAVAILABLE,
    EC_ENTITY_NOT_DEVICE,
    EC_ENTITY_ALREADY_DELETED,
    EC_ENTITY_ALREADY_DELETING,
    EC_DELETE_OFFLINE_DEVICE,
    EC_TRIED_DELETE_MAX_TIMES,
    EC_DELETE_ALREADY_SCHEDULED,
    EC_ON_SCHEDULE_DELETE_TASK,
    EC_ENTITY_UNDELETABLE_DEVICE,
    EC_DEVICE_WITHOUT_ON_OFF_FEATURE,
    EC_OTA_IMAGE_NOTIFY_RESPONE,
    EC_SYSTEM_UNAVAILABLE,
    EC_ZB_ENGINE_DISCONNECTED,
    EC_VD_ENGINE_DISCONNECTED,
    EC_TARGET_STATUS_CHANGED,
    EC_ACTION_UNEXECUTABLE,
    EC_ACTION_TASK_FINISHED,
    EC_FAILED_TOO_MANY_TIMES,
    EC_FAST_POLL_TASK_STOPPED,
    EC_NCP_RESET_FAILURE,
    EC_ASH_NOT_WORKING,
    EC_ASH_INVALID_FRAME,
    EC_NCP_UART_WRITE,
    EC_INVALID_ASH_CRC,
    EC_INVALID_ASH_LENGTH,
    EC_EZSP_INVALID_COMMAND,
    EC_TASK_FINISHED_DIRECTLY,
    EC_INVALID_ACTION_GROUP_TYPE,
    EC_CREATE_NULL_ACTION,
    EC_UPDATE_BINDING_DEVICE,
    EC_ENTITY_IS_NULL,
    EC_CONTAINS_DELETED,
    EC_ILLEGAL_ARGUMENT,
    EC_INVALID_TASK_STATE,
    EC_DEVICE_HAS_GONE,
    EC_ADJUST_TRIP_FAILED_OPENING,
    EC_ADJUST_TRIP_FAILED_CLOSING,
    EC_ADJUST_TRIP_FAILED_SETTING,
    EC_ADJUST_TRIP_FAILED_TIMEOUT,
    EC_CONTROL_ON_TRIP_ADJUSTING,
    EC_TRIP_ADJUSTING_NODE_OFFLINE,
    EC_VDS_SUBSCRIBE_INDEX_TOO_BIG,
    EC_ADJUST_TRIP_FAILED_REBOOTING,
    EC_ADJUST_TRIP_EXPECT_FINISHED,
    EC_ACTION_ENTITY_IS_NULL,
    EC_WRITE_ATTR_FAILED,
    EC_SAME_WRITE_ATTR_TASK,
    EC_PERMIT_JOIN_RESTARTED,
    EC_PERMIT_JOIN_TASK_CANCELED,
    EC_ON_OFF_RELAY_DISABLED,
    EC_EXEC_AUTO_FAILURE,
    EC_EXEC_AUTO_TIMEOUT,
    EC_PERMIT_JOIN_DURATION_TOO_LONG,
    EC_EMBER_NO_BUFFERS,
    EC_KNOB_ACTION_INVALID_ANGLE,
    EC_ASH_WRITE_FRAME_FAILURE,
    EC_ASH_REWRITE_FRAME_FAILURE,
    EC_ASH_NOT_WORKING_TIMEOUT,
    EC_INVALID_METHOD,
    EC_RECORD_CURRENT_VALUE,
    EC_NO_EXECUTIONS,
    EC_ACTION_TASK_STOPPED,
    EC_FAILED_ENABLE_AUTO,
    EC_NEVER_MATCHED,
    EC_INVALID_CONFIG_FILE,
    EC_ENTITY_HAS_NO_ATTR,
    EC_UPDATE_ACTION_ENTITY,
    EC_EMPTY_COMPOSED_ACTION,
    EC_STOP_MOTOR_ON_ADJUSTING,
    EC_INTERFACE_DISABLED,
    EC_TIMER_NOT_RUNNING,
    EC_CONFLICTED_CONDITIONS,
    EC_NOT_AUTO_TIMER,
    EC_FAILED_PAUSE_TIMER,
    EC_FAILED_CONTINUE_TIMER,
    EC_INVALID_TIMER_STATE,
    EC_FAILED_CONTROL_TIMER,
  ];

  static final Map<int, ErrorCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ErrorCode valueOf(int value) => _byValue[value];

  const ErrorCode._(int v, String n) : super(v, n);
}

