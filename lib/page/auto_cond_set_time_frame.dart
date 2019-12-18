import 'package:flutter/material.dart'; //安卓风格控件
import 'package:xlive/const/adapt.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/page/auto_cond_set_repeat_page.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/page/auto_cond_select_time_frame.dart';
import 'dart:async';
import 'dart:ui';

import 'package:xlive/rxbus/rxbus.dart';
// import 'package:flutter_picker/flutter_picker.dart';
// import 'package:xlive/widget/xy_picker.dart';

class AutoCondSetTimeFrame extends StatefulWidget {
  //这个一定要跟着createstate
  final Automation automation; //带参数的类的实现方法
  final AutomationSet automationSet;
  final int len;
  // protobuf.CalendarCondition calendar;
  AutoCondSetTimeFrame({this.automation, this.len, this.automationSet
      // this.calendar,
      });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SetTimeFramePage();
  }
}

class _SetTimeFramePage extends State<AutoCondSetTimeFrame> {
  //这个一定要跟着一个build
  //创建一个自动化的列表
  _Group _group = _Group();
  List<String> _weekdayNames = List();
  StreamSubscription _subscription; //消息通道

  void initState() {
    //onshow
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    print("--------------------auto_cond_set_time_frame_page.dart");
    _group.clear();
    var cond = widget.automation.getConditionAt(0);
    if (cond == null || !cond.hasCalendarRange()) {
      _group.add(false, [], 0);
      _group.add(false, [], 1);
    } else {
      var beginH = cond.calendarRange.begin.hour;
      var beginM = cond.calendarRange.begin.min;
      var beginS = cond.calendarRange.begin.sec;
      var endH = cond.calendarRange.end.hour;
      var endM = cond.calendarRange.end.min;
      var endS = cond.calendarRange.end.sec;
      if (beginH == 0 &&
          beginM == 0 &&
          beginS == 0 &&
          endH == 23 &&
          endM == 59 &&
          endS == 59) {
        _group.add(true, [], 0);
        _group.add(false, [], 1);
      } else {
        _group.add(false, [], 0);
        _group.add(true, [], 1);
      }
    }
    setState(() {});
  }

  void dispose() {
    //页面卸载是执行的
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  void _start() {
    //数据监听 接受事件
    _subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
        .listen((event) {
      if (event is AutomationCreatedEvent) {
        if (event.auto.uuid != widget.automation.uuid) return;
        _resetData();
        setState(() {}); //刷新界面 相当于setData
      } else if (event is AutomationUpdatedEvent) {
        if (event.auto.uuid != widget.automation.uuid) return;
        _resetData();
        setState(() {});
      }
    });
  }

  void setSelected(int index) {
    for (var i = 0; i < _group.size(); i++) {
      _UiTime obj = _group.get(i);
      if (index == i) {
        obj.selected = true;
      } else {
        obj.selected = false;
      }
    }
  }

  String macthing(int val) {
    switch (val) {
      case 0:
        return "00";
        break;
      case 1:
        return "01";
        break;
      case 2:
        return "02";
        break;
      case 3:
        return "03";
        break;
      case 4:
        return "04";
        break;
      case 5:
        return "05";
        break;
      case 6:
        return "06";
        break;
      case 7:
        return "07";
        break;
      case 8:
        return "08";
        break;
      case 9:
        return "09";
        break;
      default:
        return val.toString();
    }
  }

  String getTimeValue(BuildContext context, _UiTime _uiTime) {
    if (widget.automation.getConditionCount() < COND_COUNT) return "";
    var cond = widget.automation.getConditionAt(0);
    if (cond == null || !cond.hasCalendarRange()) return "";
    var beginHour = cond.calendarRange.begin.hour;
    var beginmin = cond.calendarRange.begin.min;
    var endHour = cond.calendarRange.end.hour;
    var endMin = cond.calendarRange.end.min;
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
    result = result + macthing(beginmin).toString() + "~";
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
    result = result + macthing(endMin);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var caldt = protobuf.DayTime.create();
    return CommonPage(
        title: DefinedLocalizations.of(context).autoSetTime,
        showBackIcon: true,
        trailing: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            alignment: Alignment.centerRight,
            width: Adapt.px(200),
            child: Image(
              width: Adapt.px(63),
              height: Adapt.px(61),
              image: AssetImage("images/edit_done.png"),
            ),
          ),
          onTap: () {
            for (var i = 0; i < _group.size(); i++) {
              _UiTime obj = _group.get(i);
              if (obj.selected == true) {
                if (obj.type == 0) {
                  var cond = widget.automation.getConditionAt(0);
                  cond.calendarRange.repeat = true;
                  cond.calendarRange.begin.hour = 0;
                  cond.calendarRange.begin.min = 0;
                  cond.calendarRange.begin.sec = 0;
                  cond.calendarRange.end.hour = 23;
                  cond.calendarRange.end.min = 59;
                  cond.calendarRange.end.sec = 59;
                  cond.calendarRange.enables.clear();
                  for (int i = 0; i < 7; ++i) {
                    cond.calendarRange.enables.add(true);
                  }
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              }
            }
          },
        ),
        child: _buildSettingTimeList(context));
  }

