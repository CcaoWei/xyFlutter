import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/const/adapt.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/page/auto_cond_set_repeat_page.dart';
import 'package:xlive/page/auto_cond_time_set_cond_page.dart';
import 'package:xlive/page/auto_light_time_set_page.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/data/data_shared.dart';
import 'dart:async';
import 'dart:ui';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/widget/switch_button.dart';
import 'package:xlive/widget/system_padding.dart';

class AutoLightTimeDetail extends StatefulWidget {
  //这个一定要跟着createstate
  final AutomationSet automationSet;
  final List deviceList;
  AutoLightTimeDetail({this.automationSet, this.deviceList});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoLightTimeDetailPage();
  }
}

class _AutoLightTimeDetailPage extends State<AutoLightTimeDetail> {
  StreamSubscription _subscription; //消息通道
  final List<_Group> _group = List();
  _AutoGroup _autoGroup = _AutoGroup();
  _DeviceGroup _deviceGroup = _DeviceGroup();
  List<String> _weekdayNames = List();
  TextEditingController _automationNameController = TextEditingController();
  void initState() {
    //onshow
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    _group.clear();
    print("-------------------------_AutoLightTimeDetailPage.dart");

    setState(() {});
  }

  void clearCalend() {
    for (Automation automation in widget.automationSet.autoset) {
      for (var cond in automation.auto.cond.composed.conditions) {
        if (cond.hasCalendar()) {
          // if(cond.calendar.calendarDayTime.hour == -1){
          //   automation.auto.cond.clear();
          // }
        } else {}
      }
    }
  }

