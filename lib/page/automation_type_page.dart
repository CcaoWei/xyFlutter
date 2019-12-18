import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/const/adapt.dart';
import 'package:xlive/localization/defined_localization.dart'; //字符
// import 'package:xlive/page/auto_setting_timer_page.dart';
import 'package:xlive/page/auto_timer_page.dart';
import 'package:xlive/page/automation_detail_page.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/data/data_shared.dart';
import 'dart:async';
import 'dart:ui';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;

class AutomationType extends StatefulWidget {
  //这个一定要跟着createstate
  final Automation automation; //带参数的类的实现方法

  AutomationType({
    this.automation, //带参数的类的实现方法 和上面一起的  下面的类_AutoMationPage要在怎么用呢 就是widgei.参数名 就行了
  });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreatAutomationPage();
  }
}

class _CreatAutomationPage extends State<AutomationType> {
  StreamSubscription _subscription; //消息通道

  void initState() {
    //onshow
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    print("---------------automation_type_page.dart");
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
    //     .where((event) => event is HomeCenterCache)
    //     .listen((event) {

    //     _resetData();
    // });
  }

  @override
  Widget build(BuildContext context) {
    // widget.automation.auto.cond.composed.clear();
    // TODO: implement build
    return CommonPage(
        title: DefinedLocalizations.of(context).createAutoMation,
        showBackIcon: true,
        child: _buildCreateAutoMation());
  }

