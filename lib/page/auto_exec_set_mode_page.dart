import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
// import 'package:xlive/const/const_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'dart:async';
import 'dart:ui';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:xlive/page/auto_exec_set_looptype_page.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'common_page.dart';

class AutoExecSetMode extends StatefulWidget {
  final Automation automation;
  final protobuf.Execution exec;
  AutoExecSetMode({this.automation, this.exec});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoSelectExecutionTypePage();
  }
}

class _AutoSelectExecutionTypePage extends State<AutoExecSetMode> {
  StreamSubscription _subscription; //消息通道
  _Group _group = _Group();
  int radiovalue = 0;
  void initState() {
    //onshow
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    print("--------------------auto_exec_set_mode_page.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    _group.add(0);
    _group.add(1);
    _group.add(2);
    if (widget.automation.auto.exec != null) {
      if (widget.automation.auto.exec.hasSequenced()) {
        if (widget.automation.auto.exec.sequenced.parameter == 2) {
          radiovalue = 2;
        }
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

  void setMode(exec) {
    switch (radiovalue) {
      case 0:
        exec.method = protobuf.ExecutionMethod.EM_ON_OFF;
        exec.parameter = 1;
        break;
      case 1:
        exec.method = protobuf.ExecutionMethod.EM_ANGULAR;
        exec.parameter = 1;
        break;
      case 2:
        exec.method = protobuf.ExecutionMethod.EM_ON_OFF;
        exec.parameter = 2;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
        title: DefinedLocalizations.of(context).autoExecutionMode,
        showBackIcon: true,
        trailing: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            alignment: Alignment.centerRight,
            width: Adapt.px(200),
            child: Image(
              width: Adapt.px(63),
              height: 20,
              image: AssetImage("images/edit_done.png"),
            ),
          ),
          onTap: () {
            if (widget.exec != null) {
              if (widget.exec.hasScene()) {
                setMode(widget.exec.scene);
              } else if (widget.exec.hasAction()) {
                setMode(widget.exec.action);
              } else if (widget.exec.hasSequenced()) {
                setMode(widget.exec.sequenced);
              }
            } else {
              if (widget.automation.getTotalExecutionCount() > 0) {
                if (widget.automation.getExecutionGroupCount() > 1) {
                } else {
                  protobuf.Execution exec = widget.automation.auto.exec;
                  if (exec.hasScene()) {
                    setMode(exec.scene);
                  } else if (exec.hasAction()) {
                    setMode(exec.action);
                  } else if (exec.hasSequenced()) {
                    setMode(exec.sequenced);
                  }
                }
              } else {
                var seqExec = protobuf.SequencedExecution.create();
                var exec = protobuf.Execution.create();
                setMode(seqExec);
                exec.sequenced = seqExec;
                widget.automation.auto.exec = exec;
              }
            }
            Navigator.of(context, rootNavigator: true).maybePop();
          },
        ),
        child: Container(
          margin: EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(40)),
          child: _buildExecutionTypeAll(context),
        ));
  }

  bool isCirculation() {
    if (widget.exec != null && widget.exec.hasSequenced() && radiovalue == 2)
      return false;
    if (widget.exec != null && !widget.exec.hasSequenced()) return true;
    if (widget.automation.getExecutionGroupCount() > 1) {
    } else if (widget.automation.getExecutionGroupCount() == 1) {
      if (radiovalue == 2) {
        return false;
      }
      return true;
    }
    return true;
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
      timeStr = hour.toString() + DefinedLocalizations.of(context).hour;
    }
    if (min > 0) {
      timeStr += min.toString() + DefinedLocalizations.of(context).minute;
    }
    if (sec > 0) {
      timeStr += sec.toString() + DefinedLocalizations.of(context).second;
    }
    return timeStr;
  }

  String circulation() {
    var exec;
    if (widget.exec != null && widget.exec.hasSequenced()) {
      exec = widget.exec;
    } else if (widget.automation.auto.exec.hasSequenced()) {
      exec = widget.automation.auto.exec;
    } else {
      return "";
    }
    if (exec != null && exec.hasSequenced()) {
      switch (exec.sequenced.loopType) {
        case protobuf.ExecutionLoopType.ELT_LOOP_PERIOD:
          return getTimeStr(exec.sequenced.loopParameter);
          break;
        case protobuf.ExecutionLoopType.ELT_LOOP_TIMES:
          if (exec.sequenced.loopParameter == 0) {
            return "";
          }
          return exec.sequenced.loopParameter.toString() +
              DefinedLocalizations.of(context).selectTime;
          break;
        default:
          return "";
      }
    }
    return "";
  }

