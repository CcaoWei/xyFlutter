part of automation_shar;

class ConditionLongpress {
  static Automation conditionLongpressSet(Automation automation, String uuid,
      int pressedSeconds, protobuf.Condition cond) {
    var lp = protobuf.LongPressCondition.create();
    lp.uUID = uuid;
    lp.pressedSeconds = pressedSeconds;
    if (cond != null) {
      cond.clear();
      cond.longPress = lp;
      for (var condItem in automation.auto.cond.composed.conditions) {
        if (condItem.hashCode == cond.hashCode) {
          condItem = cond;
        }
      }
    } else {
      var newc = protobuf.Condition.create();
      newc.longPress = lp;
      automation.auto.cond.composed.conditions.add(newc);
    }
    return automation;
  }
}
