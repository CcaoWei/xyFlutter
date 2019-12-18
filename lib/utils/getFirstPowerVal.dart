part of publish_fun;

class GetFirstPowerVal {
  static String getFirstPowerVal(
      String unit, int type, protobuf.Condition cond, _powerBegin, _powerEnd) {
    if (cond == null) return "";
    if (type != cond.attributeVariation.attrID.value) return "";
    var begin = cond.attributeVariation.targetRange.begin;
    var end = cond.attributeVariation.targetRange.end;
    begin = begin ~/ 10;
    end = end ~/ 10;
    _powerBegin.text = begin.toString();
    _powerEnd.text = end.toString();
    if (begin == 0) {
      // _locolGroup.add([begin, end], LOCAL_TYPE_POWER);
      return DefinedLocalizations.of(null).under + end.toString() + unit;
    }
    // _locolGroup.add([begin, end], LOCAL_TYPE_POWER);
    return begin.toString() +
        "~" +
        end.toString() +
        unit +
        DefinedLocalizations.of(null).among;
  }
}
