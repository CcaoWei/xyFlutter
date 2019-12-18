part of automation_shar;

class ConditionAngular {
  static Automation conditionAngularSet(Automation automation, String uuid,
      int begin, int end, protobuf.Condition cond) {
    var anc = protobuf.AngularCondition.create();
    anc.uUID = uuid;
    var range = protobuf.Range.create();
    range.begin = begin;
    range.end = end;
    anc.angleRange = range;
    if (cond != null) {
      cond.clear();
      cond.angular = anc;
      for (var condItem in automation.auto.cond.composed.conditions) {
        if (condItem.hashCode == cond.hashCode) {
          condItem = cond;
        }
      }
    } else {
      var newc = protobuf.Condition.create();
      newc.angular = anc;
      automation.auto.cond.composed.conditions.add(newc);
    }
    print(automation.auto);
    return automation;
  }

  static protobuf.AngularCondition setKnobAngle(
      String uuid, protobuf.AngularCondition anC, int begin, int end) {
    anC.uUID = uuid;
    var range = protobuf.Range.create();
    range.begin = begin;
    range.end = end;
    anC.angleRange = range;
    return anC;
  }

  static Automation conditionComAngularSet(
      Automation automation, String uuid, protobuf.Condition cond) {
    var comC = protobuf.ComposedCondition.create();
    var cond = protobuf.Condition.create();
    var anC1 = protobuf.AngularCondition.create();
    var anC2 = protobuf.AngularCondition.create();
    var cCond1 = protobuf.Condition.create();
    var cCond2 = protobuf.Condition.create();
    cCond1.angular = setKnobAngle(uuid, anC1, -720, -720);
    cCond2.angular = setKnobAngle(uuid, anC2, 720, 720);
    comC.conditions.add(cCond1);
    comC.conditions.add(cCond2);
    if (cond != null) {
      cond.clear();
      cond.composed = comC;
      for (var condItem in automation.auto.cond.composed.conditions) {
        if (condItem.hashCode == cond.hashCode) {
          condItem = cond;
        }
      }
    } else {
      var newc = protobuf.Condition.create();
      newc.composed = comC;
      automation.auto.cond.composed.conditions.add(newc);
    }
    print(automation.auto);
    return automation;
  }
}
