import 'dart:convert';
import 'dart:ui';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/automation_set/automation_shar.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/page/PickerData.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/protocol/const.pbenum.dart' as pbConst;
import 'package:xlive/widget/auto_cond_device_header.dart';
import 'common_page.dart';
import 'package:xlive/widget/xy_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

//带参数的类的实现方法 和上面一起的  下面的类_AutoMationPage要在怎么用呢 就是widgei.参数名 就行了
class AutoCondSetConditionValue extends StatefulWidget {
  final int stateType;
  final Entity entity;
  final int deviceProfile;
  final Automation automation;
  final protobuf.Condition cond;

  AutoCondSetConditionValue(
      {this.stateType,
      this.entity,
      this.deviceProfile,
      this.automation,
      this.cond});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingDeviceDetailsPage();
  }
}

class _SettingDeviceDetailsPage extends State<AutoCondSetConditionValue> {
  TextEditingController _powerBegin =
      TextEditingController(); //input  文字传到那里去 TextEditingController类型
  TextEditingController _powerEnd = TextEditingController();
  //这个一定要跟着一个build
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<_Group> _group = List();
  _SelsectNextGroup _selsectNextGroup = _SelsectNextGroup();
  _LocolGroup _locolGroup = _LocolGroup();
  List timeSelect = [0, 0, 0];
  List<int> ortherPickerSeleteds = [0, 0, 0];
  void initState() {
    super.initState();
    _resetData();
  }

  void luxSelectLow(int begin, int end) {
    if (end <= 100) {
      ortherPickerSeleteds = [0, 0, end ~/ 5];
      _locolGroup.add([0, 0, end ~/ 5], LOCAL_TYPE_SUN);
    } else if (end > 100 && end <= 500) {
      ortherPickerSeleteds = [0, 0, 20 + (end - 100) ~/ 20];
      _locolGroup.add([0, 0, 20 + (end - 100) ~/ 20], LOCAL_TYPE_SUN);
    } else if (end > 500 && end <= 1000) {
      ortherPickerSeleteds = [0, 0, 40 + (end - 500) ~/ 100];
      _locolGroup.add([0, 0, 40 + (end - 500) ~/ 100], LOCAL_TYPE_SUN);
    } else if (end > 1000 && end <= 5000) {
      ortherPickerSeleteds = [0, 0, 45 + (end - 1000) ~/ 250];
      _locolGroup.add([0, 0, 45 + (end - 1000) ~/ 250], LOCAL_TYPE_SUN);
    } else if (end > 5000 && end <= 20000) {
      ortherPickerSeleteds = [0, 0, 61 + (end - 5000) ~/ 1000];
      _locolGroup.add([0, 0, 61 + (end - 5000) ~/ 1000], LOCAL_TYPE_SUN);
    }
  }

  void luxSelectHigh(int begin, int end) {
    if (begin <= 100) {
      ortherPickerSeleteds = [1, begin ~/ 5 - 1, 0];
      _locolGroup.add([1, begin ~/ 5 - 1, 0], LOCAL_TYPE_SUN);
    } else if (begin > 100 && begin <= 500) {
      ortherPickerSeleteds = [1, 19 + (begin - 100) ~/ 20 - 1, 0];
      _locolGroup.add([1, 19 + (begin - 100) ~/ 20 - 1, 0], LOCAL_TYPE_SUN);
    } else if (begin > 500 && begin <= 1000) {
      ortherPickerSeleteds = [1, 38 + (begin - 500) ~/ 100 - 1, 0];
      _locolGroup.add([1, 38 + (begin - 500) ~/ 100 - 1, 0], LOCAL_TYPE_SUN);
    } else if (begin > 1000 && begin <= 5000) {
      ortherPickerSeleteds = [1, 43 + (begin - 1000) ~/ 250 - 1, 0];
      _locolGroup.add([1, 43 + (begin - 1000) ~/ 250 - 1, 0], LOCAL_TYPE_SUN);
    } else if (begin > 5000 && begin <= 20000) {
      ortherPickerSeleteds = [1, 59 + (begin - 5000) ~/ 1000 - 1, 0];
      _locolGroup.add([1, 59 + (begin - 5000) ~/ 1000 - 1, 0], LOCAL_TYPE_SUN);
    }
  }

