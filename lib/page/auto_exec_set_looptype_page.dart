import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xlive/rxbus/rxbus.dart';
// import 'package:flutter_picker/Picker.dart';
import 'package:xlive/widget/xy_picker.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'dart:async';
import 'dart:ui';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'common_page.dart';

class AutoExecSetLooptype extends StatefulWidget {
  final Automation automation;
  final protobuf.Execution exec;
  AutoExecSetLooptype({this.automation, this.exec});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoExecSetLooptypePage();
  }
}

class _AutoExecSetLooptypePage extends State<AutoExecSetLooptype> {
  StreamSubscription _subscription; //消息通道
  int loopParameter = 1;
  _Group _group = _Group();
  int radiovalue = 0;
  void initState() {
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    print("--------------------auto_exec_set_looptype_page.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.exec.sequenced.loopType.value == 0) {
      radiovalue = 1;
    }
    _group.add(0, "");
    _group.add(1, "");
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

  void setLoopType(exec) {
    switch (radiovalue) {
      case 0:
        exec.loopType = protobuf.ExecutionLoopType.ELT_LOOP_PERIOD;
        exec.loopParameter = Int64(loopParameter);
        break;
      case 1:
        exec.loopType = protobuf.ExecutionLoopType.ELT_LOOP_TIMES;
        exec.loopParameter = Int64(loopParameter);
        break;
      default:
    }
  }

  void pickerData(BuildContext context, _SelectType _selectType) {
    var picker = new Picker(
        adapter: NumberPickerAdapter(
          data: [
            NumberPickerColumn(begin: 0, end: 23, initValue: 0),
            NumberPickerColumn(begin: 0, end: 59, initValue: 0),
            NumberPickerColumn(begin: 0, end: 59, initValue: 0),
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
        columnPadding: EdgeInsets.all(0.0),
        cancelText: DefinedLocalizations.of(context).cancel,
        cancelTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        confirmText: DefinedLocalizations.of(context).confirm,
        confirmTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        hideHeader: false,
        title: Text(DefinedLocalizations.of(context).time),
        onConfirm: (Picker picker, List value) {
          loopParameter = (value[0] * 3600 + value[1] * 60 + value[2]) * 1000;
          _selectType.numerical = value[0].toString() +
              DefinedLocalizations.of(context).hours +
              value[1].toString() +
              DefinedLocalizations.of(context).minutes +
              value[2].toString() +
              DefinedLocalizations.of(context).second;
          setState(() {});
        });
    picker.showDialogXy(context);
  }

  void pickerTimes(BuildContext context, _SelectType _selectType) {
    // var caldt = widget
    //     .automation.auto.cond.composed.conditions[0].calendar.calendarDayTime;
    // var dt = caldt;
    // int hour = dt.hour == -1 ? 0 : dt.hour;
    // int min = dt.min == -1 ? 0 : dt.min;
    // int sec = dt.sec == -1 ? 0 : dt.sec;
    var picker = new Picker(
        adapter: NumberPickerAdapter(
          data: [
            NumberPickerColumn(begin: 1, end: 200, initValue: 0),
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
                      "paddingingi",
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
                      DefinedLocalizations.of(context).selectTime,
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
                      "padiingingi",
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                  )),
              column: 4),
        ],
        columnPadding: EdgeInsets.all(0.0),
        cancelText: DefinedLocalizations.of(context).cancel,
        cancelTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        confirmText: DefinedLocalizations.of(context).confirm,
        confirmTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        hideHeader: false,
        title: Text(DefinedLocalizations.of(context).selectTime),
        onConfirm: (Picker picker, List value) {
          loopParameter = value[0] + 1;
          _selectType.numerical = (value[0] + 1).toString() +
              DefinedLocalizations.of(context).selectTime;
          setState(() {});
        });
    picker.showDialogXy(context);
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
        title: DefinedLocalizations.of(context).autoExecutionMode,
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
            if (loopParameter == 0) {
              Fluttertoast.showToast(msg: "循环不正确");
              return;
            }
            if (widget.exec != null) {
              if (widget.exec.hasSequenced()) {
                setLoopType(widget.exec.sequenced);
              } else {
                var seqExec = protobuf.SequencedExecution.create();
                var exec = protobuf.Execution.create();
                setLoopType(seqExec);
                exec.sequenced = seqExec;
                widget.automation.auto.exec = exec;
              }
            } else {
              var seqExec = protobuf.SequencedExecution.create();
              var exec = protobuf.Execution.create();
              setLoopType(seqExec);
              exec.sequenced = seqExec;
              widget.automation.auto.exec = exec;
              if (widget.automation.getTotalExecutionCount() >= 0) {
                if (widget.automation.getExecutionGroupCount() != 1) {
                } else {
                  protobuf.Execution exec = widget.automation.auto.exec;
                  if (exec.hasSequenced()) {
                    setLoopType(exec.sequenced);
                  }
                }
              }
            }
            Navigator.of(context, rootNavigator: true).maybePop();
          },
        ),
        child: Container(
          margin: EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(40)),
          child: _buildExecutionTypeAll(context),
        ));
  }

  Widget _buildExecutionTypeAll(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 233.0,
          margin: EdgeInsets.only(top: Adapt.px(114)),
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: _group.size(),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final Object obj = _group.get(index);
              return _buildExecutionTypeItem(context, obj, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExecutionTypeItem(
      BuildContext context, _SelectType _selectType, int index) {
    return Column(
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
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: Adapt.px(63),
                        height: Adapt.px(63),
                        margin: EdgeInsets.only(right: 8.0),
                        alignment: Alignment.center,
                        child: Image(
                          width:
                              index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                          height:
                              index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                          image: AssetImage(index == radiovalue
                              ? "images/icon_check.png"
                              : 'images/icon_uncheck.png'),
                        ),
                      ),
                      Text(
                        _selectType.getLeftString(context),
                        style: TextStyle(
                            fontSize: Adapt.px(46), color: Color(0xff55585a)),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: Text(
                          _selectType.numerical,
                          style: TextStyle(
                              fontSize: Adapt.px(46), color: Color(0xff55585a)),
                        ),
                      ),
                      Image(
                        height: Adapt.px(19),
                        width: Adapt.px(35),
                        image: AssetImage("images/icon_next.png"),
                      )
                    ],
                  )
                ],
              ),
            ),
            onTap: () {
              setState(() {
                radiovalue = index;
              });
              if (_selectType.type == 0) {
                pickerData(context, _selectType);
              } else {
                pickerTimes(context, _selectType);
              }
            }),
      ],
    );
  }
}

class _SelectType {
  int type;
  String numerical;

  _SelectType({this.type, this.numerical});

  String getLeftString(BuildContext context) {
    switch (type) {
      case 0:
        return DefinedLocalizations.of(context).time;
        break;
      case 1:
        return DefinedLocalizations.of(context).number;
        break;
      default:
        return " ";
    }
  }
}

class _Group {
  // final Entity entity;
  // bool selected;
  // int type;
  final List<_SelectType> _selectType = List();
  void add(int type, String numerical) {
    _selectType.add(
      _SelectType(type: type, numerical: numerical),
    );
  }

  void clear() {
    _selectType.clear();
  }

  int size() {
    return _selectType.length > 0 ? _selectType.length : 0;
  }

  Object get(int index) => _selectType[index];
}
