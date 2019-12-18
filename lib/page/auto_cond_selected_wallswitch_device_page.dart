import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'common_page.dart';
import 'dart:ui';
import 'package:xlive/page/auto_condition_radio_type_page.dart';

class AutoCondSelectedWallswitchDevice extends StatefulWidget {
  final Automation automation; //带参数的类的实现方法
  final PhysicDevice physicDevice;
  AutoCondSelectedWallswitchDevice({
    this.automation,
    this.physicDevice, //带参数的类的实现方法 和上面一起的  下面的类_AutoMationPage要在怎么用呢 就是widgei.参数名 就行了
  });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoCondSelectedWallswitchDevicePage();
  }
}

class _AutoCondSelectedWallswitchDevicePage
    extends State<AutoCondSelectedWallswitchDevice> {
  //这个一定要跟着一个build
  //创建一个自动化的列表
  final List<_Group> _group = List();
  _DetailsGroup _deviceGroups = _DetailsGroup();
  _HeaderNeedGroup _headerNeedGroup = _HeaderNeedGroup();

  // List<_DeviceGroup> get deviceGroups {
  //   _deviceGroups.sort((a, b) {
  //     if (a.roomUuid == DEFAULT_ROOM) return 1;
  //     if (b.roomUuid == DEFAULT_ROOM) return -1;
  //     return a.roomUuid.compareTo(b.roomUuid);
  //   });
  //   return _deviceGroups;
  // }

  void initState() {
    //onshow
    super.initState();
    _resetData();
  }

  bool isPureInput(LogicDevice logicDevice) {
    for (var attrK in logicDevice.attributes.keys) {
      if (attrK == ATTRIBUTE_ID_CFG_SW_PURE_INPUT) {
        if (logicDevice.getAttributeValue(attrK) == 0) {
          //false
          return false;
        } else {
          //true
          return true;
        }
      }
    }
    return false;
  }

  bool isDisabledRelay(LogicDevice logicDevice) {
    for (var attrK in logicDevice.attributes.keys) {
      if (attrK == ATTRIBUTE_ID_CONFIG_DISABLE_RELAY) {
        if (logicDevice.getAttributeValue(attrK) == 0) {
          //false
          return false;
        } else {
          //true
          return true;
        }
      }
    }
    return false;
  }

  void _resetData() {
    print("--------------------AutoCondSelectedWallswitchDevicePage.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    _headerNeedGroup.add(widget.physicDevice);
    _group.add(_headerNeedGroup);
    for (var item in widget.physicDevice.logicDevices) {
      _deviceGroups.add(item);
    }

    _group.add(_deviceGroups);
    setState(() {});
  }

  void dispose() {
    //页面卸载是执行的
    super.dispose();
  }

  int _itemCount() => _headerNeedGroup.size() + _deviceGroups.size();
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

  @override
  Widget build(BuildContext context) {
    return CommonPage(
        title: widget.physicDevice.getName(),
        showBackIcon: true,
        child: _buildDeviceList(context));
  }

  bool isShowLight(LogicDevice logicDevice) {
    if (isPureInput(logicDevice) && !isDisabledRelay(logicDevice)) {
      return true;
    } else if (!isPureInput(logicDevice) && !isDisabledRelay(logicDevice)) {
      return true;
    }
    return false;
  }

  bool isShowInsert(LogicDevice logicDevice) {
    if (isPureInput(logicDevice) && isDisabledRelay(logicDevice)) {
      return true;
    } else if (isPureInput(logicDevice) && !isDisabledRelay(logicDevice)) {
      return true;
    }
    return false;
  }

  double getHeight() {
    var height = Adapt.px(340);
    if (widget.physicDevice.isWallSwitch) {
      return Adapt.px(240) * _itemCount() + Adapt.px(100);
    } else if (widget.physicDevice.isSwitchModule) {
      for (var item in widget.physicDevice.logicDevices) {
        if (isShowLight(item)) {
          height = height + Adapt.px(240);
        }
      }
      if (height == Adapt.px(340)) {
        height = 0.0;
      }
      return height;
    }
    return 0.0;
  }

  Widget _buildDeviceList(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      padding: EdgeInsets.only(top: 0.0),
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: getHeight(),
              child: ListView.builder(
                itemCount: _itemCount(),
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 0.0),
                itemBuilder: (BuildContext context, int index) {
                  final Object obj = _getItem(index);
                  if (obj is _HeaderNeed) {
                    return _buildHeaderNeed(context, obj);
                  } else if (obj is _DetailsNeed) {
                    if ((isShowLight(obj.logicDevice) &&
                            obj.logicDevice.parent.isSwitchModule) ||
                        obj.logicDevice.parent.isWallSwitch) {
                      return _buildDetailsNeed(context, obj, index);
                    }
                  }
                  return Text("");
                },
              ),
            ),
            Offstage(
              offstage: !widget.physicDevice.isSwitchModule,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Offstage(
                    offstage: _deviceGroups.size() == 0,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: Adapt.px(50),
                          left: Adapt.px(40),
                          bottom: Adapt.px(30)),
                      child: Text(
                        DefinedLocalizations.of(context).input,
                        style: TextStyle(
                            fontSize: Adapt.px(42), color: Color(0xff9b9b9b)),
                      ),
                    ),
                  ),
                  Container(
                    height: Adapt.px(240) * 2.4,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 0.0),
                      itemCount: _deviceGroups.size(),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final Object obj = _deviceGroups.get(index);
                        if (obj is _DetailsNeed) {
                          if ((isShowInsert(obj.logicDevice) &&
                                  obj.logicDevice.parent.isSwitchModule) ||
                              obj.logicDevice.parent.isWallSwitch) {
                            return buildSwitchModule(context, obj, index);
                          }
                        }
                        return Text("");
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
      },
    );
  }

  Widget _buildHeaderNeed(BuildContext context, _HeaderNeed pd) {
    return Container(
      height: Adapt.px(249),
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            width: Adapt.px(116),
            height: Adapt.px(116),
            image: AssetImage(pd.getImage()),
          ),
          Container(
            margin: EdgeInsets.only(left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  pd.pd.name,
                  style: TextStyle(
                      fontSize: Adapt.px(45), color: Color(0xff55585a)),
                ),
                Text(
                  DefinedLocalizations.of(context).locate +
                      pd.pd.getRoomName(context, pd.pd.roomUuid) +
                      pd.pd.name,
                  style: TextStyle(
                      fontSize: Adapt.px(45), color: Color(0x80899198)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String getChildImageUrl(LogicDevice ld) {
    if (ld.parent.isWallSwitch) {
      if (ld.uuid.endsWith('-01')) {
        if (ld.isWallSwitchButton ||
            (ld.parent.isWallSwitchS && isDisabledRelay(ld)) ||
            (ld.parent.isWallSwitchD && isPureInput(ld))) {
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
        if (ld.isWallSwitchButton ||
            (ld.parent.isWallSwitchS && isDisabledRelay(ld)) ||
            (ld.parent.isWallSwitchD && isPureInput(ld))) {
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
        if (ld.isWallSwitchButton ||
            (ld.parent.isWallSwitchS && isDisabledRelay(ld)) ||
            (ld.parent.isWallSwitchD && isPureInput(ld))) {
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
        if (ld.isWallSwitchButton ||
            (ld.parent.isWallSwitchS && isDisabledRelay(ld)) ||
            (ld.parent.isWallSwitchD && isPureInput(ld))) {
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
      if (ld.uuid.endsWith('-01')) {
        return 'images/cond_icon_sm_output1.png';
      } else if (ld.uuid.endsWith('-02')) {
        return 'images/cond_icon_sm_output2.png';
      }
    }
    return 'images/icon_ws_lt_on.png';
  }

  String getONOFF(BuildContext context, LogicDevice ld) {
    if (ld.isWallSwitchButton) {
      return " ";
    } else {
      // return ld.onOffStatus == ON_OFF_STATUS_ON
      //       ? DefinedLocalizations.of(context).open
      //       : DefinedLocalizations.of(context).close;
      return "";
    }
  }

  Widget _buildDetailsNeed(
      BuildContext context, _DetailsNeed _detailsNeed, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Adapt.px(240),
        color: Color(0xffF9F9F9),
        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: Adapt.px(15)),
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Image(
                    height: Adapt.px(120),
                    width: Adapt.px(120),
                    image:
                        AssetImage(getChildImageUrl(_detailsNeed.logicDevice)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Text(
                      _detailsNeed.logicDevice.getName(),
                      style: TextStyle(
                          fontSize: Adapt.px(45), color: Color(0xff55585a)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: Text(
                      getONOFF(context, _detailsNeed.logicDevice),
                      style: TextStyle(
                          fontSize: Adapt.px(45), color: Color(0x732d3b46)),
                    ),
                  ),
                  Image(
                    height: Adapt.px(35),
                    width: Adapt.px(19),
                    image: AssetImage("images/icon_next.png"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        var ld = _detailsNeed.logicDevice;
        if (ld.isWallSwitchButton ||
            (ld.parent.isWallSwitchS && isDisabledRelay(ld)) ||
            (ld.parent.isWallSwitchD && isPureInput(ld))) {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => AutoConditionRadioType(
                  stateType: TYPE_CONDITION_KEYPRESS,
                  entity: _detailsNeed.logicDevice,
                  deviceProfile: _detailsNeed.logicDevice.profile,
                  automation: widget.automation,
                  cond: null),
              settings: RouteSettings(name: "/AutoConditionRadioType")));
        } else {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => AutoConditionRadioType(
                  stateType: TYPE_CONDITION_ONOFF,
                  entity: _detailsNeed.logicDevice,
                  deviceProfile: _detailsNeed.logicDevice.profile,
                  automation: widget.automation,
                  cond: null),
              settings: RouteSettings(name: "/AutoConditionRadioType")));
        }
      },
    );
  }

  Widget buildSwitchModule(
      BuildContext context, _DetailsNeed _detailsNeed, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Adapt.px(240),
        color: Color(0xffF9F9F9),
        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: Adapt.px(15)),
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Image(
                    height: Adapt.px(120),
                    width: Adapt.px(120),
                    image: AssetImage(index == 0
                        ? "images/cond_icon_sm_input1.png"
                        : "images/cond_icon_sm_input2.png"),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Text(
                      _detailsNeed.logicDevice.getName(),
                      style: TextStyle(
                          fontSize: Adapt.px(45), color: Color(0xff55585a)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: Text(
                      getONOFF(context, _detailsNeed.logicDevice),
                      style: TextStyle(
                          fontSize: Adapt.px(45), color: Color(0x732d3b42)),
                    ),
                  ),
                  Image(
                    height: Adapt.px(35),
                    width: Adapt.px(19),
                    image: AssetImage("images/icon_next.png"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
            builder: (context) => AutoConditionRadioType(
                stateType: TYPE_CONDITION_KEYPRESS,
                entity: _detailsNeed.logicDevice,
                deviceProfile: _detailsNeed.logicDevice.profile,
                automation: widget.automation,
                cond: null),
            settings: RouteSettings(name: "/AutoConditionRadioType")));
      },
    );
  }
}

class _Need {} //各种body类型

class _HeaderNeed extends _Need {
  final PhysicDevice pd;
  _HeaderNeed({@required this.pd});
  String getImage() {
    if (pd.isWallSwitch) {
      return "images/automation_wall_switch.png";
    } else if (pd.isSwitchModule) {
      return "images/automation_switch_module.png";
    }
    return "";
  }
}

class _DetailsNeed extends _Need {
  //按键
  final LogicDevice logicDevice;

  _DetailsNeed({@required this.logicDevice});
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

class _HeaderNeedGroup extends _Group {
  final List<_HeaderNeed> _headerNeed = List();
  void add(PhysicDevice pd) {
    _headerNeed.add(
      _HeaderNeed(
        pd: pd,
      ),
    );
  }

  void clear() {
    _headerNeed.clear();
  }

  int size() {
    return _headerNeed.length > 0 ? _headerNeed.length : 0;
  }

  Object get(int index) => _headerNeed[index];
}

class _DetailsGroup extends _Group {
  final List<_DetailsNeed> _detailsNeed = List();
  void add(LogicDevice logicDevice) {
    _detailsNeed.add(
      _DetailsNeed(
        logicDevice: logicDevice,
      ),
    );
  }

  void clear() {
    _detailsNeed.clear();
  }

  int size() {
    return _detailsNeed.length > 0 ? _detailsNeed.length : 0;
  }

  Object get(int index) => _detailsNeed[index];
}
