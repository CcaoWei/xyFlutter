import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/data/data_shared.dart';
// import 'package:xlive/widget/scene_icon_view.dart';

class AutomationCondText extends StatefulWidget {
  final double width;
  final int maxLine;
  final Automation automation;
  final protobuf.Condition condition;
  final style;
  AutomationCondText(
      {Key key,
      @required this.width,
      @required this.automation,
      @required this.maxLine,
      @required this.condition,
      this.style})
      : super(key: key);

  State<StatefulWidget> createState() => AutomationCondTextState();
}

class AutomationCondTextState extends State<AutomationCondText> {
  LogicDevice logicDevice;
  String condText = "";
  // StreamSubscription subscription;

  void initState() {
    resetData();
    super.initState();

    // start();
  }

  @override
  // void didUpdateWidget(AutomationCondText oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.entity != oldWidget.entity) {
  //     resetData();
  //   }
  // }

  void dispose() {
    super.dispose();
    // if (subscription != null) {
    //   subscription.cancel();
    // }
  }

  Entity conditionEntity(protobuf.Condition c) {
    if (c == null) return null;
    //获得条件里面设备的logicdevice
    var uuid = null;
    if (c.hasKeypress()) {
      uuid = c.keypress.uUID;
    } else if (c.hasLongPress()) {
      uuid = c.longPress.uUID;
    } else if (c.hasAttributeVariation()) {
      uuid = c.attributeVariation.uUID;
    } else if (c.hasSequenced()) {
      uuid = c.sequenced.conditions[0].innerCondition.attributeVariation.uUID;
    } else if (c.hasAttributeVariation()) {
      uuid = c.attributeVariation.uUID;
    } else if (c.hasAngular()) {
      uuid = c.angular.uUID;
    } else if (c.hasComposed()) {
      if (c.composed.conditions[1].hasAngular()) {
        uuid = c.composed.conditions[1].angular.uUID;
      } else if (c.composed.conditions[1].hasAttributeVariation()) {
        uuid = c.composed.conditions[1].attributeVariation.uUID;
      } else if (c.composed.conditions[1].hasKeypress()) {
        //  if (c.hasKeypress()) {
        uuid = c.composed.conditions[1].keypress.uUID;
      } else if (c.composed.conditions[1].hasLongPress()) {
        uuid = c.composed.conditions[1].longPress.uUID;
      }
      // }
    }
    if (uuid == null) return null;
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    for (var phyd in cache.addedDevices) {
      for (var logd in phyd.logicDevices) {
        if (logd.uuid == uuid) {
          return logd;
        }
      }
    }
    return null;
  }

  String sectionText(int begin, int end, String unit) {
    if (begin <= -21474836) {
      //小于
      return DefinedLocalizations.of(null).under + end.toString() + unit;
    } else if (end >= 21474836) {
      //大于
      return DefinedLocalizations.of(null).greaterThan +
          begin.toString() +
          unit;
    } else {
      return DefinedLocalizations.of(null).locate +
          begin.toString() +
          " - " +
          end.toString() +
          unit +
          DefinedLocalizations.of(null).among;
    }
  }

  String sectionPowerText(int begin, int end, String unit) {
    if (begin == 0) {
      //小于
      return DefinedLocalizations.of(null).under + end.toString() + unit;
    } else if (end == 0) {
      //大于
      return DefinedLocalizations.of(null).greaterThan +
          begin.toString() +
          unit;
    } else {
      return DefinedLocalizations.of(null).locate +
          begin.toString() +
          " - " +
          end.toString() +
          unit +
          DefinedLocalizations.of(null).among;
    }
  }

