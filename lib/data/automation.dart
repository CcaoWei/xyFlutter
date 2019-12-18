part of data_shared;

class Automation extends Entity {
  protobuf.Automation auto;
  // String name;
  bool get enable => this.getAttributeValue(ATTRIBUTE_ID_AUTO_ENABLED) == 1;
  set enable(bool e) => this.setAttribute(ATTRIBUTE_ID_AUTO_ENABLED, e ? 1 : 0);

  List<protobuf.Condition> _flatternConditions = List();
  List<protobuf.Execution> _flatternExecutions = List();

  int _getWeekOffsetWithUTC(protobuf.DayTime time) {
    var nowLocal = DateTime.now();
    var local = DateTime(nowLocal.year, nowLocal.month, nowLocal.day, time.hour,
        time.min, time.sec);
    var utc = local.toUtc();
    int r = local.weekday < utc.weekday
        ? local.weekday + 7 - utc.weekday
        : local.weekday - utc.weekday;
    return r;
  }

  void _setEnablesForNonRepeat(List<bool> enables, protobuf.DayTime time) {
    var nowLocal = DateTime.now();
    var local = DateTime(nowLocal.year, nowLocal.month, nowLocal.day, time.hour,
        time.min, time.sec);
    var utc = local.toUtc();
    // int weekOffset = local.weekday < utc.weekday
    //     ? local.weekday + 7 - utc.weekday
    //     : local.weekday - utc.weekday;
    if (local.isBefore(nowLocal)) {
      local = local.add(new Duration(days: 1));
    }
    // local = local.add(new Duration(days: weekOffset));
    utc = local.toUtc();
    for (var i = 0; i < enables.length; i++) {
      if (i == utc.weekday % 7)
        enables[i] = true;
      else
        enables[i] = false;
    }
  }

  void _setEnablesForNonRepeatRange(
      List<bool> enables, protobuf.DayTime begin, end) {
    var nowLocal = DateTime.now();
    var local = DateTime(nowLocal.year, nowLocal.month, nowLocal.day,
        begin.hour, begin.min, begin.sec);
    var localEnd = DateTime(nowLocal.year, nowLocal.month, nowLocal.day,
        end.hour, end.min, end.sec);
    if (localEnd.isBefore(local))
      localEnd = localEnd.add(new Duration(days: 1));
    var utc = local.toUtc();
    if (localEnd.isBefore(nowLocal)) {
      local = local.add(new Duration(days: 1));
    }
    utc = local.toUtc();
    for (var i = 0; i < enables.length; i++) {
      if (i == utc.weekday % 7)
        enables[i] = true;
      else
        enables[i] = false;
    }
  }

  void _setEnables(List<bool> enables, int offset) {
    List<bool> copy = List<bool>();
    for (var e in enables) {
      copy.add(e);
    }
    for (var i = 0; i < enables.length; i++) {
      int index = i - offset;
      if (index < 0) index = 6;
      if (index > 6) index = 0;
      enables[index] = copy[i];
    }
  }

  void _setEnablesForLocal(protobuf.Condition c) {
    if (c.hasCalendar()) {
      int weekDayOffset = _getWeekOffsetWithUTC(c.calendar.calendarDayTime);
      if (weekDayOffset == 0) return;
      _setEnables(c.calendar.enables, -1 * weekDayOffset);
    }
    if (c.hasCalendarRange()) {
      int weekDayOffset = _getWeekOffsetWithUTC(c.calendarRange.begin);
      if (weekDayOffset == 0) return;
      _setEnables(c.calendarRange.enables, -1 * weekDayOffset);
    }
  }

  void _setEnablesForUTC(protobuf.Condition c) {
    if (c.hasCalendar()) {
      if (!c.calendar.repeat) {
        _setEnablesForNonRepeat(c.calendar.enables, c.calendar.calendarDayTime);
        return;
      }
      int weekDayOffset = _getWeekOffsetWithUTC(c.calendar.calendarDayTime);
      if (weekDayOffset == 0) return;
      _setEnables(c.calendar.enables, weekDayOffset);
    }
    if (c.hasCalendarRange()) {
      if (!c.calendarRange.repeat) {
        _setEnablesForNonRepeatRange(c.calendarRange.enables,
            c.calendarRange.begin, c.calendarRange.end);
        return;
      }
      int weekDayOffset = _getWeekOffsetWithUTC(c.calendarRange.begin);
      if (weekDayOffset == 0) return;
      _setEnables(c.calendarRange.enables, weekDayOffset);
    }
  }

  static void fromUtc(protobuf.DayTime cal) {
    var utcdt = DateTime.utc(0, 0, 0, cal.hour, cal.min, cal.sec);
    var localdt = utcdt.toLocal();
    cal.hour = localdt.hour;
    cal.min = localdt.minute;
    cal.sec = localdt.second;
  }