  Widget _buildCreateAutoMation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            height: Adapt.px(240),
            color: Color(0xFFF9F9F9),
            margin: EdgeInsets.only(
                left: 15.0, right: 15.0, bottom: 7.0, top: 20.0),
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image(
                        width: Adapt.px(75),
                        height: Adapt.px(75),
                        image: AssetImage('images/auto_time_table.png'),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                DefinedLocalizations.of(context).autoCondTime,
                                style: TextStyle(
                                    fontSize: Adapt.px(45),
                                    color: Color(0xff55585a)),
                              ),
                              Text(
                                DefinedLocalizations.of(context).weeklyPlan,
                                style: TextStyle(
                                    fontSize: Adapt.px(36),
                                    color: Color(0x50899198)),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Image(
                    width: Adapt.px(19),
                    height: Adapt.px(32),
                    image: AssetImage('images/icon_next.png'),
                  )
                ],
              ),
              onTap: () {
                //进入时间表的页面
                Automation automation;
                var newAutomation = protobuf.Automation.create();
                var newCond = protobuf.Condition.create();
                var cc = protobuf.ComposedCondition.create();
                cc.operator = protobuf.ConditionOperator.OP_AND;
                newCond.composed = cc;
                var execu = protobuf.Execution.create();
                newAutomation.cond = newCond;
                newAutomation.exec = execu;
                automation = Automation(
                    newAutomation,
                    HomeCenterManager().defaultHomeCenter.supportAutoVersion < 0
                        ? " "
                        : DefinedLocalizations.of(context).createAutoMation);
                automation.enable = true;
                var calendarC = protobuf.CalendarCondition.create();
                var dayTime = protobuf.DayTime.create();
                dayTime.hour = -1;
                dayTime.min = -1;
                dayTime.sec = -1;
                calendarC.calendarDayTime = dayTime;
                calendarC.repeat = false;
                calendarC.enables.add(false);
                calendarC.enables.add(false);
                calendarC.enables.add(false);
                calendarC.enables.add(false);
                calendarC.enables.add(false);
                calendarC.enables.add(false);
                calendarC.enables.add(false);
                var newc = protobuf.Condition.create();
                newc.calendar = calendarC;
                newCond.composed.conditions.add(newc);
                Navigator.of(context, rootNavigator: true)
                    .push(CupertinoPageRoute(
                        builder: (context) => AutomationDetail(
                              automation: automation,
                              newAuto: true,
                            ),
                        settings: RouteSettings(name: "/AutomationDetail")));
              },
            )),
        Container(
            height: Adapt.px(240),
            color: Color(0xFFF9F9F9),
            margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 7.0),
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image(
                        width: Adapt.px(75),
                        height: Adapt.px(89),
                        image: AssetImage('images/auto_timer.png'),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                DefinedLocalizations.of(context).countDown,
                                style: TextStyle(
                                    fontSize: Adapt.px(45),
                                    color: Color(0xff55585a)),
                              ),
                              Text(
                                DefinedLocalizations.of(context)
                                    .afterPeriodTime,
                                style: TextStyle(
                                    fontSize: Adapt.px(36),
                                    color: Color(0x50899198)),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Image(
                    width: Adapt.px(19),
                    height: Adapt.px(32),
                    image: AssetImage('images/icon_next.png'),
                  )
                ],
              ),
              onTap: () {
                //进入定时器页面
                Automation automation;
                var newAutomation = protobuf.Automation.create();
                var newCond = protobuf.Condition.create();
                var cc = protobuf.ComposedCondition.create();
                cc.operator = protobuf.ConditionOperator.OP_AND;
                newCond.composed = cc;
                var execu = protobuf.Execution.create();
                var cond = protobuf.Condition.create();
                var timerC = protobuf.TimerCondition.create();
                Int64 time = Int64(1);
                timerC.timeoutMS = time;
                cond.timer = timerC;
                newCond.composed.conditions.add(cond);
                newAutomation.cond = newCond;
                newAutomation.exec = execu;
                automation = Automation(
                    newAutomation,
                    HomeCenterManager().defaultHomeCenter.supportAutoVersion < 0
                        ? " "
                        : DefinedLocalizations.of(context).createAutoMation);
                automation.enable = true;
                Navigator.of(context, rootNavigator: true)
                    .push(CupertinoPageRoute(
                        builder: (context) => AutoTimer(
                              automation: automation,
                            ),
                        settings: RouteSettings(name: "/AutoTimer")));
              },
            )),
        Container(
            height: Adapt.px(240),
            color: Color(0xFFF9F9F9),
            margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 7.0),
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image(
                        width: Adapt.px(78),
                        height: Adapt.px(78),
                        image: AssetImage('images/auto_condition.png'),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                DefinedLocalizations.of(context).autoCondIfThen,
                                style: TextStyle(
                                    fontSize: Adapt.px(45),
                                    color: Color(0xff55585a)),
                              ),
                              Text(
                                DefinedLocalizations.of(context).conditionsMet,
                                style: TextStyle(
                                    fontSize: Adapt.px(36),
                                    color: Color(0x50899198)),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Image(
                    width: Adapt.px(19),
                    height: Adapt.px(32),
                    image: AssetImage('images/icon_next.png'),
                  )
                ],
              ),
              onTap: () {
                //进入如果就的页面
                Automation automation;
                var newAutomation = protobuf.Automation.create();
                var newCond = protobuf.Condition.create();
                var cc = protobuf.ComposedCondition.create();
                cc.operator = protobuf.ConditionOperator.OP_AND;
                newCond.composed = cc;
                var execu = protobuf.Execution.create();
                newAutomation.cond = newCond;
                newAutomation.exec = execu;
                automation = Automation(
                    newAutomation,
                    HomeCenterManager().defaultHomeCenter.supportAutoVersion < 0
                        ? " "
                        : DefinedLocalizations.of(context).createAutoMation);
                automation.enable = true;
                Navigator.of(context, rootNavigator: true)
                    .push(CupertinoPageRoute(
                        builder: (context) => AutomationDetail(
                              automation: automation,
                              newAuto: true,
                            ),
                        settings: RouteSettings(name: "/AutomationDetail")));
              },
            )),
        // Container(
        //     height: Adapt.px(240),
        //     color: Color(0xFFF9F9F9),
        //     margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 7.0),
        //     padding: EdgeInsets.only(left: 15.0, right: 15.0),
        //     child: GestureDetector(
        //       behavior: HitTestBehavior.opaque,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: <Widget>[
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             children: <Widget>[
        //               Image(
        //                 width: Adapt.px(90),
        //                 height: Adapt.px(75),
        //                 image: AssetImage('images/auto_light_time.png'),
        //               ),
        //               Container(
        //                 margin: EdgeInsets.only(left: 30.0),
        //                 child: Text(
        //                   "照明时间表",
        //                   style: TextStyle(
        //                       fontSize: Adapt.px(45), color: Color(0xff55585a)),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Image(
        //             width: Adapt.px(19),
        //             height: Adapt.px(32),
        //             image: AssetImage('images/icon_next.png'),
        //           )
        //         ],
        //       ),
        //       onTap: () {
        //         AutomationSet automationSet;
        //         var newAutomationSet = protobuf.AutomationSet.create();
        //         automationSet = AutomationSet(newAutomationSet, "照明时间表");
        //         automationSet.enable = true;

        //         Navigator.of(context, rootNavigator: true)
        //             .push(CupertinoPageRoute(
        //                 builder: (context) => AutoDeviceLight(
        //                       automationSet: automationSet,
        //                     ),
        //                 settings: RouteSettings(name: "/AutoDeviceLight")));
        //       },
        //     )),
      ],
    );
  }
}
