part of automation_shar;

class ConditionSequenced {
  static Automation conditionSequencedSet(
      Automation automation, newCond, protobuf.Condition cond) {
    print(automation.auto);
    var seqCond = protobuf.SequencedCondition.create();
    seqCond.conditions.add(newCond);
    if (cond != null) {
      cond.clear();
      cond.sequenced = seqCond;
      for (var condItem in automation.auto.cond.composed.conditions) {
        if (condItem.hashCode == cond.hashCode) {
          condItem = cond;
        }
      }
    } else {
      var newc = protobuf.Condition.create();
      newc.sequenced = seqCond;
      automation.auto.cond.composed.conditions.add(newc);
    }

    return automation;
  }
}
