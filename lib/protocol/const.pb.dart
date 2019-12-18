///
//  Generated code. Do not modify.
//  source: const.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'const.pbenum.dart';

export 'const.pbenum.dart';

class Attribute extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Attribute', package: const $pb.PackageName('xiaoyan.protocol'))
    ..e<AttributeID>(1, 'attrID', $pb.PbFieldType.OE, AttributeID.AttrIDOnOffStatus, AttributeID.valueOf, AttributeID.values)
    ..a<int>(2, 'attrValue', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Attribute() : super();
  Attribute.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Attribute.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Attribute clone() => new Attribute()..mergeFromMessage(this);
  Attribute copyWith(void Function(Attribute) updates) => super.copyWith((message) => updates(message as Attribute));
  $pb.BuilderInfo get info_ => _i;
  static Attribute create() => new Attribute();
  Attribute createEmptyInstance() => create();
  static $pb.PbList<Attribute> createRepeated() => new $pb.PbList<Attribute>();
  static Attribute getDefault() => _defaultInstance ??= create()..freeze();
  static Attribute _defaultInstance;

  AttributeID get attrID => $_getN(0);
  set attrID(AttributeID v) { setField(1, v); }
  bool hasAttrID() => $_has(0);
  void clearAttrID() => clearField(1);

  int get attrValue => $_get(1, 0);
  set attrValue(int v) { $_setSignedInt32(1, v); }
  bool hasAttrValue() => $_has(1);
  void clearAttrValue() => clearField(2);
}

