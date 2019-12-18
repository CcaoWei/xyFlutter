///
//  Generated code. Do not modify.
//  source: entity.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class EntityBaseType extends $pb.ProtobufEnum {
  static const EntityBaseType BaseTypeUnknown = const EntityBaseType._(0, 'BaseTypeUnknown');
  static const EntityBaseType BaseTypeArea = const EntityBaseType._(1, 'BaseTypeArea');
  static const EntityBaseType BaseTypeDevice = const EntityBaseType._(2, 'BaseTypeDevice');
  static const EntityBaseType BaseTypePeople = const EntityBaseType._(3, 'BaseTypePeople');
  static const EntityBaseType BaseTypeSysDescription = const EntityBaseType._(4, 'BaseTypeSysDescription');
  static const EntityBaseType BaseTypeFirmware = const EntityBaseType._(5, 'BaseTypeFirmware');
  static const EntityBaseType BaseTypeActionGroup = const EntityBaseType._(6, 'BaseTypeActionGroup');
  static const EntityBaseType BaseTypeAutomation = const EntityBaseType._(7, 'BaseTypeAutomation');
  static const EntityBaseType BaseTypeAutomationSet = const EntityBaseType._(8, 'BaseTypeAutomationSet');

  static const List<EntityBaseType> values = const <EntityBaseType> [
    BaseTypeUnknown,
    BaseTypeArea,
    BaseTypeDevice,
    BaseTypePeople,
    BaseTypeSysDescription,
    BaseTypeFirmware,
    BaseTypeActionGroup,
    BaseTypeAutomation,
    BaseTypeAutomationSet,
  ];

  static final Map<int, EntityBaseType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EntityBaseType valueOf(int value) => _byValue[value];

  const EntityBaseType._(int v, String n) : super(v, n);
}

class DeviceType extends $pb.ProtobufEnum {
  static const DeviceType DeviceUnknown = const DeviceType._(0, 'DeviceUnknown');
  static const DeviceType DeviceLogic = const DeviceType._(1, 'DeviceLogic');
  static const DeviceType DevicePhysic = const DeviceType._(2, 'DevicePhysic');
  static const DeviceType DeviceScene = const DeviceType._(3, 'DeviceScene');
  static const DeviceType DeviceBinding = const DeviceType._(4, 'DeviceBinding');

  static const List<DeviceType> values = const <DeviceType> [
    DeviceUnknown,
    DeviceLogic,
    DevicePhysic,
    DeviceScene,
    DeviceBinding,
  ];

  static final Map<int, DeviceType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DeviceType valueOf(int value) => _byValue[value];

  const DeviceType._(int v, String n) : super(v, n);
}

class DeleteState extends $pb.ProtobufEnum {
  static const DeleteState InUse = const DeleteState._(0, 'InUse');
  static const DeleteState Started = const DeleteState._(1, 'Started');
  static const DeleteState Executing = const DeleteState._(2, 'Executing');
  static const DeleteState Completed = const DeleteState._(3, 'Completed');

  static const List<DeleteState> values = const <DeleteState> [
    InUse,
    Started,
    Executing,
    Completed,
  ];

  static final Map<int, DeleteState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DeleteState valueOf(int value) => _byValue[value];

  const DeleteState._(int v, String n) : super(v, n);
}

class ConditionType extends $pb.ProtobufEnum {
  static const ConditionType CT_COMPOSED = const ConditionType._(0, 'CT_COMPOSED');
  static const ConditionType CT_ANGULAR = const ConditionType._(1, 'CT_ANGULAR');
  static const ConditionType CT_KEYPRESS = const ConditionType._(2, 'CT_KEYPRESS');
  static const ConditionType CT_ATTR_VARIATION = const ConditionType._(3, 'CT_ATTR_VARIATION');
  static const ConditionType CT_CALENDAR = const ConditionType._(4, 'CT_CALENDAR');
  static const ConditionType CT_CALENDAR_RANGE = const ConditionType._(5, 'CT_CALENDAR_RANGE');
  static const ConditionType CT_WITHIN_PERIOD = const ConditionType._(6, 'CT_WITHIN_PERIOD');
  static const ConditionType CT_TIMEOUT_TIMER = const ConditionType._(7, 'CT_TIMEOUT_TIMER');
  static const ConditionType CT_SEQUENCED = const ConditionType._(8, 'CT_SEQUENCED');
  static const ConditionType CT_LONGPRESS = const ConditionType._(9, 'CT_LONGPRESS');

