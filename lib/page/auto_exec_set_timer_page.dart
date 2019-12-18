import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
// import 'package:flutter_picker/Picker.dart';
import 'package:xlive/widget/xy_picker.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/page/common_page.dart';
import 'package:xlive/data/data_shared.dart';
import 'dart:async';
import 'dart:ui';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;

class AutoExecSetTimer extends StatefulWidget {
  //这个一定要跟着createstate
  final Automation automation;
  final protobuf.Execution exec;

  AutoExecSetTimer(
      {this.automation,
      this.exec //带参数的类的实现方法 和上面一起的  下面的类_AutoMationPage要在怎么用呢 就是widgei.参数名 就行了
      });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoExecSetTimerPage();
  }
}

class _AutoExecSetTimerPage extends State<AutoExecSetTimer> {
  StreamSubscription _subscription; //消息通道
  List timerSelect = [0, 0, 0];
  TextEditingController _automationNameController = TextEditingController();
  int hour = 0;
  int min = 0;
  int sec = 0;
  void initState() {
    //onshow
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    print("-------------------------_AutoExecSetTimerPage.dart");
    if (widget.exec == null) return;
    int value = widget.exec.timer.timeoutMS.toInt() ~/ 1000;
    sec = value;
    if (sec >= 60) {
      min = sec ~/ 60;
      sec = sec % 60;
      if (min >= 60) {
        hour = min ~/ 60;
        min = min % 60;
      }
    }
    timerSelect = [hour, min, sec];
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

  String getTimerSelect(List timerSelect) {
    if (timerSelect.length == 0) return "";
    var hour = timerSelect[0];
    var min = timerSelect[1];
    var sec = timerSelect[2];
    String timeStr = "";
    if (hour > 0) {
      timeStr += hour.toString() + DefinedLocalizations.of(context).hour + " ";
    }
    if (min > 0) {
      timeStr += min.toString() + DefinedLocalizations.of(context).minute + " ";
    }
    if (sec > 0) {
      timeStr += sec.toString() + DefinedLocalizations.of(context).second + " ";
    }
    if (timeStr.length > 0)
      return timeStr + DefinedLocalizations.of(context).after;
    else
      return timeStr;
  }

  bool timerPage() {
    if (widget.automation.getConditionCount() > COND_COUNT &&
        widget.automation.getConditionAt(COND_COUNT).hasTimer()) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
        title: DefinedLocalizations.of(context).createAutoMation,
        showBackIcon: true,
        trailing: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            alignment: Alignment.centerRight,
            width: Adapt.px(200),
            child: Text(DefinedLocalizations.of(context).next,
                style: TEXT_STYLE_NEXT_STEP),
          ),
          onTap: () {
            if (timerSelect.length == 0) {
              Navigator.of(context).popUntil(ModalRoute.withName(
                  timerPage() ? '/AutoTimer' : '/AutomationDetail'));
              return;
            }
            if (widget.exec == null) {
              var timerE = protobuf.TimerExecution.create();
              var exec = protobuf.Execution.create();
              Int64 time = Int64(timerSelect[0] * 60 * 60 * 1000 +
                  timerSelect[1] * 60 * 1000 +
                  timerSelect[2] * 1000);
              timerE.timeoutMS = time;
              exec.timer = timerE;
              if (widget.automation.getTotalExecutionCount() == 0) {
                widget.automation.auto.exec = exec;
              } else {
                if (widget.automation.auto.exec.hasSequenced()) {
                  widget.automation.auto.exec.sequenced.executions.add(exec);
                }
              }
            } else {
              Int64 time = Int64(timerSelect[0] * 60 * 60 * 1000 +
                  timerSelect[1] * 60 * 1000 +
                  timerSelect[2] * 1000);
              widget.exec.timer.timeoutMS = time;
            }

            Navigator.of(context).popUntil(ModalRoute.withName(
                timerPage() ? '/AutoTimer' : '/AutomationDetail'));
          },
        ),
        child: _buildSettingTimer());
  }

  Widget _buildSettingTimer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Picker(
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
                          "paddin",
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
                          "padiingin",
                          style: TextStyle(
                            color: Color(0xffffffff),
                          ),
                        ),
                      )),
                  column: 7),
            ],
            columnPadding: EdgeInsets.all(0.0),
            height: Adapt.px(350),
            cancelText: DefinedLocalizations.of(context).cancel,
            cancelTextStyle:
                TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
            confirmText: DefinedLocalizations.of(context).confirm,
            confirmTextStyle:
                TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
            unt: true,
            onSelect: (picker, index, selecteds) {
              timerSelect = picker.adapter.getSelectedValues();
              setState(() {
                timerSelect;
              });
            }).makePicker(),
        Container(
          margin: EdgeInsets.only(top: 40.0),
          child: Text(getTimerSelect(timerSelect)),
        ),
      ],
    );
  }
}