  Widget _buildExecutionTypeAll(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: Adapt.px(114)),
          height: 153.0,
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: _group.size(),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final Object obj = _group.get(index);
              return _buildExecutionTypeItem(context, obj, index);
            },
          ),
        ),
        Offstage(
          offstage: isCirculation(),
          child: Container(
              height: Adapt.px(160),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: Adapt.px(160),
                  margin: EdgeInsets.only(
                    left: Adapt.px(40),
                    right: Adapt.px(40),
                  ),
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
                        DefinedLocalizations.of(context).loop,
                        style: TextStyle(
                            fontSize: Adapt.px(46), color: Color(0xff55585a)),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Offstage(
                                offstage: false,
                                child: Container(
                                  margin: EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    circulation(),
                                    style: TextStyle(
                                        fontSize: Adapt.px(46),
                                        color: Color(0x732d3b46)),
                                  ),
                                )),
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
                  Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                          builder: (context) => AutoExecSetLooptype(
                                automation: widget.automation,
                                exec: widget.automation.auto.exec,
                              ),
                          settings:
                              RouteSettings(name: "/AutoExecSetLooptype")));
                },
              )),
        )
      ],
    );
  }

  bool isNotAngle(int index) {
    if (widget.automation.auto.cond.composed.conditions.length > 0) {
      for (var item in widget.automation.auto.cond.composed.conditions) {
        if (index != 1 && !item.hasAngular()) {
          return false;
        }
        return true;
      }
    } else {
      if (index != 1) {
        return false;
      }
    }

    return true;
  }

  bool isAngle(int index) {
    if (widget.automation.auto.cond.composed.conditions.length > 0) {
      for (var item in widget.automation.auto.cond.composed.conditions) {
        if (index == 1 && item.hasAngular()) {
          return false;
        }
        return true;
      }
    }
    return true;
  }

  Widget _buildExecutionTypeItem(
      BuildContext context, _SelectType _selectType, int index) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: isNotAngle(index),
          child: Column(
            children: <Widget>[
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: Adapt.px(160),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Color(0x33000000),
                                style: BorderStyle.solid))),
                    margin: EdgeInsets.only(
                        left: 10.0,
                        right: index == radiovalue ? 10.0 : Adapt.px(40)),
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_selectType.getLeftString(context)),
                        Image(
                          width:
                              index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                          height:
                              index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                          image: AssetImage(index == radiovalue
                              ? "images/icon_check.png"
                              : 'images/icon_uncheck.png'),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      radiovalue = index;
                    });
                  }),
            ],
          ),
        ),
        Offstage(
          offstage: isAngle(index),
          child: Column(
            children: <Widget>[
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: Adapt.px(160),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Color(0x33000000),
                                style: BorderStyle.solid))),
                    margin: EdgeInsets.only(
                        left: 10.0,
                        right: index == radiovalue ? 10.0 : Adapt.px(40)),
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_selectType.getLeftString(context)),
                        Image(
                          width:
                              index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                          height:
                              index == radiovalue ? Adapt.px(63) : Adapt.px(31),
                          image: AssetImage(index == radiovalue
                              ? "images/icon_check.png"
                              : 'images/icon_uncheck.png'),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      radiovalue = index;
                    });
                  }),
            ],
          ),
        )
      ],
    );
  }
}

class _SelectType {
  //按键
  int type;

  _SelectType({this.type});

  String getLeftString(BuildContext context) {
    switch (type) {
      case 0:
        return DefinedLocalizations.of(context).modelSet;
        break;
      case 1:
        return DefinedLocalizations.of(context).modelAngle;
        break;
      case 2:
        return DefinedLocalizations.of(context).modelFlip;
        break;
      default:
        return " ";
    }
  }
}

class _Group {
  // final Entity entity;
  // bool selected;
  // int type;
  final List<_SelectType> _selectType = List();
  void add(int type) {
    _selectType.add(
      _SelectType(
        type: type,
      ),
    );
  }

  void clear() {
    _selectType.clear();
  }

  int size() {
    return _selectType.length > 0 ? _selectType.length : 0;
  }

  Object get(int index) => _selectType[index];
}