  static void toUtc(protobuf.DayTime cal) {
    var localdt = DateTime(0, 0, 0, cal.hour, cal.min, cal.sec);
    var utcdt = localdt.toUtc();
    cal.hour = utcdt.hour;
    cal.min = utcdt.minute;
    cal.sec = utcdt.second;
  }

  void _convertConditionToUTCTime() {
    for (var c in _flatternConditions) {
      if (c.hasCalendar()) {
        _setEnablesForUTC(c);
        Automation.toUtc(c.calendar.calendarDayTime);
      }
      if (c.hasCalendarRange()) {
        _setEnablesForUTC(c);
        Automation.toUtc(c.calendarRange.begin);
        Automation.toUtc(c.calendarRange.end);
      }
    }
  }

  void _convertConditionToLocalTime() {
    for (var con in _flatternConditions) {
      if (con.hasCalendar()) {
        fromUtc(con.calendar.calendarDayTime);
        _setEnablesForLocal(con);
      }
      if (con.hasCalendarRange()) {
        fromUtc(con.calendarRange.begin);
        fromUtc(con.calendarRange.end);
        _setEnablesForLocal(con);
      }
    }
  }

  void _flatCondition(protobuf.Condition c) {
    if (!c.hasAngular() &&
        !c.hasAttributeVariation() &&
        !c.hasCalendar() &&
        !c.hasCalendarRange() &&
        !c.hasComposed() &&
        !c.hasKeypress() &&
        !c.hasTimer() &&
        !c.hasSequenced() &&
        !c.hasLongPress()) {
      print("_flatternConditions.length");
      print(_flatternConditions.length);
      return;
    }
    _flatternConditions.add(c);
  }

  void _flatExecution(protobuf.Execution e) {
    if (!e.hasAction() && !e.hasScene() && !e.hasSequenced() && !e.hasTimer()) {
      return;
    }
    if (e.hasAction()) {
      if (e.action.action.actions.length == 1) {
        _flatternExecutions.add(e);
      } else {
        for (var item in e.action.action.actions) {
          // expand all items
          var sepExe = protobuf.Execution.create();
          var sepAct = protobuf.ActionExecution.create();
          var comAct = protobuf.ComposedAction.create();
          comAct.actions.add(item);
          comAct.method = e.action.method;
          comAct.parameter = e.action.parameter;
          sepAct.action = comAct;
          sepExe.action = sepAct;

          _flatternExecutions.add(sepExe);
        }
      }
      return;
    }
    if (e.hasSequenced()) {
      for (var item in e.sequenced.executions) {
        _flatExecution(item);
      }
      return;
    }
    return _flatternExecutions.add(e);
  }

  Automation(protobuf.Automation this.auto, String name) {
    prepareForApp();
  }

  void parseInnerAuto() {
    _flatternConditions.clear();
    _flatternExecutions.clear();
    if (auto.cond.hasComposed()) {
      for (var item in auto.cond.composed.conditions) {
        _flatCondition(item);
      }
    } else {
      _flatCondition(auto.cond);
    }
    _flatExecution(auto.exec);
  }

  int getConditionCount() {
    return _flatternConditions.length;
  }

  protobuf.Condition getConditionAt(int index) {
    if (index >= _flatternConditions.length) {
      return null;
    }
    return _flatternConditions[index];
  }

  int getExecutionGroupCount() {
    // TODO: avoid hard coded group number
    return 1;
  }

  int getTotalExecutionCount() {
    return _flatternExecutions.length;
  }

  int getTotalExecutionCountOfGroup(int groupIndex) {
    // TODO: to support multiple groups
    return _flatternExecutions.length;
  }

  protobuf.Execution getExecutionAt(int index) {
    return _flatternExecutions[index];
  }

  protobuf.Execution getExecutionAtInGroup(int groupIndex, int index) {
    return _flatternExecutions[index];
  }

  bool _removeExecFromContainer(
      protobuf.Execution container, protobuf.Execution e) {
    if (container.hasSequenced()) {
      int index =
          container.sequenced.executions.indexWhere((ex) => identical(ex, e));
      if (index != -1) {
        container.sequenced.executions.removeAt(index);
        return true;
      }
      for (var item in container.sequenced.executions) {
        if (_removeExecFromContainer(item, e)) return true;
      }
    }
    if (e.hasAction() && container.hasAction()) {
      for (var item in container.action.action.actions) {
        if (item.uUID == e.action.action.actions[0].uUID &&
            item.attrID == e.action.action.actions[0].attrID &&
            item.attrValue == e.action.action.actions[0].attrValue) {
          container.action.action.actions.remove(item);
          return true;
        }
      }
    }
    return false;
  }

