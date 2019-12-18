// import 'package:fixnum/fixnum.dart';
import 'dart:convert';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xlive/utils/public_fun.dart';
import 'package:xlive/widget/auto_cond_device_header.dart';
import 'package:xlive/widget/xy_picker.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/page/PickerData.dart';
import 'package:xlive/page/auto_cond_set_condition_value_page.dart';
import 'package:xlive/page/auto_condition_radio_type_page.dart';
import 'package:xlive/protocol/const.pbenum.dart' as pbConst;
import 'common_page.dart';
import 'package:xlive/const/const_shared.dart';
import 'dart:async';
import 'dart:ui';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/localization/defined_localization.dart';
import 'package:flutter/src/widgets/navigator.dart';

class _OriginalAutomation {
  String _originalCondJson;
  String _originalExecJson;
  bool _originalEnable;
  String _originalName;
}

class AutoCondSelectDeviceSubCondition extends StatefulWidget {
  final int type;
  final Entity entity;
  final int deviceProfile;
  final Automation automation;
  final protobuf.Condition cond;

  AutoCondSelectDeviceSubCondition(
      {@required this.type,
      @required this.entity,
      @required this.deviceProfile,
      @required this.automation,
      this.cond});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoCondSelectDeviceSubConditionPage();
  }
}

