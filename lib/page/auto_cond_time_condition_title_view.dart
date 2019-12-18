import 'dart:async';

import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/const/adapt.dart';
// import 'package:xlive/const/const_shared.dart';
// import 'dart:async';
import 'dart:ui';
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/page/auto_cond_set_repeat_page.dart';
import 'package:xlive/page/auto_cond_set_time_page.dart';
import 'package:xlive/data/data_shared.dart';
// import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/widget/auto_cond_time_table_text.dart';

class AutoCondTimeConditionTitleView extends StatefulWidget {
  final protobuf.Condition cond;
  final Automation automation;
  final calendarCond;
  const AutoCondTimeConditionTitleView(
      {Key key, this.cond, this.automation, this.calendarCond})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoCondTimeConditionTitleViewPage();
  }
}

class _AutoCondTimeConditionTitleViewPage
    extends State<AutoCondTimeConditionTitleView> {
  List<String> _weekdayNames = List();
  protobuf.CalendarCondition calendarCond;
  protobuf.Condition cond;
  StreamSubscription _subscription; //消息通道
  @override
  void initState() {
    // TODO: implement initState
    _resetData();
    _start();
    super.initState();
  }

  void _start() {
    //数据监听 接受事件
    // _subscription = RxBus()
    //     .toObservable()
    //     .where((event) =>
    //         event is HomeCenterCacheEvent &&
    //         event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
    //     .listen((event) {
    //   if (event is AutomationCreatedEvent) {
    //     if (event.auto.uuid != widget.automation.uuid) return;
    //     _resetData();
    //     setState(() {}); //刷新界面 相当于setData
    //   } else if (event is AutomationUpdatedEvent) {
    //     if (event.auto.uuid != widget.automation.uuid) return;
    //     _resetData();
    // setState(() {});
    //   }
    // });
  }

  void _resetData() {
    if (widget.calendarCond != null) {
      calendarCond = widget.calendarCond;
    } else {
      calendarCond =
          widget.automation.auto.cond.composed.conditions[0].calendar;
    }
    if (widget.cond != null) {
      cond = widget.cond;
    } else {
      cond = widget.automation.auto.cond.composed.conditions[0];
    }
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

  String _getWeekDayString(protobuf.Condition conditionItem) {
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
    if (conditionItem.hasCalendar()) {
      var c = conditionItem.calendar;
      if (c.enables.length != 7) {
        print("bad enables, number is not 7");
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: Adapt.px(160),
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
                      fontSize: Adapt.px(46),
                      color: Color(0xff55585A),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: Text(
                          getTimeValue(calendarCond),
                          style: TextStyle(
                            fontSize: Adapt.px(46),
                            color: Color(0x732d3b46),
                          ),
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
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(
                      builder: (context) => AutoCondSetTime(
                            automation: widget.automation,
                          ),
                      settings: RouteSettings(name: "/AutoCondSetTime")));
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: Adapt.px(160),
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
                    DefinedLocalizations.of(context).repeat,
                    style: TextStyle(
                      fontSize: Adapt.px(46),
                      color: Color(0xff55585A),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 8.0),
                          child: Text(
                            !(cond.hasCalendar() && cond.calendar.repeat) ==
                                    false
                                ? _getWeekDayString(cond)
                                : DefinedLocalizations.of(context)
                                    .autoDefaultRepeat,
                            style: TextStyle(
                              fontSize: Adapt.px(46),
                              color: Color(0x732d3b46),
                            ),
                          )),
                      Image(
                        width: Adapt.px(19),
                        height: Adapt.px(35),
                        image: AssetImage("images/icon_next.png"),
                      )
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(
                      builder: (context) => AutoCondSetRepeat(
                            automation: widget.automation,
                          ),
                      settings: RouteSettings(name: "/AutoCondSetRepeat")));
            },
          ),
          Container(
              margin: EdgeInsets.only(top: Adapt.px(120)),
              child: AutoCondTimeTableText(
                automation: widget.automation,
                condition: widget.cond,
                width: Adapt.px(700),
                maxLine: 1,
                style: TextStyle(
                    fontSize: Adapt.px(45),
                    color: Color(0xff55585a),
                    fontWeight: FontWeight.w600),
              ))
        ],
      ),
    );
  }
}