  void luxSelectSection(int begin, int end) {
    if (begin == 0) {
      if (end <= 100) {
        ortherPickerSeleteds = [2, 0, (end - begin) ~/ 5];
        _locolGroup.add([2, 0, (end - begin) ~/ 5], LOCAL_TYPE_SUN);
      } else if (end > 100 && end <= 500) {
        ortherPickerSeleteds = [2, 0, 19 + (end - 100) ~/ 20 - 1];
        _locolGroup.add([2, 0, 19 + (end - 100) ~/ 20 - 1], LOCAL_TYPE_SUN);
      } else if (end > 500 && end <= 1000) {
        ortherPickerSeleteds = [2, 0, 38 + (end - 500) ~/ 100 - 1];
        _locolGroup.add([2, 0, 38 + (end - 500) ~/ 100 - 1], LOCAL_TYPE_SUN);
      } else if (end > 1000 && end <= 5000) {
        ortherPickerSeleteds = [2, 0, 43 + (end - 1000) ~/ 250 - 1];
        _locolGroup.add([2, 0, 43 + (end - 1000) ~/ 250 - 1], LOCAL_TYPE_SUN);
      } else if (end > 5000 && end <= 20000) {
        ortherPickerSeleteds = [2, 0, 58 + (end - 5000) ~/ 1000 - 1];
        _locolGroup.add([2, 0, 58 + (end - 5000) ~/ 1000 - 1], LOCAL_TYPE_SUN);
      }
    } else if (begin > 0 && begin <= 100) {
      if (end <= 100) {
        ortherPickerSeleteds = [2, begin ~/ 5, (end - begin) ~/ 5 - 1];
        _locolGroup
            .add([2, begin ~/ 5, (end - begin) ~/ 5 - 1], LOCAL_TYPE_SUN);
      } else if (end > 100 && end <= 500) {
        ortherPickerSeleteds = [
          2,
          begin ~/ 5,
          (19 + (end - 100) ~/ 20) - (begin ~/ 5)
        ];
        _locolGroup.add(
            [2, begin ~/ 5, (19 + (end - 100) ~/ 20) - (begin ~/ 5)],
            LOCAL_TYPE_SUN);
      } else if (end > 500 && end <= 1000) {
        ortherPickerSeleteds = [
          2,
          begin ~/ 5,
          (40 + (end - 500) ~/ 100) - (begin ~/ 5) - 1
        ];
        _locolGroup.add(
            [2, begin ~/ 5, (40 + (end - 500) ~/ 100) - (begin ~/ 5) - 1],
            LOCAL_TYPE_SUN);
      } else if (end > 1000 && end <= 5000) {
        ortherPickerSeleteds = [
          2,
          begin ~/ 5,
          (45 + (end - 1000) ~/ 250) - (begin ~/ 5) - 1
        ];
        _locolGroup.add(
            [2, begin ~/ 5, (45 + (end - 1000) ~/ 250) - (begin ~/ 5) - 1],
            LOCAL_TYPE_SUN);
      } else if (end > 5000 && end <= 20000) {
        ortherPickerSeleteds = [
          2,
          begin ~/ 5,
          (61 + (end - 5000) ~/ 1000) - (begin ~/ 5) - 1
        ];
        _locolGroup.add(
            [2, begin ~/ 5, (61 + (end - 5000) ~/ 1000) - (begin ~/ 5) - 1],
            LOCAL_TYPE_SUN);
      }
    } else if (begin > 100 && begin <= 500) {
      if (end <= 100) {
        ortherPickerSeleteds = [
          2,
          20 + (begin - 100) ~/ 20,
          (end - begin) ~/ 5 - 1
        ];
        _locolGroup.add([2, 20 + (begin - 100) ~/ 20, (end - begin) ~/ 5 - 1],
            LOCAL_TYPE_SUN);
      } else if (end > 100 && end <= 500) {
        ortherPickerSeleteds = [
          2,
          20 + (begin - 100) ~/ 20,
          (20 + (end - 100) ~/ 20) - (20 + (begin - 100) ~/ 20) - 1
        ];
        _locolGroup.add([
          2,
          20 + (begin - 100) ~/ 20,
          (20 + (end - 100) ~/ 20) - (20 + (begin - 100) ~/ 20) - 1
        ], LOCAL_TYPE_SUN);
      } else if (end > 500 && end <= 1000) {
        ortherPickerSeleteds = [
          2,
          20 + (begin - 100) ~/ 20,
          (40 + (end - 500) ~/ 100) - (20 + (begin - 100) ~/ 20) - 1
        ];
        _locolGroup.add([
          2,
          20 + (begin - 100) ~/ 20,
          (40 + (end - 500) ~/ 100) - (20 + (begin - 100) ~/ 20) - 1
        ], LOCAL_TYPE_SUN);
      } else if (end > 1000 && end <= 5000) {
        ortherPickerSeleteds = [
          2,
          20 + (begin - 100) ~/ 20,
          (45 + (end - 1000) ~/ 250) - (20 + (begin - 100) ~/ 20) - 1
        ];
        _locolGroup.add([
          2,
          20 + (begin - 100) ~/ 20,
          (45 + (end - 1000) ~/ 250) - (20 + (begin - 100) ~/ 20) - 1
        ], LOCAL_TYPE_SUN);
      } else if (end > 5000 && end <= 20000) {
        ortherPickerSeleteds = [
          2,
          20 + (begin - 100) ~/ 20,
          (61 + (end - 5000) ~/ 1000) - (20 + (begin - 100) ~/ 20) - 1
        ];
        _locolGroup.add([
          2,
          20 + (begin - 100) ~/ 20,
          (61 + (end - 5000) ~/ 1000) - (20 + (begin - 100) ~/ 20) - 1
        ], LOCAL_TYPE_SUN);
      }
    } else if (begin > 500 && begin <= 1000) {
      if (end > 500 && end <= 1000) {
        ortherPickerSeleteds = [
          2,
          39 + (begin - 500) ~/ 100,
          (39 + (end - 500) ~/ 100) - (39 + (begin - 500) ~/ 100)
        ];
        _locolGroup.add([
          2,
          39 + (begin - 500) ~/ 100,
          (39 + (end - 500) ~/ 100) - (39 + (begin - 500) ~/ 100)
        ], LOCAL_TYPE_SUN);
      } else if (end > 1000 && end <= 5000) {
        ortherPickerSeleteds = [
          2,
          39 + (begin - 500) ~/ 100,
          (44 + (end - 1000) ~/ 250) - (39 + (begin - 500) ~/ 100)
        ];
        _locolGroup.add([
          2,
          39 + (begin - 500) ~/ 100,
          (44 + (end - 1000) ~/ 250) - (39 + (begin - 500) ~/ 100)
        ], LOCAL_TYPE_SUN);
      } else if (end > 5000 && end <= 20000) {
        ortherPickerSeleteds = [
          2,
          39 + (begin - 500) ~/ 100,
          (59 + (end - 5000) ~/ 1000) - (39 + (begin - 500) ~/ 100)
        ];
        _locolGroup.add([
          2,
          39 + (begin - 500) ~/ 100,
          (59 + (end - 5000) ~/ 1000) - (39 + (begin - 500) ~/ 100)
        ], LOCAL_TYPE_SUN);
      }
    } else if (begin > 1000 && begin <= 5000) {
      if (end > 1000 && end <= 5000) {
        ortherPickerSeleteds = [
          2,
          44 + (begin - 1000) ~/ 250,
          (44 + (end - 1000) ~/ 250) - (44 + (begin - 1000) ~/ 250) - 1
        ];
        _locolGroup.add([
          2,
          44 + (begin - 1000) ~/ 250,
          (44 + (end - 1000) ~/ 250) - (44 + (begin - 1000) ~/ 250) - 1
        ], LOCAL_TYPE_SUN);
      } else if (end > 5000 && end <= 20000) {
        ortherPickerSeleteds = [
          2,
          44 + (begin - 1000) ~/ 250,
          (59 + (end - 5000) ~/ 1000) - (44 + (begin - 1000) ~/ 250)
        ];
        _locolGroup.add([
          2,
          44 + (begin - 1000) ~/ 250,
          (59 + (end - 5000) ~/ 1000) - (44 + (begin - 1000) ~/ 250)
        ], LOCAL_TYPE_SUN);
      }
    } else if (begin > 5000 && begin <= 20000) {
      if (end > 5000 && end <= 20000) {
        ortherPickerSeleteds = [
          2,
          61 + (begin - 5000) ~/ 1000 - 1,
          (61 + (end - 5000) ~/ 1000) - (61 + (begin - 5000) ~/ 1000) - 1
        ];
        _locolGroup.add([
          2,
          61 + (begin - 5000) ~/ 1000 - 1,
          (61 + (end - 5000) ~/ 1000) - (61 + (begin - 5000) ~/ 1000) - 1
        ], LOCAL_TYPE_SUN);
      }
    }
  }

