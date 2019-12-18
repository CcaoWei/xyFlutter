import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/protocol/const.pbenum.dart' as pbConst;
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/widget/scene_view.dart';
import 'package:xlive/widget/switch_button.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'dart:async';
import 'dart:ui';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'common_page.dart';

class AutoExecSelectDevice extends StatefulWidget {
  final Automation automation;
  final Entity entity;
  final protobuf.Execution exec; //带参数的类的实现方法

  AutoExecSelectDevice(
      {this.automation, //带参数的类的实现方法 和上面一起的  下面的类_AutoMationPage要在怎么用呢 就是widgei.参数名 就行了
      this.entity,
      this.exec});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddDeviceExecutionPage();
  }
}

class _AddDeviceExecutionPage extends State<AutoExecSelectDevice> {
  //这个一定要跟着一个build
  //创建一个自动化的列表
  final List<_Group> _group = List();
  _HeaderGroup _headerGroup = _HeaderGroup();
  _SceneGroup _sceneGroup = _SceneGroup();
  _DeviceGroup _deviceGroup = _DeviceGroup();

  List sceneSelectList = List();
  List deviceSelectList = List();

  StreamSubscription _subscription; //消息通道

  void initState() {
    //onshow
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    sceneSelectList.clear();
    deviceSelectList.clear();
    _group.clear();
    print("---------------auto_exec_selecte_device_page.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    final List<Automation> auto = cache.automations;
    _group.add(_headerGroup);
    final List<Scene> scenes = cache.scenes;
    final List<PhysicDevice> physicDevice = cache.addedDevices;
    if (widget.entity != null) {
      for (var scene in scenes) {
        if (scene.uuid == widget.entity.uuid) {
          _sceneGroup.add(scene);
        }
      }
      for (var devices in physicDevice) {
        if (devices.isWallSwitch || devices.isWallSwitchUS) {
          for (var ld in devices.logicDevices) {
            if (ld.isOnOffLight) {
              if (ld.uuid == widget.entity.uuid) {
                _deviceGroup.add(ld);
              }
            }
          }
        } else {
          if (devices.model == DEVICE_MODEL_AWARENESS_SWITCH ||
              devices.model == DEVICE_MODEL_DOOR_SENSOR) {
          } else {
            for (var logicD in devices.logicDevices) {
              if (logicD.isSmartDial) continue;
              if (logicD.uuid == widget.entity.uuid) {
                _deviceGroup.add(logicD);
              }
            }
          }
        }
      }
    } else {
      for (var scene in scenes) {
        _sceneGroup.add(scene);
      }
      for (var devices in physicDevice) {
        if (devices.isWallSwitch || devices.isWallSwitchUS) {
          for (var ld in devices.logicDevices) {
            if (ld.isOnOffLight) {
              _deviceGroup.add(ld);
            }
          }
        } else {
          if (devices.model == DEVICE_MODEL_AWARENESS_SWITCH ||
              devices.model == DEVICE_MODEL_DOOR_SENSOR) {
          } else {
            for (var logicD in devices.logicDevices) {
              if (logicD.isSmartDial) continue;
              _deviceGroup.add(logicD);
            }
          }
        }
      }
    }

    _group.add(_sceneGroup);
    _group.add(_deviceGroup);
    if (widget.entity != null) {
      for (var i = 0; i < _itemCount(); i++) {
        if (i == 0) continue;
        final _UiEntity uiEntity = _getItem(i);
        if (uiEntity is _UiSceneEntity) {
          if (widget.entity.uuid == uiEntity.scene.uuid) {
            uiEntity._selected = true;
            sceneSelectList.add(uiEntity);
          }
        }
        if (uiEntity is _UiDeviceEntity) {
          if (widget.entity.uuid == uiEntity.logicDevice.uuid) {
            if (widget.exec.action.action.actions[0].attrValue == 1 ||
                widget.exec.action.action.actions[0].attrValue == 100) {
              uiEntity.checked = true;
            }
            uiEntity._selected = true;
            deviceSelectList.add(uiEntity);
            // _sceneGroup.clear();
          }
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

  int _itemCount() {
    int count = 0;
    count = 1 + _sceneGroup.size() + _deviceGroup.size();
    return count;
  }

  bool isProtection(int profile) {
    //判断是否是布防撤防设备
    if (profile == PROFILE_PIR || profile == PROFILE_DOOR_CONTACT) {
      return true;
    } else {
      return false;
    }
  }

  void _updateDeviceList(bool select, List scenesAction) {
    //选中场景时 更新下面的设备
    if (select == true) {
      List<int> removeLogicD = List();
      for (var action in scenesAction) {
        for (var device in _deviceGroup._uiDeviceEntity) {
          if (device.logicDevice.uuid == action.uuid) {
            removeLogicD.add(_deviceGroup.getindex(device));
          }
        }
      }
      removeLogicD.sort();
      for (var i = removeLogicD.length - 1; i >= 0; i--) {
        _deviceGroup.removeDevice(removeLogicD[i]);
      }
    } else {
      final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
      final List<PhysicDevice> physicDevice = cache.addedDevices;
      for (var action in scenesAction) {
        if (widget.exec != null) continue;
        for (var devices in physicDevice) {
          if (devices.isWallSwitch || devices.isWallSwitchUS) {
            for (var ld in devices.logicDevices) {
              if (ld.isOnOffLight) {
                if (action.uuid == ld.uuid) {
                  _deviceGroup.add(ld);
                }
              }
            }
          } else {
            for (var logicD in devices.logicDevices) {
              if (logicD.isSmartDial) continue;
              if (logicD.isAwarenessSwitch) continue;
              if (logicD.isDoorContact) continue;
              if (action.uuid == logicD.uuid) {
                _deviceGroup.add(logicD);
              }
            }
          }
        }
      }
    }
  }

  bool isCurtainDevice(String uuid) {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    Entity deviceEntity = cache.findEntity(uuid);
    if (deviceEntity is LogicDevice) {
      if (deviceEntity.isCurtain) {
        return true;
      }
    }
    return false;
  }

  void updateExecution() {
    if (widget.exec != null) {
      if (widget.exec.hasAction()) {
        if (deviceSelectList.length == 0) {
          widget.automation.auto.exec.sequenced.executions.remove(widget.exec);
        } else {
          if (widget.exec.action.action.actions[0].uUID == widget.entity.uuid) {
            if (deviceSelectList[0].checked) {
              isCurtainDevice(widget.entity.uuid)
                  ? widget.exec.action.action.actions[0].attrValue = 100
                  : widget.exec.action.action.actions[0].attrValue = 1;
            } else {
              widget.exec.action.action.actions[0].attrValue = 0;
            }
          }
        }
      } else if (widget.exec.hasScene()) {
        if (sceneSelectList.length == 0) {
          widget.automation.auto.exec.sequenced.executions.remove(widget.exec);
        }
      }
      return;
    }
    protobuf.SequencedExecution allEx;
    if (widget.automation.auto.exec.hasSequenced()) {
      allEx = widget.automation.auto.exec.sequenced;
    } else {
      allEx = protobuf.SequencedExecution.create();
      allEx.method = protobuf.ExecutionMethod.EM_ON_OFF;
      allEx.parameter = 1;
    }
    allEx.loopType = protobuf.ExecutionLoopType.ELT_LOOP_TIMES;
    allEx.loopParameter = Int64(1);
    for (var scSel in sceneSelectList) {
      var execution = protobuf.Execution.create();
      var sceneEx = protobuf.SceneExecution.create();
      sceneEx.uUID = scSel.scene.uuid;
      sceneEx.method = protobuf.ExecutionMethod.EM_ON_OFF;
      sceneEx.parameter = 1;
      execution.scene = sceneEx;
      allEx.executions.add(execution);
    }
    //只有设备
    for (var deSel in deviceSelectList) {
      var actionExecution = protobuf.ActionExecution.create();
      var composedAction = protobuf.ComposedAction.create();
      var atomicAction = protobuf.AtomicAction.create();
      var execution = protobuf.Execution.create();
      atomicAction.uUID = deSel.logicDevice.uuid;
      if (deSel.logicDevice.isCurtain) {
        atomicAction.attrID =
            pbConst.AttributeID.AttrIDWindowCurrentLiftPercent;
        if (deSel.checked) {
          atomicAction.attrValue = 100;
        } else {
          atomicAction.attrValue = 0;
        }
      } else {
        atomicAction.attrID = pbConst.AttributeID.AttrIDOnOffStatus;
        if (deSel.checked) {
          atomicAction.attrValue = 1;
        } else {
          atomicAction.attrValue = 0;
        }
      }

      composedAction.actions.add(atomicAction);
      actionExecution.action = composedAction;
      actionExecution.method = protobuf.ExecutionMethod.EM_ON_OFF;
      actionExecution.parameter = 1;
      execution.action = actionExecution;
      allEx.executions.add(execution);
    }
    if (widget.automation.getTotalExecutionCount() == 1 &&
        widget.automation.auto.exec.sequenced.executions.length == 0) {
      var secExec = protobuf.SequencedExecution.create();
      secExec.loopType = protobuf.ExecutionLoopType.ELT_LOOP_TIMES;
      secExec.loopParameter = Int64(1);
      allEx.method = protobuf.ExecutionMethod.EM_ON_OFF;
      allEx.parameter = 1;
      var execu = protobuf.Execution.create();
      var execu2 = protobuf.Execution.create();
      execu.sequenced = allEx;
      if (widget.automation.auto.exec.hasTimer()) {
        secExec.executions.add(widget.automation.auto.exec);
        secExec.executions.add(execu);
      }
      execu2.sequenced = secExec;
      widget.automation.auto.exec = execu2;
      return;
    }
    widget.automation.auto.exec.sequenced = allEx;
  }

  bool timerPage() {
    for (var item in widget.automation.auto.cond.composed.conditions) {
      if (item.hasTimer()) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
        title: DefinedLocalizations.of(context).autoExecutionEntity,
        showBackIcon: true,
        trailing: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            alignment: Alignment.centerRight,
            width: Adapt.px(200),
            child: Image(
              width: Adapt.px(63),
              height: Adapt.px(61),
              image: AssetImage("images/edit_done.png"),
            ),
          ),
          onTap: () {
            getDevicesSelect();
            if (widget.automation == null) {
            } else {
              updateExecution();
            }
            sceneSelectList.clear();
            deviceSelectList.clear();
            Navigator.popUntil(
                context,
                ModalRoute.withName(
                    timerPage() ? '/AutoTimer' : '/AutomationDetail'));
          },
        ),
        child: Container(
          margin: EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(40)),
          child: _buildExecutionAll(context),
        ));
  }

  // 查看什么设备被选中了
  void getDevicesSelect() {
    deviceSelectList.clear();
    sceneSelectList.clear();
    for (var i = 0; i < _itemCount(); i++) {
      if (i == 0) continue;
      final _UiEntity uiEntity = _getItem(i);
      if (uiEntity is _UiSceneEntity && uiEntity._selected == true) {
        uiEntity.scene.uuid;
        sceneSelectList.add(uiEntity);
      }
      if (uiEntity is _UiDeviceEntity && uiEntity._selected == true) {
        deviceSelectList.add(uiEntity);
      }
    }
  }

  _UiEntity _getItem(int index) {
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

  Widget _buildExecutionAll(BuildContext context) {
    return ListView.builder(
      itemCount: _group.length,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(top: Adapt.px(15), bottom: Adapt.px(15)),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _buildHeader(context);
        } else if (index == 1) {
          return _buildScene(context);
        } else if (index == 2) {
          return _buildDevice(context);
        }
        return Text("");
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    // return GestureDetector(
    //   behavior: HitTestBehavior.opaque,
    //   child: Container(
    //       height: Adapt.px(160),
    //       margin: EdgeInsets.only(top: Adapt.px(65)),
    //       decoration: BoxDecoration(
    //           border: Border(
    //               bottom: BorderSide(
    //                   width: 1,
    //                   color: Color(0x33000000),
    //                   style: BorderStyle.solid))),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: <Widget>[
    //           GestureDetector(
    //             behavior: HitTestBehavior.opaque,
    //             child: Text(
    //               DefinedLocalizations.of(context).autoExecutionMode,
    //               style: TextStyle(
    //                   fontSize: Adapt.px(46), color: Color(0x502d3b46)),
    //             ),
    //             onTap: () {
    //               Navigator.of(context, rootNavigator: true)
    //                   .push(CupertinoPageRoute(
    //                       builder: (context) => AutoExecSetMode(
    //                             automation: widget.automation,
    //                             exec: widget.exec,
    //                           ),
    //                       settings: RouteSettings(name: "/AutoExecSetMode")));
    //             },
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: <Widget>[
    //               Container(
    //                 margin: EdgeInsets.only(right: Adapt.px(15)),
    //                 child: Offstage(
    //                   offstage: false,
    //                   child: Text(
    //                     getExecMethod(),
    //                     style: TextStyle(
    //                         fontSize: Adapt.px(46), color: Color(0x502d3b46)),
    //                   ),
    //                 ),
    //               ),
    //               Image(
    //                 width: Adapt.px(19),
    //                 height: Adapt.px(35),
    //                 image: AssetImage("images/icon_next.png"),
    //               )
    //             ],
    //           )
    //         ],
    //       )),
    //   onTap: () {
    //     print("选择执行方式 ----进入下一页面进行选择");
    //     Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
    //         builder: (context) => AutoExecSetMode(
    //               automation: widget.automation,
    //               exec: widget.exec,
    //             ),
    //         settings: RouteSettings(name: "/AutoExecSetMode")));
    //   },
    // );
    return Text("");
  }

  Widget _buildScene(BuildContext context) {
    int sceneHeight = (_sceneGroup.size() / 3).ceil();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Offstage(
          offstage: _sceneGroup.size() == 0,
          child: Container(
            height: Adapt.px(59),
            margin: EdgeInsets.only(bottom: Adapt.px(65), top: Adapt.px(96)),
            color: Color(0x33f6f6f6),
            child: Text(
              DefinedLocalizations.of(context).scene,
              style:
                  TextStyle(fontSize: Adapt.px(42), color: Color(0xff9b9b9b)),
            ),
          ),
        ),
        Container(
          height: sceneHeight * Adapt.px(420),
          child: GridView.builder(
            padding: EdgeInsets.all(0),
            itemCount: _sceneGroup.size(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
            ),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _buildSceneItem(context, _sceneGroup.get(index));
            },
          ),
        )
      ],
    );
  }

  Widget _buildSceneItem(BuildContext context, _UiSceneEntity _uiSceneEntity) {
    return Stack(
      children: <Widget>[
        SceneView(
          scene: _uiSceneEntity.scene,
          onClick: () {
            _uiSceneEntity.selected = !_uiSceneEntity.selected; //选择和不选择的问题
            // 选择了就要更新设备列表
            _uiSceneEntity.scene.actions;
            _updateDeviceList(
                _uiSceneEntity.selected, _uiSceneEntity.scene.actions);

            //设备需要排序功能以后优化
            setState(() {});
          },
          onLongClick: () {},
          showRealTimeState: false,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          child: Offstage(
            offstage: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      right: Adapt.px(20), bottom: Adapt.px(20)),
                  margin: EdgeInsets.only(
                      right: Adapt.px(15), bottom: Adapt.px(15)),
                  child: Image(
                    width: Adapt.px(63),
                    height: Adapt.px(63),
                    image: AssetImage(_uiSceneEntity.selected
                        ? "images/icon_check.png"
                        : "images/icon_uncheck_scene.png"),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDevice(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Offstage(
          offstage: widget.exec == null,
          child: Padding(
            padding: EdgeInsets.only(top: Adapt.px(30)),
          ),
        ),
        Offstage(
          offstage: _deviceGroup.size() == 0,
          child: Container(
            height: Adapt.px(59),
            margin: EdgeInsets.only(bottom: Adapt.px(42)),
            color: Color(0x33f6f6f6),
            child: Text(
              DefinedLocalizations.of(context).device,
              style:
                  TextStyle(fontSize: Adapt.px(42), color: Color(0xff9b9b9b)),
            ),
          ),
        ),
        Container(
            height: _deviceGroup.size() * Adapt.px(255) + Adapt.px(240),
            child: ListView.builder(
              itemCount: _deviceGroup.size(),
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _buildDeviceItem(
                    context, _deviceGroup.get(index), index);
              },
            )),
      ],
    );
  }

  Widget _buildDeviceItem(
      BuildContext context, _UiDeviceEntity _uiDeviceEntity, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
          height: Adapt.px(240),
          margin: EdgeInsets.only(bottom: Adapt.px(15)),
          padding: EdgeInsets.only(left: Adapt.px(40)),
          color: Color(0xffF9F9F9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: Adapt.px(63),
                    height: Adapt.px(63),
                    alignment: Alignment.center,
                    child: Image(
                      width: _uiDeviceEntity.selected
                          ? Adapt.px(63)
                          : Adapt.px(31),
                      height: _uiDeviceEntity.selected
                          ? Adapt.px(63)
                          : Adapt.px(31),
                      image: AssetImage(_uiDeviceEntity.selected
                          ? "images/icon_check.png"
                          : 'images/icon_uncheck.png'),
                    ),
                  ),
                  Container(
                    width: Adapt.px(110),
                    height: Adapt.px(110),
                    alignment: Alignment.center,
                    child: _buildDeviceIcon(_uiDeviceEntity.checked,
                        _uiDeviceEntity.logicDevice.profile),
                    margin: EdgeInsets.only(
                        left: Adapt.px(40), right: Adapt.px(40)),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _uiDeviceEntity.logicDevice.getName(),
                          style: TEXT_STYLE_AUTOMATION_BT,
                        ),
                        Text(
                          _uiDeviceEntity.getDeviceRoomName(
                              context, _uiDeviceEntity.logicDevice.roomUuid),
                          style: TEXT_STYLE_AUTOMATION_COND_DEVICE,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SwitchButton(
                activeColor: isProtection(_uiDeviceEntity.logicDevice.profile)
                    ? Color(0xffFFB34D)
                    : Color(0xff7CD0FF),
                value: _uiDeviceEntity.checked,
                showIndicator: false,
                showText: false,
                onChanged: (value) {
                  _uiDeviceEntity.checked = value;
                  if (value) {
                    _uiDeviceEntity.selected = true;
                  }
                  setState(() {});
                },
              ),
            ],
          )),
      onTap: () {
        _uiDeviceEntity.selected = !_uiDeviceEntity.selected;
        if (!_uiDeviceEntity.selected) {
          _uiDeviceEntity.checked = false;
        }
        setState(() {});
      },
    );
  }

