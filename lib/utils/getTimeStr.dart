part of publish_fun;

class GetTimeStr {
  static String getTimeStr(BuildContext context, keepTime) {
    var timeStr = "";
    int value = keepTime.toInt() ~/ 1000;
    var sec = value;
    var min = 0;
    var hour = 0;
    if (sec >= 60) {
      min = sec ~/ 60;
      sec = sec % 60;
      if (min >= 60) {
        hour = min ~/ 60;
        min = min % 60;
      }
    }
    if (hour > 0) {
      timeStr = hour.toString() + DefinedLocalizations.of(context).hour;
    }
    if (min > 0) {
      timeStr += min.toString() + DefinedLocalizations.of(context).minute;
    }
    if (sec > 0) {
      timeStr += sec.toString() + DefinedLocalizations.of(context).second;
    }
    return timeStr + DefinedLocalizations.of(null).after;
  }
}
