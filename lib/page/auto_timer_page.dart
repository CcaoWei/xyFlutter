import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/page/auto_exec_select_device_page.dart';
import 'package:xlive/page/auto_exec_set_mode_page.dart';
import 'package:xlive/page/auto_exec_set_timer_page.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/session/app_state_manager.dart';
import 'package:xlive/session/session.dart';
import 'package:xlive/utils/public_fun.dart';
import 'package:xlive/widget/notification_view.dart';
import 'package:xlive/widget/system_padding.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xlive/page/auto_cond_set_time_frame.dart';
import 'package:xlive/widget/autonmation_exec_icon_view.dart';
import 'package:xlive/page/auto_select_execution_type_page.dart';
import 'package:xlive/widget/xy_picker.dart';
import 'common_page.dart';
import 'dart:ui';

const int TIMER_STATE_INIT = -1;
const int TIMER_STATE_PAUSED = 2;
const int TIMER_STATE_STARTED = 3;
const int TIMER_STATE_STOPPED = 4;
const int TIMER_CMD_CONTINUE = 5;
const int TIMER_STATE_TIMEOUTED = 6;

class _Automation {
  Automation automation;
}

class _OriginalAutomation {
  String _originalCondJson;
  String _originalExecJson;
  bool _originalEnable;
  String _originalName;
}

class AutoTimer extends StatefulWidget {
  final Automation automation;
  final protobuf.Condition condition;

  AutoTimer({
    this.automation,
    this.condition,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoTimerPage();
  }
}

class _AutoTimerPage extends State<AutoTimer> with WidgetsBindingObserver {
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("timer page state change to ${state}");
    if (state == AppLifecycleState.resumed) {
      print("timer page change to resumed");
      _resetData();
    }
  }

