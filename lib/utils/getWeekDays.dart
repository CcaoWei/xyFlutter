part of publish_fun;

class GetWeekDays {
  static String getWeekDayString(
      Automation automation, BuildContext context, _weekdayNames) {
    if (automation.getConditionCount() < COND_COUNT) return "";
    var conditionItem = automation.getConditionAt(0);
    if (conditionItem == null || !conditionItem.hasCalendarRange()) return "";
    if (!conditionItem.calendarRange.repeat)
      return DefinedLocalizations.of(context).autoDefaultRepeat;
    var beginHour = conditionItem.calendarRange.begin.hour;
    var beginMin = conditionItem.calendarRange.begin.min;
    var endHour = conditionItem.calendarRange.end.hour;
    var endMin = conditionItem.calendarRange.end.min;
    if (beginHour == 0 && beginMin == 0 && endHour == 23 && endMin == 59) {
      return "";
    }
    if (_weekdayNames.length != 7) {
      _weekdayNames.add(DefinedLocalizations.of(context).weekday0);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday1);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday2);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday3);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday4);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday5);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday6);
    }
    String result = "";
    bool allWeekends = false;
    bool noWeekends = false;
    bool allWorkdays = false;
    bool noWorkdays = false;
    if (conditionItem.hasCalendarRange()) {
      var cr = conditionItem.calendarRange;
      if (cr.enables.length != 7) {
        return result;
      }
      if (cr.enables[0] && cr.enables[6]) {
        allWeekends = true;
      }
      if (!cr.enables[0] && !cr.enables[6]) {
        noWeekends = true;
      }
      if (cr.enables[1] &&
          cr.enables[2] &&
          cr.enables[3] &&
          cr.enables[4] &&
          cr.enables[5]) {
        allWorkdays = true;
      }
      if (!cr.enables[1] &&
          !cr.enables[2] &&
          !cr.enables[3] &&
          !cr.enables[4] &&
          !cr.enables[5]) {
        noWorkdays = true;
      }
      if (allWeekends && allWorkdays) {
        result = DefinedLocalizations.of(context).everyday;
        return result;
      }
      if (allWeekends && noWorkdays) {
        result = DefinedLocalizations.of(context).weekend;
        return result;
      }
      if (noWeekends && allWorkdays) {
        result = DefinedLocalizations.of(context).workday;
        return result;
      }
      if (noWeekends && noWorkdays) {
        return result;
      }
      var i = 0;
      for (var e in cr.enables) {
        if (e) result += _weekdayNames[i] + ", ";
        ++i;
      }
      result = result.substring(0, result.lastIndexOf(','));
      // c.enables
    }
    return result;
  }

  static int weekdayTime() {
    //返回周几
    // 0 1 2 3 4 5 6
    if (DateTime.now().weekday == 7) {
      return 0;
    }
    return DateTime.now().weekday;
  }
}