  String getLightName() {
    String result = "";
    if (widget.deviceList != null) {
      for (LogicDevice item in widget.deviceList) {
        result += item.getName() + " ";
      }
      return result;
    } else {
      for (var se
          in widget.automationSet.autoset[0].auto.exec.sequenced.executions) {
        for (var ac in se.action.action.actions) {
          if (ac.uUID == null) return " ";
          final HomeCenterCache cache =
              HomeCenterManager().defaultHomeCenterCache;
          for (var phyd in cache.addedDevices) {
            for (var logd in phyd.logicDevices) {
              if (logd.uuid == ac.uUID) {
                result += logd.getName() + " ";
              }
            }
          }
        }
      }
      // }
      // }

    }
    return result;
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
        if (event.auto.uuid != widget.automationSet.uuid) return;
        _resetData();
        setState(() {}); //刷新界面 相当于setData
      } else if (event is AutomationUpdatedEvent) {
        if (event.auto.uuid != widget.automationSet.uuid) return;
        _resetData();
        setState(() {});
      }
    });
  }

  String commonPageTitle() {
    if (widget.automationSet.uuid == "")
      return DefinedLocalizations.of(context).lightingSchedule;
    return widget.automationSet.getName();
  }

  @override
  Widget build(BuildContext context) {
    clearCalend();
    return CommonPage(
        title: commonPageTitle(),
        showBackIcon: true,
        trailing: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: Adapt.px(200),
            alignment: Alignment.centerRight,
            child: Image(
              width: Adapt.px(63),
              height: Adapt.px(61),
              image: AssetImage("images/edit_done.png"),
            ),
          ),
          onTap: () {
            needToAdjustCalendarCondEnables();
            final String homeCenterUuid =
                HomeCenterManager().defaultHomeCenterUuid;
            widget.automationSet.setAttribute(
                ATTRIBUTE_ID_AUTO_ENABLED, widget.automationSet.enable ? 1 : 0);
            var hcuuid = HomeCenterManager().defaultHomeCenterUuid;
            MqttProxy.writeAttribute(hcuuid, widget.automationSet.uuid,
                ATTRIBUTE_ID_AUTO_ENABLED, widget.automationSet.enable ? 1 : 0);
            if (widget.automationSet.uuid != null) {
              MqttProxy.updateAutomationSet(
                      homeCenterUuid, widget.automationSet)
                  .listen((response) {});
              Navigator.of(context).popUntil(
                ModalRoute.withName('/Home'),
              );
            } else {
              MqttProxy.createAutomationSet(
                      homeCenterUuid, widget.automationSet)
                  .listen((response) {});
              Navigator.of(context).popUntil(
                ModalRoute.withName('/Home'),
              );
            }
          },
        ),
        child: _buildAutoDetail());
  }

  String getDeviceList() {
    if (widget.deviceList != null) {
      return widget.deviceList.length.toString() +
          DefinedLocalizations.of(context).lamp;
    } else {
      return widget
              .automationSet.autoset[0].auto.exec.sequenced.executions.length
              .toString() +
          DefinedLocalizations.of(context).lamp;
    }
  }

  bool isShowItem() {
    for (Automation automation in widget.automationSet.autoset) {
      for (var i = 0; i < automation.getConditionCount(); i++) {
        if (automation.getConditionAt(i).calendar.calendarDayTime.hour == -1) {
          return false;
        }
        return true;
      }
    }
    return false;
  }

  bool isEnablesAllFalse() {
    for (var enable in widget.automationSet.autoset[0].auto.cond.composed
        .conditions[0].calendar.enables) {
      if (enable == true) {
        return true;
      }
    }
    return false;
  }

  void needToAdjustCalendarCondEnables() {
    if (!isEnablesAllFalse()) {
      for (Automation automation in widget.automationSet.autoset) {
        automation.auto.cond.composed.conditions[0].calendar.repeat = false;
      }
      var autoHour = widget.automationSet.autoset[0].auto.cond.composed
          .conditions[0].calendar.calendarDayTime.hour;
      var autoMin = widget.automationSet.autoset[0].auto.cond.composed
          .conditions[0].calendar.calendarDayTime.min;
      var autoSec = widget.automationSet.autoset[0].auto.cond.composed
          .conditions[0].calendar.calendarDayTime.sec;
      var now = DateTime.now().toUtc();
      var selectedTime =
          DateTime(now.year, now.month, now.day, autoHour, autoMin, autoSec)
              .toUtc();

      if (now.isAfter(selectedTime)) {
        selectedTime = selectedTime.add(new Duration(days: 1));
      }
      var index = selectedTime.weekday == 7 ? 0 : selectedTime.weekday;
      for (Automation automation1 in widget.automationSet.autoset) {
        automation1.auto.cond.composed.conditions[0].calendar.enables[index] =
            true;
      }
    }
  }

  bool getAutoEnable() {
    // if (widget.automation == null) return true;
    // for (var attrKey in widget.automation.attributes.keys) {
    //   if (attrKey == 35) {
    //     if (widget.automation.getAttributeValue(attrKey) == 1) {
    //       return true;
    //     } else {
    //       return false;
    //     }
    //   }
    // }
    return true;
  }

  bool isFirstTime() {
    if (widget.deviceList == null) {
      return false;
    }
    return true;
  }

  Widget _buildAutoDetail() {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Offstage(
              offstage: isFirstTime(),
              child: Container(
                //是否启用自动化部分
                height: Adapt.px(240),
                color: Color(0xfff9f9f9),
                padding: EdgeInsets.only(left: Adapt.px(40)),
                margin: EdgeInsets.only(
                    bottom: Adapt.px(61),
                    top: 30.0,
                    left: Adapt.px(40),
                    right: Adapt.px(40)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      DefinedLocalizations.of(context).automationEnable,
                      style: TEXT_STYLE_BINDING_DEVICE_NAME,
                    ),
                    SwitchButton(
                      activeColor: Color(0xFF7cd0ff),
                      showIndicator: false,
                      showText: false,
                      value: getAutoEnable(),
                      onChanged: (bool value) {
                        // widget.automation.enable = value;
                        // if (value) {
                        //   widget.automation.enable = true;
                        // } else {
                        //   widget.automation.enable = false;
                        // }
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: Adapt.px(63), left: Adapt.px(40), top: Adapt.px(61)),
              child: Text(
                DefinedLocalizations.of(context).device,
                style:
                    TextStyle(fontSize: Adapt.px(45), color: Color(0xff9b9b9b)),
              ),
            ),
            Container(
              height: Adapt.px(160),
              padding: EdgeInsets.only(right: Adapt.px(40)),
              margin: EdgeInsets.only(
                  left: Adapt.px(40), right: Adapt.px(40), bottom: 50.0),
              color: Color(0xfff9f9f9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: Adapt.px(40)),
                        child: Image(
                          width: Adapt.px(105),
                          height: Adapt.px(108),
                          image: AssetImage('images/icon_light_off.png'),
                        ),
                      ),
                      Container(
                        width: Adapt.px(430),
                        margin: EdgeInsets.only(left: Adapt.px(40)),
                        child: Text(
                          getLightName(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: Adapt.px(45), color: Color(0xff55585a)),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: Adapt.px(24)),
                        child: Text(
                          getDeviceList(),
                          style: TextStyle(
                              fontSize: Adapt.px(45), color: Color(0xff55585a)),
                        ),
                      ),
                      Image(
                        height: Adapt.px(35),
                        width: Adapt.px(19),
                        image: AssetImage("images/icon_next.png"),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    bottom: Adapt.px(63),
                    left: Adapt.px(40),
                    top: Adapt.px(61)),
                padding: EdgeInsets.only(right: Adapt.px(40)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      DefinedLocalizations.of(context).time,
                      style: TextStyle(
                          fontSize: Adapt.px(45), color: Color(0xff9b9b9b)),
                    ),
                    CupertinoButton(
                        color: Color(0xff9ca8b6),
                        minSize: 10.0,
                        padding: EdgeInsets.only(
                            left: Adapt.px(40),
                            right: Adapt.px(40),
                            top: Adapt.px(20),
                            bottom: Adapt.px(20)),
                        borderRadius: BorderRadius.all(Radius.circular(70.0)),
                        child: Text(
                          DefinedLocalizations.of(context).add,
                          style: TextStyle(fontSize: Adapt.px(45)),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(
                                  builder: (context) => AutoCondTimeSetCond(
                                        automation:
                                            widget.automationSet.autoset[0],
                                        automationSet: widget.automationSet,
                                      ),
                                  settings: RouteSettings(
                                      name: "/AutoCondTimeSetCond")));
                        }),
                  ],
                )),
            Offstage(
              offstage: isShowItem(),
              child: Stack(
                alignment: const FractionalOffset(0.9, 0.5),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: Adapt.px(40), right: Adapt.px(40)),
                    child: Image(
                      image: AssetImage("images/dotted.png"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        DefinedLocalizations.of(context).autoCondAdd,
                        style: TextStyle(
                            color: Color(0x55899198), fontSize: Adapt.px(45)),
                      )
                    ],
                  )
                ],
              ),
            ),
            Offstage(
              offstage: !isShowItem(),
              child: Container(
                height: widget.automationSet.autoset.length * 90.0,
                child: ListView.builder(
                  itemCount: widget.automationSet.autoset.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildAutoItem(
                        context, index, widget.automationSet.autoset[index]);
                  },
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: Adapt.px(160),
                margin: EdgeInsets.only(
                    left: Adapt.px(40), right: Adapt.px(40), top: 40.0),
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
                      DefinedLocalizations.of(context).repeat,
                      style: TextStyle(
                          fontSize: Adapt.px(46), color: Color(0xff55585a)),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: Adapt.px(24)),
                            child: Text(
                              getAutoLightRepeat(),
                              style: TextStyle(
                                  fontSize: Adapt.px(46),
                                  color: Color(0x732d3b46)),
                            )),
                        Image(
                          width: Adapt.px(19),
                          height: Adapt.px(35),
                          image: AssetImage("images/icon_next.png"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .push(CupertinoPageRoute(
                        builder: (context) => AutoCondSetRepeat(
                              automation: widget.automationSet.autoset[0],
                              automationSet: widget.automationSet,
                            ),
                        settings: RouteSettings(name: "/AutoCondSetRepeat")));
              },
            ),
            Container(
                height: Adapt.px(160),
                margin:
                    EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(40)),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: const Color(0x33000000),
                  width: 1,
                  style: BorderStyle.solid,
                ))),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        DefinedLocalizations.of(context).name,
                        style: TextStyle(
                            fontSize: Adapt.px(46), color: Color(0xff55585a)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: Adapt.px(20)),
                            child: Text(
                              widget.automationSet.name,
                              style: TextStyle(
                                  fontSize: Adapt.px(46),
                                  color: Color(0x732d3b46)),
                            ),
                          ),
                          Container(
                            // margin: EdgeInsets.only(top: 3.0),
                            child: Image(
                              width: Adapt.px(19),
                              height: Adapt.px(35),
                              image: AssetImage("images/icon_next.png"),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  onTap: () {
                    // //进入每一项
                    // if (_uiSetting.getLeftString(context) ==
                    //     DefinedLocalizations.of(context).name) {
                    _editerAutomationName();
                    // } else {
                    //   showPickerNumber(context);
                    // }
                  },
                ))
          ],
        );
      },
    );
  }

  void _editerAutomationName() async {
    await showCupertinoDialog(
        //模态框
        context: context,
        builder: (BuildContext context) {
          return SystemPadding(
            child: CupertinoAlertDialog(
              title: Text(
                DefinedLocalizations.of(context).addAutoNameInput,
                style: TEXT_STYLE_INPUT_HINT,
              ),
              content: Column(
                //name + input
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: Adapt.px(20)),
                  ),
                  CupertinoTextField(
                    autocorrect: true,
                    controller: _automationNameController,
                  )
                ],
              ),
              actions: <Widget>[
                //操作选项
                CupertinoDialogAction(
                  child: Text(
                    DefinedLocalizations.of(context).cancel,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).maybePop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    DefinedLocalizations.of(context).confirm,
                  ),
                  onPressed: () {
                    // _uiSetting.settingValue = _automationNameController.text;
                    widget.automationSet.name = _automationNameController.text;
                    Navigator.of(context, rootNavigator: true).maybePop();
                    setState(() {});
                  },
                ),
              ],
            ),
          );
        });
  }

  String getAutoLightRepeat() {
    if (_weekdayNames.length != 7) {
      _weekdayNames.add(DefinedLocalizations.of(context).weekday0);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday1);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday2);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday3);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday4);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday5);
      _weekdayNames.add(DefinedLocalizations.of(context).weekday6);
    }
    String result = " ";
    bool allWeekends = false;
    bool noWeekends = false;
    bool allWorkdays = false;
    bool noWorkdays = false;
    if (widget.automationSet.autoset[0].auto.cond.composed.conditions.length ==
        0) return "";
    var c = widget
        .automationSet.autoset[0].auto.cond.composed.conditions[0].calendar;
    if (c.repeat == false)
      return DefinedLocalizations.of(context).autoDefaultRepeat;
    if (c.enables.length != 7) {
      return result;
    }
    if (c.enables[0] && c.enables[6]) {
      allWeekends = true;
    }
    if (!c.enables[0] && !c.enables[6]) {
      noWeekends = true;
    }
    if (c.enables[1] &&
        c.enables[2] &&
        c.enables[3] &&
        c.enables[4] &&
        c.enables[5]) {
      allWorkdays = true;
    }
    if (!c.enables[1] &&
        !c.enables[2] &&
        !c.enables[3] &&
        !c.enables[4] &&
        !c.enables[5]) {
      noWorkdays = true;
    }
    if (allWeekends && allWorkdays) {
      result = DefinedLocalizations.of(context).everyday;
      return result;
    }
    if (allWeekends && noWorkdays) {
      result = DefinedLocalizations.of(context).weekend;
      return result;
    }
    if (noWeekends && allWorkdays) {
      result = DefinedLocalizations.of(context).workday;
      return result;
    }
    if (noWeekends && noWorkdays) {
      return result;
    }
    var i = 0;
    for (var e in c.enables) {
      if (e) result += _weekdayNames[i] + ", ";
      ++i;
    }
    result = result.substring(0, result.lastIndexOf(','));
    // c.enables
    // }
    return result;
  }

  String getAutoTime(Automation automation) {
    if (automation.auto.cond.hasComposed() &&
        automation.auto.cond.composed.conditions.length > 0) {
      protobuf.CalendarCondition cCond =
          automation.auto.cond.composed.conditions[0].calendar;
      var time = cCond.calendarDayTime.hour.toString() +
          ":" +
          cCond.calendarDayTime.min.toString() +
          ":" +
          cCond.calendarDayTime.sec.toString();
      return time;
    }
    return "";
  }

  String getAutoTimeSm(Automation automation) {
    if (automation.auto.cond.hasComposed() &&
        automation.auto.cond.composed.conditions.length > 0) {
      protobuf.CalendarCondition cCond =
          automation.auto.cond.composed.conditions[0].calendar;
      var timeSm;
      if (cCond.calendarDayTime.hour > 12) {
        return timeSm = DefinedLocalizations.of(context).afternoon;
      } else {
        return timeSm = DefinedLocalizations.of(context).morning;
      }
    }
    return "";
  }

  String getAutoLightVal(Automation automation) {
    // protobuf.Action action = automation.auto.exec.sequenced.executions[0].action;
    if (automation.auto.exec.sequenced.executions[1].action.action.actions[0]
            .attrID.value ==
        43) {
      return DefinedLocalizations.of(context).brightness +
          automation.auto.exec.sequenced.executions[1].action.action.actions[0]
              .attrValue
              .toString();
    }
    return "";
  }

  Widget _buildAutoItem(
      BuildContext context, int index, Automation automation) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
          height: Adapt.px(240),
          color: Color(0xfff9f9f9),
          margin: EdgeInsets.only(
              left: Adapt.px(40), right: Adapt.px(40), bottom: Adapt.px(20)),
          padding: EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          getAutoTimeSm(automation),
                          style: TextStyle(
                              fontSize: Adapt.px(45), color: Color(0x732D3B46)),
                        ),
                        Text(
                          getAutoTime(automation),
                          style: TextStyle(
                              fontSize: 22.0, color: Color(0x732D3B46)),
                        )
                      ],
                    ),
                  ),
                  Container(
                      child: Text(
                    getAutoLightVal(automation),
                    style: TextStyle(
                        fontSize: Adapt.px(40), color: Color(0x55899198)),
                  ))
                ],
              ),
              Image(
                height: Adapt.px(35),
                width: Adapt.px(19),
                image: AssetImage("images/icon_next.png"),
              )
            ],
          )),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
            builder: (context) => AutoLightTimeSet(
                  automationSet: widget.automationSet,
                  automation: automation,
                  deviceList: widget.deviceList,
                ),
            settings: RouteSettings(name: "/AutoLightTimeSet")));
      },
    );
  }
}

