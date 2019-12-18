import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/automation_set/automation_shar.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/page/PickerData.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/protocol/const.pbenum.dart' as pbConst;
import 'package:xlive/widget/auto_cond_device_header.dart';
import 'common_page.dart';
import 'package:xlive/widget/xy_picker.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

const int SPEED_LOW = 5000;
const int SPEED_INTERMEDIATE = 2000;
const int SPEED_QUICK = 1000;

//带参数的类的实现方法 和上面一起的  下面的类_AutoMationPage要在怎么用呢 就是widgei.参数名 就行了
class AutoConditionRadioType extends StatefulWidget {
  final int stateType;
  final Entity entity;
  final int deviceProfile;
  final Automation automation;
  final protobuf.Condition cond;

  AutoConditionRadioType(
      {this.stateType,
      this.entity,
      this.deviceProfile,
      this.automation,
      this.cond});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoConditionRadioTypePage();
  }
}

class _AutoConditionRadioTypePage extends State<AutoConditionRadioType> {
  //这个一定要跟着一个build
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<_Group> _group = List();
  _SelectGroup _selectGroup = _SelectGroup();
  _SelsectNextGroup _selsectNextGroup = _SelsectNextGroup();
  _DeviceDetailsGroup _deviceDetailsGroup = _DeviceDetailsGroup();
  _SelectDeviceDetailsGroup _selectDeviceDetailsGroup =
      _SelectDeviceDetailsGroup();
  _SelectKeypressGroup _selectKeypressGroup = _SelectKeypressGroup();
  int radiovalue = -1;
  List timeSelect = [-1, -1, -1];
  StreamSubscription _subscription; //消息通道
  List selectOptions = [];
  void initState() {
    super.initState();
    _resetData(); //onshow
    _start();
  }

  void keypressItem() {
    var numV = "-2";
    if (widget.cond != null &&
        (widget.cond.hasKeypress() || widget.cond.hasLongPress())) {
      if (widget.cond.keypress.pressedTimes == 1) {
        radiovalue = 0;
        if (widget.deviceProfile == CONDITION_DEVICE_TYPE_BUTTON ||
            widget.deviceProfile == CONDITION_DEVICE_TYPE_LIGHT) {
          _selectKeypressGroup.add(widget.entity, AUTO_CLICK, true, "1");
          _selectKeypressGroup.add(widget.entity, AUTO_DB_CLICK, false, "-2");
          _selectKeypressGroup.add(widget.entity, AUTO_LONG_PRESS, false, "-2");
        } else {
          _selectKeypressGroup.add(widget.entity, AUTO_CLICK, true, "1");
          _selectKeypressGroup.add(widget.entity, AUTO_DB_CLICK, false, "-2");
        }
      } else if (widget.cond.keypress.pressedTimes >= 2) {
        radiovalue = 1;
        if (widget.deviceProfile == CONDITION_DEVICE_TYPE_BUTTON ||
            widget.deviceProfile == CONDITION_DEVICE_TYPE_LIGHT) {
          _selectKeypressGroup.add(widget.entity, AUTO_CLICK, true, "-2");
          _selectKeypressGroup.add(widget.entity, AUTO_DB_CLICK, false,
              widget.cond.keypress.pressedTimes.toString());
          _selectKeypressGroup.add(widget.entity, AUTO_LONG_PRESS, false, "-2");
        } else {
          _selectKeypressGroup.add(widget.entity, AUTO_CLICK, true, "-2");
          _selectKeypressGroup.add(widget.entity, AUTO_DB_CLICK, false,
              widget.cond.keypress.pressedTimes.toString());
        }
      } else {
        radiovalue = 2;
        if (widget.deviceProfile == CONDITION_DEVICE_TYPE_BUTTON ||
            widget.deviceProfile == CONDITION_DEVICE_TYPE_LIGHT) {
          _selectKeypressGroup.add(widget.entity, AUTO_CLICK, true, "-2");
          _selectKeypressGroup.add(widget.entity, AUTO_DB_CLICK, false, "-2");
          _selectKeypressGroup.add(widget.entity, AUTO_LONG_PRESS, false,
              widget.cond.longPress.pressedSeconds.toString());
        }
      }
    } else {
      if (widget.deviceProfile == CONDITION_DEVICE_TYPE_BUTTON ||
          widget.deviceProfile == CONDITION_DEVICE_TYPE_LIGHT) {
        _selectKeypressGroup.add(widget.entity, AUTO_CLICK, true, "-2");
        _selectKeypressGroup.add(widget.entity, AUTO_DB_CLICK, false, "-2");
        _selectKeypressGroup.add(widget.entity, AUTO_LONG_PRESS, false, "-2");
      } else {
        _selectKeypressGroup.add(widget.entity, AUTO_CLICK, true, "-2");
        _selectKeypressGroup.add(widget.entity, AUTO_DB_CLICK, false, "-2");
      }
    }
  }

  void attributeIDPassItem() {
    //双侧
    LogicDevice lg = widget.entity as LogicDevice;
    if (widget.cond != null && widget.cond.hasSequenced()) {
      var speed = "";
      if (widget.cond.sequenced.conditions[1].checkMS == SPEED_LOW) {
        speed = DefinedLocalizations.of(null).lowSpeed;
      } else if (widget.cond.sequenced.conditions[1].checkMS ==
          SPEED_INTERMEDIATE) {
        speed = DefinedLocalizations.of(null).intermediateSpeed;
      } else if (widget.cond.sequenced.conditions[1].checkMS == SPEED_QUICK) {
        speed = DefinedLocalizations.of(null).quickSpeed;
      }
      if (widget.cond.sequenced.conditions[0].innerCondition.attributeVariation
              .attrID.value ==
          23) {
        radiovalue = 0;
        _deviceDetailsGroup.add(
            lg, DIRECTION_LEFT_TO_RIGHT, Int64(0), false, ' ', false);
        _deviceDetailsGroup.add(
            lg, DIRECTION_RIGHT_TO_LEFT, Int64(0), false, ' ', false);
        _selectDeviceDetailsGroup.add(
            lg, TYPE_TRAVELING_SPEED, "0", 0, false, speed);
      } else {
        radiovalue = 1;
        _deviceDetailsGroup.add(
            lg, DIRECTION_LEFT_TO_RIGHT, Int64(0), false, ' ', false);
        _deviceDetailsGroup.add(
            lg, DIRECTION_RIGHT_TO_LEFT, Int64(0), false, ' ', false);
        _selectDeviceDetailsGroup.add(
            lg, TYPE_TRAVELING_SPEED, "0", 0, false, speed);
      }
    } else {
      _deviceDetailsGroup.add(
          lg, DIRECTION_LEFT_TO_RIGHT, Int64(0), false, ' ', false);
      _deviceDetailsGroup.add(
          lg, DIRECTION_RIGHT_TO_LEFT, Int64(0), false, ' ', false);
      _selectDeviceDetailsGroup.add(
          lg, TYPE_TRAVELING_SPEED, "0", 0, false, " ");
    }
  }