  void removeExecution(protobuf.Execution e) {
    if (identical(auto.exec, e)) {
      auto.exec = protobuf.Execution.create(); // replace root with a empty cond
      _flatExecution(auto.exec);
    }
    if (_removeExecFromContainer(auto.exec, e)) _flatExecution(auto.exec);
  }

  bool _removeCondFromContainer(
      protobuf.Condition container, protobuf.Condition c) {
    if (container.hasComposed()) {
      int index =
          container.composed.conditions.indexWhere((cn) => identical(cn, c));
      if (index != -1) {
        container.composed.conditions.removeAt(index);
        return true;
      }
      for (var item in container.composed.conditions) {
        if (_removeCondFromContainer(item, c)) return true;
      }
    }
    if (container.hasSequenced()) {
      int index =
          container.sequenced.conditions.indexWhere((cn) => identical(cn, c));
      if (index != -1) {
        container.sequenced.conditions.removeAt(index);
        return true;
      }
      for (var item in container.composed.conditions) {
        if (_removeCondFromContainer(item, c)) return true;
      }
    }
    return false;
  }

  void removeCondition(protobuf.Condition c) {
    if (identical(auto.cond, c)) {
      auto.cond = protobuf.Condition.create(); // replace root with a empty cond
      parseInnerAuto();
    }
    if (_removeCondFromContainer(auto.cond, c)) parseInnerAuto();
  }

  static protobuf.Condition createAlwaysEnabledCalendarRangeCondition() {
    var newCalendarRangeCond = protobuf.Condition.create();
    var newCalendarRange = protobuf.CalendarRangeCondition.create();
    newCalendarRange.repeat = true;
    for (var i = 0; i < 7; i++) {
      newCalendarRange.enables.add(true);
    }
    var dayTimeBegin = protobuf.DayTime.create();
    var dayTimeEnd = protobuf.DayTime.create();
    dayTimeBegin.hour = 0;
    dayTimeBegin.min = 0;
    dayTimeBegin.sec = 0;
    dayTimeEnd.hour = 23;
    dayTimeEnd.min = 59;
    dayTimeEnd.sec = 59;
    newCalendarRange.begin = dayTimeBegin;
    newCalendarRange.end = dayTimeEnd;
    newCalendarRangeCond.calendarRange = newCalendarRange;
    return newCalendarRangeCond;
  }

  void prepareForSubmit() {
    if (auto.cond.hasComposed()) {
      for (var c in auto.cond.composed.conditions) {
        // timer condition must be the only root condition item
        // it can't be placed inside composed condition
        if (c.hasTimer()) {
          auto.cond = c;
          break;
        }
      }
    }
    _convertConditionToUTCTime();
  }

  void prepareForApp() {
    if (!auto.cond.hasComposed()) {
      print("the condition in auto not in composed, add now");
      print(auto.cond);
      var newc = protobuf.Condition.create();
      var cc = protobuf.ComposedCondition.create();
      cc.conditions.add(auto.cond);
      newc.composed = cc;
      auto.cond = newc;
      this.name = name;
      print("after add the condition in auto to composed");
      print(auto.cond);
    }
    parseInnerAuto();
    _convertConditionToLocalTime();

    // make sure the first condition in composed is a CalendarRangeCondition
    if (auto.cond.composed.conditions.length < 1 ||
        !auto.cond.composed.conditions[0].hasCalendarRange()) {
      print("after add the calendar range condition to composed");
      var crc = createAlwaysEnabledCalendarRangeCondition();
      auto.cond.composed.conditions.insert(0, crc);
      auto.cond.composed.operator = protobuf.ConditionOperator.OP_AND;
      print(auto.cond);
      parseInnerAuto();
      print(getConditionCount());
    }
  }

  static bool isEventCondition(protobuf.Condition cond) {
    if (cond.hasKeypress()) {
      return true;
    }
    if (cond.hasKeypress()) {
      return true;
    }
    if (cond.hasLongPress()) {
      return true;
    }
    if (cond.hasAngular()) {
      return true;
    }
    if (cond.hasSequenced()) {
      return true;
    }
    if (cond.hasAttributeVariation() && cond.attributeVariation.needCapture) {
      return true;
    }
    if (cond.hasComposed()) {
      int numOfEvents = 0;
      if (cond.composed.operator == protobuf.ConditionOperator.OP_AND) {
        for (var item in cond.composed.conditions) {
          if (isEventCondition(item)) {
            ++numOfEvents;
          }
        }
        if (numOfEvents > 1) {
          throw ArgumentError(
              "invalid composed condition, more than one events in AND composed cond");
        }
        return numOfEvents > 0;
      } else {
        for (var item in cond.composed.conditions) {
          if (isEventCondition(item)) {
            ++numOfEvents;
          }
        }
        return numOfEvents == cond.composed.conditions.length;
      }
    }
    return false;
  }
}
//  protobuf.Automation.create
//automations.auto .con
