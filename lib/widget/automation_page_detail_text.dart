import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/data/data_shared.dart';
// import 'package:xlive/widget/scene_icon_view.dart';

class AutomationPageDetailText extends StatefulWidget {
  final double width;
  final int maxLine;
  final Automation automation;
  final style;
  AutomationPageDetailText(
      {Key key,
      @required this.width,
      @required this.automation,
      @required this.maxLine,
      this.style})
      : super(key: key);

  State<StatefulWidget> createState() => _AutomationPageDetailTextState();
}

class _AutomationPageDetailTextState extends State<AutomationPageDetailText> {
  LogicDevice logicDevice;
  Scene scene;
  String condText = " ";
  List deviceList = [];
  void initState() {
    super.initState();
    resetData();
  }

  void dispose() {
    super.dispose();
  }

  Entity conditionEntity(protobuf.Execution e) {
    //获得条件里面设备的logicdevice
    var uuid = null;
    if (e.hasTimer()) {
      uuid = null;
    } else if (e.hasScene()) {
      uuid = e.scene.uUID;
    } else if (e.hasAction()) {
      uuid = e.action.action.actions[0].uUID;
    } else if (e.hasSequenced()) {
      if (e.sequenced.executions[0].hasTimer()) {
        uuid = null;
      } else if (e.sequenced.executions[0].hasAction()) {
        uuid = e.sequenced.executions[0].action.action.actions[0].uUID;
      } else if (e.sequenced.executions[0].hasScene()) {
        uuid = uuid = e.scene.uUID;
      } else if (e.sequenced.executions[0].hasSequenced()) {
        uuid = null;
      }
      uuid = null;
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
    for (var scene in cache.scenes) {
      if (scene.uuid == uuid) {
        return scene;
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

  String getTimeStr(keepTime) {
    var timeStr = "";
    int value = keepTime.toInt() ~/ 1000;
    print(value);
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
    // } else {
    //   timeStr = min.toString() +
    //       DefinedLocalizations.of(null).minutes +
    //       sec.toString() +
    //       DefinedLocalizations.of(null).second;
    // }

    // timeStr = timeStr.replaceAll("0小时", "");
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
    } else if (attrValue == ATTRIBUTE_ID_TOTLE_POWER) {
      int end = cond.attributeVariation.targetRange.end ~/ 10;
      int begin = cond.attributeVariation.targetRange.begin ~/ 10;
      sectionText(begin, end, "W");
    } else if (attrValue == ATTRIBUTE_ID_ACTIVE_POWER) {
    } else if (attrValue == ATTRIBUTE_ID_INSERT_EXTRACT_STATUS) {
    } else if (attrValue == ATTRIBUTE_ID_OCCUPANCY) {
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

  void resetData() {
    deviceList.clear();
    condText = " ";
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (widget.automation == null) return;
    if (!widget.automation.enable) {
      condText = DefinedLocalizations.of(null).hasBeenDiscontinued;
      return;
    }
    for (var exec in widget.automation.auto.exec.sequenced.executions) {
      if (exec.hasAction()) {
        if (exec.action.action.actions[0].attrValue == ON_OFF_STATUS_ON ||
            exec.action.action.actions[0].attrValue == 100) {
          deviceList.add(DefinedLocalizations.of(null).open);
        } else if (exec.action.action.actions[0].attrValue ==
            ON_OFF_STATUS_OFF) {
          deviceList.add(DefinedLocalizations.of(null).close);
        }
        deviceList.add(conditionEntity(exec));
      } else if (exec.hasScene()) {
        deviceList.add(DefinedLocalizations.of(null).excute);
        deviceList.add(conditionEntity(exec));
        deviceList.add(DefinedLocalizations.of(null).scene);
      } else if (exec.hasSequenced()) {
        for (var item in exec.sequenced.executions) {
          if (item.hasAction()) {
            if (item.action.action.actions[0].attrValue == ON_OFF_STATUS_ON ||
                item.action.action.actions[0].attrValue == 100) {
              deviceList.add(DefinedLocalizations.of(null).open);
            } else if (item.action.action.actions[0].attrValue ==
                ON_OFF_STATUS_OFF) {
              deviceList.add(DefinedLocalizations.of(null).close);
            }

            deviceList.add(conditionEntity(item));
          } else if (item.hasScene()) {
            deviceList.add(DefinedLocalizations.of(null).excute);
            deviceList.add(conditionEntity(item));
            deviceList.add(DefinedLocalizations.of(null).scene);
          }
        }
      }
    }
    print(deviceList.length);
    for (var ds in deviceList) {
      print(ds);
      if (ds is LogicDevice) {
        condText = condText + ds.getName() + "、";
      } else if (ds is Scene) {
        condText = condText + ds.getName() + "、";
      } else {
        if (ds == null) ds = "";
        condText = condText + ds;
      }
    }
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