  void attrIDOccupancy(type) {
    //左侧右侧
    LogicDevice lg = widget.entity as LogicDevice;
    if (widget.cond != null &&
        widget.cond.hasAttributeVariation() &&
        type == widget.cond.attributeVariation.attrID.value) {
      setRadioValue(
          widget.stateType == TYPE_CONDITION_CHILD_BODY_LEFT ? 23 : 24);
      int keepTimeMS = widget.cond.attributeVariation.keepTimeMS.toInt();
      if (widget.cond.attributeVariation.targetRange.end == 0) {
        // radiovalue = 1;
        _deviceDetailsGroup.add(
            lg, HAS_PEOPLE_ACTION, Int64(0), true, ' ', false);
        _deviceDetailsGroup.add(
            lg,
            NO_PEOPLE_ACTION,
            widget.cond.attributeVariation.keepTimeMS,
            true,
            getFirstTime(widget.cond.attributeVariation.attrID.value),
            true);
      } else if (widget.cond.attributeVariation.targetRange.end == 1) {
        // radiovalue = 0;
        _deviceDetailsGroup.add(
            lg,
            HAS_PEOPLE_ACTION,
            widget.cond.attributeVariation.keepTimeMS,
            true,
            getFirstTime(widget.cond.attributeVariation.attrID.value),
            true);
        _deviceDetailsGroup.add(
            lg, NO_PEOPLE_ACTION, Int64(0), true, ' ', false);
      }
    } else {
      _deviceDetailsGroup.add(
          lg, HAS_PEOPLE_ACTION, Int64(0), true, ' ', false);
      _deviceDetailsGroup.add(lg, NO_PEOPLE_ACTION, Int64(0), true, ' ', false);
    }
  }

  String getFirstTime(int type) {
    if (widget.cond == null) return DefinedLocalizations.of(null).immediate;
    var attrValue;
    var keepTime;
    if (widget.cond.hasAttributeVariation()) {
      attrValue = widget.cond.attributeVariation.attrID.value;
      keepTime = widget.cond.attributeVariation.keepTimeMS;
    } else if (widget.cond.hasComposed()) {
      if (widget.cond.composed.conditions[0].hasAttributeVariation()) {
        attrValue =
            widget.cond.composed.conditions[0].attributeVariation.attrID.value;
        keepTime =
            widget.cond.composed.conditions[0].attributeVariation.keepTimeMS;
      }
    }
    if (type != attrValue) return DefinedLocalizations.of(null).immediate;
    var timeStr = "";

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
    if (hour > 0) {
      timeStr += hour.toString() + DefinedLocalizations.of(null).hour + " ";
    }
    if (min > 0) {
      timeStr += min.toString() + DefinedLocalizations.of(null).minute + " ";
    }
    if (sec > 0) {
      timeStr += sec.toString() + DefinedLocalizations.of(null).second + " ";
    }
    return timeStr;
  }

  void setRadioValue(int type) {
    print(widget.automation.auto);
    print(widget.cond);
    if (widget.cond == null) return;
    if (widget.automation.getConditionAt(COND_COUNT) == null) return;
    if (widget.automation.getConditionAt(COND_COUNT).hasAttributeVariation()) {
      if (type !=
          widget.automation
              .getConditionAt(COND_COUNT)
              .attributeVariation
              .attrID
              .value) return;
      if (type == 16) {
        if (widget.cond.attributeVariation.targetRange.begin == 1) {
          radiovalue = 0;
        } else if (widget.cond.attributeVariation.targetRange.begin == 2) {
          radiovalue = 1;
        }
      } else {
        if (widget.cond.attributeVariation.targetRange.begin == 0) {
          radiovalue = 1;
        } else if (widget.cond.attributeVariation.targetRange.begin == 1) {
          radiovalue = 0;
        }
      }
    } else if (widget.cond.hasComposed()) {
      if (widget.cond.composed.conditions[0].hasAttributeVariation()) {
        var comZeroTB = widget
            .cond.composed.conditions[0].attributeVariation.targetRange.begin;
        if (type == 16) {
          if (comZeroTB == 1 || comZeroTB == 2) {
            radiovalue = 2;
          } else if (comZeroTB == 0 || comZeroTB == 4) {
            radiovalue = 3;
          }
        }
      } else if (widget.cond.composed.conditions[0].hasAngular()) {
        radiovalue = 2;
      }
    } else if (widget.cond.hasAngular()) {
      if (widget.cond.angular.angleRange.end > 0) {
        radiovalue = 2;
      } else if (widget.cond.angular.angleRange.end == 0) {
        if (widget.cond.angular.angleRange.begin < -214748) {
          radiovalue = 2;
        } else {
          radiovalue = 1;
        }
      } else {
        radiovalue = 1;
      }
    }
  }

  Int64 getFirstInt64Time(int type) {
    if (widget.cond == null) return null;
    var attrValue;
    var keepTime;
    if (widget.cond.hasAttributeVariation()) {
      attrValue = widget.cond.attributeVariation.attrID.value;
      keepTime = widget.cond.attributeVariation.keepTimeMS;
    } else if (widget.cond.hasComposed()) {
      if (widget.cond.composed.conditions[0].hasAttributeVariation()) {
        attrValue =
            widget.cond.composed.conditions[0].attributeVariation.attrID.value;
        keepTime =
            widget.cond.composed.conditions[0].attributeVariation.keepTimeMS;
      }
    }
    if (type != attrValue) return null;
    return keepTime;
  }