class _AutoCondSelectDeviceSubConditionPage
    extends State<AutoCondSelectDeviceSubCondition> {
  final List<_Group> _group = List();
  _NextGroup _nextGroup = _NextGroup();
  StreamSubscription _subscription; //消息通道
  List temSelect = [0, 0, 0];
  List<int> _selecteds = [0, 0, 0];
  _OriginalAutomation _originalAutomation = _OriginalAutomation();
  void initState() {
    super.initState();
    _originalAutomation._originalCondJson =
        widget.automation.auto.cond.writeToJson();
    _originalAutomation._originalEnable = widget.automation.enable;
    _originalAutomation._originalExecJson =
        widget.automation.auto.exec.writeToJson();
    _originalAutomation._originalName = widget.automation.name;
    _resetData();
  }

  void _resetData() {
    print("--------------auto_cond_select_device_sub_condition_page.dart");
    _group.clear();
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.deviceProfile == CONDITION_DEVICE_TYPE_PIR) {
      _nextGroup.add(widget.entity, TYPE_CONDITION_BODY,
          TYPE_CONDITION_CHILD_BODY_LEFT, " "); //左侧
      _nextGroup.add(widget.entity, TYPE_CONDITION_BODY,
          TYPE_CONDITION_CHILD_BODY_RIGHT, " "); //右侧
      _nextGroup.add(widget.entity, TYPE_CONDITION_BODY,
          TYPE_CONDITION_CHILD_BODY_DOUBLE, " "); //双侧
    } else if (widget.deviceProfile == CONDITION_DEVICE_TYPE_SMART_DIAL) {
      _nextGroup.add(widget.entity, TYPE_CONDITION_ROTATION_ANGLE,
          TYPE_CONDITION_CHILD_ROTATION_TYPE, ""); //旋转方式
      _nextGroup.add(widget.entity, TYPE_CONDITION_ROTATION_ANGLE,
          TYPE_CONDITION_CHILD_RATATION_RANGE, ""); //旋转角度
      if (widget.cond != null &&
          (widget.cond.hasComposed() || widget.cond.hasAngular())) {
        var begin, end;
        if (widget.cond.hasComposed()) {
          begin = widget.cond.composed.conditions[1].angular.angleRange.begin;
          end = widget.cond.composed.conditions[1].angular.angleRange.end;
        } else {
          begin = widget.cond.angular.angleRange.begin;
          end = widget.cond.angular.angleRange.end;
        }
        if (begin < 0) {
          //左旋
          if (begin < -214748) {
            _selecteds = [1, end.abs() ~/ 12 - 1, 0];
          } else if (end == 0) {
            _selecteds = [0, 0, begin.abs() ~/ 12 - 1];
          } else {
            _selecteds = [
              2,
              end.abs() ~/ 12 - 1,
              (begin - end).abs() ~/ 12 - 1
            ];
          }
        } else if (begin >= 0) {
          if (begin == 0) {
            _selecteds = [0, 0, end.abs() ~/ 12 - 1];
          } else if (begin > 0 && end > 720) {
            _selecteds = [1, begin.abs() ~/ 12 - 1, 0];
          } else {
            _selecteds = [
              2,
              begin.abs() ~/ 12 - 1,
              (end.abs() - begin.abs()) ~/ 12 - 1
            ];
          }
        } else if (begin == 0 && end == 0) {
          _selecteds = [0, 0, 0];
        }
      } else {
        _selecteds = [0, 0, 0];
      }
    }
    _group.add(_nextGroup);
    setState(() {});
  }

  void dispose() {
    //页面卸载是执行的
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
    if (widget.automation.getConditionCount() <= COND_COUNT) {
      return;
    }
    if (widget.automation.getConditionAt(COND_COUNT).hasAngular()) {
      if (widget.automation
                  .getConditionAt(COND_COUNT)
                  .angular
                  .angleRange
                  .begin ==
              -720 ||
          widget.automation
                  .getConditionAt(COND_COUNT)
                  .angular
                  .angleRange
                  .begin ==
              720) {
        widget.automation.auto.cond.composed.clear();
      }
    } else if (widget.automation.getConditionAt(COND_COUNT).hasComposed()) {
      if (widget.automation
          .getConditionAt(COND_COUNT)
          .composed
          .conditions[0]
          .hasAngular()) {
        if (widget.automation
                    .getConditionAt(COND_COUNT)
                    .composed
                    .conditions[0]
                    .angular
                    .angleRange
                    .begin ==
                -720 ||
            widget.automation
                    .getConditionAt(COND_COUNT)
                    .composed
                    .conditions[0]
                    .angular
                    .angleRange
                    .begin ==
                720) {
          widget.automation.auto.cond.composed.clear();
        }
      }
    }
  }

  int _itemCount() => _nextGroup.size();
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

  void pickerAngle(BuildContext context, _NextCondition _nextCondition) {
    for (var item in _selecteds) {
      item < 0 ? item = 0 : item;
    }
    new Picker(
        adapter: PickerDataAdapter<String>(
            // pickerdata: new JsonDecoder().convert(PickerDataAngle),
            pickerdata: new JsonDecoder().convert(PickerDataAngle.replaceAll(
                    "@under", DefinedLocalizations.of(context).under)
                .replaceAll("@greaterThan",
                    DefinedLocalizations.of(context).greaterThan)
                .replaceAll(
                    "@between", DefinedLocalizations.of(context).between))),
        selecteds: _selecteds,
        onSelect: (picker, index, selected) {
          if (selected[0] == 0) {
            selected[1] == 0;
          }
          setState(() {
            _selecteds = selected;
          });
        },
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
                      "paddin",
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                  )),
              column: 0),
          PickerDelimiter(
              child: Container(
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
                      "°",
                      style: TextStyle(
                        color: Color(0x732d3b46),
                        fontSize: Adapt.px(35),
                      ),
                    ),
                  )),
              column: 3),
          PickerDelimiter(
              child: Container(
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
                      "°",
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
                      "paddi",
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
        title: Text(
          DefinedLocalizations.of(context).rotationAngle,
          style: TextStyle(fontSize: Adapt.px(50), color: Color(0x732d3b46)),
        ),
        onConfirm: (Picker picker, List value) {
          temSelect = picker.adapter.getSelectedValues();
          _selecteds = value;
          switch (value[0]) {
            case 0:
              _nextCondition.type = 2006;
              break;
            case 1:
              _nextCondition.type = 2007;
              break;
            case 2:
              _nextCondition.type = 2008;
              break;
            default:
          }
          _nextCondition.uiVal = getSelectValue();
          setState(() {});
        }).showDialogXy(context);
  }

  String getSelectValue() {
    String unit = DefinedLocalizations.of(context).centigrade;
    //获取温度的显示值d
    if (temSelect.length == 0) return " ";
    if (temSelect[0] == DefinedLocalizations.of(context).greaterThan) {
      return int.parse(temSelect[1]).toString() + unit;
    } else if (temSelect[0] == DefinedLocalizations.of(context).under) {
      return int.parse(temSelect[2]).toString() + unit;
    } else {
      return int.parse(temSelect[1]).toString() +
          "~" +
          int.parse(temSelect[2]).toString() +
          unit +
          DefinedLocalizations.of(context).among;
    }
  }

  void getItemPrice(BuildContext context, protobuf.Condition cond,
      Automation automation, _NextCondition _nextCondition) {
    if (automation.getConditionCount() <= 0) _nextCondition.uiVal = "";
    if (cond != null) {
      if (cond.hasAngular()) {
        var anbegin = cond.angular.angleRange.begin;
        var anend = cond.angular.angleRange.end;
        if (_nextCondition.type == TYPE_CONDITION_CHILD_ROTATION_TYPE) {
          if (anbegin >= 0) {
            _nextCondition.uiVal = DefinedLocalizations.of(context).rightHanded;
          } else if (anbegin < 0) {
            _nextCondition.uiVal = DefinedLocalizations.of(context).leftHanded;
          } else if (anbegin == 0 && anend == 0) {
            _nextCondition.uiVal = DefinedLocalizations.of(context).arbitrarily;
          }
        } else if (_nextCondition.type == TYPE_CONDITION_CHILD_RATATION_RANGE) {
          if (anbegin == 720 || anbegin == -720) {
            _nextCondition.uiVal = "";
            return;
          }
          if (anbegin < 0) {
            //左旋
            if (anbegin == -2147483648) {
              _nextCondition.uiVal =
                  DefinedLocalizations.of(context).greaterThan +
                      anend.abs().toString() +
                      DefinedLocalizations.of(context).centigrade;
            } else if (anend == 0) {
              _nextCondition.uiVal = DefinedLocalizations.of(context).under +
                  anbegin.abs().toString() +
                  DefinedLocalizations.of(context).centigrade;
            } else {
              _nextCondition.uiVal = DefinedLocalizations.of(context).locate +
                  anend.abs().toString() +
                  "~" +
                  anbegin.abs().toString() +
                  DefinedLocalizations.of(context).centigrade;
            }
          } else if (anbegin >= 0) {
            if (anbegin == 0) {
              _nextCondition.uiVal = DefinedLocalizations.of(context).under +
                  anend.abs().toString() +
                  DefinedLocalizations.of(context).centigrade;
            } else if (anbegin > 0 && anend > 720) {
              _nextCondition.uiVal =
                  DefinedLocalizations.of(context).greaterThan +
                      anbegin.abs().toString() +
                      DefinedLocalizations.of(context).centigrade;
            } else {
              _nextCondition.uiVal = DefinedLocalizations.of(context).locate +
                  anbegin.abs().toString() +
                  "~" +
                  anend.abs().toString() +
                  DefinedLocalizations.of(context).centigrade;
            }
          } else if (anbegin == 0 && anend == 0) {
            _nextCondition.uiVal = DefinedLocalizations.of(context).arbitrarily;
          }
        }
      } else if (cond.hasAttributeVariation()) {
        int attrValue = cond.attributeVariation.attrID.value;
        int sourceRange = cond.attributeVariation.sourceRange.begin;
        int targetRange = cond.attributeVariation.targetRange.begin;
        Int64 keepms = cond.attributeVariation.keepTimeMS;
        if (attrValue == ATTRIBUTE_ID_OCCUPANCY_LEFT &&
            _nextCondition.type == TYPE_CONDITION_CHILD_BODY_LEFT) {
          if (sourceRange > targetRange) {
            _nextCondition.uiVal =
                DefinedLocalizations.of(context).noMotionDetectedFor +
                    GetTimeStr.getTimeStr(context, keepms);
          } else {
            _nextCondition.uiVal =
                DefinedLocalizations.of(context).motionDetectedFor +
                    GetTimeStr.getTimeStr(context, keepms);
          }
        } else if (attrValue == ATTRIBUTE_ID_OCCUPANCY_RIGHT &&
            _nextCondition.type == TYPE_CONDITION_CHILD_BODY_RIGHT) {
          if (sourceRange > targetRange) {
            _nextCondition.uiVal =
                DefinedLocalizations.of(context).noMotionDetectedFor +
                    GetTimeStr.getTimeStr(context, keepms);
          } else {
            _nextCondition.uiVal =
                DefinedLocalizations.of(context).motionDetectedFor +
                    GetTimeStr.getTimeStr(context, keepms);
          }
        }
      } else if (cond.hasSequenced() &&
          _nextCondition.type == TYPE_CONDITION_CHILD_BODY_DOUBLE) {
        var attrid = cond
            .sequenced.conditions[0].innerCondition.attributeVariation.attrID;
        if (attrid == pbConst.AttributeID.AttrIDOccupancyRight) {
          _nextCondition.uiVal =
              DefinedLocalizations.of(context).motionDetectedFromRightToLeft;
        } else {
          _nextCondition.uiVal =
              DefinedLocalizations.of(context).motionDetectedFromLeftToRight;
        }
      } else if (cond.hasComposed()) {
        if (_nextCondition.type == TYPE_CONDITION_CHILD_ROTATION_TYPE) {
          _nextCondition.uiVal = DefinedLocalizations.of(context).leftOrRight;
        } else if (_nextCondition.type == TYPE_CONDITION_CHILD_RATATION_RANGE) {
          if (cond.composed.conditions[0].angular.angleRange.begin == 720 ||
              cond.composed.conditions[0].angular.angleRange.begin == -720) {
            _nextCondition.uiVal = "";
            return;
          }
          if (cond.composed.conditions[0].angular.angleRange.end == 0 &&
              cond.composed.conditions[1].angular.angleRange.begin == 0) {
            _nextCondition.uiVal = DefinedLocalizations.of(context).under +
                " " +
                cond.composed.conditions[0].angular.angleRange.begin
                    .abs()
                    .toString() +
                DefinedLocalizations.of(context).centigrade;
          } else if (cond.composed.conditions[0].angular.angleRange.begin ==
                  -214748364 &&
              cond.composed.conditions[1].angular.angleRange.end == 214748364) {
            _nextCondition.uiVal =
                DefinedLocalizations.of(context).greaterThan +
                    cond.composed.conditions[0].angular.angleRange.end
                        .abs()
                        .toString() +
                    DefinedLocalizations.of(context).centigrade;
          } else {
            _nextCondition.uiVal = DefinedLocalizations.of(context).locate +
                cond.composed.conditions[0].angular.angleRange.begin
                    .abs()
                    .toString() +
                "~" +
                cond.composed.conditions[0].angular.angleRange.end
                    .abs()
                    .toString() +
                DefinedLocalizations.of(context).centigrade +
                DefinedLocalizations.of(context).among;
          }
        }
      }
    } else {
      if (widget.automation.auto.cond.hasComposed()) {
        for (var cond in widget.automation.auto.cond.composed.conditions) {
          if (cond.hasAngular()) {
            if (_nextCondition.type == TYPE_CONDITION_CHILD_ROTATION_TYPE) {
              if (cond.angular.angleRange.begin >= 0) {
                _nextCondition.uiVal =
                    DefinedLocalizations.of(context).rightHanded;
              } else if (cond.angular.angleRange.begin < 0) {
                _nextCondition.uiVal =
                    DefinedLocalizations.of(context).leftHanded;
              } else if (cond.angular.angleRange.begin == 0 &&
                  cond.angular.angleRange.end == 0) {
                _nextCondition.uiVal =
                    DefinedLocalizations.of(context).arbitrarily;
              }
            } else if (_nextCondition.type ==
                TYPE_CONDITION_CHILD_RATATION_RANGE) {
              if (cond.angular.angleRange.begin == 720 ||
                  cond.angular.angleRange.begin == -720) {
                _nextCondition.uiVal = "";
                return;
              }
              if (cond.angular.angleRange.begin < 0 &&
                  cond.angular.angleRange.end < 0) {
                if (cond.angular.angleRange.begin == -2147483648) {
                  _nextCondition.uiVal =
                      DefinedLocalizations.of(context).greaterThan +
                          cond.angular.angleRange.end.abs().toString() +
                          DefinedLocalizations.of(context).centigrade;
                } else if (cond.angular.angleRange.end == 0) {
                  _nextCondition.uiVal =
                      DefinedLocalizations.of(context).under +
                          cond.angular.angleRange.begin.abs().toString() +
                          DefinedLocalizations.of(context).centigrade;
                } else {
                  _nextCondition.uiVal =
                      DefinedLocalizations.of(context).locate +
                          cond.angular.angleRange.begin.abs().toString() +
                          "~" +
                          cond.angular.angleRange.end.abs().toString() +
                          DefinedLocalizations.of(context).centigrade;
                }
              } else if (cond.angular.angleRange.begin >= 0 &&
                  cond.angular.angleRange.end >= 0) {
                if (cond.angular.angleRange.begin == 0) {
                  _nextCondition.uiVal =
                      DefinedLocalizations.of(context).under +
                          cond.angular.angleRange.end.abs().toString() +
                          DefinedLocalizations.of(context).centigrade;
                } else if (cond.angular.angleRange.begin > 0 &&
                    cond.angular.angleRange.end > 720) {
                  _nextCondition.uiVal =
                      DefinedLocalizations.of(context).greaterThan +
                          cond.angular.angleRange.begin.abs().toString() +
                          DefinedLocalizations.of(context).centigrade;
                } else {
                  _nextCondition.uiVal =
                      DefinedLocalizations.of(context).locate +
                          cond.angular.angleRange.begin.abs().toString() +
                          "~" +
                          cond.angular.angleRange.end.abs().toString() +
                          DefinedLocalizations.of(context).centigrade +
                          DefinedLocalizations.of(context).among;
                }
              } else if (cond.angular.angleRange.begin == 0 &&
                  cond.angular.angleRange.end == 0) {
                _nextCondition.uiVal =
                    DefinedLocalizations.of(context).arbitrarily;
              }
            }
          } else if (cond.hasComposed()) {
            if (_nextCondition.type == TYPE_CONDITION_CHILD_ROTATION_TYPE) {
              _nextCondition.uiVal =
                  DefinedLocalizations.of(context).leftOrRight;
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
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
            print(widget.automation.auto.cond);
            if (widget.automation.auto.cond.composed.conditions.length == 0) {
              print("conditions length 是 0 ！");
            } else {
              if (temSelect.toString() == _selecteds.toString()) {
                if (!widget.automation
                    .getConditionAt(COND_COUNT)
                    .hasAngular()) {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName("/AutomationDetail"));
                  return;
                }
                Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).pleaseSelectAngle,
                    gravity: ToastGravity.BOTTOM);
                return;
              }
              for (var item
                  in widget.automation.auto.cond.composed.conditions) {
                if (item.hasAngular()) {
                  var range = protobuf.Range.create();
                  if (item.angular.angleRange.begin == -720 ||
                      item.angular.angleRange.begin < 0) {
                    if (temSelect[1] == "--") {
                      //低于
                      range.begin = -int.parse(temSelect[2]);
                      range.end = 0;
                    } else if (temSelect[2] == "--") {
                      //高于
                      range.begin = -2147483648;
                      range.end = -int.parse(temSelect[1]);
                    } else {
                      range.begin = -int.parse(temSelect[2]);
                      range.end = -int.parse(temSelect[1]);
                    }
                  } else if (item.angular.angleRange.begin == 720 ||
                      item.angular.angleRange.begin >= 0) {
                    if (temSelect[1] == "--") {
                      //低于
                      range.begin = 0;
                      range.end = int.parse(temSelect[2]);
                    } else if (temSelect[2] == "--") {
                      //高于
                      range.begin = int.parse(temSelect[1]);
                      range.end = 214748364;
                    } else {
                      range.begin = int.parse(temSelect[1]);
                      range.end = int.parse(temSelect[2]);
                    }
                  }
                  item.angular.angleRange = range;
                  break;
                } else if (item.hasComposed()) {
                  var range1 = protobuf.Range.create();
                  var range2 = protobuf.Range.create();
                  if (temSelect[1] == "--") {
                    //低于
                    // var rangeValue = int.parse(int.parse(temSelect[2]));
                    range1.begin = -int.parse(temSelect[2]);
                    range1.end = 0;
                    range2.begin = 0;
                    range2.end = int.parse(temSelect[2]);
                  } else if (temSelect[2] == "--") {
                    //高于
                    range1.begin = -214748364;
                    range1.end = -int.parse(temSelect[1]);
                    range2.begin = int.parse(temSelect[1]);
                    range2.end = 214748364;
                  } else {
                    range1.begin = -int.parse(temSelect[2]);
                    range1.end = -int.parse(temSelect[1]);
                    range2.begin = int.parse(temSelect[1]);
                    range2.end = int.parse(temSelect[2]);
                  }
                  item.composed.operator = protobuf.ConditionOperator.OP_OR;
                  item.composed.conditions[0].angular.angleRange = range1;
                  item.composed.conditions[1].angular.angleRange = range2;
                }
              }
            }
            Navigator.of(context)
                .popUntil(ModalRoute.withName("/AutomationDetail"));
          },
        ),
        child: _buildSetting());
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
              itemBuilder: (BuildContext context, int index) {
                final Object obj = _getItem(index);
                if (obj is _NextCondition) {
                  return _buildNextCondition(context, obj);
                }
                return Text("");
              },
            ))
      ],
    );
  }

  Widget _buildNextCondition(
      BuildContext context, _NextCondition _nextCondition) {
    getItemPrice(context, widget.cond, widget.automation, _nextCondition);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Adapt.px(160),
        margin: EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(40)),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: Color(0x33000000),
                    style: BorderStyle.solid))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(_nextCondition.getLeftString(context),
                style: TEXT_STYLE_LINE_LEFT),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_nextCondition.uiVal, style: TEXT_STYLE_LINE_RIGHT),
                  Padding(
                    padding: EdgeInsets.only(right: Adapt.px(30)),
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
        if (_nextCondition.type <= TYPE_CONDITION_CHILD_ROTATION_TYPE) {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => AutoConditionRadioType(
                  stateType: _nextCondition.type,
                  entity: widget.entity,
                  deviceProfile: widget.deviceProfile,
                  automation: widget.automation,
                  cond: widget.cond),
              settings: RouteSettings(name: "/AutoConditionRadioType")));
        } else if (_nextCondition.type >= TYPE_CONDITION_CHILD_RATATION_RANGE) {
          pickerAngle(context, _nextCondition);
          setState(() {});
        } else {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => AutoCondSetConditionValue(
                    entity: widget.entity,
                    automation: widget.automation,
                    cond: widget.cond,
                    stateType: _nextCondition.type,
                    deviceProfile: widget.deviceProfile,
                  ),
              settings: RouteSettings(name: "/AutoCondSetConditionValue")));
        }
      },
    );
  }
}