  String angularText(int begin, int end, String unit) {
    if (begin < 0) {
      //左旋
      if (begin < -214748) {
        return DefinedLocalizations.of(null).greaterThan +
            end.abs().toString() +
            unit;
      } else if (begin == 0 && end > 214748) {
        return DefinedLocalizations.of(null).greaterThan +
            begin.abs().toString() +
            unit;
      } else if (end == 0) {
        return DefinedLocalizations.of(null).under +
            begin.abs().toString() +
            unit;
      } else {
        return DefinedLocalizations.of(null).locate +
            end.abs().toString() +
            "~" +
            begin.abs().toString() +
            unit +
            DefinedLocalizations.of(null).among;
      }
    } else if (begin >= 0) {
      if (begin == 0) {
        return DefinedLocalizations.of(null).under +
            end.abs().toString() +
            unit;
      } else if (begin > 0 && end > 720) {
        return DefinedLocalizations.of(null).greaterThan +
            begin.abs().toString() +
            unit;
      } else {
        return DefinedLocalizations.of(null).locate +
            begin.abs().toString() +
            "~" +
            end.abs().toString() +
            unit +
            DefinedLocalizations.of(null).among;
      }
    } else if (begin == 0 && end == 0) {
      return DefinedLocalizations.of(null).arbitrarily;
    }
    return " ";
  }

  String getTimeStr(keepTime) {
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

    // if (hour > 0) {
    //   timeStr = hour.toString() +
    //       DefinedLocalizations.of(null).hours +
    //       min.toString() +
    //       DefinedLocalizations.of(null).minutes +
    //       sec.toString() +
    //       DefinedLocalizations.of(null).second;
    // } else if (min > 0) {
    //   timeStr = min.toString() +
    //       DefinedLocalizations.of(null).minutes +
    //       sec.toString() +
    //       DefinedLocalizations.of(null).second;
    // } else {
    //   timeStr = sec.toString() + DefinedLocalizations.of(null).second;
    // }
    // timeStr = timeStr.replaceAll(DefinedLocalizations.of(null).hourZeroMinute,
    //     DefinedLocalizations.of(null).hours);
    // timeStr = timeStr.replaceAll(DefinedLocalizations.of(null).minuteZeroSecond,
    //     DefinedLocalizations.of(null).minutes);
    // timeStr = timeStr.replaceAll(DefinedLocalizations.of(null).hourZeroSecond,
    //     DefinedLocalizations.of(null).hours);
    // return timeStr;
  }

