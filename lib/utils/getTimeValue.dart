part of publish_fun;

class GetTimeValue {
  static String getTimeValue(Automation automation, BuildContext context) {
    if (automation.getConditionCount() < COND_COUNT) return "";
    var cond = automation.getConditionAt(0);
    if (cond == null || !cond.hasCalendarRange()) return "";
    var beginHour = cond.calendarRange.begin.hour;
    var beginMin = cond.calendarRange.begin.min;
    var beginSec = cond.calendarRange.begin.min;
    var endHour = cond.calendarRange.end.hour;
    var endMin = cond.calendarRange.end.min;
    var endSec = cond.calendarRange.end.sec;
    var nowDate = new DateTime.now();
    var beginDate = DateTime(nowDate.year, nowDate.month, nowDate.day,
        beginHour, beginMin, beginSec);
    var endDate = DateTime(
        nowDate.year, nowDate.month, nowDate.day, endHour, endMin, endSec);
    var difference = endDate.difference(beginDate);
    if (difference.inSeconds >= 24 * 60 * 60 - 1 && cond.calendarRange.repeat) {
      bool allweek = true;
      for (var e in cond.calendarRange.enables) {
        allweek = allweek && e;
      }
      if (allweek) return DefinedLocalizations.of(context).anyPeriodTime;
    }
    var result;
    if (beginHour == 12) {
      result = DefinedLocalizations.of(context).afternoon +
          beginHour.toString() +
          ":";
    } else if (beginHour > 12) {
      result = DefinedLocalizations.of(context).afternoon +
          (beginHour - 12).toString() +
          ":";
    } else {
      if (beginHour == 0) {
        result = DefinedLocalizations.of(context).morning +
            (beginHour + 12).toString() +
            ":";
      } else {
        result = DefinedLocalizations.of(context).morning +
            beginHour.toString() +
            ":";
      }
    }
    result = result + Mathing.macthing(beginMin).toString() + "~";
    if (endHour > 12) {
      result = result +
          DefinedLocalizations.of(context).afternoon +
          (endHour - 12).toString() +
          ":";
    } else if (endHour == 12) {
      result = result +
          DefinedLocalizations.of(context).afternoon +
          endHour.toString() +
          ":";
    } else {
      if (endHour == 0) {
        result = result +
            DefinedLocalizations.of(context).morning +
            (endHour + 12).toString() +
            ":";
      } else {
        result = result +
            DefinedLocalizations.of(context).morning +
            endHour.toString() +
            ":";
      }
    }
    result = result + Mathing.macthing(endMin);
    return result;
  }
}
