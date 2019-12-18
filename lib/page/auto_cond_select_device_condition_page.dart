import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/page/auto_cond_select_device_sub_condition_page.dart';
import 'package:xlive/page/auto_cond_set_condition_value_page.dart';
import 'package:xlive/utils/public_fun.dart';
import 'common_page.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'dart:async';
import 'dart:ui';
import 'package:xlive/page/auto_condition_radio_type_page.dart';
import 'package:xlive/widget/auto_cond_device_header.dart';

//带参数的类的实现方法 和上面一起的  下面的类_AutoMationPage要在怎么用呢 就是widgei.参数名 就行了
class AutoCondSelectDeviceCondition extends StatefulWidget {
  final Entity entity;
  final Automation automation;
  final protobuf.Condition cond;
  // final protobuf.protobuf.Condition condition;

  AutoCondSelectDeviceCondition({
    this.entity,
    this.automation,
    this.cond,
    // this.condition
  });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingDeviceConditionPage();
  }
}

class _SettingDeviceConditionPage extends State<AutoCondSelectDeviceCondition> {
  //这个一定要跟着一个build
  final List<_Group> _group = List();
  // _SettingHeaderGroup _settingHeaderGroup = _SettingHeaderGroup();
  _SettingFooterGroup _settingFooterGroup = _SettingFooterGroup();
  //创建一个自动化的列表
  StreamSubscription _subscription; //消息通道
  void initState() {
    super.initState();
    _resetData(); //onshow
  }

  void _awarenessSwitch(LogicDevice ld) {
    _settingFooterGroup.add(ld, TYPE_CONDITION_KEYPRESS, ""); //0
    _settingFooterGroup.add(ld, TYPE_CONDITION_BODY, "");
    _settingFooterGroup.add(ld, TYPE_CONDITION_TEMPERATURE, ""); //
    _settingFooterGroup.add(ld, TYPE_CONDITION_ILLUMINANCE, ""); //
  }

  void _doorContact(LogicDevice ld) {
    _settingFooterGroup.add(ld, TYPE_CONDITION_ACTION, "");
    _settingFooterGroup.add(ld, TYPE_CONDITION_TEMPERATURE, ""); //温度
  }

  void _smartPlug(LogicDevice ld) {
    //插座总能耗暂不支持！！！！！！！
    _settingFooterGroup.add(ld, TYPE_CONDITION_ONOFF, "");
    _settingFooterGroup.add(ld, TYPE_CONDITION_ACTIVE_POWER, "");
    // _settingFooterGroup.add(ld,   TYPE_CONDITION_TOTAL_POWER,"");
  }

  void _curtain(LogicDevice ld) {
    _settingFooterGroup.add(ld, TYPE_CONDITION_CURTIAN_ONOFF, "");
    _settingFooterGroup.add(ld, TYPE_CONDITION_CURTAIN_EXERCISE, "");
  }

  void _smartDial(LogicDevice ld) {
    _settingFooterGroup.add(ld, TYPE_CONDITION_ROTATION_ANGLE, "");
    _settingFooterGroup.add(ld, TYPE_CONDITION_KEYPRESS, "");
  }

  void _resetData() {
    print("---------auto_cond_select_device_condition_page.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.entity == null) {
      if (widget.cond.hasKeypress()) {
        widget.cond.keypress.pressedTimes == 1;
      }
    } else {
      if (widget.entity is PhysicDevice) {
        final PhysicDevice pd = widget.entity as PhysicDevice;
        if (pd.isWallSwitch) {}
      } else if (widget.entity is LogicDevice) {
        final LogicDevice ld = widget.entity as LogicDevice;
        if (ld.isAwarenessSwitch) {
          _awarenessSwitch(ld);
        } else if (ld.isDoorContact) {
          _doorContact(ld);
        } else if (ld.isSmartPlug) {
          _smartPlug(ld);
        } else if (ld.isCurtain) {
          _curtain(ld);
        } else if (ld.isSmartDial) {
          _smartDial(ld);
        }
      }
    }
    _group.add(_settingFooterGroup);
    setState(() {});
  }

