part of automation_shar;

class ConditionAttributeVariation {
  static bool setNeedCapture(
      pbConst.AttributeID attrId, Automation automation) {
    if (automation.auto.cond.composed.operator == ConditionOperator.OP_OR)
      return true;
    for (var condItem in automation.auto.cond.composed.conditions) {
      if (Automation.isEventCondition(condItem)) return false;
    }
    return true;
  }

  static protobuf.Condition conditionSequencedAttribute(
      Automation automation,
      String uuid,
      pbConst.AttributeID attrId,
      protobuf.Range sourceRange,
      protobuf.Range targetRange,
      Int64 keepTimeMS,
      protobuf.Condition cond) {
    var attrCond = protobuf.AttributeVariationCondition.create();
    var newCond = protobuf.Condition.create();
    attrCond.needCapture = setNeedCapture(attrId, automation);
    attrCond.uUID = uuid;
    attrCond.attrID = attrId;
    attrCond.sourceRange = sourceRange;
    attrCond.targetRange = targetRange;
    attrCond.keepTimeMS = keepTimeMS;
    newCond.attributeVariation = attrCond;
    return newCond;
  }

  static Automation conditionAttributeVariationSet(
      Automation automation,
      String uuid,
      pbConst.AttributeID attrId,
      protobuf.Range sourceRange,
      protobuf.Range targetRange,
      Int64 keepTimeMS,
      protobuf.Condition cond) {
    //
    var attrC = protobuf.AttributeVariationCondition.create();
    attrC.needCapture = setNeedCapture(attrId, automation);
    attrC.uUID = uuid;
    attrC.attrID = attrId;
    attrC.sourceRange = sourceRange;
    attrC.targetRange = targetRange;
    attrC.keepTimeMS = keepTimeMS;

    if (cond != null) {
      cond.clear();
      cond.attributeVariation = attrC;
      for (var condItem in automation.auto.cond.composed.conditions) {
        if (condItem.hashCode == cond.hashCode) {
          condItem = cond;
        }
      }
    } else {
      var newc = protobuf.Condition.create();
      newc.attributeVariation = attrC;
      automation.auto.cond.composed.conditions.add(newc);
    }
    return automation;
  }
}