  void _resetData() {
    print("------------------AutoConditionRadioTypePage.dart");
    print(widget.stateType);
    print(widget.automation.auto);
    selectOptions = [
      DefinedLocalizations.of(null).lowSpeed,
      DefinedLocalizations.of(null).intermediateSpeed,
      DefinedLocalizations.of(null).quickSpeed
    ];
    LogicDevice lg = widget.entity as LogicDevice;
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.stateType == TYPE_CONDITION_KEYPRESS) {
      keypressItem();
    } else if (widget.stateType == TYPE_CONDITION_CHILD_BODY_DOUBLE) {
      attributeIDPassItem();
    } else if (widget.stateType == TYPE_CONDITION_CHILD_BODY_LEFT ||
        widget.stateType == TYPE_CONDITION_CHILD_BODY_RIGHT) {
      attrIDOccupancy(
          widget.stateType == TYPE_CONDITION_CHILD_BODY_LEFT ? 23 : 24);
    } else if (widget.stateType == TYPE_CONDITION_ONOFF) {
      //（打开关闭）
      if (widget.cond != null &&
          widget.cond.hasAttributeVariation() &&
          ATTRIBUTE_ID_ON_OFF_STATUS ==
              widget.cond.attributeVariation.attrID.value) {
        widget.cond.attributeVariation.targetRange.end == 1
            ? radiovalue = 0
            : radiovalue = 1;
      }
      _selectGroup.add(widget.entity, AUTO_OPEN, true, "-1");
      _selectGroup.add(widget.entity, AUTO_CLOSE, false, "-1");
      _selsectNextGroup.add(
          widget.entity,
          SETTING_TIME,
          4,
          getFirstInt64Time(widget.stateType == TYPE_CONDITION_ACTION ? 7 : 0),
          getFirstTime(widget.stateType == TYPE_CONDITION_ACTION ? 7 : 0), []);
    } else if (widget.stateType == TYPE_CONDITION_ACTION) {
      //门磁开合（打开关闭）
      if (widget.cond != null &&
          widget.cond.hasAttributeVariation() &&
          ATTRIBUTE_ID_BINARY_INPUT_STATUS ==
              widget.cond.attributeVariation.attrID.value) {
        widget.cond.attributeVariation.targetRange.end == 1
            ? radiovalue = 1
            : radiovalue = 0;
      }
      _selectGroup.add(widget.entity, AUTO_CLOSE, true, "-1");
      _selectGroup.add(widget.entity, AUTO_OPEN, false, "-1");
      _selsectNextGroup.add(
          widget.entity,
          SETTING_TIME,
          4,
          getFirstInt64Time(widget.stateType == TYPE_CONDITION_ACTION ? 7 : 0),
          getFirstTime(widget.stateType == TYPE_CONDITION_ACTION ? 7 : 0), []);
    } else if (widget.stateType == TYPE_CONDITION_CURTAIN_EXERCISE) {
      //窗帘的运动状态
      setRadioValue(16);
      _selectGroup.add(widget.entity, AUTO_OPENING, true, "-1");
      _selectGroup.add(widget.entity, AUTO_CLOSEING, false, "-1");
      _selectGroup.add(widget.entity, AUTO_OPENING_OR_CLOSEING, false, "-1");
      _selectGroup.add(widget.entity, AUTO_STACK, false, "-1");
      _selsectNextGroup.add(widget.entity, SETTING_TIME, 4,
          getFirstInt64Time(16), getFirstTime(16), []);
    } else if (widget.stateType == TYPE_CONDITION_CHILD_ROTATION_TYPE) {
      //旋钮的左旋右旋
      setRadioValue(16);

      _selectGroup.add(widget.entity, AUTO_LEFT_ROTATE, true, "-1");
      _selectGroup.add(widget.entity, AUTO_RIGHT_ROTATE, false, "-1");
      _selectGroup.add(widget.entity, AUTO_LEFT_RO_RIGHT_ROTATE, false, "-1");
    }
    _group.add(_selectGroup);
    _group.add(_deviceDetailsGroup);
    _group.add(_selsectNextGroup);
    _group.add(_selectDeviceDetailsGroup);
    _group.add(_selectKeypressGroup);
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
    // _subscription = RxBus()
    //     .toObservable()
    //     .where((event) => event is EventSink)
    //     .listen((event) {
    //   // if (event is CharacteristicVaulueUpdatedEvent) {
    // setState(() {}); //刷新界面 相当于setData
    //   // } else {
    //   //   _resetData();
    //   // }
    // });
  }

  pickerTem(
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
        onSelect: (picker, index, selecteds) {
          _selectNextCondition.temSelect = picker.adapter.getSelectedValues();
        },
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
          if (widget.stateType == TYPE_CONDITION_TOTAL_POWER) {
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

  String getSelectValue(
      _SelectNextCondition _selectNextCondition, String unit) {
    //获取温度的显示值
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

  int _itemCount() =>
      _selectGroup.size() +
      _selsectNextGroup.size() +
      _deviceDetailsGroup.size() +
      _selectDeviceDetailsGroup.size() +
      _selectKeypressGroup.size();
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

  void selected(val) {
    setState(() {
      radiovalue = val;
    });
  }

  void settingSelect(int index) {
    for (var i = 0; i < _itemCount(); i++) {
      final obj = _getItem(i);
      if (obj is _SelectCondition) {
        if (index == i) {
          obj.selected = true;
        } else {
          obj.selected = false;
        }
      } else if (obj is _DeviceDetailsCondition) {
        if (index == i) {
          obj.selected = true;
        } else {
          obj.selected = false;
        }
      }
    }
  }

  int getSpeed() {
    for (var i = 0; i < _itemCount(); i++) {
      final Object obj = _getItem(i);
      if (obj is _DeviceDetailsCondition) {
        continue;
      } else if (obj is _SelectDeviceDetailsCondition) {
        if (obj.selectValue == DefinedLocalizations.of(null).lowSpeed) {
          return SPEED_LOW;
        } else if (obj.selectValue ==
            DefinedLocalizations.of(null).intermediateSpeed) {
          return SPEED_INTERMEDIATE;
        } else if (obj.selectValue ==
            DefinedLocalizations.of(null).quickSpeed) {
          return SPEED_QUICK;
        }
      } else {
        print("的基督教的基督教");
      }
    }
    return SPEED_INTERMEDIATE;
  }

  int walkingDirection() {
    for (var i = 0; i < _group.length; i++) {
      final Object obj = _getItem(i);
      if (obj is _DeviceDetailsCondition) {
        if (radiovalue == -1) {
          return -1;
        }
        if (i == radiovalue) {
          return i;
        }
      } else if (obj is _SelectDeviceDetailsCondition) {
        continue;
      } else if (obj is _SelectCondition) {
        if (radiovalue == -1) {
          return -1;
        }
        if (i == radiovalue) {
          return i;
        }
      } else if (obj is _SelectNextCondition) {
        if (obj.uiValue == "") {
          return -1;
        } else {
          return i;
        }
      } else if (obj is _SelectKeypressCondition) {
        if (radiovalue == -1) {
          return -1;
        }
        if (i == radiovalue) {
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
  }

  protobuf.SequencedCondition setTimeLimitCondition() {
    var attrCL = protobuf.AttributeVariationCondition.create();
    var attrCR = protobuf.AttributeVariationCondition.create();
    var conditionL = protobuf.Condition.create();
    var conditionR = protobuf.Condition.create();
    var timeLCL = protobuf.TimeLimitCondition.create();
    var timeLCR = protobuf.TimeLimitCondition.create();
    var seqC = protobuf.SequencedCondition.create();
    if (walkingDirection() == -1) {
      return null;
    } else if (walkingDirection() == 0) {
      //从左到右
      timeLCL.delayMS = 0;
      timeLCL.checkMS = 2147483647;
      attrCL.attrID = pbConst.AttributeID.AttrIDOccupancyLeft;
      attrCL.uUID = widget.entity.uuid;
      attrCL.keepTimeMS = Int64(0);
      attrCL.needCapture = true;
      var srcRangeL = protobuf.Range.create();
      var tarRangeL = protobuf.Range.create();
      srcRangeL.begin = 0;
      srcRangeL.end = 0;
      tarRangeL.begin = 1;
      tarRangeL.end = 1;
      attrCL.sourceRange = srcRangeL;
      attrCL.targetRange = tarRangeL;
      attrCR.attrID = pbConst.AttributeID.AttrIDOccupancyRight;
      attrCR.uUID = widget.entity.uuid;
      attrCR.keepTimeMS = Int64(0);
      attrCR.needCapture = true;
      var srcRangeR = protobuf.Range.create();
      var tarRangeR = protobuf.Range.create();
      srcRangeR.begin = 0;
      srcRangeR.end = 0;
      tarRangeR.begin = 1;
      tarRangeR.end = 1;
      attrCR.sourceRange = srcRangeR;
      attrCR.targetRange = tarRangeR;
      timeLCR.delayMS = 100;
      timeLCR.checkMS = getSpeed();
      conditionL.attributeVariation = attrCL;
      conditionR.attributeVariation = attrCR;
      timeLCL.innerCondition = conditionL;
      timeLCR.innerCondition = conditionR;
      seqC.conditions.add(timeLCL);
      seqC.conditions.add(timeLCR);
      return seqC;
    } else if (walkingDirection() == 1) {
      //从右到左
      timeLCL.delayMS = 100;
      timeLCL.checkMS = getSpeed();
      timeLCR.delayMS = 0;
      timeLCR.checkMS = 2147483647;
      attrCL.attrID = pbConst.AttributeID.AttrIDOccupancyLeft;
      attrCL.uUID = widget.entity.uuid;
      attrCL.keepTimeMS = Int64(0);
      attrCL.needCapture = true;
      var srcRangeL = protobuf.Range.create();
      var tarRangeL = protobuf.Range.create();
      srcRangeL.begin = 0;
      srcRangeL.end = 0;
      tarRangeL.begin = 1;
      tarRangeL.end = 1;
      attrCL.sourceRange = srcRangeL;
      attrCL.targetRange = tarRangeL;
      attrCR.attrID = pbConst.AttributeID.AttrIDOccupancyRight;
      attrCR.uUID = widget.entity.uuid;
      attrCR.keepTimeMS = Int64(0);
      attrCR.needCapture = true;
      var srcRangeR = protobuf.Range.create();
      var tarRangeR = protobuf.Range.create();
      srcRangeR.begin = 0;
      srcRangeR.end = 0;
      tarRangeR.begin = 1;
      tarRangeR.end = 1;
      attrCR.sourceRange = srcRangeR;
      attrCR.targetRange = tarRangeR;
      conditionL.attributeVariation = attrCL;
      conditionR.attributeVariation = attrCR;
      timeLCL.innerCondition = conditionL;
      timeLCR.innerCondition = conditionR;
      seqC.conditions.add(timeLCR);
      seqC.conditions.add(timeLCL);
      return seqC;
    }
    return null;
  }

  void pickerTime(BuildContext context, ui) {
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
          if (ui is _SelectNextCondition) {
            ui.durationTime =
                Int64((value[0] * 60 * 60 + value[1] * 60 + value[2]) * 1000);
            getUiTime(value, ui);
          } else if (ui is _DeviceDetailsCondition) {
            ui.durationTime =
                Int64((value[0] * 60 * 60 + value[1] * 60 + value[2]) * 1000);
            if (value[0] > 0) {
              ui.uiTime = value[0].toString() +
                  DefinedLocalizations.of(context).hour +
                  value[1].toString() +
                  DefinedLocalizations.of(context).minute +
                  value[2].toString() +
                  DefinedLocalizations.of(context).second;
            } else if (value[1] > 0) {
              ui.uiTime = value[1].toString() +
                  DefinedLocalizations.of(context).minute +
                  value[2].toString() +
                  DefinedLocalizations.of(context).second;
            } else {
              ui.uiTime =
                  value[2].toString() + DefinedLocalizations.of(context).second;
            }
          }

          timeSelect = value;
          setState(() {});
        }).showDialogXy(context);
  }

  String _getSelectItem(int index) {
    for (var i = 0; i < selectOptions.length; i++) {
      if (index == i) {
        return selectOptions[i];
      }
    }
    return null;
  }

  Int64 getConditionTimeParameter() {
    for (var i = 0; i < _itemCount(); i++) {
      final obj = _getItem(i);
      if (widget.stateType == TYPE_CONDITION_BODY) {
        if (obj is _SelectCondition) {
          return obj.numerical == null
              ? Int64(0)
              : Int64(int.parse(obj.numerical));
        } else if (obj is _DeviceDetailsCondition) {
          return obj.durationTime == null ? Int64(0) : obj.durationTime;
        }
      } else if (obj is _SelectNextCondition &&
          obj.selectNumVal == SETTING_TIME) {
        return obj.durationTime == null ? Int64(0) : obj.durationTime;
      } else if (obj is _DeviceDetailsCondition && obj.selected == true) {
        print("目前显示的选的的按键的数据 只有这个333");
        print(obj.selected);
        print(obj.getLeftString(null));
        return obj.durationTime == null ? Int64(0) : obj.durationTime;
      }
    }
    return Int64(0);
  }

  protobuf.Range setSourceRange() {
    protobuf.Range sourceRange = protobuf.Range.create();
    for (var i = 0; i < _itemCount(); i++) {
      final obj = _getItem(i);
      if (obj is _DeviceDetailsCondition && obj.selected) {
        if (obj.deviceVal == HAS_PEOPLE_ACTION) {
          sourceRange.begin = 0;
          sourceRange.end = 0;
        } else if (obj.deviceVal == NO_PEOPLE_ACTION) {
          sourceRange.begin = 1;
          sourceRange.end = 1;
        }
        return sourceRange;
      } else if (obj is _SelectDeviceDetailsCondition) {
        return sourceRange;
      } else if (obj is _SelectKeypressCondition) {
        return sourceRange;
      } else if (obj is _SelectNextCondition) {
        return sourceRange;
      } else if (obj is _SelectCondition && obj.selected) {
        if (widget.stateType == TYPE_CONDITION_ACTION) {
          sourceRange.begin = -100;
          sourceRange.end = 100;
        } else {
          if (radiovalue == 0) {
            //关闭
            sourceRange.begin = 0;
            sourceRange.end = 0;
          } else if (radiovalue == 1) {
            //打开
            sourceRange.begin = 1;
            sourceRange.end = 1;
          } else if (radiovalue == 2 &&
              widget.stateType == TYPE_CONDITION_CURTIAN_ONOFF) {
            //正在打开或关闭
            sourceRange.begin = -2147483648;
            sourceRange.end = 2147483648;
          }
        }

        return sourceRange;
      }
    }
    return null;
  }

  protobuf.Range setTargetRange(int times) {
    protobuf.Range targetRange = protobuf.Range.create();
    for (var i = 0; i < _itemCount(); i++) {
      final obj = _getItem(i);
      if (obj is _DeviceDetailsCondition && obj.selected) {
        if (obj.deviceVal == HAS_PEOPLE_ACTION) {
          targetRange.begin = 1;
          targetRange.end = 1;
        } else if (obj.deviceVal == NO_PEOPLE_ACTION) {
          targetRange.begin = 0;
          targetRange.end = 0;
        }
        return targetRange;
      } else if (obj is _SelectCondition && obj.selected) {
        if (widget.stateType == TYPE_CONDITION_ACTION) {
          radiovalue == 0 ? targetRange.begin = 0 : targetRange.begin = 1;
          radiovalue == 0 ? targetRange.end = 0 : targetRange.end = 1;
        } else {
          if (radiovalue == 0) {
            //关闭
            targetRange.begin = 1;
            targetRange.end = 1;
          } else if (radiovalue == 1) {
            //打开
            targetRange.begin = 0;
            targetRange.end = 0;
          } else if (radiovalue == 2 &&
              widget.stateType == TYPE_CONDITION_CURTIAN_ONOFF) {
            //正在打开或关闭
            targetRange.begin = times;
            targetRange.end = times;
          } else if (radiovalue == 3 &&
              widget.stateType == TYPE_CONDITION_CURTIAN_ONOFF) {
            //正在打开或关闭
            targetRange.begin = times;
            targetRange.end = times;
          }
        }

        return targetRange;
      }
    }
    return null;
  }

  int getKeyTimes() {
    print(radiovalue);
    final obj = _getItem(radiovalue);
    if (obj is _SelectCondition && obj.selected == true) {
      return obj.numerical == null ? Int64(0) : int.parse(obj.numerical);
    } else if (obj is _SelectKeypressCondition && obj.selected == true) {
      return obj.numerical == "-2" ? 1 : int.parse(obj.numerical);
    }
    return 1;
  }

  void pickerTimes(BuildContext context, _Condition _condition, int index) {
    var numerical;
    if (_condition is _SelectCondition) {
      numerical = _condition.numerical;
    } else if (_condition is _SelectKeypressCondition) {
      numerical = _condition.numerical;
    }
    Picker(
        adapter: NumberPickerAdapter(
          data: [
            NumberPickerColumn(
                begin: index == 1 ? 2 : 1,
                end: 6,
                initValue: int.parse(numerical)),
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
                    index == 1
                        ? DefinedLocalizations.of(context).selectTime
                        : DefinedLocalizations.of(context).second,
                    style: TextStyle(
                      color: Color(0xffffffff),
                    ),
                  ),
                )),
            column: 2,
          ),
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
              column: 3),
        ],
        columnPadding: EdgeInsets.all(0.0),
        cancelText: DefinedLocalizations.of(context).cancel,
        cancelTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        confirmText: DefinedLocalizations.of(context).confirm,
        confirmTextStyle:
            TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff)),
        hideHeader: false,
        title: Text(index == 1
            ? DefinedLocalizations.of(context).selectTime
            : DefinedLocalizations.of(context).second),
        onConfirm: (Picker picker, List value) {
          if (_condition is _SelectCondition) {
            _condition.selected = true;
            _condition.numerical =
                picker.adapter.getSelectedValues()[0].toString();
          } else if (_condition is _SelectKeypressCondition) {
            _condition.selected = true;
            _condition.numerical =
                picker.adapter.getSelectedValues()[0].toString();
          }
          setState(() {});
        }).showDialogXy(context);
  }

  pbConst.AttributeID getAcAttrID() {
    switch (widget.stateType) {
      case TYPE_CONDITION_CHILD_BODY_LEFT:
        return pbConst.AttributeID.AttrIDOccupancyLeft;
        break;
      case TYPE_CONDITION_CHILD_BODY_RIGHT:
        return pbConst.AttributeID.AttrIDOccupancyRight;
        break;
      case TYPE_CONDITION_ACTION:
        return pbConst.AttributeID.AttrIDBinInputStatus;
        break;
      case TYPE_CONDITION_ONOFF:
        return pbConst.AttributeID.AttrIDOnOffStatus;
        break;
      case TYPE_CONDITION_CURTAIN_EXERCISE: //
        return pbConst.AttributeID.AttrIDWindowCoveringMotorStatus;
        break;
      default:
        return pbConst.AttributeID.AttrIDOccupancyLeft;
    }
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
                    msg: DefinedLocalizations.of(context).selectCond,
                    gravity: ToastGravity.BOTTOM);
                return null;
              }
              print("的基督教的大结局的");
              print(getConditionTimeParameter());
              if (widget.stateType == TYPE_CONDITION_KEYPRESS) {
                ConditionKeypress.conditionKeypressSet(widget.automation,
                    widget.entity.uuid, getKeyTimes(), widget.cond);
              } else if (widget.stateType ==
                  TYPE_CONDITION_CHILD_ROTATION_TYPE) {
                if (radiovalue == 0) {
                  ConditionAngular.conditionAngularSet(widget.automation,
                      widget.entity.uuid, -720, -720, widget.cond);
                } else if (radiovalue == 1) {
                  ConditionAngular.conditionAngularSet(widget.automation,
                      widget.entity.uuid, 720, 720, widget.cond);
                } else if (radiovalue == 2) {
                  ConditionAngular.conditionComAngularSet(
                      widget.automation, widget.entity.uuid, widget.cond);
                }
              } else if (widget.stateType == TYPE_CONDITION_CHILD_BODY_DOUBLE) {
                var sc = setTimeLimitCondition();
                if (widget.cond != null) {
                  widget.cond.clear();
                  widget.cond.sequenced = sc;
                  for (var condItem
                      in widget.automation.auto.cond.composed.conditions) {
                    if (condItem.hashCode == widget.cond.hashCode) {
                      condItem = widget.cond;
                    }
                  }
                } else if (sc != null) {
                  var newc = protobuf.Condition.create();
                  newc.sequenced = sc;
                  widget.automation.auto.cond.composed.conditions.add(newc);
                }
              } else if (widget.stateType == TYPE_CONDITION_CURTIAN_ONOFF &&
                  (radiovalue == 2 || radiovalue == 3)) {
                if (radiovalue == 2) {
                  //正在打开或关闭
                  protobuf.Condition cond1 =
                      ConditionAttributeVariation.conditionSequencedAttribute(
                          widget.automation,
                          widget.entity.uuid,
                          getAcAttrID(),
                          setSourceRange(),
                          setTargetRange(1),
                          getConditionTimeParameter(),
                          widget.cond);
                  protobuf.Condition cond2 =
                      ConditionAttributeVariation.conditionSequencedAttribute(
                          widget.automation,
                          widget.entity.uuid,
                          getAcAttrID(),
                          setSourceRange(),
                          setTargetRange(2),
                          getConditionTimeParameter(),
                          widget.cond);
                  ConditionSequenced.conditionSequencedSet(
                      widget.automation, cond1, widget.cond);
                  ConditionSequenced.conditionSequencedSet(
                      widget.automation, cond2, widget.cond);
                } else if (radiovalue == 3) {
                  //静止
                  protobuf.Condition cond0 =
                      ConditionAttributeVariation.conditionSequencedAttribute(
                          widget.automation,
                          widget.entity.uuid,
                          getAcAttrID(),
                          setSourceRange(),
                          setTargetRange(0),
                          getConditionTimeParameter(),
                          widget.cond);
                  protobuf.Condition cond4 =
                      ConditionAttributeVariation.conditionSequencedAttribute(
                          widget.automation,
                          widget.entity.uuid,
                          getAcAttrID(),
                          setSourceRange(),
                          setTargetRange(4),
                          getConditionTimeParameter(),
                          widget.cond);
                  ConditionSequenced.conditionSequencedSet(
                      widget.automation, cond0, widget.cond);
                  ConditionSequenced.conditionSequencedSet(
                      widget.automation, cond4, widget.cond);
                }
              } else {
                ConditionAttributeVariation.conditionAttributeVariationSet(
                    widget.automation,
                    widget.entity.uuid,
                    getAcAttrID(),
                    setSourceRange(),
                    setTargetRange(-1),
                    getConditionTimeParameter(),
                    widget.cond);
              }
              if (widget.stateType == TYPE_CONDITION_CHILD_ROTATION_TYPE) {
                Navigator.of(context).maybePop();
              } else {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName("/AutomationDetail"));
              }
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
          type: widget.stateType,
        ),
        Container(
            height: Adapt.px(1300),
            child: ListView.builder(
              itemCount: _itemCount(),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final Object obj = _getItem(index);
                if (obj is _SelectCondition) {
                  return _buildSelectCondition(context, obj, index);
                } else if (obj is _DeviceDetailsCondition) {
                  return _buildDeviceDetailsCondition(context, obj, index);
                } else if (obj is _SelectDeviceDetailsCondition) {
                  return _buildSelectDeviceDetailsCondition(
                      context, obj, index);
                } else if (obj is _SelectNextCondition) {
                  return _buildSelectNextCondition(context, obj);
                } else if (obj is _SelectKeypressCondition) {
                  return _buildSelectKeypressCondition(context, obj, index);
                }
                return Text("");
              },
            ))
      ],
    );
  }

  Widget _buildSelectKeypressCondition(BuildContext context,
      _SelectKeypressCondition _selectKeypressCondition, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Adapt.px(160),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: Color(0x33000000),
                    style: BorderStyle.solid))),
        margin: EdgeInsets.only(
            left: 10.0, right: index == radiovalue ? 10.0 : 15.0),
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: Adapt.px(45)),
                  width: Adapt.px(63),
                  height: Adapt.px(63),
                  alignment: Alignment.center,
                  child: Image(
                    width: index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                    height: index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                    image: AssetImage(index == radiovalue
                        ? "images/icon_check.png"
                        : 'images/icon_uncheck.png'),
                  ),
                ),
                Text(_selectKeypressCondition.getLeftString(context)),
              ],
            ),
            Offstage(
              offstage: index == 0,
              child: Row(
                children: <Widget>[
                  Offstage(
                    offstage: _selectKeypressCondition.numerical == "-2",
                    child: Container(
                      margin: EdgeInsets.only(right: Adapt.px(30)),
                      child: Text(_selectKeypressCondition.numerical +
                          (index == 1
                              ? DefinedLocalizations.of(context).selectTime
                              : DefinedLocalizations.of(context).second)),
                    ),
                  ),
                  Image(
                    width: Adapt.px(19),
                    height: Adapt.px(35),
                    image: AssetImage("images/icon_next.png"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        settingSelect(index);
        selected(index);
        if (_selectKeypressCondition.type == 1 ||
            _selectKeypressCondition.type == 8) {
          pickerTimes(context, _selectKeypressCondition, index);
        }
        setState(() {});
      },
    );
  }

  Widget _buildSelectDeviceDetailsCondition(BuildContext context,
      _SelectDeviceDetailsCondition _selectDeviceDetailsCondition, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: Adapt.px(160),
            margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 60.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: Color(0x33000000),
                        style: BorderStyle.solid))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_selectDeviceDetailsCondition.getLeftString(context)),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: Text(_selectDeviceDetailsCondition.selectValue),
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
            if (_selectDeviceDetailsCondition.selected) {
              _selectDeviceDetailsCondition.selected = false;
            } else {
              _selectDeviceDetailsCondition.selected = true;
            }
            setState(() {});
          },
        ),
        Offstage(
            offstage: !_selectDeviceDetailsCondition.selected,
            child: Container(
                height: 300.0,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: selectOptions.length,
                    itemBuilder: (BuildContext context, int optionItem) {
                      return _buildSpeedItem(
                          context,
                          _selectDeviceDetailsCondition,
                          _getSelectItem(optionItem),
                          optionItem);
                    })))
      ],
    );
  }

  Widget _buildSpeedItem(
      BuildContext context,
      _SelectDeviceDetailsCondition _selectDeviceDetailsCondition,
      String speedValue,
      int index) {
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
              Text(speedValue),
              Image(
                width: speedValue == _selectDeviceDetailsCondition.selectValue
                    ? Adapt.px(63)
                    : Adapt.px(31),
                height: speedValue == _selectDeviceDetailsCondition.selectValue
                    ? Adapt.px(63)
                    : Adapt.px(31),
                image: AssetImage(
                    speedValue == _selectDeviceDetailsCondition.selectValue
                        ? "images/icon_check.png"
                        : 'images/icon_uncheck.png'),
              ),
            ],
          )),
      onTap: () {
        _selectDeviceDetailsCondition.selectValue = _getSelectItem(index);
        setState(() {});
      },
    );
  }

  Widget _buildSelectCondition(
      BuildContext context, _SelectCondition _selectCondition, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Adapt.px(160),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: Color(0x33000000),
                    style: BorderStyle.solid))),
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Row(
            // children: <Widget>[

            Text(_selectCondition.getLeftString(context)),
            Container(
              // margin: EdgeInsets.only(right: Adapt.px(45)),
              width: Adapt.px(63),
              height: Adapt.px(63),
              alignment: Alignment.center,
              child: Image(
                width: index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                height: index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                image: AssetImage(index == radiovalue
                    ? "images/icon_check.png"
                    : 'images/icon_uncheck.png'),
              ),
            ),
            // ],
            // ),
            // Offstage(
            //   offstage: index == 1,
            //   child: Row(
            //     children: <Widget>[
            //       Offstage(
            //         offstage: _selectCondition.numerical == "-1",
            //         child: Container(
            //           margin: EdgeInsets.only(right: Adapt.px(30)),
            //           child: Text(_selectCondition.numerical +
            //               (index == 2 ? DefinedLocalizations.of(context).selectTime : DefinedLocalizations.of(context).second)),
            //         ),
            //       ),
            //       Image(
            //         width: Adapt.px(19),
            //         height: Adapt.px(35),
            //         image: AssetImage("images/icon_next.png"),
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
      onTap: () {
        settingSelect(index);
        selected(index);
        setState(() {});
      },
    );
  }

  Widget _buildDeviceDetailsCondition(BuildContext context,
      _DeviceDetailsCondition _deviceDetailsCondition, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            height: Adapt.px(160),
            margin: EdgeInsets.only(
                left: 10.0, right: index == radiovalue ? 10.0 : 15.0),
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: Color(0x33000000),
                        style: BorderStyle.solid))),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _deviceDetailsCondition.getLeftString(context),
                    style: TextStyle(
                        fontSize: Adapt.px(46), color: Color(0xff55585a)),
                  ),
                  Image(
                    width: index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                    height: index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                    image: AssetImage(index == radiovalue
                        ? "images/icon_check.png"
                        : 'images/icon_uncheck.png'),
                  ),
                ],
              ),
              onTap: () {
                selected(index);
                settingSelect(index);
                setState(() {});
              },
            )),
        Offstage(
          offstage: !_deviceDetailsCondition.showDurtime,
          child: Offstage(
            offstage: !(index == radiovalue),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: Adapt.px(160),
                margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
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
                      index == 0
                          ? DefinedLocalizations.of(context)
                              .autoSelectCheckPeopleTime
                          : DefinedLocalizations.of(context)
                              .autoSelectCheckNoPeopleTime,
                      style: TextStyle(
                          fontSize: Adapt.px(46), color: Color(0xff55585a)),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 8.0),
                          child: Text(
                            _deviceDetailsCondition.uiTime.toString(),
                            style: TextStyle(
                                fontSize: Adapt.px(46),
                                color: Color(0x732d3b46)),
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
                if (widget.deviceProfile == 0) {
                  pickerTime(context, _deviceDetailsCondition);
                }

                setState(() {});
              },
            ),
          ),
        )
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
        margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: Color(0x33000000),
                    style: BorderStyle.solid))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(_selectNextCondition.getLeftString(context)),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Offstage(
                      offstage: false,
                      child: Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: Text(_selectNextCondition.uiValue),
                      )),
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
        } else if (_selectNextCondition.detailsNum == 4) {
          pickerTime(context, _selectNextCondition);
        }
      },
    );
  }
}

