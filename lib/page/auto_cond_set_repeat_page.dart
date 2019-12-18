import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
// import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/page/common_page.dart';
import 'package:xlive/rxbus/rxbus.dart';
// import 'package:xlive/channel/event_channel.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'dart:async';
// import 'package:flutter_picker/flutter_picker.dart';
// import 'package:xlive/protocol/entity.pb.dart' as protobuf;
// import 'package:xlive/protocol/const.pbenum.dart' as pbConst;

class AutoCondSetRepeat extends StatefulWidget {
  //这个一定要跟着createstate
  final Automation automation;
  final AutomationSet automationSet;
  final protobuf.Condition cond;

  AutoCondSetRepeat({this.automation, this.automationSet, this.cond});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingTimeRepeatPage();
  }
}

class _SettingTimeRepeatPage extends State<AutoCondSetRepeat> {
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
    print("----------------------setting_repeat_page.dart");
    _group.clear();
    var cond;
    if (widget.cond != null) {
      cond = widget.automation.getConditionAt(0);
    } else {
      cond = widget.automation.getConditionAt(COND_COUNT);
    }
    if (cond == null) {
      print("bad condition, not calender");
    }
    var c;
    if (cond.hasCalendarRange()) {
      c = cond.calendarRange;
    } else if (cond.hasCalendar()) {
      c = cond.calendar;
    }
    for (var i = 0; i < 7; ++i) {
      _group.add(c.repeat && c.enables[i], i);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CommonPage(
        title: DefinedLocalizations.of(context).autoSetRepeat,
        showBackIcon: true,
        trailing: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            alignment: Alignment.centerRight,
            width: Adapt.px(200),
            child: Image(
              width: Adapt.px(63),
              height: Adapt.px(61),
              image: AssetImage('images/edit_done.png'),
            ),
          ),
          onTap: () {
            var cond;
            if (widget.cond != null) {
              cond = widget
                  .automation.auto.cond.composed.conditions[0].calendarRange;
            } else {
              cond = widget.automation.auto.cond.composed.conditions[COND_COUNT]
                  .calendar;
            }
            bool repeat = false;
            _UiTimeRepeat sun = _group.get(0);
            repeat |= sun.selected;
            _UiTimeRepeat mon = _group.get(1);
            repeat |= mon.selected;
            _UiTimeRepeat tue = _group.get(2);
            repeat |= tue.selected;
            _UiTimeRepeat wed = _group.get(3);
            repeat |= wed.selected;
            _UiTimeRepeat thu = _group.get(4);
            repeat |= thu.selected;
            _UiTimeRepeat fri = _group.get(5);
            repeat |= fri.selected;
            _UiTimeRepeat sat = _group.get(6);
            repeat |= sat.selected;
            if (widget.automationSet != null) {
              for (var automation in widget.automationSet.autoset) {
                automation.auto.cond.composed.conditions[COND_COUNT].calendar
                    .enables[0] = sun.selected;
                automation.auto.cond.composed.conditions[COND_COUNT].calendar
                    .enables[1] = mon.selected;
                automation.auto.cond.composed.conditions[COND_COUNT].calendar
                    .enables[2] = tue.selected;
                automation.auto.cond.composed.conditions[COND_COUNT].calendar
                    .enables[3] = wed.selected;
                automation.auto.cond.composed.conditions[COND_COUNT].calendar
                    .enables[4] = thu.selected;
                automation.auto.cond.composed.conditions[COND_COUNT].calendar
                    .enables[5] = fri.selected;
                automation.auto.cond.composed.conditions[COND_COUNT].calendar
                    .enables[6] = sat.selected;
                automation.auto.cond.composed.conditions[COND_COUNT].calendar
                    .repeat = repeat;
                Navigator.pop(context);
                return;
              }
            }
            cond.enables[0] = sun.selected;
            cond.enables[1] = mon.selected;
            cond.enables[2] = tue.selected;
            cond.enables[3] = wed.selected;
            cond.enables[4] = thu.selected;
            cond.enables[5] = fri.selected;
            cond.enables[6] = sat.selected;
            cond.repeat = repeat;

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

  Widget _buildSettingTime(
      BuildContext context, _UiTimeRepeat _uiTimeRepeat, int index) {
    var timeName = "";
    switch (_uiTimeRepeat.index) {
      case 0:
        timeName = DefinedLocalizations.of(context).weekday0;
        break;
      case 1:
        timeName = DefinedLocalizations.of(context).weekday1;
        break;
      case 2:
        timeName = DefinedLocalizations.of(context).weekday2;
        break;
      case 3:
        timeName = DefinedLocalizations.of(context).weekday3;
        break;
      case 4:
        timeName = DefinedLocalizations.of(context).weekday4;
        break;
      case 5:
        timeName = DefinedLocalizations.of(context).weekday5;
        break;
      case 6:
        timeName = DefinedLocalizations.of(context).weekday6;
        break;
      default:
    }
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
            Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Text(
                timeName,
                style:
                    TextStyle(fontSize: Adapt.px(46), color: Color(0xff55585a)),
              ),
            ),
            Container(
                margin:
                    EdgeInsets.only(right: _uiTimeRepeat.selected ? 0 : 7.0),
                child: Image(
                  width: _uiTimeRepeat.selected ? Adapt.px(63) : Adapt.px(31),
                  height: _uiTimeRepeat.selected ? Adapt.px(63) : Adapt.px(31),
                  image: AssetImage(_uiTimeRepeat.selected
                      ? "images/icon_check.png"
                      : 'images/icon_uncheck.png'),
                )),
          ],
        ),
      ),
      onTap: () {
        if (_uiTimeRepeat.selected) {
          _uiTimeRepeat.selected = false;
        } else {
          _uiTimeRepeat.selected = true;
        }

        setState(() {});
      },
    );
  }
}

class _UiTimeRepeat {
  bool selected;
  int index;

  _UiTimeRepeat({
    this.selected,
    this.index,
  });
}

class _Group {
  final List<_UiTimeRepeat> _uiTimeRepeat = List();
  void add(bool selected, int index) {
    _uiTimeRepeat.add(
      _UiTimeRepeat(selected: selected, index: index),
    );
  }

  void clear() {
    _uiTimeRepeat.clear();
  }

  int size() {
    return _uiTimeRepeat.length > 0 ? _uiTimeRepeat.length : 0;
  }

  Object get(int index) => _uiTimeRepeat[index];
}
