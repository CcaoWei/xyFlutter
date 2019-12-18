import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/data/data_shared.dart';
// import 'package:xlive/widget/scene_icon_view.dart';

class AutoCondTimeTableText extends StatefulWidget {
  final double width;
  final int maxLine;
  final Automation automation;
  final protobuf.Condition condition;
  final style;
  AutoCondTimeTableText(
      {Key key,
      @required this.width,
      @required this.automation,
      @required this.maxLine,
      @required this.condition,
      this.style})
      : super(key: key);

  State<StatefulWidget> createState() => _AutoCondTimeTableTextState();
}

class _AutoCondTimeTableTextState extends State<AutoCondTimeTableText> {
  LogicDevice logicDevice;
  String condText = "";
  List<String> _weekdayNames = List();
  // StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    // start();
  }

  @override
  void dispose() {
    super.dispose();
    // if (subscription != null) {
    //   subscription.cancel();
    // }
  }

  String _getWeekDayString(protobuf.Condition conditionItem) {
    if (conditionItem.calendar != null && !conditionItem.calendar.repeat)
      return "";
    if (_weekdayNames.length != 7) {
      _weekdayNames.add(DefinedLocalizations.of(context).weekday0);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday1);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday2);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday3);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday4);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday5);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday6);
    }

    String result = conditionItem.calendar.repeat
        ? DefinedLocalizations.of(context).dateEach
        : "";
    bool allWeekends = false;
    bool noWeekends = false;
    bool allWorkdays = false;
    bool noWorkdays = false;
    if (conditionItem.hasCalendar()) {
      var c = conditionItem.calendar;
      if (c.enables.length != 7) {
        return result;
      }
      if (c.enables[0] && c.enables[6]) {
        allWeekends = true;
      }
      if (!c.enables[0] && !c.enables[6]) {
        noWeekends = true;
      }
      if (c.enables[1] &&
          c.enables[2] &&
          c.enables[3] &&
          c.enables[4] &&
          c.enables[5]) {
        allWorkdays = true;
      }
      if (!c.enables[1] &&
          !c.enables[2] &&
          !c.enables[3] &&
          !c.enables[4] &&
          !c.enables[5]) {
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
      for (var e in c.enables) {
        if (e) result += _weekdayNames[i] + ", ";
        ++i;
      }
      result = result.substring(0, result.lastIndexOf(','));
      // c.enables
    }
    return result;
  }

  String getTimeValue(protobuf.CalendarCondition calendarC) {
    if (calendarC.calendarDayTime.hour == -1 &&
        calendarC.calendarDayTime.min == -1 &&
        calendarC.calendarDayTime.sec == -1) {
      return "";
    }
    String timeStr = " ";
    var hour = calendarC.calendarDayTime.hour;
    var min = calendarC.calendarDayTime.min;
    var sec = calendarC.calendarDayTime.sec;
    var hourS, minS, secS;
    hour > 9 ? hourS = hour.toString() : hourS = "0" + hour.toString();
    min > 9 ? minS = min.toString() : minS = "0" + min.toString();
    sec > 9 ? secS = sec.toString() : secS = "0" + sec.toString();
    timeStr = hourS + "：" + minS + "：" + secS;
    return timeStr;
  }

  void resetData() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    if (widget.condition.hasCalendar() &&
        widget.condition.calendar.calendarDayTime.hour != -1) {
      condText = _getWeekDayString(widget.condition) +
          " " +
          getTimeValue(widget.condition.calendar);
    }
    return Container(
        width: widget.width,
        child: Text(
          condText,
          maxLines: widget.maxLine,
          overflow: TextOverflow.ellipsis,
          style: widget.style,
        ));
  }
}