class _Condition {} //各种body类型

class _SelectCondition extends _Condition {
  //按键
  final LogicDevice entity;
  bool selected;
  int type;
  String numerical;

  _SelectCondition(
      {@required this.entity,
      // @required this.selectNumVal,
      // @required this.selectNum,
      this.selected,
      this.type,
      this.numerical});

  String getLeftString(BuildContext context) {
    switch (type) {
      case AUTO_CLICK:
        return DefinedLocalizations.of(context).autoClick;
        break;
      case AUTO_DB_CLICK:
        return DefinedLocalizations.of(context).autoDblclick;
        break;
      case AUTO_OPEN:
        return DefinedLocalizations.of(context).open;
        break;
      case AUTO_CLOSE:
        return DefinedLocalizations.of(context).close;
        break;
      case AUTO_OPENING:
        return DefinedLocalizations.of(context).opening;
        break;
      case AUTO_CLOSEING:
        return DefinedLocalizations.of(context).closing;
        break;
      case AUTO_OPENING_OR_CLOSEING:
        return DefinedLocalizations.of(context).openingClosing;
        break;
      case AUTO_STACK:
        return DefinedLocalizations.of(context).fallAsleep;
        break;
      case AUTO_LONG_PRESS:
        return DefinedLocalizations.of(context).longPress;
        break;
      case AUTO_LEFT_ROTATE:
        return DefinedLocalizations.of(context).leftHanded;
        break;
      case AUTO_RIGHT_ROTATE:
        return DefinedLocalizations.of(context).rightHanded;
        break;
      case AUTO_LEFT_RO_RIGHT_ROTATE:
        return DefinedLocalizations.of(context).leftOrRight;
        break;
      default:
        return "default";
    }
  }
}