  StreamSubscription _subscription; //消息通道
  TextEditingController _automationNameController = TextEditingController();
  SlidableController slidableController;
  _SetGroup _setGroup = _SetGroup();
  _OriginalAutomation _originalAutomation = _OriginalAutomation();
  _Automation _automation = _Automation();
  Timer _timer;
  int nowTime = 0;
  int timems;
  String _holeLabel = "";
  List timerSelect = [0, 0, 0];
  Color otherColor;
  TextStyle otherText;
  String otherName = DefinedLocalizations.of(null).begin;
  void initState() {
    _automation.automation = widget.automation;
    slidableController = new SlidableController(
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    _originalAutomation._originalName = widget.automation.name;
    _originalAutomation._originalCondJson =
        widget.automation.auto.cond.writeToJson();
    _originalAutomation._originalEnable = widget.automation.enable;
    _originalAutomation._originalExecJson =
        widget.automation.auto.exec.writeToJson();
    //onshow
    super.initState();
    _resetData();
    _start();
    WidgetsBinding.instance.addObserver(this);
  }

  Color _fabColor = Colors.blue;

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  void deactivate() {
    print(_automation.automation.uuid);
    print(AppStateManager().history);
    super.deactivate();
  }

  void dispose() {
    print("disposed~~~!!!!");
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _timer = null;
    //页面卸载是执行的
    if (_subscription != null) {
      _subscription.cancel();
    }

    onGoBackClicked();
    super.dispose();
  }

  void _resetData() {
    print("---------------------auto_timer_page.dart");
    print(widget.automation.auto);
    print(widget.automation.enable);
    print(widget.automation.name);
    _setGroup.clear();
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    print(HomeCenterManager().defaultHomeCenter.online);
    if (_automation.automation != null) {
      _automationNameController.text = _automation.automation.name;
    }
    _setGroup.add(0, _automation.automation.name);
    otherColor = Color(0xff9ca8b6);
    otherText = Text_o3;
    if (_automation.automation.uuid == null) return;
    _automation.automation = cache.findEntity(_automation.automation.uuid);
    print(
        "RRRRRRR ${widget.automation.auto.hashCode} ${_automation.automation.auto.hashCode}");
    // widget.automation.auto = _automation.automation.auto;
    var originalTimems = _automation.automation
            .getConditionAt(COND_COUNT)
            .timer
            .timeoutMS
            .toInt() ~/
        1000;
    _holeLabel = formatSeconds(originalTimems);
    setTimerSelect(originalTimems);
    if (_automation.automation.uuid != null) {
      var state = _automation.automation
          .getAttributeValue(ATTRIBUTE_ID_AUTO_TIMER_STATE);

      //主动获取剩余多少时间
      var hc = HomeCenterManager().defaultHomeCenter;
      if (hc == null) return;
      var remainedTimems = _automation.automation
              .getAttributeValue(ATTRIBUTE_ID_AUTO_TIMER_REMAINED_TIME_MS)
              .toInt() ~/
          1000;
      if (remainedTimems > 0) _holeLabel = formatSeconds(remainedTimems);
      MqttProxy.getAutomationTimeoutMs(hc.uuid, _automation.automation.uuid)
          .listen((response) {
        if (response is GetAutomationTimeoutMsResponse) {
          if (response.success) {
            nowTime = response.timeoutms.toInt() ~/ 1000;
            print("getAutomationTimeoutMs new newnewnewnew");
            _holeLabel = formatSeconds(nowTime);
            if (state == TIMER_STATE_STARTED) {
              reGetCountdown();
            }
            setState(() {
              _holeLabel;
            });
          } else {
            print("getAutomationTimeoutMs erro erroerroerroerro");
          }
        }
      });
      // }

      // 2、3、4、5
      //  暂停、启动、停止、继续
      if (state == TIMER_STATE_INIT ||
          state == TIMER_STATE_STOPPED ||
          state == TIMER_STATE_TIMEOUTED) {
        //启动成功
        otherName = DefinedLocalizations.of(null).begin;
        otherText = Text_o3;
        otherColor = Color(0xff9CA8B6);
      } else if (state == TIMER_STATE_PAUSED) {
        otherName = DefinedLocalizations.of(null).timerContinue;
        otherText = Text_o3;
        otherColor = Color(0xff9CA8B6);
      } else if (state == TIMER_STATE_STARTED) {
        //启动
        // reGetCountdown();
        otherName = DefinedLocalizations.of(null).timerStop;
        otherText = Text_o;
        otherColor = Color(0xffffffff);
      } else if (state == TIMER_CMD_CONTINUE) {
        Fluttertoast.showToast(msg: "不合理的状态！！！！！！！ 5");
      }
    } else {
      // create a new timer
      otherName = DefinedLocalizations.of(null).begin;
      otherText = Text_o3;
      otherColor = Color(0xff9CA8B6);
    }
    setState(() {});
  }

  void _start() {
    _subscription = RxBus().toObservable().where((event) {
      if (event is HomeCenterCacheEvent) {
        return event.homeCenterUuid ==
            HomeCenterManager().defaultHomeCenterUuid;
      } else {
        return true;
      }
    }).listen((event) {
      if (event is AutomationUpdatedEvent) {
        if (event.auto.uuid != _automation.automation.uuid) return;
        _automation.automation = event.auto;
        _originalAutomation._originalName = event.auto.name;
        _originalAutomation._originalCondJson =
            event.auto.auto.cond.writeToJson();
        _originalAutomation._originalEnable = event.auto.enable;
        _originalAutomation._originalExecJson =
            event.auto.auto.exec.writeToJson();
        print(event.auto.name);
      } else if (event is AutomationCreatedEvent) {
        if (_automation.automation.uuid == null ||
            _automation.automation.uuid.isEmpty) {
          throw new FormatException("automation uuid 是空的");
        }
        if (event.auto.uuid != _automation.automation.uuid) return;
        _automation.automation = event.auto;
        _originalAutomation._originalName = event.auto.name;
        _originalAutomation._originalCondJson =
            event.auto.auto.cond.writeToJson();
        _originalAutomation._originalEnable = event.auto.enable;
        _originalAutomation._originalExecJson =
            event.auto.auto.cond.writeToJson();
      } else if (event is DeviceAttributeReportEvent) {
        if (event.uuid != _automation.automation.uuid) return;

        if (event.attrId == ATTRIBUTE_ID_AUTO_TIMER_STATE) {
          if (event.attrValue == TIMER_STATE_TIMEOUTED) {
            //  _automation.automation.setAttribute(ATTRIBUTE_ID_AUTO_TIMER_STATE, TIMER_STATE_TIMEOUTED);
          }

          if (event.attrId == ATTRIBUTE_ID_AUTO_TIMER_STATE &&
              event.attrValue == TIMER_STATE_PAUSED) {
            _timer?.cancel();
            _timer = null;
          }
          _resetData();
        }
      } else if (event is SessionStateChangedEvent) {
        _resetData();
      } else if (event is GetEntityCompletedEvent) {
        _resetData();
      }
    });
  }

  String formatSeconds(value) {
    var d = Duration(seconds: value);
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void setTimerSelect(int newTimeSecond) {
    var d = Duration(seconds: newTimeSecond);
    timerSelect = [
      d.inHours.remainder(24),
      d.inMinutes.remainder(60),
      d.inSeconds.remainder(60)
    ];
  }

  void reGetCountdown() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
    _timer = new Timer.periodic(new Duration(seconds: 1), (Timer timer) {
      if (nowTime > 0) {
        nowTime--;
        _holeLabel = formatSeconds(nowTime);
      } else {
        _timer?.cancel();
        _timer = null;
        return;
      }
      setState(() {
        _holeLabel = formatSeconds(nowTime);
        nowTime;
      });
    });
  }

  void setTimerOther() {
    if (_automation.automation.uuid == null) {
      if (_automation.automation.getTotalExecutionCount() <= 0) {
        Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).incompleteAutomation);
        return;
      }
      if (timerSelect[0] == 0 && timerSelect[1] == 0 && timerSelect[2] == 0) {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).incorrectTime,
        );
        return;
      }

      var hcuuid = HomeCenterManager().defaultHomeCenterUuid;
      _automation.automation.name = _automationNameController.text;

      _automation.automation.enable = true;
      _automation.automation.prepareForSubmit();
      setAutoTimer();
      MqttProxy.createAutomation(hcuuid, _automation.automation).listen((res) {
        _automation.automation.prepareForApp();
        if (res.success) {
          otherName = DefinedLocalizations.of(context).timerStop;
          otherColor = Color(0xffffffff);
          otherText = Text_o;
          _automation.automation.uuid = res.message.createEntityResult.uUID;
          var huuid = HomeCenterManager().defaultHomeCenterUuid;
        }
      });
    } else {
      var hcuuid = HomeCenterManager().defaultHomeCenterUuid;
      var autouuid = _automation.automation.uuid;
      var state = _automation.automation
          .getAttributeValue(ATTRIBUTE_ID_AUTO_TIMER_STATE);
      // 2、3、4、5
      //  暂停、启动、停止、继续
      if (otherName == DefinedLocalizations.of(context).timerStop) {
        otherName = DefinedLocalizations.of(context).timerContinue;
        otherText = Text_o3;
        otherColor = Color(0xff9ca8b6);
        MqttProxy.writeAttribute(hcuuid, autouuid,
                ATTRIBUTE_ID_AUTO_TIMER_STATE, TIMER_STATE_PAUSED)
            .listen((response) {
          if (response is WriteAttributeResponse) {
            if (response.success) {
              _timer?.cancel();
              _timer = null;
            } else {
              Fluttertoast.showToast(msg: "暂停失败${response.code}");
            }
          }
        });
      } else if (otherName == DefinedLocalizations.of(context).timerContinue) {
        if (_automation.automation.getTotalExecutionCount() <= 0) {
          Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).incompleteAutomation);
          return;
        }
        if (timerSelect[0] == 0 && timerSelect[1] == 0 && timerSelect[2] == 0) {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).incorrectTime,
          );
          return;
        }
        otherName = DefinedLocalizations.of(context).timerStop;
        otherColor = Color(0xffffffff);
        otherText = Text_o;
        if (isUpdateAuto()) {
          var hcuuid = HomeCenterManager().defaultHomeCenterUuid;
          setContinueAutoTimer();
          _automation.automation.prepareForSubmit();
          _automation.automation.enable = true;
          _automation.automation.name = _automationNameController.text;
          print(_automation.automation.name);
          print(_automationNameController.text);
          MqttProxy.updateAutomation(hcuuid, _automation.automation)
              .listen((res) {
            _automation.automation.prepareForApp();
            if (res.success) {
              otherName = DefinedLocalizations.of(context).timerStop;
              otherColor = Color(0xffffffff);
              otherText = Text_o;
              // _resetData();
              // reGetCountdown();
              // Fluttertoast.showToast(msg: "更新成功");
            } else {
              Fluttertoast.showToast(msg: "继续更新 失败${res}");
            }
          });
          return;
        }
        MqttProxy.writeAttribute(
          hcuuid,
          autouuid,
          ATTRIBUTE_ID_AUTO_TIMER_STATE,
          TIMER_CMD_CONTINUE,
        ).listen((response) {
          if (response is WriteAttributeResponse) {
            if (response.success) {
              // _resetData();
              // setState(() {});
              // Fluttertoast.showToast(msg: "继续成功");
            } else {
              // Fluttertoast.showToast(msg: "继续 写值失败${response}");
            }
          }
        });
        setState(() {});
        // 2、3、4、5
        //  暂停、启动、停止、继续
      } else if (otherName == DefinedLocalizations.of(null).begin) {
        //启动
        if (_automation.automation.getTotalExecutionCount() <= 0) {
          Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).incompleteAutomation);
          return;
        }
        if (timerSelect[0] == 0 && timerSelect[1] == 0 && timerSelect[2] == 0) {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).incorrectTime,
          );
          return;
        }
        var hcuuid = HomeCenterManager().defaultHomeCenterUuid;
        setAutoTimer();
        _automation.automation.prepareForSubmit();
        _automation.automation.enable = true;
        _automation.automation.name = _automationNameController.text;
        _holeLabel = formatSeconds(
            timerSelect[0] * 60 * 60 + timerSelect[1] * 60 + timerSelect[2]);
        MqttProxy.updateAutomation(hcuuid, _automation.automation)
            .listen((res) {
          _automation.automation.prepareForApp();
          if (res.success) {
            otherName = DefinedLocalizations.of(context).timerStop;
            otherColor = Color(0xffffffff);
            otherText = Text_o;
          }
        });
        setState(() {});
      }
    }
  }

  void setAutoTimer() {
    var cond = _automation.automation.getConditionAt(COND_COUNT);
    Int64 timeoutMs = Int64(
        (timerSelect[0] * 60 * 60 + timerSelect[1] * 60 + timerSelect[2]) *
            1000);
    cond.timer.timeoutMS = timeoutMs;
  }

  void setContinueAutoTimer() {
    var continueTime = nowTime;
    var cond = _automation.automation.getConditionAt(COND_COUNT);
    Int64 timeoutMs = Int64(nowTime * 1000);
    cond.timer.timeoutMS = timeoutMs;
  }

  bool showTimer() {
    if (_automation.automation.uuid == null) return false;

    var state =
        _automation.automation.getAttributeValue(ATTRIBUTE_ID_AUTO_TIMER_STATE);
    if (state == TIMER_STATE_PAUSED || state == TIMER_STATE_STARTED) {
      return true;
    }
    return false;
  }

  bool cancelBool() {
    if (_automation.automation.uuid == null) return true;
    var state =
        _automation.automation.getAttributeValue(ATTRIBUTE_ID_AUTO_TIMER_STATE);
    if (state == TIMER_STATE_INIT ||
        state == TIMER_STATE_STOPPED ||
        state == TIMER_STATE_TIMEOUTED) return true;
    return false;
  }

  bool getAutoEnable() {
    if (_automation.automation == null) return true;
    for (var attrKey in _automation.automation.attributes.keys) {
      if (attrKey == ATTRIBUTE_ID_AUTO_ENABLED) {
        if (_automation.automation.getAttributeValue(attrKey) == 1) {
          return true;
        } else {
          return false;
        }
      }
    }
    return true;
  }

  bool isExecutionGroup() {
    if (_automation.automation == null) return true;
    //是否要分组显示
    if (_automation.automation.getExecutionGroupCount() > 1) {
      return true;
    } else {
      return false;
    }
  }

  double getExecutionHeight() {
    //获取condition的高度
    if (_automation.automation == null) return Adapt.px(200);
    if (_automation.automation.getExecutionGroupCount() > 1) {
      return _automation.automation.getTotalExecutionCount() * Adapt.px(255);
    } else {
      return _automation.automation.getTotalExecutionCount() * Adapt.px(285);
    }
  }

  bool getIsSceneEntity(uuid) {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return null;
    var entity = cache.findEntity(uuid);
    if (entity is Scene) {
      return true;
    } else {
      return false;
    }
  }

  void onGoBackClicked() {
    widget.automation.auto.cond = protobuf.Condition.create();
    widget.automation.auto.cond
        .mergeFromJson(_originalAutomation._originalCondJson);
    widget.automation.auto.exec = protobuf.Execution.create();
    widget.automation.auto.exec
        .mergeFromJson(_originalAutomation._originalExecJson);
    widget.automation.enable = _originalAutomation._originalEnable;
  }

  String commonPageTitle() {
    if (_automation.automation.uuid == "" ||
        _automation.automation.uuid == null)
      return DefinedLocalizations.of(null).createAutoMation;
    if (!_automation.automation.name.isEmpty)
      return _automation.automation.name;
    if (_automation.automation.getConditionCount() > COND_COUNT &&
        _automation.automation.getConditionAt(COND_COUNT).hasTimer()) {
      var times =
          _automation.automation.getConditionAt(COND_COUNT).timer.timeoutMS;
      return GetTimeStr.getTimeStr(null, times);
    } else {
      return "";
    }
  }

  bool isUpdateAuto() {
    if (_originalAutomation._originalCondJson ==
            _automation.automation.auto.cond.writeToJson() &&
        _originalAutomation._originalExecJson ==
            _automation.automation.auto.exec.writeToJson() &&
        _originalAutomation._originalEnable == _automation.automation.enable &&
        _originalAutomation._originalName == _automation.automation.name &&
        _automation.automation.name == _automationNameController.text)
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _automation.automation.parseInnerAuto();
    return CommonPage(
      title: commonPageTitle(),
      showBackIcon: true,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          NotificationView(), //显示  失去网络  xxx请求添加 啊 之类的
          Expanded(
            child: _buildAutoTimerConditionPage(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoTimerConditionPage(BuildContext context) {
    var state =
        _automation.automation.getAttributeValue(ATTRIBUTE_ID_AUTO_TIMER_STATE);
    var uuid = _automation.automation.uuid;
    return ListView.builder(
      itemCount: 1,
      padding: EdgeInsets.only(top: 0),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(40)),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Offstage(
                      // 2、3、4、5
                      //  暂停、启动、停止、继续
                      offstage: !showTimer(),
                      child: Container(
                        width: Adapt.px(1000),
                        margin: EdgeInsets.only(
                            left: Adapt.px(40),
                            right: Adapt.px(40),
                            top: Adapt.px(150)),
                        height: Adapt.px(238),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Color(0x20000000),
                              style: BorderStyle.solid),
                          top: BorderSide(
                              width: 1,
                              color: Color(0x20000000),
                              style: BorderStyle.solid),
                        )),
                        child: Center(
                          child: Text(
                            _holeLabel,
                            style: TextStyle(
                                fontSize: Adapt.px(150),
                                color: Color(0x732d3b46)),
                          ),
                        ),
                      ),
                    ),
                    Offstage(
                      // 2、3、4、5
                      //  暂停、启动、停止、继续
                      offstage: showTimer(),
                      child: Container(
                        child: Picker(
                            adapter: NumberPickerAdapter(
                              data: [
                                NumberPickerColumn(
                                    begin: 0,
                                    end: 23,
                                    initValue: timerSelect[0]),
                                NumberPickerColumn(
                                    begin: 0,
                                    end: 59,
                                    initValue: timerSelect[1]),
                                NumberPickerColumn(
                                    begin: 0,
                                    end: 59,
                                    initValue: timerSelect[2]),
                              ],
                            ),
                            delimiter: [
                              PickerDelimiter(
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(top: Adapt.px(20)),
                                      decoration: BoxDecoration(
                                          // color: Color(0x33eeeeee),
                                          border: Border(
                                              top: BorderSide(
                                                  width: 0.0,
                                                  color: Color(0xfff7f7f7f),
                                                  style: BorderStyle.solid),
                                              bottom: BorderSide(
                                                  width: 0.0,
                                                  color: Color(0x99f7f7f7f),
                                                  style: BorderStyle.solid))),
                                      child: Center(
                                        child: Text(
                                          "padding",
                                          style: TextStyle(
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      )),
                                  column: 0),
                              PickerDelimiter(
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(top: Adapt.px(20)),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  width: 0.0,
                                                  color: Color(0xfff7f7f7f),
                                                  style: BorderStyle.solid),
                                              bottom: BorderSide(
                                                  width: 0.0,
                                                  color: Color(0x99f7f7f7f),
                                                  style: BorderStyle.solid))),
                                      child: Center(
                                        child: Text(
                                          DefinedLocalizations.of(context).hour,
                                          style: TextStyle(
                                            color: Color(0x732d3b46),
                                            fontSize: Adapt.px(35),
                                          ),
                                        ),
                                      )),
                                  column: 2),
                              PickerDelimiter(
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(top: Adapt.px(20)),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  width: 0.0,
                                                  color: Color(0xfff7f7f7f),
                                                  style: BorderStyle.solid),
                                              bottom: BorderSide(
                                                  width: 0.0,
                                                  color: Color(0x99f7f7f7f),
                                                  style: BorderStyle.solid))),
                                      child: Center(
                                        child: Text(
                                          DefinedLocalizations.of(context)
                                              .minute,
                                          style: TextStyle(
                                            color: Color(0x732d3b46),
                                            fontSize: Adapt.px(35),
                                          ),
                                        ),
                                      )),
                                  column: 4),
                              PickerDelimiter(
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(top: Adapt.px(20)),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  width: 0.0,
                                                  color: Color(0xfff7f7f7f),
                                                  style: BorderStyle.solid),
                                              bottom: BorderSide(
                                                  width: 0.0,
                                                  color: Color(0x99f7f7f7f),
                                                  style: BorderStyle.solid))),
                                      child: Center(
                                        child: Text(
                                          DefinedLocalizations.of(context)
                                              .second,
                                          style: TextStyle(
                                            color: Color(0x732d3b46),
                                            fontSize: Adapt.px(35),
                                          ),
                                        ),
                                      )),
                                  column: 6),
                              PickerDelimiter(
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(top: Adapt.px(20)),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  width: 0.0,
                                                  color: Color(0xfff7f7f7f),
                                                  style: BorderStyle.solid),
                                              bottom: BorderSide(
                                                  width: 0.0,
                                                  color: Color(0x99f7f7f7f),
                                                  style: BorderStyle.solid))),
                                      child: Center(
                                        child: Text(
                                          "padiinging",
                                          style: TextStyle(
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      )),
                                  column: 7),
                            ],
                            columnPadding: EdgeInsets.all(0.0),
                            height: Adapt.px(350),
                            cancelText: DefinedLocalizations.of(context).cancel,
                            cancelTextStyle: TextStyle(
                                fontSize: Adapt.px(42),
                                color: Color(0xff7cd0ff)),
                            confirmText:
                                DefinedLocalizations.of(context).confirm,
                            confirmTextStyle: TextStyle(
                                fontSize: Adapt.px(42),
                                color: Color(0xff7cd0ff)),
                            unt: true,
                            onSelect: (picker, index, selecteds) {
                              timerSelect = selecteds;
                              setState(() {});
                            }).makePicker(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: showTimer() ? Adapt.px(130) : Adapt.px(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                                height: Adapt.px(120),
                                padding: EdgeInsets.only(
                                    left: Adapt.px(132), right: Adapt.px(132)),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0x202d3b46)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      DefinedLocalizations.of(context).cancel,
                                      style: cancelBool() ? Text_o2 : Text_o,
                                    ),
                                  ],
                                )),
                            onTap: () {
                              // if (_timer != null) {
                              var hcuuid =
                                  HomeCenterManager().defaultHomeCenterUuid;
                              var autouuid = _automation.automation.uuid;
                              MqttProxy.writeAttribute(
                                      hcuuid,
                                      autouuid,
                                      ATTRIBUTE_ID_AUTO_TIMER_STATE,
                                      TIMER_STATE_STOPPED)
                                  .listen((response) {
                                if (response is WriteAttributeResponse) {
                                  if (response.success) {
                                    otherName =
                                        DefinedLocalizations.of(context).begin;
                                    otherColor = Color(0xff9ca8b6);
                                    otherText = Text_o3;
                                    // Fluttertoast.showToast(msg: "取消成功");
                                  }
                                }
                              });
                              setState(() {
                                _timer?.cancel();
                                _timer = null;
                              });
                              // }
                            },
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                                height: Adapt.px(120),
                                padding: EdgeInsets.only(
                                    left: Adapt.px(132), right: Adapt.px(132)),
                                decoration: BoxDecoration(
                                    color: otherColor,
                                    border: Border.all(
                                        width: 1, color: Color(0x202d3b46)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(otherName, style: otherText),
                                  ],
                                )),
                            onTap: () {
                              setTimerOther();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: Adapt.px(120)),
                alignment: Alignment.centerLeft,
                child: Text(
                  DefinedLocalizations.of(context).afterCountdown,
                  style: TextStyle(
                      fontSize: Adapt.px(45),
                      color: Color(0xff55585a),
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Adapt.px(86)),
              ),
              Container(
                //就的部分
                margin: EdgeInsets.only(bottom: Adapt.px(115)),
                child: _buildThenContent(context),
              ),
              Container(
                height: _setGroup.size() * Adapt.px(160),
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: _setGroup.size(),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    Object obj = _setGroup.get(index);
                    return _buildSettingItem(context, obj);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Adapt.px(136)),
              )
            ],
          ),
        );
      },
    );
  }

  bool ifShow() {
    if (_automation.automation.auto.cond.composed.conditions.length >
        COND_COUNT) {
      if (_automation.automation.auto.cond.composed.conditions[COND_COUNT]
              .hasCalendar() ||
          _automation.automation.auto.cond.composed.conditions[COND_COUNT]
              .hasTimer()) {
        return true;
      }
      return false;
    }
    return false;
  }

  bool autoExection() {
    //判断是否存在一个auto
    if (_automation.automation == null) {
      return false;
    }
    if (_automation.automation.getExecutionGroupCount() > 0) {
      return false;
    }
    if (_automation.automation.getTotalExecutionCount() > 0) {
      return false;
    }
    return true;
  }

  String getExecMethod() {
    protobuf.ExecutionMethod _method =
        _automation.automation.auto.exec.sequenced.method;
    int _parameter = _automation.automation.auto.exec.sequenced.parameter;
    switch (_method) {
      case protobuf.ExecutionMethod.EM_ON_OFF:
        if (_parameter == 2) {
          return DefinedLocalizations.of(null).modelFlip;
        } else {
          return DefinedLocalizations.of(null).modelSet;
        }
        break;
      case protobuf.ExecutionMethod.EM_ANGULAR:
        return DefinedLocalizations.of(null).modelAngle;
        break;
      default:
        return DefinedLocalizations.of(null).modelSet;
    }
  }

  Entity getEntity(String uuid) {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return null;
    return cache.findEntity(uuid);
  }

  Widget _buildGroupOnly(BuildContext context) {
    return Column(
      children: <Widget>[
        Offstage(
          offstage: _automation.automation.getTotalExecutionCount() <= 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: EdgeInsets.only(bottom: Adapt.px(41)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    DefinedLocalizations.of(context).performFollowingActions,
                    style: TextStyle(
                        fontSize: Adapt.px(45),
                        fontWeight: FontWeight.w600,
                        color: Color(0xff55585a)),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: Text(
                          getExecMethod(),
                          style: TextStyle(
                              fontSize: Adapt.px(45), color: Color(0x732D3B46)),
                        ),
                      ),
                      Image(
                        width: Adapt.px(19),
                        height: Adapt.px(32),
                        image: AssetImage("images/icon_next.png"),
                      )
                    ],
                  )
                ],
              ),
            ),
            onTap: () {
              if (_timer != null ||
                  otherName == DefinedLocalizations.of(context).timerStop) {
                Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).pauseCountdown);
                return;
              }
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(
                      builder: (context) => AutoExecSetMode(
                            automation: _automation.automation,
                            exec: _automation.automation.auto.exec,
                          ),
                      settings: RouteSettings(name: "/AutoExecSetMode")));
            },
          ),
        ),
        Container(
          height: getExecutionHeight(),
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: !autoExection() == false
                ? 0
                : _automation.automation.getTotalExecutionCount(),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              var executationItem =
                  _automation.automation.getExecutionAt(index);
              Entity entity;
              if (executationItem.hasTimer()) {
                return _buildThenContentListItem(
                    executationItem, null, executationItem.timer);
              } else if (executationItem.hasAction()) {
                entity =
                    getEntity(executationItem.action.action.actions[0].uUID);
                return _buildThenContentListItem(executationItem, entity, null);
              } else if (executationItem.hasScene()) {
                entity = getEntity(executationItem.scene.uUID);
                return _buildThenContentListItem(executationItem, entity, null);
              } else {
                print("其他类型");
              }
              return Text("");
            },
          ),
        )
      ],
    );
  }

  bool isNeedthenDotto() {
    //判断是否存在一个auto
    if (_automation.automation == null) {
      return false;
    }
    if (_automation.automation.getTotalExecutionCount() < 1) {
      return false;
    }
    return true;
  }

  Widget _buildThenContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DefinedLocalizations.of(context).then + ":",
                style: TextStyle(
                    fontSize: Adapt.px(53),
                    color: Color(0xff55585a),
                    fontWeight: FontWeight.w600),
              ),
              CupertinoButton(
                  color: Color(0xff9ca8b6),
                  minSize: 10.0,
                  padding: EdgeInsets.only(
                      left: Adapt.px(40),
                      right: Adapt.px(40),
                      top: 5.0,
                      bottom: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(70.0)),
                  child: Text(DefinedLocalizations.of(context).add,
                      style: TEXT_STYLE_BUTTON_ADD),
                  onPressed: () {
                    if (_timer != null ||
                        otherName ==
                            DefinedLocalizations.of(context).timerStop) {
                      Fluttertoast.showToast(msg: "请先暂停倒计时");
                      return;
                    }
                    Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                            builder: (context) => AutoSelectExecutionType(
                                  automation: _automation.automation,
                                ),
                            settings: RouteSettings(
                                name: "/AutoSelectExecutionType")));
                  })
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Stack(
                children: <Widget>[
                  Offstage(
                      offstage: isNeedthenDotto(),
                      child: Container(
                        child: Stack(
                          alignment: const FractionalOffset(0.9, 0.5),
                          children: <Widget>[
                            Image(
                              image: AssetImage("images/dotted.png"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  DefinedLocalizations.of(context).autoExecAdd,
                                  style: TextStyle(
                                      color: Color(0x80899198),
                                      fontSize: Adapt.px(42)),
                                )
                              ],
                            )
                          ],
                        ),
                      )),

                  // Stack(
                  //   children: <Widget>[
                  Offstage(
                      offstage: autoExection(),
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0),
                        // height: getExecutionHeight(),
                        child: Stack(
                          children: <Widget>[
                            Offstage(
                              //表示多个分组时显示
                              offstage: !isExecutionGroup(),
                              child: Text("多个分组时显示"),
                            ),
                            Offstage(
                              //表示一个分组
                              offstage: isExecutionGroup(),
                              child: _buildGroupOnly(
                                context,
                              ),
                            )
                          ],
                        ),
                      ))
                ],
                // )
                //  ],
              ))
        ],
      ),
    );
  }

  void _editerAutomationName(_UiSetting _uiSetting) async {
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
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
                    _uiSetting.settingValue = _automationNameController.text;
                    Navigator.of(context, rootNavigator: true).maybePop();
                    setState(() {});
                  },
                ),
              ],
            ),
          );
        });
  }

  void _deleteAutomationExec(
      protobuf.Execution exec, BuildContext context) async {
    //删除自动化弹窗
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return SystemPadding(
          child: CupertinoAlertDialog(
            title: Text(DefinedLocalizations.of(context).warn),
            content:
                Text(DefinedLocalizations.of(context).sureToDeleteExecution),
            actions: <Widget>[
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
                  DefinedLocalizations.of(context).delete,
                ),
                onPressed: () {
                  for (var i = 0;
                      i < _automation.automation.getTotalExecutionCount();
                      i++) {}
                  _automation.automation.removeExecution(exec);
                  Navigator.of(context, rootNavigator: true).maybePop();
                  // _resetData();
                  setState(() {
                    _automation.automation;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String getSceneName(BuildContext context, Entity entity) {
    if (entity is Scene) return entity.getSceneName(context);
    return "";
  }

  Widget _buildThenContentListItem(
      protobuf.Execution executionItem, Entity entity, execTimer) {
    String uuid;
    if (entity == null) {
      uuid = "";
    } else {
      uuid = entity.uuid;
    }

    return Container(
      margin: EdgeInsets.only(bottom: Adapt.px(15)),
      child: Slidable(
        delegate: SlidableDrawerDelegate(),
        key: Key("entity.uuid"),
        controller: slidableController,
        actionExtentRatio: 0.25,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: <Widget>[
              Container(
                // margin: EdgeInsets.only(bottom: Adapt.px(15)),
                height: Adapt.px(240),
                color: Color(0xfff9f9f9),
                padding: EdgeInsets.only(right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Offstage(
                          offstage:
                              !(entity != null || executionItem.hasTimer()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Offstage(
                                      //设备和场景的图标
                                      offstage: (entity == null),
                                      child: Stack(
                                        children: <Widget>[
                                          Offstage(
                                              offstage: entity == null,
                                              child:
                                                  AutomationExecIconDeviceView(
                                                entity: entity,
                                                exec: executionItem,
                                              )),
                                        ],
                                      )),
                                  Offstage(
                                    //延时的图标
                                    offstage: !(entity == null &&
                                        executionItem.hasTimer()),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: Adapt.px(50),
                                          right: Adapt.px(50)),
                                      width: Adapt.px(105),
                                      alignment: Alignment.center,
                                      child: Image(
                                        height: Adapt.px(75),
                                        width: Adapt.px(89),
                                        image: AssetImage(
                                          "images/auto_timer.png",
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  child: Stack(
                                children: <Widget>[
                                  Offstage(
                                    //显示设备或者场景的文案
                                    offstage: (entity == null),
                                    child: Stack(
                                      children: <Widget>[
                                        Offstage(
                                          //设备的文案
                                          offstage: getIsSceneEntity(uuid),
                                          child: Text(
                                            GetExecutionName.getExecutionName(
                                                context, executionItem, entity),
                                            style: TextStyle(
                                                fontSize: Adapt.px(45),
                                                color: Color(0xff55585a)),
                                          ),
                                        ),
                                        Offstage(
                                          //场景的文案
                                          offstage: !getIsSceneEntity(uuid),
                                          child: Text(
                                            entity != null
                                                ? getSceneName(context, entity)
                                                : "",
                                            style: TextStyle(
                                                fontSize: Adapt.px(45),
                                                color: Color(0xff55585a)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Offstage(
                                    //显示timer的文案
                                    offstage: !(entity == null &&
                                        executionItem.hasTimer()),
                                    child: Text(
                                      DefinedLocalizations.of(context)
                                          .timeDelay,
                                      style: TextStyle(
                                          fontSize: Adapt.px(45),
                                          color: Color(0xff55585a)),
                                    ),
                                  )
                                ],
                              )),
                            ],
                          ),
                        ),
                        Offstage(
                          offstage:
                              !(entity == null && !executionItem.hasTimer()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: Adapt.px(50), right: Adapt.px(50)),
                                width: Adapt.px(105),
                                child: Image(
                                  height: Adapt.px(105),
                                  width: Adapt.px(108),
                                  image: AssetImage(
                                    "images/icon_light_off.png",
                                  ),
                                ),
                              ),
                              Text(
                                DefinedLocalizations.of(context).deviceRemoved,
                                style: TextStyle(
                                    fontSize: Adapt.px(45),
                                    color: Color(0xff55585a)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Offstage(
                          offstage:
                              !(entity == null && executionItem.hasTimer()),
                          child: Text(
                            GetTimeStr.getTimeStr(
                                context, executionItem.timer.timeoutMS),
                            style: TextStyle(
                                fontSize: Adapt.px(45),
                                color: Color(0xff55585a)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                        ),
                        Image(
                          width: Adapt.px(19),
                          height: Adapt.px(32),
                          image: AssetImage("images/icon_next.png"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            if (entity == null && !executionItem.hasTimer()) {
              Fluttertoast.showToast(
                  msg: DefinedLocalizations.of(context).deviceHasBeenDeleted);
              return;
            }
            if (execTimer != null) {
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(
                      builder: (context) => AutoExecSetTimer(
                            automation: _automation.automation,
                            exec: executionItem,
                          ),
                      settings: RouteSettings(name: "/AutoExecSetTimer")));
              return;
            }
            Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                builder: (context) => AutoExecSelectDevice(
                      automation: _automation.automation,
                      entity: entity,
                      exec: executionItem,
                    ),
                settings: RouteSettings(name: "/AutoExecSelectDevice")));
          },
        ),
        secondaryActions: <Widget>[
          SlideAction(
            child: Text(
              DefinedLocalizations.of(context).delete,
              style: TextStyle(color: Colors.white, fontSize: Adapt.px(45)),
            ),
            color: Color(0xffFF8343),
            onTap: () {
              if (_timer != null ||
                  otherName == DefinedLocalizations.of(context).timerStop) {
                Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).pauseCountdown);
                return;
              }
              _deleteAutomationExec(executionItem, context);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  String setSettingItemText(BuildContext context, _UiSetting _uiSetting) {
    if (_uiSetting.titleNum == 0) {
      if (_automation.automation.uuid == null) {
        if (_uiSetting.settingValue != null) return _uiSetting.settingValue;
        return "";
      }
      if (_uiSetting.settingValue != null) return _uiSetting.settingValue;
      return _automation.automation.name;
    } else {
      return "???";
    }
  }

  bool settingVal(_UiSetting _uiSetting) {
    if (_uiSetting.titleNum == 0) return false;
    if (_automation.automation.getConditionCount() < COND_COUNT) return false;
    var conditionItem = _automation.automation.getConditionAt(0);
    if (conditionItem == null || !conditionItem.hasCalendarRange())
      return false;
    var beginHour = conditionItem.calendarRange.begin.hour;
    var beginmin = conditionItem.calendarRange.begin.min;
    var endHour = conditionItem.calendarRange.end.hour;
    var endMin = conditionItem.calendarRange.end.min;
    if (beginHour == 0 && beginmin == 0 && endHour == 23 && endMin == 59) {
      return false;
    } else {
      return true;
    }
  }

  Widget _buildSettingItem(BuildContext context, _UiSetting _uiSetting) {
    setSettingItemText(context, _uiSetting);
    return Container(
        height: Adapt.px(160),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: const Color(0x20000000),
          width: 1,
          style: BorderStyle.solid,
        ))),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _uiSetting.getLeftString(context),
                style:
                    TextStyle(fontSize: Adapt.px(46), color: Color(0x502d3b46)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    setSettingItemText(context, _uiSetting),
                    style: TextStyle(
                        fontSize: Adapt.px(46), color: Color(0x732d3b46)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: Adapt.px(24)),
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: 3.0),
                    child: Image(
                      width: Adapt.px(19),
                      height: Adapt.px(32),
                      image: AssetImage("images/icon_next.png"),
                    ),
                  )
                ],
              )
            ],
          ),
          onTap: () {
            //进入每一项
            if (_uiSetting.getLeftString(context) ==
                DefinedLocalizations.of(context).name) {
              _editerAutomationName(_uiSetting);
            } else {
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(
                      builder: (context) => AutoCondSetTimeFrame(
                            automation: _automation.automation,
                          ),
                      settings: RouteSettings(name: "/AutoCondSetTimeFrame")));
            }
          },
        ));
  }
}

class _UiSetting {
  int titleNum;
  String settingValue;
  _UiSetting({this.titleNum, this.settingValue});
  String getLeftString(BuildContext context) {
    switch (titleNum) {
      case 0:
        return DefinedLocalizations.of(context).name;
        break;
      case 1:
        return DefinedLocalizations.of(context).effectiveTime;
        break;
      case 2:
        return DefinedLocalizations.of(context).name; //别的
        break;
      default:
        return "default";
    }
  }
}

class _SetGroup {
  final List<_UiSetting> _uiSetting = List();
  void add(int titleNum, String settingValue) {
    _uiSetting.add(
      _UiSetting(
        titleNum: titleNum,
        settingValue: settingValue,
      ),
    );
  }

  void clear() {
    _uiSetting.clear();
  }

  int size() {
    return _uiSetting.length > 0 ? _uiSetting.length : 0;
  }

  Object get(int index) => _uiSetting[index];
}
