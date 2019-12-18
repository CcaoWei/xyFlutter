import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'dart:async';
import 'dart:ui';

import 'package:xlive/localization/defined_localization.dart';

class AutoCondDeviceHeader extends StatefulWidget {
  final Entity entity;
  final int type;

  AutoCondDeviceHeader({@required this.entity, this.type});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoCondDeviceHeaderPage();
  }
}

class _AutoCondDeviceHeaderPage extends State<AutoCondDeviceHeader> {
  StreamSubscription _subscription; //消息通道
  Entity entity;
  LogicDevice logicDevice;
  PhysicDevice physicDevice;
  int profile;
  void initState() {
    super.initState();
    _resetData(); //onshow
    _start();
  }

  void _resetData() {
    if (widget.entity is LogicDevice) {
      logicDevice = widget.entity as LogicDevice;
      if (logicDevice.parent.isSwitchModule) {
        profile = CONDITION_DEVICE_TYPE_BUTTON;
      } else {
        profile = logicDevice.profile;
      }
    } else if (widget.entity is PhysicDevice) {
      physicDevice = widget.entity as PhysicDevice;
      if (physicDevice.isWallSwitch) {
        profile = 0;
      } else if (physicDevice.isSmartDial) {
        profile = 0;
      }
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

  String getChildImageUrl(LogicDevice ld) {
    if (ld.parent.isWallSwitch) {
      if (ld.uuid.endsWith('-01')) {
        if (ld.isWallSwitchButton) {
          return 'images/wall_switch_binding_left_top.png';
        } else {
          if (ld.parent.available) {
            return ld.onOffStatus == ON_OFF_STATUS_ON
                ? 'images/icon_ws_lt_on.png'
                : 'images/icon_ws_lt_off.png';
          } else {
            return 'images/icon_ws_lt_offline.png';
          }
        }
      } else if (ld.uuid.endsWith('-02')) {
        if (ld.isWallSwitchButton) {
          return 'images/wall_switch_binding_top.png';
        } else {
          if (ld.parent.available) {
            return ld.onOffStatus == ON_OFF_STATUS_ON
                ? 'images/icon_ws_rt_on.png'
                : 'images/icon_ws_rt_off.png';
          } else {
            return 'images/icon_ws_rt_offline.png';
          }
        }
      } else if (ld.uuid.endsWith('-04')) {
        if (ld.isWallSwitchButton) {
          return 'images/wall_switch_binding_right.png';
        } else {
          if (ld.parent.available) {
            return ld.onOffStatus == ON_OFF_STATUS_ON
                ? 'images/icon_ws_rb_on.png'
                : 'images/icon_ws_rb_off.png';
          } else {
            return 'images/icon_ws_rb_offline.png';
          }
        }
      } else if (ld.uuid.endsWith('-03')) {
        if (ld.isWallSwitchButton) {
          return 'images/wall_switch_binding_left.png';
        } else {
          if (ld.parent.available) {
            return ld.onOffStatus == ON_OFF_STATUS_ON
                ? 'images/icon_ws_lb_on.png'
                : 'images/icon_ws_lb_off.png';
          } else {
            return 'images/icon_ws_lb_offline.png';
          }
        }
      }
    } else if (ld.parent.isWallSwitchUS) {
      if (ld.parent.available) {
        return ld.onOffStatus == ON_OFF_STATUS_ON
            ? 'images/icon_ws_us_m_on.png'
            : 'images/icon_ws_us_m_off.png';
      } else {
        return 'images/icon_ws_m_offline.png';
      }
    } else if (ld.parent.isSwitchModule) {
      if (widget.type == TYPE_CONDITION_KEYPRESS) {
        if (ld.uuid.endsWith('-01')) {
          return 'images/inputL.png';
        } else if (ld.uuid.endsWith('-02')) {
          return 'images/inputR.png';
        }
      } else {
        if (ld.uuid.endsWith('-01')) {
          return 'images/cond_icon_sm_output1.png';
        } else if (ld.uuid.endsWith('-02')) {
          return 'images/cond_icon_sm_output2.png';
        }
      }
    }
    return 'images/icon_ws_lt_on.png';
  }

  String getDeviceImage() {
    switch (profile) {
      case CONDITION_DEVICE_TYPE_PIR:
        return "images/automation_pir.png";
        break;
      case CONDITION_DEVICE_TYPE_PLUG:
        return "images/automation_plug.png";
        break;
      case CONDITION_DEVICE_TYPE_LIGHT:
        return "images/automation_light_socket.png";
        break;
      case CONDITION_DEVICE_TYPE_SENSOR:
        return "images/automation_door_sensor.png";
        break;
      case CONDITION_DEVICE_TYPE_UI:
        return "images/";
        break;
      case CONDITION_DEVICE_TYPE_BUTTON:
        return getChildImageUrl(widget.entity);
        break;
      case CONDITION_DEVICE_TYPE_CURTAIN:
        return "images/automation_curtain.png";
        break;
      case CONDITION_DEVICE_TYPE_SMART_DIAL:
        return "images/icon_sd_offline.png";
        break;
      case CONDITION_DEVICE_TYPE_UN:
        return "images/";
        break;
      default:
        return '';
    }
  }

  String devicePosition(BuildContext context) {
    switch (profile) {
      case CONDITION_DEVICE_TYPE_PIR:
        return DefinedLocalizations.of(context).locate +
            logicDevice.getRoomName(context, widget.entity.roomUuid) +
            DefinedLocalizations.of(context).s +
            logicDevice.getName();
      case CONDITION_DEVICE_TYPE_PLUG:
        return DefinedLocalizations.of(context).locate +
            logicDevice.getRoomName(context, logicDevice.roomUuid) +
            DefinedLocalizations.of(context).s +
            logicDevice.getName();
      case CONDITION_DEVICE_TYPE_LIGHT:
        return DefinedLocalizations.of(context).locate +
            logicDevice.getRoomName(context, logicDevice.roomUuid) +
            DefinedLocalizations.of(context).s +
            logicDevice.getName();
      case CONDITION_DEVICE_TYPE_SENSOR:
        return DefinedLocalizations.of(context).locate +
            logicDevice.getRoomName(context, logicDevice.roomUuid) +
            DefinedLocalizations.of(context).s +
            logicDevice.getName();
      case CONDITION_DEVICE_TYPE_UI:
        return DefinedLocalizations.of(context).locate +
            logicDevice.getRoomName(context, logicDevice.roomUuid) +
            DefinedLocalizations.of(context).s +
            logicDevice.getName();
      case CONDITION_DEVICE_TYPE_CURTAIN:
        return DefinedLocalizations.of(context).locate +
            logicDevice.getRoomName(context, logicDevice.roomUuid) +
            DefinedLocalizations.of(context).s +
            logicDevice.getName();
      case CONDITION_DEVICE_TYPE_BUTTON:
        return DefinedLocalizations.of(context).locate +
            logicDevice.getRoomName(context, logicDevice.roomUuid) +
            DefinedLocalizations.of(context).s +
            logicDevice.getName();
      case CONDITION_DEVICE_TYPE_SMART_DIAL:
        return DefinedLocalizations.of(context).locate +
            logicDevice.getRoomName(context, logicDevice.roomUuid) +
            DefinedLocalizations.of(context).s +
            logicDevice.getName();
      case CONDITION_DEVICE_TYPE_UN:
        return DefinedLocalizations.of(context).locate +
            logicDevice.getRoomName(context, logicDevice.roomUuid) +
            DefinedLocalizations.of(context).s +
            logicDevice.getName();
      default:
        return '';
    }
  }

  void _start() {
    //数据监听 接受事件
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Adapt.px(249),
      padding: EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: const Color(0x33000000),
                  width: 1,
                  style: BorderStyle.solid))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image(
            width: Adapt.px(116),
            height: Adapt.px(116),
            image: AssetImage(getDeviceImage()),
          ),
          Container(
            margin: EdgeInsets.only(left: 13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  logicDevice.getName(),
                  style: TextStyle(
                      fontSize: Adapt.px(45), color: Color(0xff55585a)),
                ),
                Text(
                  devicePosition(context),
                  style: TextStyle(
                      fontSize: Adapt.px(36), color: Color(0x80899189)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