class _DeviceDetailsCondition extends _Condition {
  final LogicDevice logicDevice;
  final int deviceVal;
  Int64 durationTime;
  bool showDurtime;
  String uiTime;
  bool selected;
  _DeviceDetailsCondition(
      {@required this.logicDevice,
      @required this.deviceVal,
      this.durationTime,
      this.showDurtime,
      this.uiTime,
      this.selected});
  String getLeftString(BuildContext context) {
    switch (deviceVal) {
      case HAS_PEOPLE_ACTION:
        return DefinedLocalizations.of(context).hasPeopleAction;
        break;
      case NO_PEOPLE_ACTION:
        return DefinedLocalizations.of(context).noPeopleAction;
        break;
      case DIRECTION_LEFT_TO_RIGHT:
        return DefinedLocalizations.of(context).directionLeftToRight;
        break;
      case DIRECTION_RIGHT_TO_LEFT:
        return DefinedLocalizations.of(context).directionRightToLeft;
        break;
      default:
        return "default3";
    }
  }
}

class _SelectDeviceDetailsCondition extends _Condition {
  final LogicDevice logicDevice;
  final int selectNumVal;
  var direction;
  int speed;
  bool selected;
  String selectValue;
  _SelectDeviceDetailsCondition(
      {@required this.logicDevice,
      @required this.selectNumVal,
      this.direction,
      this.speed,
      this.selected,
      this.selectValue});
  String getLeftString(BuildContext context) {
    switch (selectNumVal) {
      case TYPE_TRAVELING_SPEED:
        return DefinedLocalizations.of(context).travelingSpeed;
        break;
      case TYPE_HAS_PEOPLE_ACTION:
        return DefinedLocalizations.of(context).hasPeopleAction;
        break;
      case TYPE_DIRECTION_LEFT_TO_RIGHT:
        return DefinedLocalizations.of(context).directionLeftToRight;
        break;
      case TYPE_DIRECTION_RIGHT_TO_LEFT:
        return DefinedLocalizations.of(context).directionRightToLeft;
        break;
      default:
        return "default1";
    }
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
        return DefinedLocalizations.of(context).locate;
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
        return "default4";
    }
  }
}