  String getFirstPowerVal(String unit, int type) {
    if (widget.cond == null) return "";
    if (type != widget.cond.attributeVariation.attrID.value) return "";
    var begin = widget.cond.attributeVariation.targetRange.begin;
    var end = widget.cond.attributeVariation.targetRange.end;
    begin = begin ~/ 10;
    end = end ~/ 10;
    _powerBegin.text = begin.toString();
    _powerEnd.text = end.toString();
    if (begin == 0) {
      _locolGroup.add([begin, end], LOCAL_TYPE_POWER);
      return DefinedLocalizations.of(null).under + end.toString() + unit;
    }
    _locolGroup.add([begin, end], LOCAL_TYPE_POWER);
    return begin.toString() +
        "~" +
        end.toString() +
        unit +
        DefinedLocalizations.of(null).among;
  }

  String getFirstVal(String unit, int type) {
    if (widget.cond == null) return "";
    if (type != widget.cond.attributeVariation.attrID.value) return "";
    var begin = widget.cond.attributeVariation.targetRange.begin;
    var end = widget.cond.attributeVariation.targetRange.end;
    if (unit == DefinedLocalizations.of(null).degreeCentigrade) {
      begin = begin ~/ 10;
      end = end ~/ 10;
    }
    if (begin < -21474836) {
      if (unit == DefinedLocalizations.of(null).degreeCentigrade) {
        ortherPickerSeleteds = [0, 0, 20 + end];
        _locolGroup.add([0, 0, 20 + end], LOCAL_TYPE_TEM);
      } else if (unit == "%") {
        ortherPickerSeleteds = [0, 0, end];
        _locolGroup.add([0, 0, end], LOCAL_TYPE_PERCENT);
      } else if (unit == "Lux") {
        luxSelectLow(begin, end);
      }
      return DefinedLocalizations.of(null).under + end.toString() + unit;
    } else if (end > 21474836) {
      if (unit == DefinedLocalizations.of(null).degreeCentigrade) {
        ortherPickerSeleteds = [1, 20 + begin, 0];
        _locolGroup.add([1, 20 + begin, 0], LOCAL_TYPE_TEM);
      } else if (unit == "%") {
        ortherPickerSeleteds = [1, begin, 0];
        _locolGroup.add([1, begin, 0], LOCAL_TYPE_PERCENT);
      } else if (unit == "Lux") {
        luxSelectHigh(begin, end);
      }

      return DefinedLocalizations.of(null).greaterThan +
          begin.toString() +
          unit;
    } else {
      if (unit == DefinedLocalizations.of(null).degreeCentigrade) {
        ortherPickerSeleteds = [2, 20 + begin, ((end - begin) - 1).abs()];
        _locolGroup.add(
            [2, 20 + begin, (begin.abs() - end.abs()) - 1], LOCAL_TYPE_TEM);
      } else if (unit == "%") {
        ortherPickerSeleteds = [
          2,
          begin,
          ((end.abs() - begin.abs()) - 1).abs()
        ];
        _locolGroup.add([2, begin, ((end.abs() - begin.abs()) - 1).abs()],
            LOCAL_TYPE_PERCENT);
      } else if (unit == "Lux") {
        luxSelectSection(begin, end);
      }

      return begin.toString() +
          "~" +
          end.toString() +
          unit +
          DefinedLocalizations.of(null).among;
    }
  }

