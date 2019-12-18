import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/const/adapt.dart';
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/page/auto_exec_set_timer_page.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/page/auto_exec_select_device_page.dart';
import 'package:xlive/data/data_shared.dart';
import 'dart:ui';

class AutoSelectExecutionType extends StatefulWidget {
  //这个一定要跟着createstate
  final Automation automation; //带参数的类的实现方法

  AutoSelectExecutionType({
    @required
        this.automation, //带参数的类的实现方法 和上面一起的  下面的类_AutoMationPage要在怎么用呢 就是widgei.参数名 就行了
  });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoExecutionPage();
  }
}

class _AutoExecutionPage extends State<AutoSelectExecutionType> {
  void initState() {
    //onshow
    super.initState();
    _resetData();
  }

  void _resetData() {
    print("---------------auto_select_execution_type_page.dart");
    if (widget.automation == null) return;

    setState(() {});
  }

  void dispose() {
    //页面卸载是执行的
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CommonPage(
        title: DefinedLocalizations.of(context).selectExecutiveCategory,
        showBackIcon: true,
        child: _buildSelectConditionClassify(context));
  }

  Widget _buildSelectConditionClassify(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: Adapt.px(180),
              color: Color(0xfff9f9f9),
              margin: EdgeInsets.only(bottom: Adapt.px(15)),
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Image(
                          width: Adapt.px(79),
                          height: Adapt.px(78),
                          image: AssetImage("images/auto_device.png"),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                              DefinedLocalizations.of(context).deviceAndScene,
                              style: TextStyle(
                                  fontSize: Adapt.px(45),
                                  color: Color(0xff55585a))),
                        )
                      ],
                    ),
                  ),
                  Image(
                    width: Adapt.px(19),
                    height: Adapt.px(35),
                    image: AssetImage("images/icon_next.png"),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(
                      builder: (context) => AutoExecSelectDevice(
                            automation: widget.automation,
                          ),
                      settings: RouteSettings(name: "/AutoExecSelectDevice")));
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: Adapt.px(180),
              color: Color(0xfff9f9f9),
              margin: EdgeInsets.only(bottom: Adapt.px(15)),
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Image(
                          width: Adapt.px(75),
                          height: Adapt.px(75),
                          image: AssetImage("images/auto_time_table.png"),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                            DefinedLocalizations.of(context).decelerator,
                            style: TextStyle(
                                fontSize: Adapt.px(45),
                                color: Color(0xff55585a)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Image(
                    width: Adapt.px(19),
                    height: Adapt.px(35),
                    image: AssetImage("images/icon_next.png"),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                      builder: (context) =>
                          AutoExecSetTimer(automation: widget.automation),
                      settings: RouteSettings(name: "/AutoExecSetTimer")));
            },
          ),
        ],
      ),
    );
  }
}
