///
//  Generated code. Do not modify.
//  source: entity.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const EntityBaseType$json = const {
  '1': 'EntityBaseType',
  '2': const [
    const {'1': 'BaseTypeUnknown', '2': 0},
    const {'1': 'BaseTypeArea', '2': 1},
    const {'1': 'BaseTypeDevice', '2': 2},
    const {'1': 'BaseTypePeople', '2': 3},
    const {'1': 'BaseTypeSysDescription', '2': 4},
    const {'1': 'BaseTypeFirmware', '2': 5},
    const {'1': 'BaseTypeActionGroup', '2': 6},
    const {'1': 'BaseTypeAutomation', '2': 7},
    const {'1': 'BaseTypeAutomationSet', '2': 8},
  ],
};

const DeviceType$json = const {
  '1': 'DeviceType',
  '2': const [
    const {'1': 'DeviceUnknown', '2': 0},
    const {'1': 'DeviceLogic', '2': 1},
    const {'1': 'DevicePhysic', '2': 2},
    const {'1': 'DeviceScene', '2': 3},
    const {'1': 'DeviceBinding', '2': 4},
  ],
};

const DeleteState$json = const {
  '1': 'DeleteState',
  '2': const [
    const {'1': 'InUse', '2': 0},
    const {'1': 'Started', '2': 1},
    const {'1': 'Executing', '2': 2},
    const {'1': 'Completed', '2': 3},
  ],
};

const ConditionType$json = const {
  '1': 'ConditionType',
  '2': const [
    const {'1': 'CT_COMPOSED', '2': 0},
    const {'1': 'CT_ANGULAR', '2': 1},
    const {'1': 'CT_KEYPRESS', '2': 2},
    const {'1': 'CT_ATTR_VARIATION', '2': 3},
    const {'1': 'CT_CALENDAR', '2': 4},
    const {'1': 'CT_CALENDAR_RANGE', '2': 5},
    const {'1': 'CT_WITHIN_PERIOD', '2': 6},
    const {'1': 'CT_TIMEOUT_TIMER', '2': 7},
    const {'1': 'CT_SEQUENCED', '2': 8},
    const {'1': 'CT_LONGPRESS', '2': 9},
  ],
};

const ConditionOperator$json = const {
  '1': 'ConditionOperator',
  '2': const [
    const {'1': 'OP_OR', '2': 0},
    const {'1': 'OP_AND', '2': 1},
  ],
};

const ExectionType$json = const {
  '1': 'ExectionType',
  '2': const [
    const {'1': 'ET_TIMER', '2': 0},
    const {'1': 'ET_SCENE', '2': 1},
    const {'1': 'ET_ACTION', '2': 2},
    const {'1': 'ET_SEQUENCED', '2': 3},
  ],
};

const ExecutionMethod$json = const {
  '1': 'ExecutionMethod',
  '2': const [
    const {'1': 'EM_ILLEGAL', '2': 0},
    const {'1': 'EM_ON_OFF', '2': 1},
    const {'1': 'EM_ANGULAR', '2': 2},
  ],
};

const ExecutionLoopType$json = const {
  '1': 'ExecutionLoopType',
  '2': const [
    const {'1': 'ELT_LOOP_TIMES', '2': 0},
    const {'1': 'ELT_LOOP_PERIOD', '2': 1},
  ],
};