  String getFirstTime(int type) {
    //type 为attributeVariation.attrID.value
    if (widget.cond == null) return DefinedLocalizations.of(null).immediate;
    if (type != widget.cond.attributeVariation.attrID.value)
      return DefinedLocalizations.of(null).immediate;
    var timeStr = "";
    var keepTime = widget.cond.attributeVariation.keepTimeMS;
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
    timeSelect = [hour, min, sec];
    _locolGroup.add([hour, min, sec], LOCAL_TYPE_TIME);
    if (hour > 0) {
      timeStr = hour.toString() + DefinedLocalizations.of(null).hour;
    }
    if (min > 0) {
      timeStr += min.toString() + DefinedLocalizations.of(null).minute;
    }
    if (sec > 0) {
      timeStr += sec.toString() + DefinedLocalizations.of(null).second;
    }
    return timeStr;
  }

  void _resetData() {
    print("------------------auto_cond_set_condition_value_page.dart");
    print(widget.stateType);
    _locolGroup.clear();
    _powerBegin.text = "0";
    _powerEnd.text = "2200";
    LogicDevice lg = widget.entity as LogicDevice;
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.stateType == TYPE_CONDITION_TEMPERATURE) {
      //温度
      _selsectNextGroup.add(
          widget.entity,
          SETTING_TEM,
          3,
          Int64(0),
          getFirstVal(DefinedLocalizations.of(null).degreeCentigrade,
              ATTRIBUTE_ID_TEMPERATURE),
          []);
      _selsectNextGroup.add(widget.entity, SETTING_TIME, 4, Int64(0),
          getFirstTime(ATTRIBUTE_ID_TEMPERATURE), []);
      if (widget.cond != null) {
        var begin = widget.cond.attributeVariation.targetRange.begin;
        var end = widget.cond.attributeVariation.targetRange.end;
        getFirstVal(DefinedLocalizations.of(null).degreeCentigrade,
            ATTRIBUTE_ID_TEMPERATURE);
      } else {
        ortherPickerSeleteds = [0, 0, 0];
      }
    } else if (widget.stateType == TYPE_CONDITION_ILLUMINANCE) {
      //照度

      _selsectNextGroup.add(widget.entity, SETTING_SUN, 5, Int64(0),
          getFirstVal("Lux", ATTRIBUTE_ID_LUMINANCE), []);
      _selsectNextGroup.add(widget.entity, SETTING_TIME, 4, Int64(0),
          getFirstTime(ATTRIBUTE_ID_LUMINANCE), []);
    } else if (widget.stateType == TYPE_CONDITION_ACTIVE_POWER) {
      //111111111112
      //即时功率
      _selsectNextGroup.add(widget.entity, SETTING_POWER, 6, Int64(0),
          getFirstPowerVal("W", ATTRIBUTE_ID_ACTIVE_POWER), []);
      _selsectNextGroup.add(widget.entity, SETTING_TIME, 4, Int64(0),
          getFirstTime(ATTRIBUTE_ID_ACTIVE_POWER), []);
    } else if (widget.stateType == TYPE_CONDITION_TOTAL_POWER) {
      //总功率
      _selsectNextGroup.add(widget.entity, SETTING_DISSIPATION, 5, Int64(0),
          getFirstVal("W", 1), []);
      _selsectNextGroup.add(widget.entity, SETTING_TIME, 4, Int64(0),
          getFirstTime(ATTRIBUTE_ID_TOTLE_POWER), []);
    } else if (widget.stateType == TYPE_CONDITION_CURTIAN_ONOFF) {
      //窗帘的开合
      _selsectNextGroup.add(
          widget.entity,
          SETTING_OPEN_CLOSE_STATUES,
          7,
          Int64(0),
          getFirstVal("%", ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION), []);
      _selsectNextGroup.add(widget.entity, SETTING_TIME, 4, Int64(0),
          getFirstTime(ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION), []);
    }
    _group.add(_selsectNextGroup);
    setState(() {});
  }

  void dispose() {
    //页面卸载是执行的
    super.dispose();
  }

  void pickerTem(
      BuildContext context, _SelectNextCondition _selectNextCondition) async {
    Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerTem.replaceAll(
                    "@under", DefinedLocalizations.of(context).under)
                .replaceAll("@greaterThan",
                    DefinedLocalizations.of(context).greaterThan)
                .replaceAll(
                    "@between", DefinedLocalizations.of(context).between))),
        columnPadding: EdgeInsets.all(0.0),
        cancelText: DefinedLocalizations.of(context).cancel,
        cancelTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        selecteds: ortherPickerSeleteds,
        onSelect: (picker, intdex, selects) {
          if (selects[0] == 0) {
            selects[1] = 0;
          }
          setState(() {
            ortherPickerSeleteds = selects;
          });
        },
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
                      "°C",
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
                      "°C",
                      style: TextStyle(
                        color: Color(0x732d3b46),
                        fontSize: Adapt.px(35),
                      ),
                    ),
                  )),
              column: 5),
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
              column: 6),
        ],
        confirmText: DefinedLocalizations.of(context).confirm,
        confirmTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        hideHeader: false,
        title: Text(DefinedLocalizations.of(context).temperature),
        onConfirm: (Picker picker, List value) {
          switch (value[0]) {
            case 0:
              _selectNextCondition.selectNumVal = SETTING_UNDER;
              break;
            case 1:
              _selectNextCondition.selectNumVal = SETTING_EXCEED;
              break;
            case 2:
              _selectNextCondition.selectNumVal = SETTING_SITUATE;
              break;
            default:
          }
          _selectNextCondition.temSelect = picker.adapter.getSelectedValues();
          if (widget.stateType == TYPE_CONDITION_ACTIVE_POWER) {
            _selectNextCondition.uiValue =
                getSelectValue(_selectNextCondition, "W");
          } else if (widget.stateType == TYPE_CONDITION_CURTIAN_ONOFF) {
            _selectNextCondition.uiValue =
                getSelectValue(_selectNextCondition, "%");
          } else {
            _selectNextCondition.uiValue = getSelectValue(_selectNextCondition,
                DefinedLocalizations.of(context).degreeCentigrade);
          }

          setState(() {});
        });
    picker.showDialogXy(context);
  }

  void pickerPresent(
      BuildContext context, _SelectNextCondition _selectNextCondition) {
    Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerPresent.replaceAll(
                    "@under", DefinedLocalizations.of(context).under)
                .replaceAll("@greaterThan",
                    DefinedLocalizations.of(context).greaterThan)
                .replaceAll(
                    "@between", DefinedLocalizations.of(context).between))),
        columnPadding: EdgeInsets.all(0.0),
        cancelText: DefinedLocalizations.of(context).cancel,
        cancelTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        confirmText: DefinedLocalizations.of(context).confirm,
        confirmTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        hideHeader: false,
        title: Text(
          DefinedLocalizations.of(context).openCloseState,
          style: TextStyle(fontSize: Adapt.px(50), color: Color(0x732d3b46)),
        ),
        selecteds: ortherPickerSeleteds,
        onSelect: (picker, index, selecteds) {
          if (selecteds[0] == 0) {
            selecteds[1] == 0;
          }
          setState(() {
            ortherPickerSeleteds = selecteds;
          });
        },
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
                      "padin",
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
                      "%",
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
                      "%",
                      style: TextStyle(
                        color: Color(0x732d3b46),
                        fontSize: Adapt.px(35),
                      ),
                    ),
                  )),
              column: 5),
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
                      "padin",
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                  )),
              column: 6),
        ],
        onConfirm: (Picker picker, List value) {
          _selectNextCondition.temSelect = picker.adapter.getSelectedValues();
          switch (value[0]) {
            case 0:
              _selectNextCondition.selectNumVal = SETTING_UNDER;
              break;
            case 1:
              _selectNextCondition.selectNumVal = SETTING_EXCEED;
              break;
            case 2:
              _selectNextCondition.selectNumVal = SETTING_SITUATE;
              break;
            default:
          }
          if (widget.stateType == TYPE_CONDITION_CURTIAN_ONOFF) {
            _selectNextCondition.uiValue =
                getSelectValue(_selectNextCondition, "%");
          }

          setState(() {});
        });
    picker.showDialogXy(context);
  }

  void pickerSun(
      BuildContext context, _SelectNextCondition _selectNextCondition) {
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerSun.replaceAll(
                    "@under", DefinedLocalizations.of(context).under)
                .replaceAll("@greaterThan",
                    DefinedLocalizations.of(context).greaterThan)
                .replaceAll(
                    "@between", DefinedLocalizations.of(context).between))),
        columnPadding: EdgeInsets.all(0.0),
        cancelText: DefinedLocalizations.of(context).cancel,
        cancelTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        selecteds: ortherPickerSeleteds,
        onSelect: (picker, intdex, selects) {
          if (selects[0] == 0) {
            selects[1] = 0;
          }
          setState(() {
            ortherPickerSeleteds = selects;
          });
        },
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
                      "p",
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
                      "Lux",
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
                      "Lux",
                      style: TextStyle(
                        color: Color(0x732d3b46),
                        fontSize: Adapt.px(35),
                      ),
                    ),
                  )),
              column: 5),
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
                      "pa",
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                  )),
              column: 6),
        ],
        confirmText: DefinedLocalizations.of(context).confirm,
        confirmTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        hideHeader: false,
        title: Text(DefinedLocalizations.of(context).illuminance),
        onConfirm: (Picker picker, List value) {
          _selectNextCondition.temSelect = picker.adapter.getSelectedValues();
          switch (value[0]) {
            case 0:
              _selectNextCondition.selectNumVal = SETTING_UNDER;
              break;
            case 1:
              _selectNextCondition.selectNumVal = SETTING_EXCEED;
              break;
            case 2:
              _selectNextCondition.selectNumVal = SETTING_SITUATE;
              break;
            default:
          }
          _selectNextCondition.uiValue =
              getSelectValue(_selectNextCondition, "Lux");
          setState(() {});
        }).showDialogXy(context);
  }

  String getSelectValue(
      _SelectNextCondition _selectNextCondition, String unit) {
    if (_selectNextCondition.temSelect.length == 0) return "";
    if (_selectNextCondition.temSelect[0] ==
        DefinedLocalizations.of(context).greaterThan) {
      return _selectNextCondition.temSelect[1].toString() + unit;
    } else if (_selectNextCondition.temSelect[0] ==
        DefinedLocalizations.of(context).under) {
      return _selectNextCondition.temSelect[2].toString() + unit;
    } else {
      return _selectNextCondition.temSelect[1].toString() +
          "~" +
          _selectNextCondition.temSelect[2].toString() +
          unit +
          DefinedLocalizations.of(context).among;
    }
  }

  int _itemCount() => _selsectNextGroup.size();
  Object _getItem(int index) {
    int step = 0;
    for (var group in _group) {
      if (index >= step && index < step + group.size()) {
        return group.get(index - step);
      } else {
        step += group.size();
      }
    }
    return null;
  }

  pbConst.AttributeID getAcAttrID() {
    switch (widget.stateType) {
      case TYPE_CONDITION_TEMPERATURE:
        return pbConst.AttributeID.AttrIDTemperature;
        break;
      case TYPE_CONDITION_ILLUMINANCE: //111111111113
        return pbConst.AttributeID.AttrIDLuminance;
        break;
      case TYPE_CONDITION_ACTIVE_POWER: //111111111113
        return pbConst.AttributeID.AttrIDActivePower;
        break;
      case TYPE_CONDITION_TOTAL_POWER:
        return pbConst.AttributeID.AttrIDTotalPower;
        break;
      case TYPE_CONDITION_CURTIAN_ONOFF: //窗帘开合状态
        return pbConst.AttributeID.AttrIDWindowCurrentLiftPercent;
        break;
      default:
        return pbConst.AttributeID.AttrIDWindowCurrentLiftPercent;
    }
  }

  int walkingDirection() {
    if (int.parse(_powerBegin.text) > 2200 ||
        int.parse(_powerEnd.text) > 2200) {
      return -1;
    }
    for (var i = 0; i < _group.length; i++) {
      final Object obj = _getItem(i);
      if (obj is _SelectNextCondition) {
        if (obj.uiValue == "") {
          return -1;
        } else {
          return i;
        }
      }
    }
    return -1;
  }

  void getUiTime(List value, _SelectNextCondition _selectNextCondition) {
    if (value == null)
      _selectNextCondition.uiValue = DefinedLocalizations.of(context).immediate;
    String timeStr = "";
    if (value[0] > 0) {
      timeStr +=
          value[0].toString() + DefinedLocalizations.of(context).hour + " ";
    }
    if (value[1] > 0) {
      timeStr +=
          value[1].toString() + DefinedLocalizations.of(context).minute + " ";
    }
    if (value[2] > 0) {
      timeStr +=
          value[2].toString() + DefinedLocalizations.of(context).second + " ";
    }
    _selectNextCondition.uiValue = timeStr;
    // if (value[0] > 0) {
    //   _selectNextCondition.uiValue = value[0].toString() +
    //       DefinedLocalizations.of(context).hourFull +
    //       value[1].toString() +
    //       DefinedLocalizations.of(context).minutes +
    //       value[2].toString() +
    //       DefinedLocalizations.of(context).second;
    // } else {
    //   _selectNextCondition.uiValue = value[1].toString() +
    //       DefinedLocalizations.of(context).minutes +
    //       value[2].toString() +
    //       DefinedLocalizations.of(context).second;
    // }

    // _selectNextCondition.uiValue =
    //     _selectNextCondition.uiValue.replaceAll(" 0小时", "");
    // _selectNextCondition.uiValue = _selectNextCondition.uiValue.replaceAll(
    //     DefinedLocalizations.of(context).hourZeroMinute,
    //     DefinedLocalizations.of(context).hour);
    // _selectNextCondition.uiValue = _selectNextCondition.uiValue.replaceAll(
    //     DefinedLocalizations.of(context).minuteZeroSecond,
    //     DefinedLocalizations.of(context).minutes);
    // _selectNextCondition.uiValue = _selectNextCondition.uiValue.replaceAll(
    //     DefinedLocalizations.of(context).hourZeroSecond,
    //     DefinedLocalizations.of(context).hour);
  }

  void pickerTimeDuration(
      BuildContext context, _SelectNextCondition _selectNextCondition) {
    var hour, min, sec;
    timeSelect[0] == -1 ? hour = 0 : hour = timeSelect[0];
    timeSelect[1] == -1 ? min = 0 : min = timeSelect[1];
    timeSelect[2] == -1 ? sec = 0 : sec = timeSelect[2];
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
          _selectNextCondition.durationTime =
              Int64((value[0] * 60 * 60 + value[1] * 60 + value[2]) * 1000);
          getUiTime(value, _selectNextCondition);
          timeSelect = value;
          setState(() {});
        }).showDialogXy(context);
  }

  Int64 getConditionTimeParameter() {
    for (var i = 0; i < _itemCount(); i++) {
      final obj = _getItem(i);
      if (obj is _SelectNextCondition && obj.selectNumVal == SETTING_TIME) {
        return obj.durationTime == null ? Int64(0) : obj.durationTime;
      }
    }
    return Int64(0);
  }

  protobuf.Range setSourceRange() {
    protobuf.Range sourceRange = protobuf.Range.create();
    sourceRange.begin = -2147483648;
    sourceRange.end = 2147483647;
    return sourceRange;
  }

  protobuf.Range setTargetRange() {
    protobuf.Range targetRange = protobuf.Range.create();
    for (var i = 0; i < _itemCount(); i++) {
      final obj = _getItem(i);
      if (obj is _SelectNextCondition) {
        if (widget.stateType == TYPE_CONDITION_TEMPERATURE) {
          if (obj.temSelect[0] == DefinedLocalizations.of(context).between) {
            targetRange.begin = int.parse(obj.temSelect[1]) * 10;
            targetRange.end = int.parse(obj.temSelect[2]) * 10;
          } else if (obj.temSelect[0] ==
              DefinedLocalizations.of(context).greaterThan) {
            targetRange.begin = int.parse(obj.temSelect[1]) * 10;
            targetRange.end = 2147483647;
          } else if (obj.temSelect[0] ==
              DefinedLocalizations.of(context).under) {
            targetRange.begin = -2147483647;
            targetRange.end = int.parse(obj.temSelect[2]) * 10;
          }
        } else if (widget.stateType == TYPE_CONDITION_ACTIVE_POWER) {
          targetRange.begin = int.parse(_powerBegin.text) * 10;
          targetRange.end = int.parse(_powerEnd.text) * 10;
        } else {
          if (obj.temSelect[0] == DefinedLocalizations.of(context).between) {
            targetRange.begin = int.parse(obj.temSelect[1]);
            targetRange.end = int.parse(obj.temSelect[2]);
          } else if (obj.temSelect[0] ==
              DefinedLocalizations.of(context).greaterThan) {
            targetRange.begin = int.parse(obj.temSelect[1]);
            targetRange.end = 2147483647;
          } else if (obj.temSelect[0] ==
              DefinedLocalizations.of(context).under) {
            targetRange.begin = -2147483647;
            targetRange.end = int.parse(obj.temSelect[2]);
          }
        }

        return targetRange;
      }
    }
    return null;
  }

  void powerDialog(
      BuildContext context, _SelectNextCondition _selectNextCondition) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              height: Adapt.px(556),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: Adapt.px(159),
                    padding: EdgeInsets.only(
                        left: Adapt.px(45), right: Adapt.px(45)),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Color(0x33000000),
                                style: BorderStyle.solid))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Text(DefinedLocalizations.of(context).cancel,
                              style: TextStyle(
                                  fontSize: Adapt.px(42),
                                  color: Color(0xff7cd0ff))),
                          onTap: () {
                            _powerBegin.text = "";
                            _powerEnd.text = "";
                            _selectNextCondition.uiValue = "";
                            ortherPickerSeleteds = [];
                            setState(() {});
                            Navigator.of(context, rootNavigator: true)
                                .maybePop();
                          },
                        ),
                        Text(DefinedLocalizations.of(context).powerRange,
                            style: TextStyle(
                                fontSize: Adapt.px(50),
                                color: Color(0xff2d3b46))),
                        GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Text(
                                DefinedLocalizations.of(context).complete,
                                style: TextStyle(
                                    fontSize: Adapt.px(42),
                                    color: Color(0xff7cd0ff))),
                            onTap: () {
                              if (_powerBegin.text == _powerEnd.text) {
                                _selectNextCondition.uiValue =
                                    DefinedLocalizations.of(context)
                                        .numericalViolation;
                                return;
                              }
                              if (_powerBegin.text == "0") {
                                _selectNextCondition.uiValue =
                                    DefinedLocalizations.of(context).under +
                                        _powerEnd.text;
                              } else {
                                _selectNextCondition.uiValue =
                                    _powerBegin.text +
                                        "W - " +
                                        _powerEnd.text +
                                        "W";
                              }
                              ortherPickerSeleteds = [
                                int.parse(_powerBegin.text),
                                int.parse(_powerEnd.text)
                              ];
                              setState(() {});
                              Navigator.of(context, rootNavigator: true)
                                  .maybePop();
                            }),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: Adapt.px(83), bottom: Adapt.px(83)),
                      child: Center(
                        child: Text(
                          DefinedLocalizations.of(context).inputPower,
                          style: TextStyle(
                              fontSize: Adapt.px(40), color: Color(0xff55585a)),
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: Adapt.px(180),
                        height: Adapt.px(80),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: Color(0x20000000),
                                    style: BorderStyle.solid))),
                        child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration.collapsed(
                                hintText: '0',
                                hintStyle: TextStyle(color: Color(0x152d3b46))),
                            autocorrect: false,
                            controller: _powerBegin),
                      ),
                      Container(
                          margin: EdgeInsets.only(right: Adapt.px(46)),
                          child: Text("W",
                              style: TextStyle(
                                  fontSize: Adapt.px(35),
                                  color: Color(0xff2d3b46)))),
                      Container(
                          margin: EdgeInsets.only(right: Adapt.px(44)),
                          child: Text("-",
                              style: TextStyle(
                                  fontSize: Adapt.px(35),
                                  color: Color(0xff2d3b46)))),
                      Container(
                        width: Adapt.px(180),
                        height: Adapt.px(80),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: Color(0x20000000),
                                    style: BorderStyle.solid))),
                        child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration.collapsed(
                                hintText: '2200',
                                hintStyle: TextStyle(color: Color(0x152d3b46))),
                            autocorrect: false,
                            controller: _powerEnd),
                      ),
                      Container(
                          child: Text("W",
                              style: TextStyle(
                                  fontSize: Adapt.px(35),
                                  color: Color(0xff2d3b46))))
                    ],
                  )
                ],
              ),
            ),
          );
          // );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: null,
      body: CommonPage(
          title: DefinedLocalizations.of(context).settingCond,
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
              if (walkingDirection() == -1) {
                Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).addConditionCorrectly,
                    gravity: ToastGravity.BOTTOM);
                return null;
              }
              if (int.parse(_powerBegin.text) >= int.parse(_powerEnd.text)) {
                Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).invalidPowerCondition,
                    gravity: ToastGravity.BOTTOM);
                return null;
              }
              ConditionAttributeVariation.conditionAttributeVariationSet(
                  widget.automation,
                  widget.entity.uuid,
                  getAcAttrID(),
                  setSourceRange(),
                  setTargetRange(),
                  getConditionTimeParameter(),
                  widget.cond);
              Navigator.of(context)
                  .popUntil(ModalRoute.withName("/AutomationDetail"));
            },
          ),
          child: _buildSetting()),
    );
  }

  Widget _buildSetting() {
    return ListView(
      children: <Widget>[
        AutoCondDeviceHeader(
          entity: widget.entity,
        ),
        Container(
            height: Adapt.px(1300),
            child: ListView.builder(
              itemCount: _itemCount(),
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemBuilder: (BuildContext context, int index) {
                final Object obj = _getItem(index);
                if (obj is _SelectNextCondition) {
                  return _buildSelectNextCondition(context, obj);
                }
                return Text("");
              },
            ))
      ],
    );
  }

  Widget _buildSelectNextCondition(
      BuildContext context, _SelectNextCondition _selectNextCondition) {
    if (_selectNextCondition.uiValue == null) {
      _selectNextCondition.uiValue = "";
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
            Text(
              _selectNextCondition.getLeftString(context),
              style:
                  TextStyle(fontSize: Adapt.px(46), color: Color(0xff55585a)),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: Text(
                      _selectNextCondition.uiValue,
                      style: TextStyle(
                          fontSize: Adapt.px(46), color: Color(0x732d3b46)),
                    ),
                  ),
                  Offstage(
                    offstage: false,
                    child: Image(
                      width: Adapt.px(19),
                      height: Adapt.px(35),
                      image: AssetImage("images/icon_next.png"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        if (_selectNextCondition.detailsNum == 3) {
          pickerTem(context, _selectNextCondition); //温度
        } else if (_selectNextCondition.detailsNum == 7) {
          pickerPresent(context, _selectNextCondition); //窗帘开合百分比
        } else if (_selectNextCondition.detailsNum == 4) {
          pickerTimeDuration(context, _selectNextCondition);
        } else if (_selectNextCondition.detailsNum == 5) {
          pickerSun(context, _selectNextCondition);
        } else if (_selectNextCondition.detailsNum == 6) {
          powerDialog(context, _selectNextCondition);
        }
      },
    );
  }
}

class _Condition {} //各种body类型

class _Group {
  //需要一个group 盛放需要的列表
  int size() {
    return 0;
  }

  Object get(int index) {
    return Object();
  }
}

class _SelectNextCondition extends _Condition {
  //按键
  Entity entity;
  int selectNumVal;
  // int deviceDetailsNum;
  int detailsNum;
  Int64 durationTime = Int64(0);
  String uiValue;
  List temSelect;

  _SelectNextCondition({
    @required this.entity,
    @required this.selectNumVal,
    // @required this.deviceDetailsNum,
    @required this.detailsNum,
    this.durationTime,
    this.uiValue,
    this.temSelect,
  });
  String getLeftString(BuildContext context) {
    switch (selectNumVal) {
      case SETTING_TEM: //0
        return DefinedLocalizations.of(context).settingTemperature;
        break;
      case SETTING_TIME: //1
        return DefinedLocalizations.of(context).timeOfDuration;
        break;
      case SETTING_SUN: //2
        return DefinedLocalizations.of(context).setIllumination;
        break;
      case SETTING_EXCEED: //3
        return DefinedLocalizations.of(context).greaterThan;
        break;
      case SETTING_UNDER: //4
        return DefinedLocalizations.of(context).under;
        break;
      case SETTING_SITUATE: //5
        return DefinedLocalizations.of(context).between;
        break;
      case SETTING_POWER: //6
        return DefinedLocalizations.of(context).immediatelyPower;
        break;
      case SETTING_DISSIPATION: //6
        return DefinedLocalizations.of(context).totalPower;
        break;
      case SETTING_OPEN_CLOSE_STATUES: //8
        return DefinedLocalizations.of(context).openCloseState;
        break;
      default:
        return " ";
    }
  }
}

class _SelsectNextGroup extends _Group {
  final List<_SelectNextCondition> _selectNextCondition = List();
  void add(Entity entity, int selectNumVal, int detailsNum, Int64 durationTime,
      String uiValue, List temSelect) {
    _selectNextCondition.add(
      _SelectNextCondition(
        entity: entity,
        selectNumVal: selectNumVal,
        // deviceDetailsNum: deviceDetailsNum,
        detailsNum: detailsNum,
        durationTime: durationTime,
        uiValue: uiValue,
        temSelect: temSelect,
      ),
    );
  }

  void clear() {
    _selectNextCondition.clear();
  }

  int size() {
    return _selectNextCondition.length > 0 ? _selectNextCondition.length : 0;
  }

  Object get(int index) => _selectNextCondition[index];
}

class _Locol {
  List locol = List();
  int type;
  _Locol({this.locol, this.type});
}

class _LocolGroup {
  final List<_Locol> _local = List();
  void add(List locol, int type) {
    _local.add(
      _Locol(locol: locol, type: type),
    );
  }

  void clear() {
    _local.clear();
  }

  int size() {
    return _local.length > 0 ? _local.length : 0;
  }

  Object get(int index) => _local[index];
}
