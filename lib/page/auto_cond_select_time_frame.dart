import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart'; //安卓风格控件
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/page/PickerData.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/data/data_shared.dart';
import 'dart:async';
import 'package:xlive/widget/xy_picker.dart';

class AutoCondSelectTimeFrame extends StatefulWidget {
  //这个一定要跟着createstate
  final Automation automation; //带参数的类的实现方法
  final AutomationSet automationSet;
  final int len;
  // protobuf.CalendarCondition calendar;
  AutoCondSelectTimeFrame({this.automation, this.len, this.automationSet});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelectTimeFramePage();
  }
}

class _SelectTimeFramePage extends State<AutoCondSelectTimeFrame> {
  //这个一定要跟着一个build
  //创建一个自动化的列表
  List<int> beginSelects = [0, 0, 0];
  List<int> endSelects = [0, 0, 0];

  StreamSubscription _subscription; //消息通道

  void initState() {
    //onshow
    super.initState();
    _resetData();
  }

  void _resetData() {
    print("--------------------auto_cond_select_time_frame_page.dart");
    var cond = widget.automation.getConditionAt(0);
    if (!cond.hasCalendarRange()) return;
    var beginH = cond.calendarRange.begin.hour;
    var beginM = cond.calendarRange.begin.min;
    var endH = cond.calendarRange.end.hour;
    var endM = cond.calendarRange.end.min;
    if (beginH <= 11) {
      beginSelects = [0, beginH, beginM];
    } else {
      beginSelects = [1, beginH - 12, beginM];
    }

    if (endH <= 11) {
      endSelects = [0, endH, endM];
    } else {
      endSelects = [1, endH - 12, endM];
    }
    setState(() {
      beginSelects;
      endSelects;
    });
  }

  void dispose() {
    //页面卸载是执行的
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var caldt = protobuf.DayTime.create();
    return CommonPage(
      title: DefinedLocalizations.of(context).selectDate,
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
          String beginhour = beginSelects[1].toString();
          String beginmin = beginSelects[2].toString();
          String endhour = endSelects[1].toString();
          String endmin = endSelects[2].toString();
          if (beginSelects.toString() == endSelects.toString()) {
            Fluttertoast.showToast(
                msg: DefinedLocalizations.of(context).dateError);
            return;
          }
          // 0 = 12 1=1 2=2  3=3
          if (beginSelects[0] == 1) {
            beginhour = (beginSelects[1] + 12).toString();
          }
          if (endSelects[0] == 1) {
            endhour = (endSelects[1] + 12).toString();
          }
          if (widget.automation.getConditionCount() < COND_COUNT) return;
          var cond = widget.automation.getConditionAt(0);
          cond.calendarRange.begin.hour = int.parse(beginhour);
          cond.calendarRange.begin.min = int.parse(beginmin);
          cond.calendarRange.begin.sec = 0;
          cond.calendarRange.end.hour = int.parse(endhour);
          cond.calendarRange.end.min = int.parse(endmin);
          cond.calendarRange.end.sec = 0;
          Navigator.of(context).maybePop();
        },
      ),
      child: Container(
          padding: EdgeInsets.only(
              left: Adapt.px(40), right: Adapt.px(40), top: Adapt.px(120)),
          child: _buildSelectTime(context)),
    );
  }

  Widget _buildSelectTime(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(DefinedLocalizations.of(context).dateBegin,
                  style: TextStyle(
                      fontSize: Adapt.px(45),
                      color: Color(0xff55585a),
                      fontWeight: FontWeight.w600)),
              Picker(
                  adapter: PickerDataAdapter<String>(
                      pickerdata: new JsonDecoder().convert(
                          PickerTimeFrame.replaceAll("@morning",
                                  DefinedLocalizations.of(context).morning)
                              .replaceAll("@afternoon",
                                  DefinedLocalizations.of(context).afternoon))),
                  selecteds: beginSelects,
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
                                "padding",
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
                        column: 3),
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
                                "padiinging",
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
                  cancelTextStyle: TextStyle(
                      fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
                  confirmText: DefinedLocalizations.of(context).confirm,
                  confirmTextStyle: TextStyle(
                      fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
                  unt: true,
                  onSelect: (picker, index, selecteds) {
                    setState(() {
                      beginSelects = selecteds;
                    });
                  }).makePicker(),
            ],
          )),
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(DefinedLocalizations.of(context).dateEnd,
                  style: TextStyle(
                      fontSize: Adapt.px(45),
                      color: Color(0xff55585a),
                      fontWeight: FontWeight.w600)),
              Picker(
                  adapter: PickerDataAdapter<String>(
                      pickerdata: new JsonDecoder().convert(
                          PickerTimeFrame1.replaceAll("@morning",
                                  DefinedLocalizations.of(context).morning)
                              .replaceAll("@afternoon",
                                  DefinedLocalizations.of(context).afternoon))),
                  selecteds: endSelects,
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
                                "padding",
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
                        column: 3),
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
                                "padiinging",
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
                  cancelTextStyle: TextStyle(
                      fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
                  confirmText: DefinedLocalizations.of(context).confirm,
                  confirmTextStyle: TextStyle(
                      fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
                  unt: true,
                  onSelect: (picker, index, selecteds) {
                    setState(() {
                      endSelects = selecteds;
                    });
                  }).makePicker(),
            ],
          )),
        ],
      ),
      onTap: () {},
    );
  }
}