class _Group {
  int size() {
    return 0;
  }

  Object get(int index) {
    return Object();
  }
}

class _AutoGroup extends _Group {
  //场景执行
  final List<_UiAutoGroup> _uiAutoGroup = List();
  void add(Scene scene) {
    _uiAutoGroup.add(
      _UiAutoGroup(
        scene: scene,
      ),
    );
  }

  void clear() {
    _uiAutoGroup.clear();
  }

  int size() {
    return _uiAutoGroup.length > 0 ? _uiAutoGroup.length : 0;
  }

  void remove(index) {
    _uiAutoGroup.remove(index);
  }

  Object get(int index) => _uiAutoGroup[index];
}

class _DeviceGroup extends _Group {
  List<_UiDeviceEntity> _uiDeviceEntity = List();
  void add(LogicDevice logicDevice) {
    _uiDeviceEntity.add(
      _UiDeviceEntity(logicDevice: logicDevice),
    );
  }

  void removeDevice(int index) {
    _uiDeviceEntity.removeAt(index);
  }

  void remove(index) {
    _uiDeviceEntity.remove(index);
  }

  void clear() {
    _uiDeviceEntity.clear();
  }

  int size() {
    return _uiDeviceEntity.length > 0 ? _uiDeviceEntity.length : 0;
  }

  int getindex(element) {
    return _uiDeviceEntity.indexOf(element);
  }

  Object get(int index) => _uiDeviceEntity[index];
}

class _UiEntity {}

class _UiAutoGroup extends _UiEntity {
  final Scene scene;
  _UiAutoGroup({
    @required this.scene,
  });
  bool _selected = false;
  bool get selected => _selected;
  set selected(bool selected) => _selected = selected;
}

class _UiDeviceEntity extends _UiEntity {
  final LogicDevice logicDevice;
  _UiDeviceEntity({
    @required this.logicDevice,
  });

  String getDeviceRoomName(BuildContext context, String roomUuid) {
    final HomeCenterCache entities = HomeCenterManager().defaultHomeCenterCache;
    final List<Room> rooms = entities.rooms;
    // return DefinedLocalizations.of(context).roomDefault;
    for (var item in rooms) {
      if (roomUuid == item.uuid) {
        if (item.name == "") {
          return DefinedLocalizations.of(context).undefinedArea;
        }
        return item.name;
      }
    }
    return DefinedLocalizations.of(context).roomDefault;
  }

  bool _selected = false;
  bool get selected => _selected;
  set selected(bool selected) => _selected = selected;

  bool checked = false;
}
