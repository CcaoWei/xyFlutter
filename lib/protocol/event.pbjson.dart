///
//  Generated code. Do not modify.
//  source: event.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const UpgradeStatus$json = const {
  '1': 'UpgradeStatus',
  '2': const [
    const {'1': 'UpgradeStarted', '2': 0},
    const {'1': 'UpgradeOngoing', '2': 1},
    const {'1': 'UpgradeFinished', '2': 2},
    const {'1': 'UpgradeError', '2': 3},
  ],
};

const Event$json = const {
  '1': 'Event',
  '2': const [
    const {'1': 'MessageID', '3': 1, '4': 1, '5': 9, '10': 'MessageID'},
    const {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
    const {'1': 'Time', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'Time'},
    const {'1': 'EntityAvailable', '3': 4, '4': 1, '5': 11, '6': '.xiaoyan.protocol.EntityAvailableEvent', '9': 0, '10': 'EntityAvailable'},
    const {'1': 'PhysicDeviceOnline', '3': 5, '4': 1, '5': 11, '6': '.xiaoyan.protocol.PhysicDeviceOnlineEvent', '9': 0, '10': 'PhysicDeviceOnline'},
    const {'1': 'PhysicDeviceOffline', '3': 6, '4': 1, '5': 11, '6': '.xiaoyan.protocol.PhysicDeviceOfflineEvent', '9': 0, '10': 'PhysicDeviceOffline'},
    const {'1': 'DeviceKeyPressed', '3': 7, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeviceKeyPressedEvent', '9': 0, '10': 'DeviceKeyPressed'},
    const {'1': 'DeviceAttrReport', '3': 8, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeviceAttrReportEvent', '9': 0, '10': 'DeviceAttrReport'},
    const {'1': 'OnOffStatusChanged', '3': 9, '4': 1, '5': 11, '6': '.xiaoyan.protocol.OnOffStatusChangedEvent', '9': 0, '10': 'OnOffStatusChanged'},
    const {'1': 'SceneCreated', '3': 10, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SceneCreatedEvent', '9': 0, '10': 'SceneCreated'},
    const {'1': 'SceneUpdated', '3': 11, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SceneUpdatedEvent', '9': 0, '10': 'SceneUpdated'},
    const {'1': 'SceneDeleted', '3': 12, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SceneDeletedEvent', '9': 0, '10': 'SceneDeleted'},
    const {'1': 'BindingCreated', '3': 13, '4': 1, '5': 11, '6': '.xiaoyan.protocol.BindingCreatedEvent', '9': 0, '10': 'BindingCreated'},
    const {'1': 'BindingUpdated', '3': 14, '4': 1, '5': 11, '6': '.xiaoyan.protocol.BindingUpdatedEvent', '9': 0, '10': 'BindingUpdated'},
    const {'1': 'BindingDeleted', '3': 15, '4': 1, '5': 11, '6': '.xiaoyan.protocol.BindingDeletedEvent', '9': 0, '10': 'BindingDeleted'},
    const {'1': 'EntityInfoConfigured', '3': 16, '4': 1, '5': 11, '6': '.xiaoyan.protocol.EntityInfoConfiguredEvent', '9': 0, '10': 'EntityInfoConfigured'},
    const {'1': 'AreaCreated', '3': 17, '4': 1, '5': 11, '6': '.xiaoyan.protocol.AreaCreatedEvent', '9': 0, '10': 'AreaCreated'},
    const {'1': 'AreaRenamed', '3': 18, '4': 1, '5': 11, '6': '.xiaoyan.protocol.AreaRenamedEvent', '9': 0, '10': 'AreaRenamed'},
    const {'1': 'AreaDeleted', '3': 19, '4': 1, '5': 11, '6': '.xiaoyan.protocol.AreaDeletedEvent', '9': 0, '10': 'AreaDeleted'},
    const {'1': 'PermitJoinChanged', '3': 20, '4': 1, '5': 11, '6': '.xiaoyan.protocol.PermitJoinChangedEvent', '9': 0, '10': 'PermitJoinChanged'},
    const {'1': 'BindingEnableChanged', '3': 21, '4': 1, '5': 11, '6': '.xiaoyan.protocol.BindingEnableChangedEvent', '9': 0, '10': 'BindingEnableChanged'},
    const {'1': 'FirmwareUpgradeStatusChanged', '3': 22, '4': 1, '5': 11, '6': '.xiaoyan.protocol.FirmwareUpgradeStatusChangedEvent', '9': 0, '10': 'FirmwareUpgradeStatusChanged'},
    const {'1': 'UpdateRecommendFirmware', '3': 23, '4': 1, '5': 11, '6': '.xiaoyan.protocol.UpdateRecommendFirmwareEvent', '9': 0, '10': 'UpdateRecommendFirmware'},
    const {'1': 'FirmwareAvailable', '3': 24, '4': 1, '5': 11, '6': '.xiaoyan.protocol.FirmwareAvailableEvent', '9': 0, '10': 'FirmwareAvailable'},
    const {'1': 'DeviceAdded', '3': 25, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeviceAddedEvent', '9': 0, '10': 'DeviceAdded'},
    const {'1': 'DeviceAssociation', '3': 26, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeviceAssociationEvent', '9': 0, '10': 'DeviceAssociation'},
    const {'1': 'Presence', '3': 27, '4': 1, '5': 11, '6': '.xiaoyan.protocol.PresenceEvent', '9': 0, '10': 'Presence'},
    const {'1': 'DeviceDeleted', '3': 28, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DeviceDeletedEvent', '9': 0, '10': 'DeviceDeleted'},
    const {'1': 'EntityUpdated', '3': 29, '4': 1, '5': 11, '6': '.xiaoyan.protocol.EntityUpdatedEvent', '9': 0, '10': 'EntityUpdated'},
    const {'1': 'EntityCreated', '3': 30, '4': 1, '5': 11, '6': '.xiaoyan.protocol.EntityCreatedEvent', '9': 0, '10': 'EntityCreated'},
    const {'1': 'EntityDeleted', '3': 31, '4': 1, '5': 11, '6': '.xiaoyan.protocol.EntityDeletedEvent', '9': 0, '10': 'EntityDeleted'},
    const {'1': 'UpdateAvailableEntity', '3': 32, '4': 1, '5': 11, '6': '.xiaoyan.protocol.UpdateAvailableEntityEvent', '9': 0, '10': 'UpdateAvailableEntity'},
  ],
  '8': const [
    const {'1': 'Body'},
  ],
};

const EntityAvailableEvent$json = const {
  '1': 'EntityAvailableEvent',
  '2': const [
    const {'1': 'Entity', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Entity'},
  ],
};

const UpdateAvailableEntityEvent$json = const {
  '1': 'UpdateAvailableEntityEvent',
  '2': const [
    const {'1': 'Entity', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Entity'},
  ],
};

const EntityUpdatedEvent$json = const {
  '1': 'EntityUpdatedEvent',
  '2': const [
    const {'1': 'Entity', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Entity'},
  ],
};

const EntityCreatedEvent$json = const {
  '1': 'EntityCreatedEvent',
  '2': const [
    const {'1': 'Entity', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Entity'},
  ],
};

const PhysicDeviceOnlineEvent$json = const {
  '1': 'PhysicDeviceOnlineEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
  ],
};

const PhysicDeviceOfflineEvent$json = const {
  '1': 'PhysicDeviceOfflineEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Gone', '3': 2, '4': 1, '5': 8, '10': 'Gone'},
    const {'1': 'Model', '3': 3, '4': 1, '5': 9, '10': 'Model'},
    const {'1': 'Name', '3': 4, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'HomeCenter', '3': 5, '4': 1, '5': 9, '10': 'HomeCenter'},
  ],
};

const DeviceKeyPressedEvent$json = const {
  '1': 'DeviceKeyPressedEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'SEQ', '3': 2, '4': 1, '5': 5, '10': 'SEQ'},
    const {'1': 'Times', '3': 3, '4': 1, '5': 5, '10': 'Times'},
    const {'1': 'Profile', '3': 4, '4': 1, '5': 14, '6': '.xiaoyan.protocol.DeviceProfile', '10': 'Profile'},
    const {'1': 'Name', '3': 5, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'RSSI', '3': 6, '4': 1, '5': 5, '10': 'RSSI'},
    const {'1': 'AlertLevel', '3': 7, '4': 1, '5': 5, '10': 'AlertLevel'},
  ],
};

const DeviceAttrReportEvent$json = const {
  '1': 'DeviceAttrReportEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Attributes', '3': 2, '4': 3, '5': 11, '6': '.xiaoyan.protocol.Attribute', '10': 'Attributes'},
    const {'1': 'Profile', '3': 3, '4': 1, '5': 14, '6': '.xiaoyan.protocol.DeviceProfile', '10': 'Profile'},
    const {'1': 'Name', '3': 4, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'RSSI', '3': 5, '4': 1, '5': 5, '10': 'RSSI'},
    const {'1': 'AlertLevel', '3': 6, '4': 1, '5': 5, '10': 'AlertLevel'},
  ],
};

const OnOffStatusChangedEvent$json = const {
  '1': 'OnOffStatusChangedEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'OnOff', '3': 2, '4': 1, '5': 8, '10': 'OnOff'},
    const {'1': 'Causer', '3': 3, '4': 1, '5': 9, '10': 'Causer'},
  ],
};

const SceneCreatedEvent$json = const {
  '1': 'SceneCreatedEvent',
  '2': const [
    const {'1': 'Causer', '3': 1, '4': 1, '5': 9, '10': 'Causer'},
    const {'1': 'Scene', '3': 2, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Scene'},
  ],
};

const SceneUpdatedEvent$json = const {
  '1': 'SceneUpdatedEvent',
  '2': const [
    const {'1': 'Causer', '3': 1, '4': 1, '5': 9, '10': 'Causer'},
    const {'1': 'Scene', '3': 2, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Scene'},
  ],
};

const SceneDeletedEvent$json = const {
  '1': 'SceneDeletedEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Causer', '3': 2, '4': 1, '5': 9, '10': 'Causer'},
  ],
};

const BindingCreatedEvent$json = const {
  '1': 'BindingCreatedEvent',
  '2': const [
    const {'1': 'Causer', '3': 1, '4': 1, '5': 9, '10': 'Causer'},
    const {'1': 'Binding', '3': 2, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Binding'},
  ],
};

const BindingUpdatedEvent$json = const {
  '1': 'BindingUpdatedEvent',
  '2': const [
    const {'1': 'Causer', '3': 1, '4': 1, '5': 9, '10': 'Causer'},
    const {'1': 'Binding', '3': 2, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Binding'},
  ],
};

const BindingDeletedEvent$json = const {
  '1': 'BindingDeletedEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Causer', '3': 2, '4': 1, '5': 9, '10': 'Causer'},
  ],
};

const EntityInfoConfiguredEvent$json = const {
  '1': 'EntityInfoConfiguredEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Causer', '3': 2, '4': 1, '5': 9, '10': 'Causer'},
    const {'1': 'Name', '3': 3, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'IsNew', '3': 4, '4': 1, '5': 8, '10': 'IsNew'},
    const {'1': 'AreaUUID', '3': 5, '4': 1, '5': 9, '10': 'AreaUUID'},
  ],
};

const AreaCreatedEvent$json = const {
  '1': 'AreaCreatedEvent',
  '2': const [
    const {'1': 'Area', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Area'},
    const {'1': 'Causer', '3': 2, '4': 1, '5': 9, '10': 'Causer'},
  ],
};

const AreaRenamedEvent$json = const {
  '1': 'AreaRenamedEvent',
  '2': const [
    const {'1': 'Area', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LiveEntity', '10': 'Area'},
    const {'1': 'Causer', '3': 2, '4': 1, '5': 9, '10': 'Causer'},
  ],
};

const AreaDeletedEvent$json = const {
  '1': 'AreaDeletedEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Causer', '3': 2, '4': 1, '5': 9, '10': 'Causer'},
  ],
};

const DeviceAddedEvent$json = const {
  '1': 'DeviceAddedEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Causer', '3': 2, '4': 1, '5': 9, '10': 'Causer'},
  ],
};

const PermitJoinChangedEvent$json = const {
  '1': 'PermitJoinChangedEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Duration', '3': 2, '4': 1, '5': 13, '10': 'Duration'},
    const {'1': 'Causer', '3': 3, '4': 1, '5': 9, '10': 'Causer'},
  ],
};