class _SelectKeypressCondition extends _Condition {
  //按键
  final LogicDevice entity;
  bool selected;
  int type;
  String numerical;

  _SelectKeypressCondition(
      {@required this.entity,
      // @required this.selectNumVal,
      // @required this.selectNum,
      this.selected,
      this.type,
      this.numerical});

  String getLeftString(BuildContext context) {
    switch (type) {
      case AUTO_CLICK:
        return DefinedLocalizations.of(context).autoClick;
        break;
      case AUTO_DB_CLICK:
        return DefinedLocalizations.of(context).autoDblclick;
        break;
      case AUTO_OPEN:
        return DefinedLocalizations.of(context).open;
        break;
      case AUTO_CLOSE:
        return DefinedLocalizations.of(context).close;
        break;
      case AUTO_OPENING:
        return DefinedLocalizations.of(context).opening;
        break;
      case AUTO_CLOSEING:
        return DefinedLocalizations.of(context).closing;
        break;
      case AUTO_OPENING_OR_CLOSEING:
        return DefinedLocalizations.of(context).openingClosing;
        break;
      case AUTO_STACK:
        return DefinedLocalizations.of(context).fallAsleep;
        break;
      case AUTO_LONG_PRESS:
        return DefinedLocalizations.of(context).longPress;
        break;
      case AUTO_LEFT_ROTATE:
        return DefinedLocalizations.of(context).leftHanded;
        break;
      case AUTO_RIGHT_ROTATE:
        return DefinedLocalizations.of(context).rightHanded;
        break;
      case AUTO_LEFT_RO_RIGHT_ROTATE:
        return DefinedLocalizations.of(context).leftOrRight;
        break;
      default:
        return " ";
    }
  }
}

