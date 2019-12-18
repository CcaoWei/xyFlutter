part of publish_fun;

class GetTimeName {
  static String getTimeName(BuildContext context, int keepTime) {
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
    if (hour > 12) {
      timeStr = timeStr +
          DefinedLocalizations.of(context).afternoon +
          (hour - 12).toString() +
          "：";
    } else {
      timeStr = timeStr +
          DefinedLocalizations.of(context).morning +
          hour.toString() +
          "：";
    }
    timeStr = timeStr + Mathing.macthing(min) + "：" + Mathing.macthing(sec);
    return timeStr;
  }
}
