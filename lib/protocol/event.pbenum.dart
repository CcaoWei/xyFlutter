///
//  Generated code. Do not modify.
//  source: event.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class UpgradeStatus extends $pb.ProtobufEnum {
  static const UpgradeStatus UpgradeStarted = const UpgradeStatus._(0, 'UpgradeStarted');
  static const UpgradeStatus UpgradeOngoing = const UpgradeStatus._(1, 'UpgradeOngoing');
  static const UpgradeStatus UpgradeFinished = const UpgradeStatus._(2, 'UpgradeFinished');
  static const UpgradeStatus UpgradeError = const UpgradeStatus._(3, 'UpgradeError');

  static const List<UpgradeStatus> values = const <UpgradeStatus> [
    UpgradeStarted,
    UpgradeOngoing,
    UpgradeFinished,
    UpgradeError,
  ];

  static final Map<int, UpgradeStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UpgradeStatus valueOf(int value) => _byValue[value];

  const UpgradeStatus._(int v, String n) : super(v, n);
}