const BindingEnableChangedEvent$json = const {
  '1': 'BindingEnableChangedEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Enabled', '3': 2, '4': 1, '5': 8, '10': 'Enabled'},
    const {'1': 'Causer', '3': 3, '4': 1, '5': 9, '10': 'Causer'},
  ],
};

const DeviceAssociationEvent$json = const {
  '1': 'DeviceAssociationEvent',
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

const FirmwareAvailableEvent$json = const {
  '1': 'FirmwareAvailableEvent',
};

const FirmwareUpgradeStatusChangedEvent$json = const {
  '1': 'FirmwareUpgradeStatusChangedEvent',
  '2': const [
    const {'1': 'DeviceUUID', '3': 1, '4': 1, '5': 9, '10': 'DeviceUUID'},
    const {'1': 'FirmwareUUID', '3': 2, '4': 1, '5': 9, '10': 'FirmwareUUID'},
    const {'1': 'FirmwareVersion', '3': 3, '4': 1, '5': 9, '10': 'FirmwareVersion'},
    const {'1': 'Status', '3': 4, '4': 1, '5': 14, '6': '.xiaoyan.protocol.UpgradeStatus', '10': 'Status'},
    const {'1': 'Percent', '3': 5, '4': 1, '5': 13, '10': 'Percent'},
    const {'1': 'Code', '3': 6, '4': 1, '5': 14, '6': '.xiaoyan.protocol.ErrorCode', '10': 'Code'},
  ],
};

const UpdateRecommendFirmwareEvent$json = const {
  '1': 'UpdateRecommendFirmwareEvent',
  '2': const [
    const {'1': 'FirmwareUUID', '3': 1, '4': 1, '5': 9, '10': 'FirmwareUUID'},
    const {'1': 'DeviceUUID', '3': 2, '4': 1, '5': 9, '10': 'DeviceUUID'},
  ],
};

const PresenceEvent$json = const {
  '1': 'PresenceEvent',
  '2': const [
    const {'1': 'Username', '3': 1, '4': 1, '5': 9, '10': 'Username'},
    const {'1': 'Online', '3': 2, '4': 1, '5': 8, '10': 'Online'},
    const {'1': 'Resource', '3': 3, '4': 1, '5': 9, '10': 'Resource'},
    const {'1': 'Name', '3': 4, '4': 1, '5': 9, '10': 'Name'},
  ],
};

const DeviceDeletedEvent$json = const {
  '1': 'DeviceDeletedEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Causer', '3': 2, '4': 1, '5': 9, '10': 'Causer'},
  ],
};

const EntityDeletedEvent$json = const {
  '1': 'EntityDeletedEvent',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Causer', '3': 2, '4': 1, '5': 9, '10': 'Causer'},
  ],
};