  String attributeVariationText(protobuf.Condition cond) {
    int attrValue = cond.attributeVariation.attrID.value;
    int sourceBegin = cond.attributeVariation.sourceRange.begin;
    int targetBegin = cond.attributeVariation.targetRange.begin;
    var targetEnd = cond.attributeVariation.targetRange.end;
    Int64 keepms = cond.attributeVariation.keepTimeMS;
    if (attrValue == ATTRIBUTE_ID_OCCUPANCY_LEFT ||
        attrValue == ATTRIBUTE_ID_OCCUPANCY_RIGHT) {
      if (sourceBegin > targetBegin) {
        return DefinedLocalizations.of(null).forNoOne + getTimeStr(keepms);
      } else {
        return DefinedLocalizations.of(null).forSomeone + getTimeStr(keepms);
      }
    } else if (attrValue == ATTRIBUTE_ID_ON_OFF_STATUS) {
      if (targetBegin == 1) {
        return DefinedLocalizations.of(null).openAndHold + getTimeStr(keepms);
      } else {
        return DefinedLocalizations.of(null).closeAndHold + getTimeStr(keepms);
      }
    } else if (attrValue == ATTRIBUTE_ID_ACTIVE_POWER) {
      int end = cond.attributeVariation.targetRange.end ~/ 10;
      int begin = cond.attributeVariation.targetRange.begin ~/ 10;
      return DefinedLocalizations.of(null).immediatelyPower +
          sectionPowerText(begin, end, "W") +
          DefinedLocalizations.of(null).hold +
          getTimeStr(keepms);
    } else if (attrValue == ATTRIBUTE_ID_LUMINANCE) {
      return DefinedLocalizations.of(null).illuminance +
          sectionText(targetBegin, targetEnd, "Lux") +
          DefinedLocalizations.of(null).hold +
          getTimeStr(keepms);
    } else if (attrValue == ATTRIBUTE_ID_TEMPERATURE) {
      int end = cond.attributeVariation.targetRange.end ~/ 10;
      int begin = cond.attributeVariation.targetRange.begin ~/ 10;
      return DefinedLocalizations.of(null).temperature +
          sectionText(begin, end, "°C") +
          DefinedLocalizations.of(null).hold +
          getTimeStr(keepms);
    } else if (attrValue == ATTRIBUTE_ID_BINARY_INPUT_STATUS) {
      if (targetBegin == 1) {
        return DefinedLocalizations.of(null).openAndHold + getTimeStr(keepms);
      } else {
        return DefinedLocalizations.of(null).closeAndHold + getTimeStr(keepms);
      }
    } else if (attrValue == ATTRIBUTE_ID_BATTERY_PERCENT) {
    } else if (attrValue == ATTRIBUTE_ID_FIRMWARE_VERSION) {
    } else if (attrValue == ATTRIBUTE_ID_PERMIT_JOIN) {
    } else if (attrValue == ATTRIBUTE_ID_CURTAIN_DIRECTION) {
      return DefinedLocalizations.of(null).exerciseState;
    } else if (attrValue == ATTRIBUTE_ID_CURTAIN_TARGET_POSITION) {
    } else if (attrValue == ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION) {
      return DefinedLocalizations.of(null).openCloseState +
          sectionText(targetBegin, targetEnd, "%") +
          DefinedLocalizations.of(null).hold +
          getTimeStr(keepms);
    } else if (attrValue == ATTRIBUTE_ID_SUPPORT_OTA) {
    } else if (attrValue == ATTRIBUTE_ID_ALERT_LEVEL) {
    } else if (attrValue == ATTRIBUTE_ID_CURTAIN_STATUS) {
      if (targetBegin == 1 && targetEnd == 1) {
        return DefinedLocalizations.of(null).opening +
            DefinedLocalizations.of(null).hold +
            getTimeStr(keepms);
      } else if (targetBegin == 2 && targetEnd == 2) {
        return DefinedLocalizations.of(null).closing +
            DefinedLocalizations.of(null).hold +
            getTimeStr(keepms);
      }
      // return "运动状态在"+sectionText(targetBegin,targetEnd,"%")+DefinedLocalizations.of(null).hold+getTimeStr(keepms);
    }
    return " ";
  }

  String getTimeValue(protobuf.CalendarCondition calendarC) {
    if (calendarC.calendarDayTime.hour == -1 &&
        calendarC.calendarDayTime.min == -1 &&
        calendarC.calendarDayTime.sec == -1) {
      return "";
    }
    String timeStr = " ";
    var hour = calendarC.calendarDayTime.hour;
    var min = calendarC.calendarDayTime.min;
    var sec = calendarC.calendarDayTime.sec;
    var hourS, minS, secS;
    hour > 9 ? hourS = hour.toString() : hourS = "0" + hour.toString();
    min > 9 ? minS = min.toString() : minS = "0" + min.toString();
    sec > 9 ? secS = sec.toString() : secS = "0" + sec.toString();
    timeStr = hourS + "：" + minS + "：" + secS;
    return timeStr;
  }