class _Group {
  //需要一个group 盛放需要的列表
  int size() {
    return 0;
  }

  Object get(int index) {
    return Object();
  }
}

class _SelectGroup extends _Group {
  final List<_SelectCondition> _selectCondition = List();
  void add(Entity entity, int type, bool selected, String numerical) {
    _selectCondition.add(
      _SelectCondition(
          entity: entity,
          // selectNumVal: selectNumVal,
          // selectNum: detailsNum,
          selected: selected,
          type: type,
          numerical: numerical),
    );
  }

  void clear() {
    _selectCondition.clear();
  }

  int size() {
    return _selectCondition.length > 0 ? _selectCondition.length : 0;
  }

  Object get(int index) => _selectCondition[index];
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

class _DeviceDetailsGroup extends _Group {
  final List<_DeviceDetailsCondition> _deviceDetailsCondition = List();
  void add(LogicDevice logicDevice, int deviceVal, Int64 durationTime,
      bool showDurtime, String uiTime, bool selected) {
    _deviceDetailsCondition.add(
      _DeviceDetailsCondition(
          logicDevice: logicDevice,
          deviceVal: deviceVal,
          durationTime: durationTime,
          showDurtime: showDurtime,
          uiTime: uiTime,
          selected: selected),
    );
  }

  void clear() {
    _deviceDetailsCondition.clear();
  }