  String getExecMethod() {
    protobuf.ExecutionMethod _method;
    int _parameter;
    if (widget.exec != null) {
      if (widget.exec.hasAction()) {
        _method = widget.exec.action.method;
        _parameter = widget.exec.action.parameter;
      } else if (widget.exec.hasScene()) {
        _method = widget.exec.scene.method;
        _parameter = widget.exec.scene.parameter;
      } else {
        _method = protobuf.ExecutionMethod.EM_ON_OFF;
        _parameter = 1;
      }
    } else {
      _method = widget.automation.auto.exec.sequenced.method;
      _parameter = widget.automation.auto.exec.sequenced.parameter;
    }

    switch (_method) {
      case protobuf.ExecutionMethod.EM_ON_OFF:
        if (_parameter == 2) {
          return DefinedLocalizations.of(context).modelFlip;
        } else {
          return DefinedLocalizations.of(context).modelSet;
        }
        break;
      case protobuf.ExecutionMethod.EM_ANGULAR:
        return DefinedLocalizations.of(context).modelAngle;
        break;
      default:
        return DefinedLocalizations.of(context).modelSet;
    }
  }

  Widget _buildDeviceIcon(bool checked, int profile) {
    if (profile == PROFILE_ON_OFF_LIGHT) {
      return Image(
        width: Adapt.px(105),
        height: Adapt.px(108),
        image: AssetImage(
            checked ? 'images/icon_light_on.png' : 'images/icon_light_off.png'),
      );
    } else if (profile == PROFILE_SMART_PLUG) {
      return Image(
        width: Adapt.px(78),
        height: Adapt.px(78),
        image: AssetImage(
            checked ? 'images/icon_plug_on.png' : 'images/icon_plug_off.png'),
      );
    } else if (profile == PROFILE_WINDOW_CORVERING) {
      return Image(
        width: Adapt.px(76),
        height: Adapt.px(66),
        image: AssetImage('images/icon_curtain.png'),
      );
    } else if (profile == 0) {
      return Image(
        width: Adapt.px(78),
        height: Adapt.px(78),
        image: AssetImage('images/icon_pir.png'),
      );
    } else if (profile == 3) {
      return Image(
        width: Adapt.px(78),
        height: Adapt.px(66),
        image: AssetImage('images/icon_dc.png'),
      );
    }
    return Container();
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

class _HeaderGroup extends _Group {
  int size() {
    return 1;
  }
}

class _SceneGroup extends _Group {
  //场景执行
  final List<_UiSceneEntity> _uiSceneEntity = List();
  void add(Scene scene) {
    _uiSceneEntity.add(
      _UiSceneEntity(
        scene: scene,
      ),
    );
  }

  void clear() {
    _uiSceneEntity.clear();
  }

  int size() {
    return _uiSceneEntity.length > 0 ? _uiSceneEntity.length : 0;
  }

  void remove(index) {
    _uiSceneEntity.remove(index);
  }

  Object get(int index) => _uiSceneEntity[index];
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

class _UiSceneEntity extends _UiEntity {
  final Scene scene;
  _UiSceneEntity({
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
