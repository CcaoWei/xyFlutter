import 'package:flutter/material.dart'; //安卓风格控件
import 'package:xlive/const/adapt.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'dart:async';
import 'dart:ui';
// import 'package:flutter_picker/flutter_picker.dart';
import 'package:xlive/widget/xy_picker.dart';

class AutoCondSetTime extends StatefulWidget {
  //这个一定要跟着createstate
  final Automation automation; //带参数的类的实现方法
  final AutomationSet automationSet;
  final int len;
  // protobuf.CalendarCondition calendar;
  AutoCondSetTime({this.automation, this.len, this.automationSet
      // this.calendar,
      });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingTimePage();
  }
}

class _SettingTimePage extends State<AutoCondSetTime> {
  //这个一定要跟着一个build
  //创建一个自动化的列表
  _Group _group = _Group();

  StreamSubscription _subscription; //消息通道

  void initState() {
    //onshow
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    print("--------------------auto_cond_set_time_page.dart");
    _group.clear();
    var caldt = widget.automation.auto.cond.composed.conditions[COND_COUNT]
        .calendar.calendarDayTime;
    if (caldt.hour != -1) {
      caldt.hour == "" ? 0 : caldt.hour;
      caldt.min == "" ? 0 : caldt.min;
      caldt.sec == "" ? 0 : caldt.sec;
      _group.add(true, [caldt.hour, caldt.min, caldt.sec], 2);
    } else {
      _group.add(true, [], 2);
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

  void pickerTime(BuildContext context, _UiTime _uiTime) {
    var caldt = widget.automation.auto.cond.composed.conditions[COND_COUNT]
        .calendar.calendarDayTime;
    var dt = caldt;
    int hour = dt.hour == -1 ? 0 : dt.hour;
    int min = dt.min == -1 ? 0 : dt.min;
    int sec = dt.sec == -1 ? 0 : dt.sec;
    var picker = new Picker(
        adapter: NumberPickerAdapter(
          data: [
            NumberPickerColumn(begin: 0, end: 23, initValue: hour),
            NumberPickerColumn(begin: 0, end: 59, initValue: min),
            NumberPickerColumn(begin: 0, end: 59, initValue: sec),
          ],
        ),
        delimiter: [
          PickerDelimiter(
              child: Container(
                  padding: EdgeInsets.only(top: Adapt.px(20)),
                  decoration: BoxDecoration(
                      // color: Color(0x33eeeeee),
                      border: Border(
                          top: BorderSide(
                              width: 0.0,
                              color: Color(0xfff7f7f7f),
                              style: BorderStyle.solid),
                          bottom: BorderSide(
                              width: 0.0,
                              color: Color(0x99f7f7f7f),
                              style: BorderStyle.solid))),
                  child: Center(
                    child: Text(
                      "padi",
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                  )),
              column: 0),
          PickerDelimiter(
              child: Container(
                  padding: EdgeInsets.only(top: Adapt.px(20)),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 0.0,
                              color: Color(0xfff7f7f7f),
                              style: BorderStyle.solid),
                          bottom: BorderSide(
                              width: 0.0,
                              color: Color(0x99f7f7f7f),
                              style: BorderStyle.solid))),
                  child: Center(
                    child: Text(
                      DefinedLocalizations.of(context).hour,
                      style: TextStyle(
                        color: Color(0x732d3b46),
                        fontSize: Adapt.px(35),
                      ),
                    ),
                  )),
              column: 2),
          PickerDelimiter(
              child: Container(
                  padding: EdgeInsets.only(top: Adapt.px(20)),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 0.0,
                              color: Color(0xfff7f7f7f),
                              style: BorderStyle.solid),
                          bottom: BorderSide(
                              width: 0.0,
                              color: Color(0x99f7f7f7f),
                              style: BorderStyle.solid))),
                  child: Center(
                    child: Text(
                      DefinedLocalizations.of(context).minute,
                      style: TextStyle(
                        color: Color(0x732d3b46),
                        fontSize: Adapt.px(35),
                      ),
                    ),
                  )),
              column: 4),
          PickerDelimiter(
              child: Container(
                  padding: EdgeInsets.only(top: Adapt.px(20)),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 0.0,
                              color: Color(0xfff7f7f7f),
                              style: BorderStyle.solid),
                          bottom: BorderSide(
                              width: 0.0,
                              color: Color(0x99f7f7f7f),
                              style: BorderStyle.solid))),
                  child: Center(
                    child: Text(
                      DefinedLocalizations.of(context).second,
                      style: TextStyle(
                        color: Color(0x732d3b46),
                        fontSize: Adapt.px(35),
                      ),
                    ),
                  )),
              column: 6),
          PickerDelimiter(
              child: Container(
                  padding: EdgeInsets.only(top: Adapt.px(20)),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 0.0,
                              color: Color(0xfff7f7f7f),
                              style: BorderStyle.solid),
                          bottom: BorderSide(
                              width: 0.0,
                              color: Color(0x99f7f7f7f),
                              style: BorderStyle.solid))),
                  child: Center(
                    child: Text(
                      "padi",
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                  )),
              column: 7),
        ],
        columnPadding: EdgeInsets.all(0),
        cancelText: DefinedLocalizations.of(context).cancel,
        cancelTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        confirmText: DefinedLocalizations.of(context).confirm,
        confirmTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        hideHeader: false,
        title: Text(DefinedLocalizations.of(context).time),
        onConfirm: (Picker picker, List value) {
          // _deviceDetailsCondition.durationTime =
          //     Int64((value[0] * 60 + value[1]) * 1000);
          // _uiTime.timeValue = value[0].toString()+DefinedLocalizations.of(context).hour+value[1].toString()+DefinedLocalizations.of(context).minute+value[2].toString()+DefinedLocalizations.of(context).second;
          _uiTime.timeValue = value;
          setState(() {});
        });
    picker.showDialogXy(context);
  }

  String getTimeValue(BuildContext context, _UiTime _uiTime) {
    if (_uiTime.timeValue.length == 0) {
      return "";
    } else {
      String timeStr = "";
      timeStr = _uiTime.timeValue[0].toString() +
          ":" +
          _uiTime.timeValue[1].toString() +
          ":" +
          _uiTime.timeValue[2].toString();
      return timeStr;
    }
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
                } else if (obj.type == 1) {
                } else if (obj.type == 2) {
                  caldt.hour = obj.timeValue[0];
                  caldt.min = obj.timeValue[1];
                  caldt.sec = obj.timeValue[2];
                  widget.automation.auto.cond.composed.conditions[1].calendar
                      .calendarDayTime = caldt;
                }
              }
            }
            Navigator.pop(context);
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

  Widget _buildSettingTime(BuildContext context, _UiTime _uiTime, int index) {
    return GestureDetector(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: _uiTime.selected ? 4.0 : 0),
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
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: Adapt.px(27)),
                  child: Text(
                    getTimeValue(context, _uiTime),
                    style: TextStyle(
                        fontSize: Adapt.px(46), color: Color(0x732d3b46)),
                  ),
                ),
                Offstage(
                  offstage: _uiTime.type != 2,
                  child: Image(
                    width: Adapt.px(19),
                    height: Adapt.px(35),
                    image: AssetImage("images/icon_next.png"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        setSelected(index);
        if (_uiTime.type == 2) {
          pickerTime(context, _uiTime);
        }

        setState(() {});
      },
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
        return DefinedLocalizations.of(context).sunset;
        break;
      case 1:
        return DefinedLocalizations.of(context).sunrise;
        break;
      case 2:
        return DefinedLocalizations.of(context).specialTime;
        break;
      default:
        return "default";
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