  int size() {
    return _deviceDetailsCondition.length > 0
        ? _deviceDetailsCondition.length
        : 0;
  }

  Object get(int index) => _deviceDetailsCondition[index];
}

class _SelectDeviceDetailsGroup extends _Group {
  final List<_SelectDeviceDetailsCondition> _selectDeviceDetailsCondition =
      List();
  void add(LogicDevice logicDevice, int selectNumVal, direction, int speed,
      bool selected, String selectValue) {
    _selectDeviceDetailsCondition.add(
      _SelectDeviceDetailsCondition(
          logicDevice: logicDevice,
          selectNumVal: selectNumVal,
          speed: speed,
          direction: direction,
          selected: selected,
          selectValue: selectValue),
    );
  }

  void clear() {
    _selectDeviceDetailsCondition.clear();
  }

  int size() {
    return _selectDeviceDetailsCondition.length > 0
        ? _selectDeviceDetailsCondition.length
        : 0;
  }

  Object get(int index) => _selectDeviceDetailsCondition[index];
}

class _SelectKeypressGroup extends _Group {
  final List<_SelectKeypressCondition> _selectCondition = List();
  void add(Entity entity, int type, bool selected, String numerical) {
    _selectCondition.add(
      _SelectKeypressCondition(
          entity: entity,
          // selectNumVal: selectNumVal,
          // selectNum: detailsNum,
          selected: selected,
          type: type,
          numerical: numerical),
    );
  }

  void clear() {
    _selectCondition.clear();
  }

  int size() {
    return _selectCondition.length > 0 ? _selectCondition.length : 0;
  }

  Object get(int index) => _selectCondition[index];
}
