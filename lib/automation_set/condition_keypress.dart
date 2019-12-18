part of automation_shar;

class ConditionKeypress {
  static Automation conditionKeypressSet(Automation automation, String uuid,
      int pressedTimes, protobuf.Condition cond) {
    var kp = protobuf.KeypressCondition.create();
    kp.uUID = uuid;
    kp.pressedTimes = pressedTimes;
    if (cond != null) {
      cond.clear();
      cond.keypress = kp;
      for (var condItem in automation.auto.cond.composed.conditions) {
        if (condItem.hashCode == cond.hashCode) {
          condItem = cond;
        }
      }
    } else {
      var newc = protobuf.Condition.create();
      newc.keypress = kp;
      automation.auto.cond.composed.conditions.add(newc);
    }
    return automation;
  }
}