  void dispose() {
    //页面卸载是执行的
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

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

  int judgeTypePage(int type) {
    if (type == TYPE_CONDITION_KEYPRESS ||
        type == TYPE_CONDITION_ACTION ||
        type == TYPE_CONDITION_ONOFF ||
        type == TYPE_CONDITION_CURTAIN_EXERCISE) {
      return RADIO_TYPE_PAGE;
    } else if (type == TYPE_CONDITION_TEMPERATURE ||
        type == TYPE_CONDITION_ILLUMINANCE ||
        type == TYPE_CONDITION_TOTAL_POWER ||
        type == TYPE_CONDITION_ACTIVE_POWER ||
        type == TYPE_CONDITION_CURTIAN_ONOFF) {
      return COND_VALUE_PAGE;
    }
    return SUB_COND_PAGE;
  }

  void setRangeString(BuildContext context, int begin, int end,
      _CondDeviceItem _condDeviceItem, String unit) {
    if (begin <= -21474836) {
      _condDeviceItem.itemResult =
          DefinedLocalizations.of(context).under + end.toString() + unit;
    } else if (end >= 21474836) {
      _condDeviceItem.itemResult =
          DefinedLocalizations.of(context).greaterThan +
              begin.toString() +
              unit;
    } else {
      _condDeviceItem.itemResult = DefinedLocalizations.of(context).locate +
          begin.toString() +
          " - " +
          end.toString() +
          unit +
          DefinedLocalizations.of(context).among;
    }
  }

  void setRangePowerString(BuildContext context, int begin, int end,
      _CondDeviceItem _condDeviceItem, String unit) {
    if (begin == 0) {
      _condDeviceItem.itemResult =
          DefinedLocalizations.of(context).under + end.toString() + unit;
      return;
    }
    _condDeviceItem.itemResult = DefinedLocalizations.of(context).locate +
        begin.toString() +
        " - " +
        end.toString() +
        unit +
        DefinedLocalizations.of(context).among;
  }

  void getItemPrice(BuildContext context, protobuf.Condition cond,
      Automation automation, _CondDeviceItem _condDeviceItem) {
    if (automation.getConditionCount() <= 0) _condDeviceItem.itemResult = "";
    if (cond != null) {
      if (cond.hasAngular() &&
          _condDeviceItem.type == TYPE_CONDITION_ROTATION_ANGLE) {
        var begin = cond.angular.angleRange.begin;
        var end = cond.angular.angleRange.end;
        if (cond.angular.angleRange.begin < 0) {
          //左旋
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).sinistrogyrationUntil +
                  AngularText.angularText(context, begin, end, "°");
        } else if (cond.angular.angleRange.begin >= 0) {
          //右旋
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).dextrorotationUntil +
                  AngularText.angularText(context, begin, end, "°");
        } else if (cond.angular.angleRange.begin == 0 &&
            cond.angular.angleRange.end == 0) {
          //任意角度
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).rotationAnyAngle;
        }
      } else if (cond.hasKeypress() &&
          _condDeviceItem.type == TYPE_CONDITION_KEYPRESS) {
        if (cond.keypress.pressedTimes == 1) {
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).autoClick;
        } else {
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).autoDblclick;
        }
      } else if (cond.hasAttributeVariation()) {
        int attrValue = cond.attributeVariation.attrID.value;
        if (attrValue == ATTRIBUTE_ID_OCCUPANCY_LEFT &&
            _condDeviceItem.type == TYPE_CONDITION_BODY) {
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).pirDetectionLeft;
        } else if (attrValue == ATTRIBUTE_ID_OCCUPANCY_RIGHT &&
            _condDeviceItem.type == TYPE_CONDITION_BODY) {
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).pirDetectionRight;
        } else if (attrValue == ATTRIBUTE_ID_ON_OFF_STATUS &&
            _condDeviceItem.type == TYPE_CONDITION_ONOFF) {
          if (cond.attributeVariation.targetRange.begin == 1) {
            _condDeviceItem.itemResult = DefinedLocalizations.of(context).open;
          } else {
            _condDeviceItem.itemResult = DefinedLocalizations.of(context).close;
          }
        } else if (attrValue == ATTRIBUTE_ID_BINARY_INPUT_STATUS &&
            _condDeviceItem.type == TYPE_CONDITION_ACTION) {
          if (cond.attributeVariation.targetRange.begin == 1) {
            _condDeviceItem.itemResult = DefinedLocalizations.of(context).open;
          } else {
            _condDeviceItem.itemResult = DefinedLocalizations.of(context).close;
          }
        } else if (attrValue == ATTRIBUTE_ID_TEMPERATURE &&
            _condDeviceItem.type == TYPE_CONDITION_TEMPERATURE) {
          int end = cond.attributeVariation.targetRange.end ~/ 10;
          int begin = cond.attributeVariation.targetRange.begin ~/ 10;
          setRangeString(context, begin, end, _condDeviceItem,
              DefinedLocalizations.of(context).degreeCentigrade);
        } else if (attrValue == ATTRIBUTE_ID_LUMINANCE &&
            _condDeviceItem.type == TYPE_CONDITION_ILLUMINANCE) {
          int end = cond.attributeVariation.targetRange.end;
          int begin = cond.attributeVariation.targetRange.begin;
          setRangeString(context, begin, end, _condDeviceItem, "lux");
        } else if (attrValue == ATTRIBUTE_ID_ACTIVE_POWER &&
            _condDeviceItem.type == TYPE_CONDITION_ACTIVE_POWER) {
          // _condDeviceItem.itemResult = "功率值";
          int end = cond.attributeVariation.targetRange.end ~/ 10;
          int begin = cond.attributeVariation.targetRange.begin ~/ 10;
          setRangePowerString(context, begin, end, _condDeviceItem, "W");
        } else if (attrValue == ATTRIBUTE_ID_TOTLE_POWER &&
            _condDeviceItem.type == TYPE_CONDITION_TOTAL_POWER) {
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).energyConsumptionValues;
        } else if (attrValue == ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION &&
            _condDeviceItem.type == TYPE_CONDITION_CURTIAN_ONOFF) {
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).openCloseStateValues;
        } else if (attrValue == ATTRIBUTE_ID_CURTAIN_STATUS &&
            _condDeviceItem.type == TYPE_CONDITION_CURTAIN_EXERCISE) {
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).exerciseStateValues;
        }
      } else if (cond.hasSequenced() &&
          _condDeviceItem.type == TYPE_CONDITION_BODY) {
        _condDeviceItem.itemResult =
            DefinedLocalizations.of(context).pirDetectionBilateral;
      } else if (widget.cond.hasWithinPeriod()) {
        _condDeviceItem.itemResult = "按键4";
      } else if (widget.cond.hasCalendar()) {
        _condDeviceItem.itemResult = "按键5";
      } else if (widget.cond.hasCalendarRange()) {
        _condDeviceItem.itemResult = "按键6";
      } else if (widget.cond.hasTimer()) {
        _condDeviceItem.itemResult = "按键7";
      } else if (widget.cond.hasComposed() &&
          _condDeviceItem.type == TYPE_CONDITION_CURTAIN_EXERCISE) {
        var begin = widget
            .cond.composed.conditions[0].attributeVariation.targetRange.begin;
        if (begin == 0 || begin == 4) {
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).fallAsleep;
        } else {
          _condDeviceItem.itemResult =
              DefinedLocalizations.of(context).openingClosing;
        }
      } else if (widget.cond.hasComposed() &&
          _condDeviceItem.type == TYPE_CONDITION_ROTATION_ANGLE) {
        _condDeviceItem.itemResult =
            DefinedLocalizations.of(context).leftOrRight;
      }
    }
  }

  int _itemCount() => _settingFooterGroup.size();
  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: widget.entity.getName(),
      showBackIcon: true,
      child: _buildSettingCondition(
        context,
      ),
    );
  }

  Widget _buildSettingCondition(BuildContext context) {
    return ListView(
      children: <Widget>[
        AutoCondDeviceHeader(
          entity: widget.entity,
        ),
        Container(
          height: Adapt.px(1300),
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: _itemCount(),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final Object obj = _getItem(index);
              if (obj is _CondDeviceItem) {
                return _buildFooter(context, obj);
              }
              return Text("");
            },
          ),
        )
      ],
    );
  }

  Widget _buildFooter(BuildContext context, _CondDeviceItem _condDeviceItem) {
    getItemPrice(context, widget.cond, widget.automation, _condDeviceItem);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Adapt.px(160),
        margin: EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(40)),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: Adapt.px(2),
                    color: Color(0x20000000),
                    style: BorderStyle.solid))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _condDeviceItem.getLeftString(context),
              style: TEXT_STYLE_LINE_LEFT,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_condDeviceItem.itemResult,
                        style: TEXT_STYLE_LINE_RIGHT),
                    Padding(padding: EdgeInsets.only(left: Adapt.px(23))),
                    Image(
                      width: Adapt.px(19),
                      height: Adapt.px(35),
                      image: AssetImage("images/icon_next.png"),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        if (judgeTypePage(_condDeviceItem.type) == SUB_COND_PAGE) {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => AutoCondSelectDeviceSubCondition(
                  type: _condDeviceItem.type,
                  entity: widget.entity,
                  deviceProfile: _condDeviceItem.footerLogicDevice.profile,
                  automation: widget.automation,
                  cond: widget.cond),
              settings:
                  RouteSettings(name: "/AutoCondSelectDeviceSubCondition")));
        } else if (judgeTypePage(_condDeviceItem.type) == RADIO_TYPE_PAGE) {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => AutoConditionRadioType(
                  stateType: _condDeviceItem.type,
                  entity: widget.entity,
                  deviceProfile: _condDeviceItem.footerLogicDevice.profile,
                  automation: widget.automation,
                  cond: widget.cond),
              settings: RouteSettings(name: "/AutoConditionRadioType")));
        } else {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => AutoCondSetConditionValue(
                  stateType: _condDeviceItem.type,
                  entity: widget.entity,
                  deviceProfile: _condDeviceItem.footerLogicDevice.profile,
                  automation: widget.automation,
                  cond: widget.cond),
              settings: RouteSettings(name: "/AutoCondSetConditionValue")));
        }
      },
    );
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