class _Condition {} //各种body类型

class _NextCondition extends _Condition {
  //按键
  Entity entity;
  int devicetype;
  int type;
  String uiVal;
  _NextCondition({this.entity, this.devicetype, this.type, this.uiVal});

  String getLeftString(BuildContext context) {
    switch (type) {
      case 23:
        return DefinedLocalizations.of(context).pirDetectionLeft;
        break;
      case TYPE_CONDITION_CHILD_BODY_LEFT:
        return DefinedLocalizations.of(context).pirDetectionLeft;
        break;
      case 24:
        return DefinedLocalizations.of(context).pirDetectionRight;
        break;
      case TYPE_CONDITION_CHILD_BODY_RIGHT:
        return DefinedLocalizations.of(context).pirDetectionRight;
        break;
      case 1111:
        return DefinedLocalizations.of(context).pirDetectionBilateral;
        break;
      case TYPE_CONDITION_CHILD_BODY_DOUBLE:
        return DefinedLocalizations.of(context).pirDetectionBilateral;
        break;
      case TYPE_CONDITION_CHILD_ROTATION_TYPE:
        return DefinedLocalizations.of(context).rotatingWay;
        break;
      case TYPE_CONDITION_CHILD_RATATION_RANGE:
        return DefinedLocalizations.of(context).rotationAngle;
        break;
      case 2006:
        return DefinedLocalizations.of(context).under;
        break;
      case 2007:
        return DefinedLocalizations.of(context).greaterThan;
        break;
      case 2008:
        return DefinedLocalizations.of(context).locate;
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

class _NextGroup extends _Group {
  final List<_NextCondition> _nextCondition = List();
  void add(Entity entity, int devicetype, int type, String uiVal) {
    _nextCondition.add(
      _NextCondition(
          entity: entity,
          // selectName: selectName,
          devicetype: devicetype,
          type: type,
          uiVal: uiVal),
    );
  }

  void clear() {
    _nextCondition.clear();
  }

  int size() {
    return _nextCondition.length > 0 ? _nextCondition.length : 0;
  }

  Object get(int index) => _nextCondition[index];
}
