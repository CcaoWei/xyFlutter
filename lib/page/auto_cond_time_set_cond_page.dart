import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/const/adapt.dart';
// import 'package:xlive/const/const_shared.dart';
// import 'dart:async';
import 'dart:ui';
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/page/common_page.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
// import 'package:xlive/page/auto_cond_set_repeat_page.dart';
import 'package:xlive/page/auto_cond_set_time_page.dart';
import 'package:xlive/data/data_shared.dart';

class AutoCondTimeSetCond extends StatefulWidget {
  final protobuf.Condition cond;
  final Automation automation;
  final AutomationSet automationSet;
  final calendarCond;
  const AutoCondTimeSetCond(
      {Key key,
      this.cond,
      this.automation,
      this.calendarCond,
      this.automationSet})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoCondTimeSetCondPage();
  }
}

class _AutoCondTimeSetCondPage extends State<AutoCondTimeSetCond> {
  List<String> _weekdayNames = List();
  protobuf.CalendarCondition calendarCond;
  protobuf.Condition cond;
  @override
  void initState() {
    // TODO: implement initState
    _resetData();
    super.initState();
  }

  bool isFirst() {
    if (widget.automationSet.autoset.length == 1) {
      if (widget.automationSet.autoset[0].auto.cond.hasComposed()) {
        if (widget.automationSet.autoset[0].auto.cond.composed.conditions
                .length ==
            0) {
          int length = widget.automationSet.autoset.length - 1;
          var calendarC = protobuf.CalendarCondition.create();
          var comC = protobuf.ComposedCondition.create();
          var dayTime = protobuf.DayTime.create();
          dayTime.hour = -1;
          dayTime.min = -1;
          dayTime.sec = -1;
          calendarC.calendarDayTime = dayTime;
          calendarC.repeat = false;
          calendarC.enables.add(false);
          calendarC.enables.add(false);
          calendarC.enables.add(false);
          calendarC.enables.add(false);
          calendarC.enables.add(false);
          calendarC.enables.add(false);
          calendarC.enables.add(false);
          var newc = protobuf.Condition.create();
          newc.calendar = calendarC;
          widget.automationSet.autoset[length].auto.cond.composed = comC;
          widget.automationSet.autoset[length].auto.cond.composed.conditions
              .add(newc);

          return true;
        } else if (widget
                .automationSet.autoset[0].auto.cond.composed.conditions.length >
            0) {
          if (widget.automationSet.autoset[0].auto.cond.composed.conditions[0]
                  .calendar.calendarDayTime.hour ==
              -1) {
            return true;
          } else {
            return false;
          }
        }
        return true;
      }
    }
    return false;
  }

  void _resetData() {
    print("-----------AutoCondTimeSetCond");
    int length = widget.automationSet.autoset.length - 1;
    if (isFirst()) {
      int length = widget.automationSet.autoset.length - 1;
      if (widget.automationSet.autoset[length].auto.cond.composed.conditions[0]
          .hasCalendar()) {
      } else {
        var calendarC = protobuf.CalendarCondition.create();
        var comC = protobuf.ComposedCondition.create();
        var dayTime = protobuf.DayTime.create();
        dayTime.hour = -1;
        dayTime.min = -1;
        dayTime.sec = -1;
        calendarC.calendarDayTime = dayTime;
        calendarC.repeat = false;
        calendarC.enables.add(false);
        calendarC.enables.add(false);
        calendarC.enables.add(false);
        calendarC.enables.add(false);
        calendarC.enables.add(false);
        calendarC.enables.add(false);
        calendarC.enables.add(false);
        var newc = protobuf.Condition.create();
        newc.calendar = calendarC;
        widget.automationSet.autoset[length].auto.cond.composed = comC;
        widget.automationSet.autoset[length].auto.cond.composed.conditions
            .add(newc);
      }
    } else if (!isFirst()) {
      Automation newAutomation;
      newAutomation =
          Automation(widget.automationSet.autoset[0].auto.clone(), "");
      widget.automationSet.autoset.add(newAutomation);
      int length = widget.automationSet.autoset.length - 1;
      var comC = protobuf.ComposedCondition.create();
      var calendarC = protobuf.CalendarCondition.create();
      var dayTime = protobuf.DayTime.create();
      dayTime.hour = -1;
      dayTime.min = -1;
      dayTime.sec = -1;
      calendarC.calendarDayTime = dayTime;
      calendarC.repeat = false;
      calendarC.enables.add(false);
      calendarC.enables.add(false);
      calendarC.enables.add(false);
      calendarC.enables.add(false);
      calendarC.enables.add(false);
      calendarC.enables.add(false);
      calendarC.enables.add(false);
      var newc = protobuf.Condition.create();
      newc.calendar = calendarC;
      comC.conditions.add(newc);
      widget.automationSet.autoset[length].auto.cond.composed = comC;
    }
  }

  String getTimeValue() {
    int length = widget.automationSet.autoset.length - 1;
    if (!widget.automationSet.autoset[length].auto.cond.hasComposed())
      return "";
    if (widget.automationSet.autoset[length].auto.cond.composed.conditions
            .length <=
        0) return "";
    if (widget.automationSet.autoset[length].auto.cond.composed.conditions[0]
        .hasCalendar()) {
      protobuf.CalendarCondition calendarC = widget.automationSet
          .autoset[length].auto.cond.composed.conditions[0].calendar;
      if (calendarC.calendarDayTime.hour == -1 &&
          calendarC.calendarDayTime.min == -1 &&
          calendarC.calendarDayTime.sec == -1) {
        return "";
      }
      return calendarC.calendarDayTime.hour.toString() +
          DefinedLocalizations.of(context).hour +
          calendarC.calendarDayTime.min.toString() +
          DefinedLocalizations.of(context).minute +
          calendarC.calendarDayTime.sec.toString() +
          DefinedLocalizations.of(context).second;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    // for (Automation automation in widget.automationSet.autoset) {
    //   automation.parseInnerAuto();
    // }
    // TODO: implement build
    return CommonPage(
      title: DefinedLocalizations.of(context).lightingTimeSetting,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.centerRight,
          width: Adapt.px(200),
          child: Text(
            DefinedLocalizations.of(context).next,
            style: TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
          ),
        ),
        onTap: () {
          Navigator.of(context).maybePop();
        },
      ),
      child: _buildTime(context),
    );
  }

  Widget _buildTime(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: Adapt.px(160),
              margin: EdgeInsets.only(left: 15.0, right: 15.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Color(0x33000000),
                          style: BorderStyle.solid))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    DefinedLocalizations.of(context).time,
                    style: TextStyle(
                        fontSize: Adapt.px(46), color: Color(0xff55585a)),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: Text(
                          getTimeValue(),
                          style: TextStyle(
                              fontSize: Adapt.px(46), color: Color(0x732d3b46)),
                        ),
                      ),
                      Image(
                        width: Adapt.px(19),
                        height: Adapt.px(35),
                        image: AssetImage("images/icon_next.png"),
                      )
                    ],
                  )
                ],
              ),
            ),
            onTap: () {
              int length = widget.automationSet.autoset.length - 1;
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(
                      builder: (context) => AutoCondSetTime(
                            automation: widget.automationSet.autoset[length],
                            len: length,
                            automationSet: widget.automationSet,
                          ),
                      settings: RouteSettings(name: "/AutoCondSetTime")));
            },
          ),
        ],
      ),
    );
  }
}