  Widget _buildSettingTimeList(BuildContext context) {
    return ListView.builder(
      itemCount: _group.size(),
      itemBuilder: (BuildContext context, int index) {
        final Object obj = _group.get(index);
        return _buildSettingTime(context, obj, index);
      },
    );
  }

  bool isShowRepeat(int index, _UiTime _uiTime) {
    if (index == 1) {
      if (_uiTime.selected) return false;
      return true;
    }
    return true;
  }

  String _getWeekDayString() {
    if (widget.automation.getConditionCount() < COND_COUNT) return "";
    var conditionItem = widget.automation.getConditionAt(0);
    if (conditionItem == null || !conditionItem.hasCalendarRange()) return "";
    if (!conditionItem.calendarRange.repeat)
      return DefinedLocalizations.of(null).autoDefaultRepeat;
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

  Widget _buildSettingTime(BuildContext context, _UiTime _uiTime, int index) {
    return Column(
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: Adapt.px(160),
            margin: EdgeInsets.only(
                left: 15.0, right: 15.0, top: index == 1 ? Adapt.px(120) : 0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: Color(0x33000000),
                        style: BorderStyle.solid))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: Adapt.px(63),
                      height: Adapt.px(63),
                      alignment: Alignment.center,
                      child: Image(
                        width: _uiTime.selected ? Adapt.px(63) : Adapt.px(31),
                        height: _uiTime.selected ? Adapt.px(63) : Adapt.px(31),
                        image: AssetImage(_uiTime.selected
                            ? "images/icon_check.png"
                            : 'images/icon_uncheck.png'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Text(
                        _uiTime.getLeftString(context),
                        style: TextStyle(
                            fontSize: Adapt.px(46), color: Color(0xff55585a)),
                      ),
                    ),
                  ],
                ),
                Offstage(
                    offstage: index == 0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: Adapt.px(27)),
                          child: Text(
                            getTimeValue(context, _uiTime),
                            style: TextStyle(
                                fontSize: Adapt.px(46),
                                color: Color(0x732d3b46)),
                          ),
                        ),
                        Image(
                          width: Adapt.px(19),
                          height: Adapt.px(35),
                          image: AssetImage("images/icon_next.png"),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          onTap: () {
            setSelected(index);
            if (index == 1) {
              Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                      builder: (context) => AutoCondSelectTimeFrame(
                            automation: widget.automation,
                          ),
                      settings:
                          RouteSettings(name: "/AutoCondSelectTimeFrame")));
            }
            setState(() {});
          },
        ),
        Offstage(
          offstage: isShowRepeat(index, _uiTime),
          child: Container(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: Adapt.px(160),
                margin: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                ),
                padding: EdgeInsets.only(left: Adapt.px(70)),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Color(0x33000000),
                            style: BorderStyle.solid))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                            DefinedLocalizations.of(context).repeat,
                            style: TextStyle(
                                fontSize: Adapt.px(46),
                                color: Color(0xff55585a)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: Adapt.px(27)),
                          child: Text(
                            _getWeekDayString(),
                            style: TextStyle(
                                fontSize: Adapt.px(46),
                                color: Color(0x732d3b46)),
                          ),
                        ),
                        Image(
                          width: Adapt.px(19),
                          height: Adapt.px(35),
                          image: AssetImage("images/icon_next.png"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .push(CupertinoPageRoute(
                        builder: (context) => AutoCondSetRepeat(
                              automation: widget.automation,
                              cond: widget.automation.getConditionAt(0),
                            ),
                        settings: RouteSettings(name: "/AutoCondSetRepeat")));
              },
            ),
          ),
        )
      ],
    );
  }
}

class _UiTime {
  bool selected;
  // String timeName;
  List timeValue;
  int type;
  _UiTime({this.selected, this.timeValue, this.type});
  String getLeftString(BuildContext context) {
    switch (type) {
      case 0:
        return DefinedLocalizations.of(context).anyPeriodTime;
        break;
      case 1:
        return DefinedLocalizations.of(context).specificPeriodTime;
        break;
      default:
        return " ";
    }
  }
}

class _Group {
  final List<_UiTime> _uiTime = List();
  void add(bool selected, List timeValue, int type) {
    _uiTime.add(
      _UiTime(selected: selected, timeValue: timeValue, type: type),
    );
  }

  void clear() {
    _uiTime.clear();
  }

  int size() {
    return _uiTime.length > 0 ? _uiTime.length : 0;
  }

  Object get(int index) => _uiTime[index];
}
