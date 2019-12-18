import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/const/adapt.dart';
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/page/auto_light_time_detail_page.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'dart:async';
import 'dart:ui';
import 'package:xlive/widget/xy_color_picker.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/widget/switch_button.dart';
import 'package:xlive/protocol/const.pbenum.dart' as pbConst;

class AutoLightTimeSet extends StatefulWidget {
  //这个一定要跟着createstate
  final AutomationSet automationSet;
  final List deviceList;
  final Automation automation;

  AutoLightTimeSet({this.automationSet, this.deviceList, this.automation});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoLightTimeSetPage();
  }
}

class _AutoLightTimeSetPage extends State<AutoLightTimeSet> {
  int _value = 0;
  StreamSubscription _subscription; //消息通道
  double progressValue = 0.0;
  bool deviceBtn = false;
  int colorValuer = 0;
  Color currentColor = const Color(0xff443a49);
  void initState() {
    //onshow
    super.initState();
    _resetData();
    _start();
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
        if (event.auto.uuid != widget.automation.uuid) return;
        _resetData();
        setState(() {}); //刷新界面 相当于setData
      } else if (event is AutomationUpdatedEvent) {
        if (event.auto.uuid != widget.automation.uuid) return;
        _resetData();
        setState(() {});
      }
    });
  }

  void _resetData() {
    print("------------------AutoLightTimeSet.dart");
    if (widget.automation != null) {
      widget.automation.auto.exec.sequenced.executions[0].action.action
                  .actions[0].attrValue ==
              1
          ? deviceBtn = true
          : deviceBtn = false;
      // widget.automation.auto.exec.sequenced.executions[0].action.action.actions[0].attrValue == 1 ?deviceBtn=true:deviceBtn=false;
      progressValue = widget.automation.auto.exec.sequenced.executions[1].action
          .action.actions[0].attrValue
          .toDouble();
      _value = widget.automation.auto.exec.sequenced.executions[1].action.action
          .actions[0].attrValue;
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

  void changeColor(Color color) => setState(() {
        currentColor = color;
        colorValuer = color.value;
      });
  void changeColorAndPopout(Color color) => setState(() {
        currentColor = color;
        Timer(const Duration(milliseconds: 500),
            () => Navigator.of(context).maybePop());
      });
  @override
  Widget build(BuildContext context) {
    for (var item in widget.automationSet.autoset) {
      item.parseInnerAuto();
    }
    return CommonPage(
      title: "照明设置",
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
          if (widget.automation != null) {
            for (var exec in widget.automation.auto.exec.sequenced.executions) {
              for (var action in exec.action.action.actions) {
                if (action.attrID.value == 0) {
                  deviceBtn ? action.attrValue = 1 : action.attrValue = 0;
                } else if (action.attrID.value == 43) {
                  action.attrValue = progressValue.toInt();
                }
              }
            }
            Navigator.of(context).maybePop();
            return;
          }
          Automation automation;
          var newAutomation = protobuf.Automation.create();
          var newCond = protobuf.Condition.create();
          // always put conditions in composed
          var cc = protobuf.ComposedCondition.create();
          newCond.composed = cc;
          var execu = protobuf.Execution.create();
          newAutomation.cond = newCond;
          newAutomation.exec = execu;
          automation = Automation(
              newAutomation,
              HomeCenterManager().defaultHomeCenter.supportAutoVersion < 0
                  ? ""
                  : DefinedLocalizations.of(context).createAutoMation);
          automation.enable = true;

          protobuf.SequencedExecution allEx;
          allEx = protobuf.SequencedExecution.create();
          allEx.method = protobuf.ExecutionMethod.EM_ON_OFF;
          allEx.parameter = 1;
          allEx.loopType = protobuf.ExecutionLoopType.ELT_LOOP_TIMES;
          allEx.loopParameter = Int64(1);
          //只有设备
          for (LogicDevice deSel in widget.deviceList) {
            var actionExecution1 = protobuf.ActionExecution.create();
            var actionExecution2 = protobuf.ActionExecution.create();
            var actionExecution3 = protobuf.ActionExecution.create();
            var composedAction1 = protobuf.ComposedAction.create();
            var composedAction2 = protobuf.ComposedAction.create();
            var composedAction3 = protobuf.ComposedAction.create();
            var atomicAction1 = protobuf.AtomicAction.create();
            var atomicAction2 = protobuf.AtomicAction.create();
            var atomicAction3 = protobuf.AtomicAction.create();
            var execution1 = protobuf.Execution.create();
            var execution2 = protobuf.Execution.create();
            var execution3 = protobuf.Execution.create();
            atomicAction1.uUID = deSel.uuid;
            atomicAction1.attrID = pbConst.AttributeID.AttrIDOnOffStatus;
            deviceBtn
                ? atomicAction1.attrValue = 1
                : atomicAction1.attrValue = 0;
            actionExecution1.action = composedAction1;
            actionExecution1.method = protobuf.ExecutionMethod.EM_ON_OFF;
            actionExecution1.parameter = 1;
            execution1.action = actionExecution1;

            atomicAction2.uUID = deSel.uuid;
            atomicAction2.attrID = pbConst.AttributeID.AttrIDLCTargetLevel;
            atomicAction2.attrValue = _value;
            actionExecution2.action = composedAction2;
            actionExecution2.method = protobuf.ExecutionMethod.EM_ON_OFF;
            actionExecution2.parameter = 1;
            execution2.action = actionExecution2;

            atomicAction3.uUID = deSel.uuid;
            atomicAction3.attrID = pbConst.AttributeID.AttrIDColorTemperature;
            atomicAction3.attrValue = colorValuer;
            actionExecution3.action = composedAction3;
            actionExecution3.method = protobuf.ExecutionMethod.EM_ON_OFF;
            actionExecution3.parameter = 1;
            execution3.action = actionExecution3;

            composedAction1.actions.add(atomicAction1);
            composedAction2.actions.add(atomicAction2);
            composedAction3.actions.add(atomicAction3);
            allEx.executions.add(execution1);
            allEx.executions.add(execution2);
            allEx.executions.add(execution3);
          }
          automation.auto.exec.sequenced = allEx;
          widget.automationSet.autoset.add(automation);
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => AutoLightTimeDetail(
                  automationSet: widget.automationSet,
                  deviceList: widget.deviceList),
              settings: RouteSettings(name: "/AutoLightTimeDetail")));
        },
      ),
      child: _buildLightSet(context),
    );
  }

  String getLightName(bool deviceBtn) {
    String result;
    if (deviceBtn) {
      result = DefinedLocalizations.of(context).open;
    } else {
      result = DefinedLocalizations.of(context).close;
    }
    if (widget.deviceList == null) {
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
      return result;
    }

    // }
    for (LogicDevice item in widget.deviceList) {
      result += item.getName() + " ";
    }
    return result;
  }

  Widget _buildLightSet(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Container(
          margin: EdgeInsets.only(
              left: Adapt.px(40), right: Adapt.px(40), top: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: Adapt.px(240),
                color: Color(0xfff9f9f9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: Adapt.px(40)),
                          child: Image(
                            width: Adapt.px(105),
                            height: Adapt.px(108),
                            image: AssetImage(deviceBtn
                                ? 'images/icon_light_on.png'
                                : 'images/icon_light_off.png'),
                          ),
//                        ),
                        ),
                        Container(
                          width: Adapt.px(330),
                          margin: EdgeInsets.only(left: Adapt.px(40)),
                          child: Text(
                            getLightName(deviceBtn),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: Adapt.px(45),
                                color: Color(0xff55585a)),
                          ),
                        ),
                      ],
                    ),
                    SwitchButton(
                      activeColor: Color(0xFF7cd0ff),
                      showIndicator: false,
                      showText: false,
                      // value: getAutoEnable(),
                      value: deviceBtn,
                      onChanged: (bool value) {
                        deviceBtn = value;
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: Adapt.px(120), bottom: Adapt.px(42)),
                child: Text(
                  DefinedLocalizations.of(context).colorTemperature,
                  style: TextStyle(
                      fontSize: Adapt.px(42), color: Color(0xff9b9b9b)),
                ),
              ),
              Container(
                  height: Adapt.px(240),
                  color: Color(0xfff9f9f9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "0K",
                        style: TextStyle(
                            fontSize: Adapt.px(36), color: Color(0x50899198)),
                      ),
                      Container(
                        child: SingleChildScrollView(
                          child: ColorPicker(
                            // pickerColor: currentColor,
                            pickerColor: currentColor,
                            onColorChanged: changeColor,
                            colorPickerWidth: Adapt.px(720),
                            pickerAreaHeightPercent: 0,
                            enableAlpha: false,
                          ),
                        ),
                      ),
                      Text(
                        "8000K",
                        style: TextStyle(
                            fontSize: Adapt.px(36), color: Color(0x50899198)),
                      )
                    ],
                  )),
              Container(
                margin:
                    EdgeInsets.only(top: Adapt.px(120), bottom: Adapt.px(42)),
                child: Text(
                  DefinedLocalizations.of(context).brightness,
                  style: TextStyle(
                      fontSize: Adapt.px(42), color: Color(0xff9b9b9b)),
                ),
              ),
              Container(
                  height: Adapt.px(240),
                  color: Color(0xfff9f9f9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "0%",
                        style: TextStyle(
                            fontSize: Adapt.px(36), color: Color(0x50899198)),
                      ),
                      Container(
                        width: Adapt.px(720),
                        child: Slider(
                          value: progressValue,
                          // activeColor: Color(value),
                          label: '$_value' + "%",
                          divisions: 99,
                          onChanged: (double) {
                            setState(() {
                              progressValue =
                                  double.floorToDouble(); //转化成double
                              _value = progressValue.toInt();
                            });
                          },
                          min: 0.0,
                          max: 100.0,
                        ),
                      ),
                      Text(
                        "100%",
                        style: TextStyle(
                            fontSize: Adapt.px(36), color: Color(0x50899198)),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