  static const List<ConditionType> values = const <ConditionType> [
    CT_COMPOSED,
    CT_ANGULAR,
    CT_KEYPRESS,
    CT_ATTR_VARIATION,
    CT_CALENDAR,
    CT_CALENDAR_RANGE,
    CT_WITHIN_PERIOD,
    CT_TIMEOUT_TIMER,
    CT_SEQUENCED,
    CT_LONGPRESS,
  ];

  static final Map<int, ConditionType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ConditionType valueOf(int value) => _byValue[value];

  const ConditionType._(int v, String n) : super(v, n);
}

class ConditionOperator extends $pb.ProtobufEnum {
  static const ConditionOperator OP_OR = const ConditionOperator._(0, 'OP_OR');
  static const ConditionOperator OP_AND = const ConditionOperator._(1, 'OP_AND');

  static const List<ConditionOperator> values = const <ConditionOperator> [
    OP_OR,
    OP_AND,
  ];

  static final Map<int, ConditionOperator> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ConditionOperator valueOf(int value) => _byValue[value];

  const ConditionOperator._(int v, String n) : super(v, n);
}

class ExectionType extends $pb.ProtobufEnum {
  static const ExectionType ET_TIMER = const ExectionType._(0, 'ET_TIMER');
  static const ExectionType ET_SCENE = const ExectionType._(1, 'ET_SCENE');
  static const ExectionType ET_ACTION = const ExectionType._(2, 'ET_ACTION');
  static const ExectionType ET_SEQUENCED = const ExectionType._(3, 'ET_SEQUENCED');

  static const List<ExectionType> values = const <ExectionType> [
    ET_TIMER,
    ET_SCENE,
    ET_ACTION,
    ET_SEQUENCED,
  ];

  static final Map<int, ExectionType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ExectionType valueOf(int value) => _byValue[value];

  const ExectionType._(int v, String n) : super(v, n);
}

class ExecutionMethod extends $pb.ProtobufEnum {
  static const ExecutionMethod EM_ILLEGAL = const ExecutionMethod._(0, 'EM_ILLEGAL');
  static const ExecutionMethod EM_ON_OFF = const ExecutionMethod._(1, 'EM_ON_OFF');
  static const ExecutionMethod EM_ANGULAR = const ExecutionMethod._(2, 'EM_ANGULAR');

  static const List<ExecutionMethod> values = const <ExecutionMethod> [
    EM_ILLEGAL,
    EM_ON_OFF,
    EM_ANGULAR,
  ];

  static final Map<int, ExecutionMethod> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ExecutionMethod valueOf(int value) => _byValue[value];

  const ExecutionMethod._(int v, String n) : super(v, n);
}

class ExecutionLoopType extends $pb.ProtobufEnum {
  static const ExecutionLoopType ELT_LOOP_TIMES = const ExecutionLoopType._(0, 'ELT_LOOP_TIMES');
  static const ExecutionLoopType ELT_LOOP_PERIOD = const ExecutionLoopType._(1, 'ELT_LOOP_PERIOD');

  static const List<ExecutionLoopType> values = const <ExecutionLoopType> [
    ELT_LOOP_TIMES,
    ELT_LOOP_PERIOD,
  ];

  static final Map<int, ExecutionLoopType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ExecutionLoopType valueOf(int value) => _byValue[value];

  const ExecutionLoopType._(int v, String n) : super(v, n);
}