  void resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.automation == null) return;
    protobuf.Condition condition = widget.condition;
    logicDevice = conditionEntity(condition) as LogicDevice;
    if (condition.hasAngular()) {
      var begin = condition.angular.angleRange.begin;
      var end = condition.angular.angleRange.end;
      if (begin < 0) {
        //左旋
        if (logicDevice == null) {
          condText = DefinedLocalizations.of(null).deviceRemoved;
        } else {
          condText = logicDevice.getName() +
              DefinedLocalizations.of(null).sinistrogyrationUntil +
              angularText(begin, end, "°");
        }
      } else if (begin >= 0) {
        //右旋
        if (logicDevice == null) {
          condText = DefinedLocalizations.of(null).deviceRemoved;
        } else {
          condText = logicDevice.getName() +
              DefinedLocalizations.of(null).dextrorotationUntil +
              angularText(begin, end, "°");
        }
      } else if (begin == 0 && end == 0) {
        //任意角度
        if (logicDevice == null) {
          condText = DefinedLocalizations.of(null).deviceRemoved;
        } else {
          condText = logicDevice.getName() +
              DefinedLocalizations.of(null).rotationAnyAngle;
        }
      }
      // condText = logicDevice.getName() + ;
    } else if (condition.hasKeypress()) {
      if (logicDevice == null) {
        condText = DefinedLocalizations.of(null).deviceRemoved;
      } else {
        condText = logicDevice.getName() +
            DefinedLocalizations.of(null).clike +
            condition.keypress.pressedTimes.toString() +
            DefinedLocalizations.of(null).selectTime;
      }
    } else if (condition.hasAttributeVariation()) {
      if (logicDevice == null) {
        condText = DefinedLocalizations.of(null).deviceRemoved;
      } else {
        condText = logicDevice.getName() + attributeVariationText(condition);
      }
    } else if (condition.hasWithinPeriod()) {
    } else if (condition.hasCalendar()) {
      condText = getTimeValue(condition.calendar);
    } else if (condition.hasCalendarRange()) {
    } else if (condition.hasTimer()) {
      var times = widget.automation.getConditionAt(COND_COUNT).timer.timeoutMS;
      condText = getTimeStr(times) + DefinedLocalizations.of(null).after;
    } else if (condition.hasComposed()) {
      if (condition.composed.conditions[0].hasAngular()) {
        var begin = condition.composed.conditions[0].angular.angleRange.begin;
        var end = condition.composed.conditions[0].angular.angleRange.end;
        if (condition.composed.conditions[0].angular.angleRange.begin < 0) {
          //左旋
          if (logicDevice == null) {
            condText = DefinedLocalizations.of(null).deviceRemoved;
          } else {
            condText = logicDevice.getName() +
                DefinedLocalizations.of(null).arbitrarilyRotate +
                angularText(begin, end, "°");
          }
        } else if (condition.composed.conditions[0].angular.angleRange.begin >=
            0) {
          //右旋
          if (logicDevice == null) {
            condText = DefinedLocalizations.of(null).deviceRemoved;
          } else {
            condText = logicDevice.getName() +
                DefinedLocalizations.of(null).arbitrarilyRotate +
                angularText(begin, end, "°");
          }
        } else if (condition.composed.conditions[0].angular.angleRange.begin ==
                0 &&
            condition.composed.conditions[0].angular.angleRange.end == 0) {
          //任意角度
          if (logicDevice == null) {
            condText = DefinedLocalizations.of(null).deviceRemoved;
          } else {
            condText = logicDevice.getName() +
                DefinedLocalizations.of(null).rotationAnyAngle;
          }
        }
      } else if (condition.composed.conditions[0].hasAttributeVariation()) {
        var attrid = condition.composed.conditions[0].attributeVariation.attrID;
        if (attrid == ATTRIBUTE_ID_OCCUPANCY_LEFT ||
            attrid == ATTRIBUTE_ID_OCCUPANCY_RIGHT) {
          if (logicDevice == null) {
            condText = DefinedLocalizations.of(null).deviceRemoved;
          } else {
            condText = logicDevice.getName() +
                DefinedLocalizations.of(null).someoneAfter;
          }
        } else {
          if (logicDevice == null) {
            condText = DefinedLocalizations.of(null).deviceRemoved;
          } else {
            condText = logicDevice.getName() +
                DefinedLocalizations.of(null).exerciseState;
          }
        }
      }
    } else if (condition.hasSequenced()) {
      if (logicDevice == null) {
        condText = DefinedLocalizations.of(null).deviceRemoved;
      } else {
        condText =
            logicDevice.getName() + DefinedLocalizations.of(null).someoneAfter;
      }
    } else if (condition.hasLongPress()) {
      if (logicDevice == null) {
        condText = DefinedLocalizations.of(null).deviceRemoved;
      } else {
        condText = logicDevice.getName() +
            DefinedLocalizations.of(null).longPress +
            condition.longPress.pressedSeconds.toString() +
            DefinedLocalizations.of(null).second;
      }
    }
    // }

    setState(() {});
  }

  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        child: Text(
          condText,
          maxLines: widget.maxLine,
          overflow: TextOverflow.ellipsis,
          style: widget.style,
        ));
  }
}
