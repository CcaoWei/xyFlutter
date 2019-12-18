///
//  Generated code. Do not modify.
//  source: message.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const Message$json = const {
  '1': 'Message',
  '2': const [
    const {'1': 'MessageID', '3': 1, '4': 1, '5': 9, '10': 'MessageID'},
    const {'1': 'CorrelationID', '3': 2, '4': 1, '5': 9, '10': 'CorrelationID'},
    const {'1': 'Sender', '3': 3, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'Time', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'Time'},
    const {'1': 'Error', '3': 10, '4': 1, '5': 11, '6': '.xiaoyan.protocol.ErrorResponse', '9': 0, '10': 'Error'},
    const {'1': 'OnOff', '3': 11, '4': 1, '5': 11, '6': '.xiaoyan.protocol.OnOffRequest', '9': 0, '10': 'OnOff'},
    const {'1': 'OnOffResult', '3': 12, '4': 1, '5': 11, '6': '.xiaoyan.protocol.OnOffResponse', '9': 0, '10': 'OnOffResult'},
    const {'1': 'GetEntity', '3': 13, '4': 1, '5': 11, '6': '.xiaoyan.protocol.GetEntityRequest', '9': 0, '10': 'GetEntity'},
    const {'1': 'GetEntityResult', '3': 14, '4': 1, '5': 11, '6': '.xiaoyan.protocol.GetEntityResponse', '9': 0, '10': 'GetEntityResult'},
    const {'1': 'CreateScene', '3': 15, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CreateSceneRequest', '9': 0, '10': 'CreateScene'},
    const {'1': 'CreateSceneResult', '3': 16, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CreateSceneResponse', '9': 0, '10': 'CreateSceneResult'},
    const {'1': 'UpdateScene', '3': 17, '4': 1, '5': 11, '6': '.xiaoyan.protocol.UpdateSceneRequest', '9': 0, '10': 'UpdateScene'},
    const {'1': 'UpdateSceneResult', '3': 18, '4': 1, '5': 11, '6': '.xiaoyan.protocol.UpdateSceneResponse', '9': 0, '10': 'UpdateSceneResult'},
    const {'1': 'DeleteScene', '3': 19, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeleteSceneRequest', '9': 0, '10': 'DeleteScene'},
    const {'1': 'DeleteSceneResult', '3': 20, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeleteSceneResponse', '9': 0, '10': 'DeleteSceneResult'},
    const {'1': 'SetSceneOnOff', '3': 21, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetSceneOnOffRequest', '9': 0, '10': 'SetSceneOnOff'},
    const {'1': 'SetSceneOnOffResult', '3': 22, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetSceneOnOffResponse', '9': 0, '10': 'SetSceneOnOffResult'},
    const {'1': 'CreateBinding', '3': 23, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CreateBindingRequest', '9': 0, '10': 'CreateBinding'},
    const {'1': 'CreateBindingResult', '3': 24, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CreateBindingResponse', '9': 0, '10': 'CreateBindingResult'},
    const {'1': 'UpdateBinding', '3': 25, '4': 1, '5': 11, '6': '.xiaoyan.protocol.UpdateBindingRequest', '9': 0, '10': 'UpdateBinding'},
    const {'1': 'UpdateBindingResult', '3': 26, '4': 1, '5': 11, '6': '.xiaoyan.protocol.UpdateBindingResponse', '9': 0, '10': 'UpdateBindingResult'},
    const {'1': 'DeleteBinding', '3': 27, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeleteBindingRequest', '9': 0, '10': 'DeleteBinding'},
    const {'1': 'DeleteBindingResult', '3': 28, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeleteBindingResponse', '9': 0, '10': 'DeleteBindingResult'},
    const {'1': 'SetBindingEnable', '3': 29, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetBindingEnableRequest', '9': 0, '10': 'SetBindingEnable'},
    const {'1': 'SetBindingEnableResult', '3': 30, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetBindingEnableResponse', '9': 0, '10': 'SetBindingEnableResult'},
    const {'1': 'ConfigEntityInfo', '3': 31, '4': 1, '5': 11, '6': '.xiaoyan.protocol.ConfigEntityInfoRequest', '9': 0, '10': 'ConfigEntityInfo'},
    const {'1': 'ConfigEntityInfoResult', '3': 32, '4': 1, '5': 11, '6': '.xiaoyan.protocol.ConfigEntityInfoResponse', '9': 0, '10': 'ConfigEntityInfoResult'},
    const {'1': 'CreateArea', '3': 33, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CreateAreaRequest', '9': 0, '10': 'CreateArea'},
    const {'1': 'CreateAreaResult', '3': 34, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CreateAreaResponse', '9': 0, '10': 'CreateAreaResult'},
    const {'1': 'DeleteArea', '3': 35, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeleteAreaRequest', '9': 0, '10': 'DeleteArea'},
    const {'1': 'DeleteAreaResult', '3': 36, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeleteAreaResponse', '9': 0, '10': 'DeleteAreaResult'},
    const {'1': 'SetPermitJoin', '3': 37, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetPermitJoinRequest', '9': 0, '10': 'SetPermitJoin'},
    const {'1': 'SetPermitJoinResult', '3': 38, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetPermitJoinResponse', '9': 0, '10': 'SetPermitJoinResult'},
    const {'1': 'SetAlertLevel', '3': 39, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetAlertLevelRequest', '9': 0, '10': 'SetAlertLevel'},
    const {'1': 'SetAlertLevelResult', '3': 40, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetAlertLevelResponse', '9': 0, '10': 'SetAlertLevelResult'},
    const {'1': 'ReadAttribute', '3': 41, '4': 1, '5': 11, '6': '.xiaoyan.protocol.ReadAttributeRequest', '9': 0, '10': 'ReadAttribute'},
    const {'1': 'ReadAttributeResult', '3': 42, '4': 1, '5': 11, '6': '.xiaoyan.protocol.ReadAttributeResponse', '9': 0, '10': 'ReadAttributeResult'},
    const {'1': 'FirmwareUpgrade', '3': 43, '4': 1, '5': 11, '6': '.xiaoyan.protocol.FirmwareUpgradeRequest', '9': 0, '10': 'FirmwareUpgrade'},
    const {'1': 'FirmwareUpgradeResult', '3': 44, '4': 1, '5': 11, '6': '.xiaoyan.protocol.FirmwareUpgradeResponse', '9': 0, '10': 'FirmwareUpgradeResult'},
    const {'1': 'IdentifyDevice', '3': 45, '4': 1, '5': 11, '6': '.xiaoyan.protocol.IdentifyDeviceRequest', '9': 0, '10': 'IdentifyDevice'},
    const {'1': 'IdentifyDeviceResult', '3': 46, '4': 1, '5': 11, '6': '.xiaoyan.protocol.IdentifyDeviceResponse', '9': 0, '10': 'IdentifyDeviceResult'},
    const {'1': 'DeleteEntity', '3': 47, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeleteEntityRequest', '9': 0, '10': 'DeleteEntity'},
    const {'1': 'DeleteEntityResult', '3': 48, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeleteEntityResponse', '9': 0, '10': 'DeleteEntityResult'},
    const {'1': 'ControlWindowCovering', '3': 49, '4': 1, '5': 11, '6': '.xiaoyan.protocol.ControlWindowCoveringRequest', '9': 0, '10': 'ControlWindowCovering'},
    const {'1': 'ControlWindowCoveringResult', '3': 50, '4': 1, '5': 11, '6': '.xiaoyan.protocol.ControlWindowCoveringResponse', '9': 0, '10': 'ControlWindowCoveringResult'},
    const {'1': 'GetTime', '3': 51, '4': 1, '5': 11, '6': '.xiaoyan.protocol.GetTimeRequest', '9': 0, '10': 'GetTime'},
    const {'1': 'GetTimeResult', '3': 52, '4': 1, '5': 11, '6': '.xiaoyan.protocol.GetTimeResponse', '9': 0, '10': 'GetTimeResult'},
    const {'1': 'SetTime', '3': 53, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetTimeRequest', '9': 0, '10': 'SetTime'},
    const {'1': 'SetTimeResult', '3': 54, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetTimeResponse', '9': 0, '10': 'SetTimeResult'},
    const {'1': 'DeviceAssociation', '3': 55, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeviceAssociationNotification', '9': 0, '10': 'DeviceAssociation'},
    const {'1': 'CheckNewVersion', '3': 56, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CheckNewVersionRequest', '9': 0, '10': 'CheckNewVersion'},
    const {'1': 'SetUpgradePolicy', '3': 57, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetUpgradePolicyRequest', '9': 0, '10': 'SetUpgradePolicy'},
    const {'1': 'SetUpgradePolicyResult', '3': 58, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SetUpgradePolicyResponse', '9': 0, '10': 'SetUpgradePolicyResult'},
    const {'1': 'GetUpgradePolicy', '3': 59, '4': 1, '5': 11, '6': '.xiaoyan.protocol.GetUpgradePolicyRequest', '9': 0, '10': 'GetUpgradePolicy'},
    const {'1': 'GetUpgradePolicyResult', '3': 60, '4': 1, '5': 11, '6': '.xiaoyan.protocol.GetUpgradePolicyResponse', '9': 0, '10': 'GetUpgradePolicyResult'},
    const {'1': 'GetHomeKitSetting', '3': 61, '4': 1, '5': 11, '6': '.xiaoyan.protocol.GetHomeKitSettingRequest', '9': 0, '10': 'GetHomeKitSetting'},
    const {'1': 'GetHomeKitSettingResult', '3': 62, '4': 1, '5': 11, '6': '.xiaoyan.protocol.GetHomeKitSettingResponse', '9': 0, '10': 'GetHomeKitSettingResult'},
    const {'1': 'WriteAttribute', '3': 63, '4': 1, '5': 11, '6': '.xiaoyan.protocol.WriteAttributeRequest', '9': 0, '10': 'WriteAttribute'},
    const {'1': 'WriteAttributeResult', '3': 64, '4': 1, '5': 11, '6': '.xiaoyan.protocol.WriteAttributeResponse', '9': 0, '10': 'WriteAttributeResult'},
    const {'1': 'CheckNewVersionResult', '3': 65, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CheckNewVersionResponse', '9': 0, '10': 'CheckNewVersionResult'},
    const {'1': 'CreateEntity', '3': 66, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CreateEntityRequest', '9': 0, '10': 'CreateEntity'},
    const {'1': 'CreateEntityResult', '3': 67, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CreateEntityResponse', '9': 0, '10': 'CreateEntityResult'},
    const {'1': 'UpdateEntity', '3': 68, '4': 1, '5': 11, '6': '.xiaoyan.protocol.UpdateEntityRequest', '9': 0, '10': 'UpdateEntity'},
    const {'1': 'UpdateEntityResult', '3': 69, '4': 1, '5': 11, '6': '.xiaoyan.protocol.UpdateEntityResponse', '9': 0, '10': 'UpdateEntityResult'},
    const {'1': 'AllocateLanAccessToken', '3': 70, '4': 1, '5': 11, '6': '.xiaoyan.protocol.AllocateLanAccessTokenRequest', '9': 0, '10': 'AllocateLanAccessToken'},
    const {'1': 'AllocateLanAccessTokenResult', '3': 71, '4': 1, '5': 11, '6': '.xiaoyan.protocol.AllocateLanAccessTokenResponse', '9': 0, '10': 'AllocateLanAccessTokenResult'},
    const {'1': 'RevokeLanAccessToken', '3': 72, '4': 1, '5': 11, '6': '.xiaoyan.protocol.RevokeLanAccessTokenRequest', '9': 0, '10': 'RevokeLanAccessToken'},
    const {'1': 'RevokeLanAccessTokenResult', '3': 73, '4': 1, '5': 11, '6': '.xiaoyan.protocol.RevokeLanAccessTokenResponse', '9': 0, '10': 'RevokeLanAccessTokenResult'},
    const {'1': 'GetAutomationTimeoutMs', '3': 74, '4': 1, '5': 11, '6': '.xiaoyan.protocol.GetAutomationTimeoutMsRequest', '9': 0, '10': 'GetAutomationTimeoutMs'},
    const {'1': 'GetAutomationTimeoutMsResult', '3': 75, '4': 1, '5': 11, '6': '.xiaoyan.protocol.GetAutomationTimeoutMsResponse', '9': 0, '10': 'GetAutomationTimeoutMsResult'},
  ],
  '8': const [
    const {'1': 'Body'},
  ],
};

const ErrorResponse$json = const {
  '1': 'ErrorResponse',
  '2': const [
    const {'1': 'Code', '3': 1, '4': 1, '5': 14, '6': '.xiaoyan.protocol.ErrorCode', '10': 'Code'},
    const {'1': 'Description', '3': 2, '4': 1, '5': 9, '10': 'Description'},
  ],
};

const OnOffRequest$json = const {
  '1': 'OnOffRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Command', '3': 2, '4': 1, '5': 14, '6': '.xiaoyan.protocol.OnOffCommand', '10': 'Command'},
  ],
};

const OnOffResponse$json = const {
  '1': 'OnOffResponse',
  '2': const [
    const {'1': 'Status', '3': 1, '4': 1, '5': 8, '10': 'Status'},
  ],
};

const GetEntityRequest$json = const {
  '1': 'GetEntityRequest',
  '2': const [
    const {'1': 'Type', '3': 1, '4': 1, '5': 14, '6': '.xiaoyan.protocol.EntityType', '10': 'Type'},
    const {'1': 'Commit', '3': 2, '4': 1, '5': 13, '10': 'Commit'},
    const {'1': 'Count', '3': 3, '4': 1, '5': 13, '10': 'Count'},
    const {'1': 'Index', '3': 4, '4': 1, '5': 13, '10': 'Index'},
  ],
};

const GetEntityResponse$json = const {
  '1': 'GetEntityResponse',
  '2': const [
    const {'1': 'Entities', '3': 1, '4': 3, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Entities'},
    const {'1': 'CountRemaining', '3': 2, '4': 1, '5': 13, '10': 'CountRemaining'},
  ],
};

const CreateSceneRequest$json = const {
  '1': 'CreateSceneRequest',
  '2': const [
    const {'1': 'Scene', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Scene'},
  ],
};

const CreateSceneResponse$json = const {
  '1': 'CreateSceneResponse',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const UpdateSceneRequest$json = const {
  '1': 'UpdateSceneRequest',
  '2': const [
    const {'1': 'Scene', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Scene'},
  ],
};

const UpdateSceneResponse$json = const {
  '1': 'UpdateSceneResponse',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'OnOff', '3': 2, '4': 1, '5': 8, '10': 'OnOff'},
  ],
};

const DeleteSceneRequest$json = const {
  '1': 'DeleteSceneRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const DeleteSceneResponse$json = const {
  '1': 'DeleteSceneResponse',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const SetSceneOnOffRequest$json = const {
  '1': 'SetSceneOnOffRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Command', '3': 2, '4': 1, '5': 14, '6': '.xiaoyan.protocol.OnOffCommand', '10': 'Command'},
  ],
};

const SetSceneOnOffResponse$json = const {
  '1': 'SetSceneOnOffResponse',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'OnOff', '3': 2, '4': 1, '5': 8, '10': 'OnOff'},
    const {'1': 'Stage', '3': 3, '4': 1, '5': 14, '6': '.xiaoyan.protocol.SceneStage', '10': 'Stage'},
  ],
};

const CreateBindingRequest$json = const {
  '1': 'CreateBindingRequest',
  '2': const [
    const {'1': 'Binding', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Binding'},
  ],
};

const CreateBindingResponse$json = const {
  '1': 'CreateBindingResponse',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const UpdateBindingRequest$json = const {
  '1': 'UpdateBindingRequest',
  '2': const [
    const {'1': 'Binding', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Binding'},
  ],
};

const UpdateBindingResponse$json = const {
  '1': 'UpdateBindingResponse',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const DeleteBindingRequest$json = const {
  '1': 'DeleteBindingRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const DeleteBindingResponse$json = const {
  '1': 'DeleteBindingResponse',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const SetBindingEnableRequest$json = const {
  '1': 'SetBindingEnableRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Enabled', '3': 2, '4': 1, '5': 8, '10': 'Enabled'},
  ],
};

const SetBindingEnableResponse$json = const {
  '1': 'SetBindingEnableResponse',
};

const ConfigEntityInfoRequest$json = const {
  '1': 'ConfigEntityInfoRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Name', '3': 2, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'AreaUUID', '3': 3, '4': 1, '5': 9, '10': 'AreaUUID'},
  ],
};

const ConfigEntityInfoResponse$json = const {
  '1': 'ConfigEntityInfoResponse',
  '2': const [
    const {'1': 'IsNew', '3': 1, '4': 1, '5': 8, '10': 'IsNew'},
  ],
};

const CreateAreaRequest$json = const {
  '1': 'CreateAreaRequest',
  '2': const [
    const {'1': 'Name', '3': 1, '4': 1, '5': 9, '10': 'Name'},
  ],
};

const CreateAreaResponse$json = const {
  '1': 'CreateAreaResponse',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const DeleteAreaRequest$json = const {
  '1': 'DeleteAreaRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const DeleteAreaResponse$json = const {
  '1': 'DeleteAreaResponse',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const SetPermitJoinRequest$json = const {
  '1': 'SetPermitJoinRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Duration', '3': 2, '4': 1, '5': 13, '10': 'Duration'},
  ],
};

const SetPermitJoinResponse$json = const {
  '1': 'SetPermitJoinResponse',
  '2': const [
    const {'1': 'Duration', '3': 1, '4': 1, '5': 13, '10': 'Duration'},
  ],
};

const SetAlertLevelRequest$json = const {
  '1': 'SetAlertLevelRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Level', '3': 2, '4': 1, '5': 13, '10': 'Level'},
  ],
};

const SetAlertLevelResponse$json = const {
  '1': 'SetAlertLevelResponse',
  '2': const [
    const {'1': 'Level', '3': 1, '4': 1, '5': 13, '10': 'Level'},
  ],
};

const ReadAttributeRequest$json = const {
  '1': 'ReadAttributeRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'AttrID', '3': 2, '4': 1, '5': 14, '6': '.xiaoyan.protocol.AttributeID', '10': 'AttrID'},
    const {'1': 'Realtime', '3': 3, '4': 1, '5': 8, '10': 'Realtime'},
    const {'1': 'TimeoutMS', '3': 4, '4': 1, '5': 5, '10': 'TimeoutMS'},
  ],
};

const ReadAttributeResponse$json = const {
  '1': 'ReadAttributeResponse',
  '2': const [
    const {'1': 'Code', '3': 1, '4': 1, '5': 5, '10': 'Code'},
    const {'1': 'Value', '3': 2, '4': 1, '5': 5, '10': 'Value'},
  ],
};

const WriteAttributeRequest$json = const {
  '1': 'WriteAttributeRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'AttrID', '3': 2, '4': 1, '5': 14, '6': '.xiaoyan.protocol.AttributeID', '10': 'AttrID'},
    const {'1': 'Value', '3': 3, '4': 1, '5': 5, '10': 'Value'},
  ],
};

const WriteAttributeResponse$json = const {
  '1': 'WriteAttributeResponse',
  '2': const [
    const {'1': 'Code', '3': 1, '4': 1, '5': 5, '10': 'Code'},
  ],
};

const FirmwareUpgradeRequest$json = const {
  '1': 'FirmwareUpgradeRequest',
  '2': const [
    const {'1': 'FirmwareUUID', '3': 1, '4': 1, '5': 9, '10': 'FirmwareUUID'},
    const {'1': 'Devices', '3': 2, '4': 1, '5': 9, '10': 'Devices'},
  ],
};

const FirmwareUpgradeResponse$json = const {
  '1': 'FirmwareUpgradeResponse',
};

const IdentifyDeviceRequest$json = const {
  '1': 'IdentifyDeviceRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Duration', '3': 2, '4': 1, '5': 5, '10': 'Duration'},
  ],
};

const IdentifyDeviceResponse$json = const {
  '1': 'IdentifyDeviceResponse',
};

const DeleteEntityRequest$json = const {
  '1': 'DeleteEntityRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const DeleteEntityResponse$json = const {
  '1': 'DeleteEntityResponse',
};

const ControlWindowCoveringRequest$json = const {
  '1': 'ControlWindowCoveringRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Percent', '3': 2, '4': 1, '5': 13, '10': 'Percent'},
  ],
};

const ControlWindowCoveringResponse$json = const {
  '1': 'ControlWindowCoveringResponse',
};

const GetTimeRequest$json = const {
  '1': 'GetTimeRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const GetTimeResponse$json = const {
  '1': 'GetTimeResponse',
  '2': const [
    const {'1': 'Time', '3': 1, '4': 1, '5': 9, '10': 'Time'},
    const {'1': 'TimeZone', '3': 2, '4': 1, '5': 9, '10': 'TimeZone'},
  ],
};

const SetTimeRequest$json = const {
  '1': 'SetTimeRequest',
  '2': const [
    const {'1': 'Time', '3': 1, '4': 1, '5': 9, '10': 'Time'},
    const {'1': 'TimeZone', '3': 2, '4': 1, '5': 9, '10': 'TimeZone'},
  ],
};

const SetTimeResponse$json = const {
  '1': 'SetTimeResponse',
};

const DeviceAssociationNotification$json = const {
  '1': 'DeviceAssociationNotification',
  '2': const [
    const {'1': 'User', '3': 1, '4': 1, '5': 9, '10': 'User'},
    const {'1': 'By', '3': 2, '4': 1, '5': 9, '10': 'By'},
    const {'1': 'DeviceName', '3': 3, '4': 1, '5': 9, '10': 'DeviceName'},
    const {'1': 'DeviceUUID', '3': 4, '4': 1, '5': 9, '10': 'DeviceUUID'},
    const {'1': 'Action', '3': 5, '4': 1, '5': 14, '6': '.xiaoyan.protocol.AssociationAction', '10': 'Action'},
    const {'1': 'Status', '3': 6, '4': 1, '5': 14, '6': '.xiaoyan.protocol.SubscriptionType', '10': 'Status'},
    const {'1': 'UserDisplayName', '3': 7, '4': 1, '5': 9, '10': 'UserDisplayName'},
    const {'1': 'ByDisplayName', '3': 8, '4': 1, '5': 9, '10': 'ByDisplayName'},
  ],
};

const CheckNewVersionRequest$json = const {
  '1': 'CheckNewVersionRequest',
};

const CheckNewVersionResponse$json = const {
  '1': 'CheckNewVersionResponse',
};

const SetUpgradePolicyRequest$json = const {
  '1': 'SetUpgradePolicyRequest',
  '2': const [
    const {'1': 'Channel', '3': 1, '4': 1, '5': 9, '10': 'Channel'},
    const {'1': 'Interval', '3': 2, '4': 1, '5': 13, '10': 'Interval'},
  ],
};

const SetUpgradePolicyResponse$json = const {
  '1': 'SetUpgradePolicyResponse',
};

const GetUpgradePolicyRequest$json = const {
  '1': 'GetUpgradePolicyRequest',
};

const GetUpgradePolicyResponse$json = const {
  '1': 'GetUpgradePolicyResponse',
  '2': const [
    const {'1': 'Channel', '3': 1, '4': 1, '5': 9, '10': 'Channel'},
    const {'1': 'Interval', '3': 2, '4': 1, '5': 13, '10': 'Interval'},
  ],
};

const GetHomeKitSettingRequest$json = const {
  '1': 'GetHomeKitSettingRequest',
};

const GetHomeKitSettingResponse$json = const {
  '1': 'GetHomeKitSettingResponse',
  '2': const [
    const {'1': 'SetupCode', '3': 1, '4': 1, '5': 9, '10': 'SetupCode'},
  ],
};

const CreateEntityRequest$json = const {
  '1': 'CreateEntityRequest',
  '2': const [
    const {'1': 'Entity', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Entity'},
  ],
};

const CreateEntityResponse$json = const {
  '1': 'CreateEntityResponse',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const UpdateEntityRequest$json = const {
  '1': 'UpdateEntityRequest',
  '2': const [
    const {'1': 'Entity', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Entity'},
  ],
};

const UpdateEntityResponse$json = const {
  '1': 'UpdateEntityResponse',
};

const AllocateLanAccessTokenRequest$json = const {
  '1': 'AllocateLanAccessTokenRequest',
  '2': const [
    const {'1': 'ClientID', '3': 1, '4': 1, '5': 9, '10': 'ClientID'},
    const {'1': 'ExpirationSeconds', '3': 2, '4': 1, '5': 5, '10': 'ExpirationSeconds'},
  ],
};

const AllocateLanAccessTokenResponse$json = const {
  '1': 'AllocateLanAccessTokenResponse',
  '2': const [
    const {'1': 'AccessToken', '3': 1, '4': 1, '5': 9, '10': 'AccessToken'},
  ],
};

const RevokeLanAccessTokenRequest$json = const {
  '1': 'RevokeLanAccessTokenRequest',
  '2': const [
    const {'1': 'ClientID', '3': 1, '4': 1, '5': 9, '10': 'ClientID'},
  ],
};

const RevokeLanAccessTokenResponse$json = const {
  '1': 'RevokeLanAccessTokenResponse',
};

const GetAutomationTimeoutMsRequest$json = const {
  '1': 'GetAutomationTimeoutMsRequest',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const GetAutomationTimeoutMsResponse$json = const {
  '1': 'GetAutomationTimeoutMsResponse',
  '2': const [
    const {'1': 'TimeoutMS', '3': 1, '4': 1, '5': 3, '10': 'TimeoutMS'},
  ],
};