const LiveEntity$json = const {
  '1': 'LiveEntity',
  '2': const [
    const {'1': 'BaseType', '3': 1, '4': 1, '5': 14, '6': '.xiaoyan.protocol.EntityBaseType', '10': 'BaseType'},
    const {'1': 'UUID', '3': 2, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Name', '3': 3, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'AreaUUID', '3': 4, '4': 1, '5': 9, '10': 'AreaUUID'},
    const {'1': 'New', '3': 5, '4': 1, '5': 8, '10': 'New'},
    const {'1': 'DeleteState', '3': 6, '4': 1, '5': 14, '6': '.xiaoyan.protocol.DeleteState', '10': 'DeleteState'},
    const {'1': 'Attributes', '3': 7, '4': 3, '5': 11, '6': '.xiaoyan.protocol.Attribute', '10': 'Attributes'},
    const {'1': 'EntityDevice', '3': 8, '4': 1, '5': 11, '6': '.xiaoyan.protocol.PhysicDevice', '9': 0, '10': 'EntityDevice'},
    const {'1': 'EntityArea', '3': 9, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Area', '9': 0, '10': 'EntityArea'},
    const {'1': 'EntityBinding', '3': 10, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Binding', '9': 0, '10': 'EntityBinding'},
    const {'1': 'EntityScene', '3': 11, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Scene', '9': 0, '10': 'EntityScene'},
    const {'1': 'EntityFirmware', '3': 12, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Firmware', '9': 0, '10': 'EntityFirmware'},
    const {'1': 'EntityZigbeeSystem', '3': 13, '4': 1, '5': 11, '6': '.xiaoyan.protocol.ZigbeeSystem', '9': 0, '10': 'EntityZigbeeSystem'},
    const {'1': 'EntityAutomation', '3': 14, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Automation', '9': 0, '10': 'EntityAutomation'},
    const {'1': 'EntityAutomationSet', '3': 15, '4': 1, '5': 11, '6': '.xiaoyan.protocol.AutomationSet', '9': 0, '10': 'EntityAutomationSet'},
  ],
  '8': const [
    const {'1': 'Entity'},
  ],
};

const LogicDevice$json = const {
  '1': 'LogicDevice',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Profile', '3': 2, '4': 1, '5': 14, '6': '.xiaoyan.protocol.DeviceProfile', '10': 'Profile'},
    const {'1': 'Name', '3': 3, '4': 1, '5': 9, '10': 'Name'},
    const {'1': 'Attributes', '3': 4, '4': 3, '5': 11, '6': '.xiaoyan.protocol.Attribute', '10': 'Attributes'},
    const {'1': 'AreaUUID', '3': 5, '4': 1, '5': 9, '10': 'AreaUUID'},
  ],
};

const PhysicDevice$json = const {
  '1': 'PhysicDevice',
  '2': const [
    const {'1': 'Model', '3': 1, '4': 1, '5': 9, '10': 'Model'},
    const {'1': 'Online', '3': 2, '4': 1, '5': 8, '10': 'Online'},
    const {'1': 'Available', '3': 3, '4': 1, '5': 8, '10': 'Available'},
    const {'1': 'LogicDevices', '3': 4, '4': 3, '5': 11, '6': '.xiaoyan.protocol.LogicDevice', '10': 'LogicDevices'},
    const {'1': 'UpgradingPercentage', '3': 5, '4': 1, '5': 5, '10': 'UpgradingPercentage'},
    const {'1': 'UpgradingFirmwareUUID', '3': 6, '4': 1, '5': 9, '10': 'UpgradingFirmwareUUID'},
    const {'1': 'RecommendFirmwareUUID', '3': 7, '4': 1, '5': 9, '10': 'RecommendFirmwareUUID'},
    const {'1': 'RecommendFirmwareVersion', '3': 8, '4': 1, '5': 5, '10': 'RecommendFirmwareVersion'},
    const {'1': 'IsNew', '3': 9, '4': 1, '5': 8, '10': 'IsNew'},
  ],
};

const Area$json = const {
  '1': 'Area',
};

const Action$json = const {
  '1': 'Action',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'AttrID', '3': 2, '4': 1, '5': 14, '6': '.xiaoyan.protocol.AttributeID', '10': 'AttrID'},
    const {'1': 'AttrValue', '3': 3, '4': 1, '5': 5, '10': 'AttrValue'},
  ],
};

const Binding$json = const {
  '1': 'Binding',
  '2': const [
    const {'1': 'Type', '3': 1, '4': 1, '5': 14, '6': '.xiaoyan.protocol.BindingType', '10': 'Type'},
    const {'1': 'Enabled', '3': 2, '4': 1, '5': 8, '10': 'Enabled'},
    const {'1': 'TriggerAddress', '3': 3, '4': 1, '5': 9, '10': 'TriggerAddress'},
    const {'1': 'Actions', '3': 4, '4': 3, '5': 11, '6': '.xiaoyan.protocol.Action', '10': 'Actions'},
    const {'1': 'Parameter', '3': 5, '4': 1, '5': 5, '10': 'Parameter'},
  ],
};

const ZigbeeSystem$json = const {
  '1': 'ZigbeeSystem',
  '2': const [
    const {'1': 'Available', '3': 1, '4': 1, '5': 8, '10': 'Available'},
    const {'1': 'PanId', '3': 2, '4': 1, '5': 13, '10': 'PanId'},
    const {'1': 'Channel', '3': 3, '4': 1, '5': 13, '10': 'Channel'},
    const {'1': 'Version', '3': 4, '4': 1, '5': 13, '10': 'Version'},
    const {'1': 'PermitJoinDuration', '3': 5, '4': 1, '5': 13, '10': 'PermitJoinDuration'},
  ],
};

const Firmware$json = const {
  '1': 'Firmware',
  '2': const [
    const {'1': 'SystemUUID', '3': 1, '4': 1, '5': 9, '10': 'SystemUUID'},
    const {'1': 'ImageModel', '3': 2, '4': 1, '5': 9, '10': 'ImageModel'},
    const {'1': 'Version', '3': 3, '4': 1, '5': 5, '10': 'Version'},
    const {'1': 'SuitableDevices', '3': 4, '4': 3, '5': 9, '10': 'SuitableDevices'},
  ],
};

const Scene$json = const {
  '1': 'Scene',
  '2': const [
    const {'1': 'Actions', '3': 1, '4': 3, '5': 11, '6': '.xiaoyan.protocol.Action', '10': 'Actions'},
  ],
};

const Range$json = const {
  '1': 'Range',
  '2': const [
    const {'1': 'Begin', '3': 1, '4': 1, '5': 5, '10': 'Begin'},
    const {'1': 'End', '3': 2, '4': 1, '5': 5, '10': 'End'},
  ],
};

const DayTime$json = const {
  '1': 'DayTime',
  '2': const [
    const {'1': 'Hour', '3': 1, '4': 1, '5': 5, '10': 'Hour'},
    const {'1': 'Min', '3': 2, '4': 1, '5': 5, '10': 'Min'},
    const {'1': 'Sec', '3': 3, '4': 1, '5': 5, '10': 'Sec'},
  ],
};

const DayTimeRange$json = const {
  '1': 'DayTimeRange',
  '2': const [
    const {'1': 'Begin', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DayTime', '10': 'Begin'},
    const {'1': 'End', '3': 2, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DayTime', '10': 'End'},
  ],
};

const AngularCondition$json = const {
  '1': 'AngularCondition',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'AngleRange', '3': 2, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Range', '10': 'AngleRange'},
  ],
};

const KeypressCondition$json = const {
  '1': 'KeypressCondition',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'PressedTimes', '3': 2, '4': 1, '5': 5, '10': 'PressedTimes'},
  ],
};

const AttributeVariationCondition$json = const {
  '1': 'AttributeVariationCondition',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'AttrID', '3': 2, '4': 1, '5': 14, '6': '.xiaoyan.protocol.AttributeID', '10': 'AttrID'},
    const {'1': 'SourceRange', '3': 3, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Range', '10': 'SourceRange'},
    const {'1': 'TargetRange', '3': 4, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Range', '10': 'TargetRange'},
    const {'1': 'KeepTimeMS', '3': 5, '4': 1, '5': 3, '10': 'KeepTimeMS'},
    const {'1': 'NeedCapture', '3': 6, '4': 1, '5': 8, '10': 'NeedCapture'},
  ],
};

const WithinPeriodCondition$json = const {
  '1': 'WithinPeriodCondition',
  '2': const [
    const {'1': 'PeriodMS', '3': 1, '4': 1, '5': 3, '10': 'PeriodMS'},
  ],
};

const CalendarCondition$json = const {
  '1': 'CalendarCondition',
  '2': const [
    const {'1': 'Repeat', '3': 1, '4': 1, '5': 8, '10': 'Repeat'},
    const {'1': 'CalendarDayTime', '3': 2, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DayTime', '10': 'CalendarDayTime'},
    const {'1': 'Enables', '3': 3, '4': 3, '5': 8, '10': 'Enables'},
  ],
};

const CalendarRangeCondition$json = const {
  '1': 'CalendarRangeCondition',
  '2': const [
    const {'1': 'Repeat', '3': 1, '4': 1, '5': 8, '10': 'Repeat'},
    const {'1': 'Begin', '3': 2, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DayTime', '10': 'Begin'},
    const {'1': 'End', '3': 3, '4': 1, '5': 11, '6': '.xiaoyan.protocol.DayTime', '10': 'End'},
    const {'1': 'Enables', '3': 4, '4': 3, '5': 8, '10': 'Enables'},
  ],
};

const TimerCondition$json = const {
  '1': 'TimerCondition',
  '2': const [
    const {'1': 'TimeoutMS', '3': 1, '4': 1, '5': 3, '10': 'TimeoutMS'},
  ],
};

const ComposedCondition$json = const {
  '1': 'ComposedCondition',
  '2': const [
    const {'1': 'Operator', '3': 1, '4': 1, '5': 14, '6': '.xiaoyan.protocol.ConditionOperator', '10': 'Operator'},
    const {'1': 'Conditions', '3': 2, '4': 3, '5': 11, '6': '.xiaoyan.protocol.Condition', '10': 'Conditions'},
  ],
};

const TimeLimitCondition$json = const {
  '1': 'TimeLimitCondition',
  '2': const [
    const {'1': 'DelayMS', '3': 1, '4': 1, '5': 5, '10': 'DelayMS'},
    const {'1': 'CheckMS', '3': 2, '4': 1, '5': 5, '10': 'CheckMS'},
    const {'1': 'InnerCondition', '3': 3, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Condition', '10': 'InnerCondition'},
  ],
};

const SequencedCondition$json = const {
  '1': 'SequencedCondition',
  '2': const [
    const {'1': 'Conditions', '3': 1, '4': 3, '5': 11, '6': '.xiaoyan.protocol.TimeLimitCondition', '10': 'Conditions'},
  ],
};

const LongPressCondition$json = const {
  '1': 'LongPressCondition',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'PressedSeconds', '3': 2, '4': 1, '5': 5, '10': 'PressedSeconds'},
  ],
};

const Condition$json = const {
  '1': 'Condition',
  '2': const [
    const {'1': 'Angular', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.AngularCondition', '9': 0, '10': 'Angular'},
    const {'1': 'Keypress', '3': 2, '4': 1, '5': 11, '6': '.xiaoyan.protocol.KeypressCondition', '9': 0, '10': 'Keypress'},
    const {'1': 'AttributeVariation', '3': 3, '4': 1, '5': 11, '6': '.xiaoyan.protocol.AttributeVariationCondition', '9': 0, '10': 'AttributeVariation'},
    const {'1': 'WithinPeriod', '3': 4, '4': 1, '5': 11, '6': '.xiaoyan.protocol.WithinPeriodCondition', '9': 0, '10': 'WithinPeriod'},
    const {'1': 'Calendar', '3': 5, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CalendarCondition', '9': 0, '10': 'Calendar'},
    const {'1': 'CalendarRange', '3': 6, '4': 1, '5': 11, '6': '.xiaoyan.protocol.CalendarRangeCondition', '9': 0, '10': 'CalendarRange'},
    const {'1': 'Timer', '3': 7, '4': 1, '5': 11, '6': '.xiaoyan.protocol.TimerCondition', '9': 0, '10': 'Timer'},
    const {'1': 'Composed', '3': 8, '4': 1, '5': 11, '6': '.xiaoyan.protocol.ComposedCondition', '9': 0, '10': 'Composed'},
    const {'1': 'Sequenced', '3': 9, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SequencedCondition', '9': 0, '10': 'Sequenced'},
    const {'1': 'LongPress', '3': 10, '4': 1, '5': 11, '6': '.xiaoyan.protocol.LongPressCondition', '9': 0, '10': 'LongPress'},
  ],
  '8': const [
    const {'1': 'ConditionValue'},
  ],
};

const TimerExecution$json = const {
  '1': 'TimerExecution',
  '2': const [
    const {'1': 'TimeoutMS', '3': 1, '4': 1, '5': 3, '10': 'TimeoutMS'},
  ],
};

const SceneExecution$json = const {
  '1': 'SceneExecution',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'Method', '3': 2, '4': 1, '5': 14, '6': '.xiaoyan.protocol.ExecutionMethod', '10': 'Method'},
    const {'1': 'Parameter', '3': 3, '4': 1, '5': 5, '10': 'Parameter'},
  ],
};

const AtomicAction$json = const {
  '1': 'AtomicAction',
  '2': const [
    const {'1': 'UUID', '3': 1, '4': 1, '5': 9, '10': 'UUID'},
    const {'1': 'AttrID', '3': 2, '4': 1, '5': 14, '6': '.xiaoyan.protocol.AttributeID', '10': 'AttrID'},
    const {'1': 'AttrValue', '3': 3, '4': 1, '5': 5, '10': 'AttrValue'},
    const {'1': 'AttrParams', '3': 4, '4': 3, '5': 5, '10': 'AttrParams'},
  ],
};

const ComposedAction$json = const {
  '1': 'ComposedAction',
  '2': const [
    const {'1': 'Method', '3': 1, '4': 1, '5': 14, '6': '.xiaoyan.protocol.ExecutionMethod', '10': 'Method'},
    const {'1': 'Parameter', '3': 2, '4': 1, '5': 5, '10': 'Parameter'},
    const {'1': 'Actions', '3': 3, '4': 3, '5': 11, '6': '.xiaoyan.protocol.AtomicAction', '10': 'Actions'},
  ],
};

const ActionExecution$json = const {
  '1': 'ActionExecution',
  '2': const [
    const {'1': 'Method', '3': 1, '4': 1, '5': 14, '6': '.xiaoyan.protocol.ExecutionMethod', '10': 'Method'},
    const {'1': 'Parameter', '3': 2, '4': 1, '5': 5, '10': 'Parameter'},
    const {'1': 'Action', '3': 3, '4': 1, '5': 11, '6': '.xiaoyan.protocol.ComposedAction', '10': 'Action'},
  ],
};

const SequencedExecution$json = const {
  '1': 'SequencedExecution',
  '2': const [
    const {'1': 'Method', '3': 1, '4': 1, '5': 14, '6': '.xiaoyan.protocol.ExecutionMethod', '10': 'Method'},
    const {'1': 'Parameter', '3': 2, '4': 1, '5': 5, '10': 'Parameter'},
    const {'1': 'LoopType', '3': 3, '4': 1, '5': 14, '6': '.xiaoyan.protocol.ExecutionLoopType', '10': 'LoopType'},
    const {'1': 'LoopParameter', '3': 4, '4': 1, '5': 3, '10': 'LoopParameter'},
    const {'1': 'Executions', '3': 5, '4': 3, '5': 11, '6': '.xiaoyan.protocol.Execution', '10': 'Executions'},
  ],
};

const Execution$json = const {
  '1': 'Execution',
  '2': const [
    const {'1': 'Timer', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.TimerExecution', '9': 0, '10': 'Timer'},
    const {'1': 'Scene', '3': 2, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SceneExecution', '9': 0, '10': 'Scene'},
    const {'1': 'Action', '3': 3, '4': 1, '5': 11, '6': '.xiaoyan.protocol.ActionExecution', '9': 0, '10': 'Action'},
    const {'1': 'Sequenced', '3': 4, '4': 1, '5': 11, '6': '.xiaoyan.protocol.SequencedExecution', '9': 0, '10': 'Sequenced'},
  ],
  '8': const [
    const {'1': 'ExecutionValue'},
  ],
};

const Automation$json = const {
  '1': 'Automation',
  '2': const [
    const {'1': 'Cond', '3': 1, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Condition', '10': 'Cond'},
    const {'1': 'Exec', '3': 2, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Execution', '10': 'Exec'},
    const {'1': 'Next', '3': 3, '4': 1, '5': 11, '6': '.xiaoyan.protocol.Automation', '10': 'Next'},
  ],
};

const AutomationSet$json = const {
  '1': 'AutomationSet',
  '2': const [
    const {'1': 'Set', '3': 1, '4': 3, '5': 11, '6': '.xiaoyan.protocol.Automation', '10': 'Set'},
  ],
};