class _SettingFooterGroup extends _Group {
  final List<_CondDeviceItem> _condDeviceItem = List();
  void add(LogicDevice logicDevice, int type, String itemResult) {
    _condDeviceItem.add(
      _CondDeviceItem(
          footerLogicDevice: logicDevice,
          // leftString: leftString,
          type: type,
          itemResult: itemResult),
    );
  }

  void clear() {
    _condDeviceItem.clear();
  }

  int size() {
    return _condDeviceItem.length > 0 ? _condDeviceItem.length : 0;
  }

  Object get(int index) => _condDeviceItem[index];
}

class _CondDeviceItem {
  final LogicDevice footerLogicDevice;
  int type;
  String itemResult;
  _CondDeviceItem(
      {@required this.footerLogicDevice, this.type, this.itemResult});
  String getLeftString(BuildContext context) {
    switch (type) {
      case TYPE_CONDITION_KEYPRESS:
        return DefinedLocalizations.of(context).keypress;
        break;
      case TYPE_CONDITION_BODY:
        return DefinedLocalizations.of(context).pirDetectionBody;
        break;
      case TYPE_CONDITION_TEMPERATURE:
        return DefinedLocalizations.of(context).temperature;
        break;
      case TYPE_CONDITION_ILLUMINANCE:
        return DefinedLocalizations.of(context).illuminance;
        break;
      case TYPE_CONDITION_ACTION:
        return DefinedLocalizations.of(context).openingClosingAction;
        break;
      case TYPE_CONDITION_ONOFF:
        return DefinedLocalizations.of(context).powerState;
        break;
      case TYPE_CONDITION_TOTAL_POWER:
        return DefinedLocalizations.of(context).totalEnergyConsumption;
        break;
      case TYPE_CONDITION_ACTIVE_POWER:
        return DefinedLocalizations.of(context).immediatelyPower;
        break;
      case TYPE_CONDITION_CURTIAN_ONOFF:
        return DefinedLocalizations.of(context).openCloseState;
        break;
      case TYPE_CONDITION_CURTAIN_EXERCISE:
        return DefinedLocalizations.of(context).exerciseState;
        break;
      case TYPE_CONDITION_ROTATION_ANGLE:
        return DefinedLocalizations.of(context).rotation;
        break;
      default:
        return " ";
    }
  }
}
