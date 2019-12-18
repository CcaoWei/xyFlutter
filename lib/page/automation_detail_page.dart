// import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/page/auto_cond_select_device_condition_page.dart';
import 'package:xlive/page/auto_cond_time_condition_title_view.dart';
import 'package:xlive/page/auto_condition_radio_type_page.dart';
import 'package:xlive/page/auto_exec_select_device_page.dart';
import 'package:xlive/page/auto_exec_set_mode_page.dart';
import 'package:xlive/page/auto_exec_set_timer_page.dart';
import 'package:xlive/page/auto_select_condition_type_page.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/widget/system_padding.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/widget/automation_cond_text.dart';
import 'package:xlive/widget/switch_button.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'dart:async';
import 'dart:ui';
import 'package:xlive/widget/automation_cond_icon_device_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xlive/page/auto_cond_set_time_frame.dart';
import 'package:xlive/widget/autonmation_exec_icon_view.dart';
import 'package:xlive/page/auto_select_execution_type_page.dart';
import 'package:xlive/utils/public_fun.dart';

class _Automation {
  Automation automation;
}

class _OriginalAutomation {
  String _originalCondJson;
  String _originalExecJson;
  bool _originalEnable;
  String _originalName;
}

//如果就页面
class AutomationDetail extends StatefulWidget {
  final Automation automation;
  final protobuf.Condition condition;
  final bool newAuto;

  AutomationDetail({
    this.automation,
    this.condition,
    this.newAuto, //带参数的类的实现方法 和上面一起的  下面的类_AutoMationPage要在怎么用呢 就是widgei.参数名 就行了
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoConditionPage();
  }
}

class _AutoConditionPage extends State<AutomationDetail> {
  StreamSubscription _subscription; //消息通道
  TextEditingController _automationNameController = TextEditingController();
  SlidableController slidableController;
  _SetGroup _setGroup = _SetGroup();
  List<String> _weekdayNames = List();
  _OriginalAutomation _originalAutomation = _OriginalAutomation();
  _Automation _automation = _Automation();
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
  }

  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  bool isShowCalendarRange() {
    if (_automation.automation.getConditionCount() < 0) return true;
    for (var i = 0;
        i < _automation.automation.auto.cond.composed.conditions.length;
        i++) {
      var cond = _automation.automation.auto.cond.composed.conditions[i];
      if (cond.hasCalendar()) {
        return true;
      }
    }
    return false;
  }

  void _resetData() {
    print("---------------------automation_detail_page.dart");
    print(widget.automation.auto);
    _setGroup.clear();
    HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (_automation.automation != null) {
      _automationNameController.text = _automation.automation.name;
    } else {
      _automationNameController.text = "";
    }
    _setGroup.add(0, _automation.automation.name);
    if (!isShowCalendarRange()) {
      _setGroup.add(1, "");
    }

    setState(() {});
  }

  void dispose() {
    //页面卸载是执行的
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
    onGoBackClicked();
  }

  void _start() {
    //数据监听 接受事件
    _subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
        .listen((event) {
      if (event is AutomationUpdatedEvent) {
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
            event.auto.auto.exec.writeToJson();
        print(event.auto.name);
        _resetData();
        // setState(() {});
      } else if (event is AutomationCreatedEvent) {
        if (event.auto.uuid != _automation.automation.uuid) return;
        _automation.automation = event.auto;
        _originalAutomation._originalName = event.auto.name;
        _originalAutomation._originalCondJson =
            event.auto.auto.cond.writeToJson();
        _originalAutomation._originalEnable = event.auto.enable;
        _originalAutomation._originalExecJson =
            event.auto.auto.cond.writeToJson();
        _resetData();
        // setState(() {});
      }
    });
  }

  bool getAutoEnable() {
    if (_automation.automation == null) return true;
    for (var attrKey in _automation.automation.attributes.keys) {
      if (attrKey == 35) {
        if (_automation.automation.getAttributeValue(attrKey) == 1) {
          return true;
        } else {
          return false;
        }
      }
    }
    return true;
  }

  bool isAuto() {
    //判断是否存在一个auto
    if (_automation.automation == null) {
      return false;
    }
    if (_automation.automation.auto.cond.hasComposed() &&
        _automation.automation.auto.cond.composed.conditions.length < 1) {
      return false;
    }
    return true;
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

  bool isNeedifTitle() {
    if (_automation.automation == null) {
      return false;
    }
    var cond = _automation.automation.auto.cond;
    if (cond.hasComposed() && cond.composed.conditions.length < 2) {
      return false;
    }
    return true;
  }

  double getConditionHeight() {
    if (_automation.automation == null) return 100;
    if (_automation.automation.auto.cond.composed.conditions.length > 1) {
      if (_automation.automation.auto.cond.composed.conditions[COND_COUNT]
          .hasCalendar()) {
        return Adapt.px(500);
      }
    }
    return _automation.automation.getConditionCount() * Adapt.px(240); /////
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
    if (_automation.automation == null) return Adapt.px(300);
    if (_automation.automation.getExecutionGroupCount() > 1) {
      return _automation.automation.getTotalExecutionCount() * Adapt.px(180) +
          Adapt.px(180);
    } else {
      return _automation.automation.getTotalExecutionCount() * Adapt.px(255);
    }
  }

  Entity getEntity(String uuid) {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return null;
    return cache.findEntity(uuid);
  }

  void _deleteAutomationCond(
      protobuf.Condition cond, BuildContext context) async {
    //删除自动化弹窗
    print(cond);
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return SystemPadding(
          child: CupertinoAlertDialog(
            title: Text(DefinedLocalizations.of(context).warn),
            content:
                Text(DefinedLocalizations.of(context).sureToDeleteCondition),
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
                  _automation.automation.removeCondition(cond);
                  setState(() {});
                  Navigator.of(context, rootNavigator: true).maybePop();
                  // _resetData();
                },
              ),
            ],
          ),
        );
      },
    );
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
      return DefinedLocalizations.of(context).createAutoMation;
    if (_automation.automation.name.length != 0)
      return _automation.automation.name;

    return GetAutoName.getAutoName(_automation.automation);
  }

  bool showEditIcon() {
    if (_originalAutomation._originalCondJson ==
            _automation.automation.auto.cond.writeToJson() &&
        _originalAutomation._originalExecJson ==
            _automation.automation.auto.exec.writeToJson() &&
        _originalAutomation._originalEnable == _automation.automation.enable &&
        _originalAutomation._originalName == _automationNameController.text)
      return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _automation.automation.parseInnerAuto();
    return CommonPage(
      title: commonPageTitle(),
      showBackIcon: true,
      trailing: Offstage(
        offstage: showEditIcon(),
        child: GestureDetector(
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
            if ((_automation.automation.getConditionCount() == COND_COUNT ||
                _automation.automation.getTotalExecutionCount() == 0)) {
              Fluttertoast.showToast(
                msg: DefinedLocalizations.of(context).incompleteAutomation,
              );
              return;
            }
            if (_automation.automation.auto.cond.composed.conditions[COND_COUNT]
                    .hasCalendar() &&
                _automation.automation.auto.cond.composed.conditions[COND_COUNT]
                        .calendar.calendarDayTime.hour ==
                    -1) {
              Fluttertoast.showToast(
                msg: DefinedLocalizations.of(context).incompleteAutomation,
              );
              return;
            }
            final String homeCenterUuid =
                HomeCenterManager().defaultHomeCenterUuid;
            final _UiSetting obj = _setGroup.get(0);
            _automation.automation.name = "";
            if (obj.settingValue != null && obj.settingValue.length > 0) {
              _automation.automation.name = obj.settingValue;
            }

            _automation.automation.setAttribute(ATTRIBUTE_ID_AUTO_ENABLED,
                _automation.automation.enable ? 1 : 0);
            if (_automation.automation.uuid != null) {
              _automation.automation.prepareForSubmit();
              MqttProxy.updateAutomation(homeCenterUuid, _automation.automation)
                  .listen((response) {
                _automation.automation.prepareForApp();
                if (response is UpdateAutomationResponse) {
                  if (response.success) {
                    // Navigator.of(context).maybePop();
                  } else if (response.code == -1) {
                    Fluttertoast.showToast(
                      msg: DefinedLocalizations.of(context).badRequest,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: DefinedLocalizations.of(context).error,
                    );
                  }
                }
              });

              Navigator.of(context).maybePop();
            } else {
              _automation.automation.prepareForSubmit();
              MqttProxy.createAutomation(homeCenterUuid, _automation.automation)
                  .listen((response) {
                _automation.automation.prepareForApp();
                if (response is CreateAutomationResponse) {
                  if (response.success) {
                  } else if (response.code == -1) {
                    Fluttertoast.showToast(
                      msg: DefinedLocalizations.of(context).badRequest,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: DefinedLocalizations.of(context).error,
                    );
                  }
                }
              });
              Navigator.of(context).popUntil(
                ModalRoute.withName('/Home'),
              );
            }
          },
        ),
      ),
      child: _buildAutoConditionPage(context),
      // onGoBack:onGoBackClicked,
    );
  }

  bool isShowAutoEnable() {
    if (widget.newAuto) return true;
    return false;
  }

  Widget _buildAutoConditionPage(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            children: <Widget>[
              Offstage(
                offstage: isShowAutoEnable(),
                child: Container(
                  //是否启用自动化部分
                  height: Adapt.px(240),
                  color: Color(0xfff9f9f9),
                  padding: EdgeInsets.only(left: 15.0),
                  margin: EdgeInsets.only(top: Adapt.px(65)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        DefinedLocalizations.of(context).automationEnable,
                        style: TextStyle(
                            color: Color(0xff55585a), fontSize: Adapt.px(45)),
                      ),
                      SwitchButton(
                        activeColor: Color(0xFF7cd0ff),
                        showIndicator: false,
                        showText: false,
                        value: getAutoEnable(),
                        onChanged: (bool value) {
                          _automation.automation.enable = value;
                          if (value) {
                            _automation.automation.enable = true;
                          } else {
                            _automation.automation.enable = false;
                          }
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
              ),
              Container(
                //当部分
                margin: EdgeInsets.only(
                    bottom: Adapt.px(24),
                    top: isShowAutoEnable() ? Adapt.px(50) : Adapt.px(121)),
                child: _buildIfContent(context),
              ),
              Container(
                //就的部分
                margin: EdgeInsets.only(bottom: Adapt.px(115)),
                child: _buildThenContent(context),
              ),
              Container(
                height: _setGroup.size() * Adapt.px(160),
                child: ListView.builder(
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
          .hasCalendar()) {
        return true;
      }
      return false;
    }
    return false;
  }

  bool addCondition() {
    // if (_automation.automation.getConditionCount() < 2) {
    //   return false;
    // }
    // return true;
    return false;
  }

  Widget _buildIfContent(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Offstage(
              offstage: ifShow(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    DefinedLocalizations.of(context).iF + ":",
                    style: TextStyle(
                        fontSize: Adapt.px(53),
                        color: Color(0xff55585a),
                        fontWeight: FontWeight.w600),
                  ),
                  Offstage(
                    offstage: addCondition(),
                    child: CupertinoButton(
                        color: Color(0xff9ca8b6),
                        minSize: 10.0,
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(70.0)),
                        child: Text(
                          DefinedLocalizations.of(context).add,
                          style: TextStyle(
                              fontSize: Adapt.px(39), color: Color(0xffffffff)),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(
                                  builder: (context) => AutoSelectConditionType(
                                      automation: _automation.automation),
                                  settings: RouteSettings(
                                      name: "/AutoSelectConditionType")));
                        }),
                  ),
                ],
              )),
          Offstage(
            offstage:
                _automation.automation.getConditionCount() <= COND_COUNT ||
                    ifShow(),
            child: Container(
              margin: EdgeInsets.only(top: Adapt.px(83)),
              alignment: Alignment.centerLeft,
              child: Text(
                DefinedLocalizations.of(context).conditionsMet,
                style: TextStyle(
                    fontSize: Adapt.px(45),
                    letterSpacing: Adapt.px(0.54),
                    color: Color(0xff55585a),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Container(
            margin: _automation.automation.auto.cond.hasCalendar()
                ? EdgeInsets.only(top: 0)
                : EdgeInsets.only(top: 20.0),
            child: Stack(
              children: <Widget>[
                Offstage(
                  offstage: isNeedifTitle(),
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
                            DefinedLocalizations.of(context).autoCondAdd,
                            style: TextStyle(
                                color: Color(0x80899198),
                                fontSize: Adapt.px(42)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Offstage(
                    offstage: !isAuto(),
                    child: Container(
                      height: getConditionHeight().toDouble(),
                      child: ListView.builder(
                        itemCount: !isAuto()
                            ? 0
                            : _automation.automation.getConditionCount(),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) return Text("");
                          var conditionItem =
                              _automation.automation.getConditionAt(index);
                          Entity entity;
                          if (conditionItem.hasKeypress()) {
                            entity = getEntity(conditionItem.keypress.uUID);
                            return _buildIfItem(conditionItem, entity);
                          } else if (conditionItem.hasCalendarRange()) {
                            return Container();
                          } else if (conditionItem.hasAngular()) {
                            entity = getEntity(conditionItem.angular.uUID);
                            return _buildIfItem(conditionItem, entity);
                          } else if (conditionItem.hasLongPress()) {
                            entity = getEntity(conditionItem.longPress.uUID);
                            return _buildIfItem(conditionItem, entity);
                          } else if (conditionItem.hasAttributeVariation()) {
                            entity = getEntity(
                                conditionItem.attributeVariation.uUID);
                            return _buildIfItem(conditionItem, entity);
                          } else if (conditionItem.hasCalendar()) {
                            return AutoCondTimeConditionTitleView(
                                cond: conditionItem,
                                automation: _automation.automation,
                                calendarCond: conditionItem.calendar);
                          } else if (conditionItem.hasCalendarRange()) {
                            print("conditionItem.hasCalendarRange");
                          } else if (conditionItem.hasWithinPeriod()) {
                            print("conditionItem.hasWithinPeriod");
                          } else if (conditionItem.hasSequenced()) {
                            if (conditionItem
                                .sequenced.conditions[0].innerCondition
                                .hasAttributeVariation()) {
                              entity = getEntity(conditionItem
                                  .sequenced
                                  .conditions[0]
                                  .innerCondition
                                  .attributeVariation
                                  .uUID);
                              return _buildSeqConditionListItem(
                                  conditionItem, entity);
                            } else {}
                          } else if (conditionItem.hasComposed()) {
                            if (conditionItem.composed.conditions.length == 0)
                              return Text("");
                            for (var item
                                in conditionItem.composed.conditions) {
                              if (item.hasComposed()) {
                                for (var comC in item.composed.conditions) {
                                  if (comC.hasAngular()) {
                                    //旋钮
                                    entity = getEntity(comC.angular.uUID);
                                  } else if (comC.hasAttributeVariation()) {
                                    entity =
                                        getEntity(comC.attributeVariation.uUID);
                                  }
                                }
                              } else if (item.hasAngular()) {
                                //旋钮
                                entity = getEntity(item.angular.uUID);
                              } else if (item.hasAttributeVariation()) {
                                entity =
                                    getEntity(item.attributeVariation.uUID);
                              } else {
                                return Text("");
                              }
                            }
                            return _buildComConditionItem(
                                context, conditionItem, entity);
                          }
                          return Text("");
                        },
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildComConditionItem(
      BuildContext context, protobuf.Condition conditionItem, Entity entity) {
    return Container(
      margin: EdgeInsets.only(bottom: Adapt.px(15)),
      child: Slidable(
        delegate: SlidableDrawerDelegate(),
        key: Key("s"),
        controller: slidableController,
        actionExtentRatio: 0.25,
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: Adapt.px(240),
              color: Color(0xfff9f9f9),
              padding: EdgeInsets.only(right: 15.0),
              // margin: EdgeInsets.only(bottom: Adapt.px(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AutomationCondIconDeviceView(
                        entity: entity,
                        cond: conditionItem,
                      ),
                      Container(
                        child: Text(
                          GetConditionName.getConditionName(
                              context, entity, conditionItem),
                          style: TextStyle(
                              fontSize: Adapt.px(45), color: Color(0xff55585a)),
                        ),
                      )
                    ],
                  ),
                  Image(
                    width: Adapt.px(19),
                    height: Adapt.px(32),
                    image: AssetImage("images/icon_next.png"),
                  )
                ],
              ),
            ),
            onTap: () {
              if (entity == null) {
                Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).deviceHasBeenDeleted);
                return;
              }
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (context) => AutoCondSelectDeviceCondition(
                        entity: ConditionEntity.conditionEntity(conditionItem),
                        automation: _automation.automation,
                        cond: conditionItem,
                      ),
                  settings: RouteSettings(
                    name: '/AutoCondSelectDeviceCondition',
                  ),
                ),
              );
            }),
        secondaryActions: <Widget>[
          SlideAction(
            child: Text(
              DefinedLocalizations.of(context).delete,
              style: TextStyle(color: Colors.white, fontSize: Adapt.px(45)),
            ),
            color: Color(0xffFF8343),
            onTap: () {
              _deleteAutomationCond(conditionItem, context);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIfItem(protobuf.Condition conditionItem, Entity entity) {
    return Container(
        margin: EdgeInsets.only(bottom: Adapt.px(15)),
        child: Slidable(
          delegate: SlidableDrawerDelegate(),
          key: Key(conditionItem.hashCode.toString()),
          controller: slidableController,
          actionExtentRatio: 0.25,
          child: Container(
            // margin: EdgeInsets.only(bottom: Adapt.px(15)),
            color: Color(0xfff9f9f9),
            height: Adapt.px(240),
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Center(
                                  child: AutomationCondIconDeviceView(
                                    entity: entity,
                                    cond: conditionItem,
                                  ),
                                ),
                                Center(
                                  child: AutomationCondText(
                                      automation: _automation.automation,
                                      width: Adapt.px(600),
                                      maxLine: 2,
                                      condition: conditionItem,
                                      style: TextStyle(
                                          fontSize: Adapt.px(45),
                                          color: Color(0xff55585a))),
                                ),

                                // Container(
                                //   child: Text(
                                //     // getConditionName(entity, conditionItem),
                                //     AutomationCondText(

                                //     ),
                                //     style: TextStyle(
                                //         fontSize: Adapt.px(45),
                                //         color: Color(0xff55585a)),
                                //   ),
                                // )
                              ],
                            ),
                            Image(
                              width: Adapt.px(19),
                              height: Adapt.px(32),
                              image: AssetImage("images/icon_next.png"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (entity == null) {
                      Fluttertoast.showToast(
                          msg: DefinedLocalizations.of(context)
                              .deviceHasBeenDeleted);
                      return;
                    }
                    if (ConditionEntity.conditionEntity(conditionItem)
                        is LogicDevice) {
                      LogicDevice logicDevice =
                          ConditionEntity.conditionEntity(conditionItem);
                      if (logicDevice.isOnOffLight) {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(
                            builder: (context) => AutoConditionRadioType(
                                  entity: ConditionEntity.conditionEntity(
                                      conditionItem),
                                  automation: _automation.automation,
                                  cond: conditionItem,
                                  stateType: TYPE_CONDITION_ONOFF,
                                  deviceProfile: CONDITION_DEVICE_TYPE_LIGHT,
                                ),
                            settings: RouteSettings(
                              name: '/AutoConditionRadioType',
                            ),
                          ),
                        );
                        return;
                      } else if (logicDevice.isWallSwitchButton ||
                          (logicDevice.parent.isWallSwitchS &&
                              logicDevice.disableRelay == 1) ||
                          logicDevice.pureInput == 1) {
                        Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                                builder: (context) => AutoConditionRadioType(
                                    stateType: TYPE_CONDITION_KEYPRESS,
                                    entity: ConditionEntity.conditionEntity(
                                        conditionItem),
                                    deviceProfile: CONDITION_DEVICE_TYPE_BUTTON,
                                    automation: _automation.automation,
                                    cond: conditionItem),
                                settings: RouteSettings(
                                    name: "/AutoConditionRadioType")));
                        return;
                      }
                    }
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                        builder: (context) => AutoCondSelectDeviceCondition(
                              entity: ConditionEntity.conditionEntity(
                                  conditionItem),
                              automation: _automation.automation,
                              cond: conditionItem,
                            ),
                        settings: RouteSettings(
                          name: '/AutoCondSelectDeviceCondition',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          secondaryActions: <Widget>[
            Container(
              height: Adapt.px(240),
              child: SlideAction(
                child: Text(
                  DefinedLocalizations.of(context).delete,
                  style: TextStyle(color: Colors.white, fontSize: Adapt.px(45)),
                ),
                color: Color(0xffFF8343),
                onTap: () {
                  _deleteAutomationCond(conditionItem, context);
                  setState(() {});
                },
              ),
            ),
          ],
        ));
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
            itemCount: !autoExection() == false
                ? 0
                : _automation.automation.getTotalExecutionCount(),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              var executationItem =
                  _automation.automation.getExecutionAt(index);
              Entity entity;
              if (executationItem.hasAction()) {
                entity =
                    getEntity(executationItem.action.action.actions[0].uUID);
                return _buildThenContentListItem(executationItem, entity);
              } else if (executationItem.hasScene()) {
                entity = getEntity(executationItem.scene.uUID);
                return _buildThenContentListItem(executationItem, entity);
              } else if (executationItem.hasTimer()) {
                entity = null;
                return _buildThenContentListItem(executationItem, entity);
              }
              return Text("");
            },
          ),
        )
      ],
    );
  }

  Widget _buildThenContent(BuildContext context) {
    // height: getExecutionHeight().toDouble(),
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
                      left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(70.0)),
                  child: Text(
                    DefinedLocalizations.of(context).add,
                    style: TextStyle(
                        fontSize: Adapt.px(39), color: Color(0xffffffff)),
                  ),
                  onPressed: () {
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
                        height: getExecutionHeight() + Adapt.px(120),
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

  Widget _buildSeqConditionListItem(
      protobuf.Condition conditionItem, LogicDevice entity) {
    if (conditionItem.hasSequenced() &&
        entity != null &&
        entity.isAwarenessSwitch) {
      return Container(
        margin: EdgeInsets.only(bottom: Adapt.px(15)),
        child: Slidable(
          delegate: SlidableDrawerDelegate(),
          key: Key(entity.getName()),
          controller: slidableController,
          actionExtentRatio: 0.25,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: Adapt.px(240),
              color: Color(0xfff9f9f9),
              padding: EdgeInsets.only(right: 15.0),
              margin: EdgeInsets.only(bottom: Adapt.px(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AutomationCondIconDeviceView(
                        entity: entity,
                        cond: conditionItem,
                      ),
                      Container(
                        width: Adapt.px(480),
                        child: Text(
                          GetConditionName.getConditionName(
                              context, entity, conditionItem),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: Adapt.px(45), color: Color(0xff55585a)),
                        ),
                      )
                    ],
                  ),
                  Image(
                    width: Adapt.px(19),
                    height: Adapt.px(32),
                    image: AssetImage("images/icon_next.png"),
                  )
                ],
              ),
            ),
            onTap: () {
              if (entity == null) {
                Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).deviceHasBeenDeleted);
                return;
              }
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (context) => AutoCondSelectDeviceCondition(
                        entity: ConditionEntity.conditionEntity(conditionItem),
                        automation: _automation.automation,
                        cond: conditionItem,
                      ),
                  settings: RouteSettings(
                    name: '/AutoCondSelectDeviceCondition',
                  ),
                ),
              );
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
                _deleteAutomationCond(conditionItem, context);
                setState(() {});
              },
            ),
          ],
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(bottom: Adapt.px(15)),
      child: Slidable(
        delegate: SlidableDrawerDelegate(),
        key: Key(""),
        controller: slidableController,
        actionExtentRatio: 0.25,
        child: Container(
          height: Adapt.px(240),
          color: Color(0xfff9f9f9),
          padding: EdgeInsets.only(right: 15.0),
          margin: EdgeInsets.only(bottom: Adapt.px(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AutomationCondIconDeviceView(
                    entity: null,
                    cond: conditionItem,
                  ),
                  Container(
                    width: Adapt.px(480),
                    child: Text(
                      DefinedLocalizations.of(context).deviceHasBeenDeleted,
                      style: TextStyle(
                          fontSize: Adapt.px(45), color: Color(0xff55585a)),
                    ),
                  )
                ],
              ),
              Image(
                width: Adapt.px(19),
                height: Adapt.px(32),
                image: AssetImage("images/icon_next.png"),
              )
            ],
          ),
        ),
        secondaryActions: <Widget>[
          SlideAction(
            child: Text(
              DefinedLocalizations.of(context).delete,
              style: TextStyle(color: Colors.white, fontSize: Adapt.px(45)),
            ),
            color: Color(0xffFF8343),
            onTap: () {
              _deleteAutomationCond(conditionItem, context);
              setState(() {});
            },
          ),
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
                    // _automation.automation.name =
                    //     _automationNameController.text;
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
                  _automation.automation.removeExecution(exec);
                  Navigator.of(context, rootNavigator: true).maybePop();
                  // _resetData();
                  setState(() {});
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
      protobuf.Execution executionItem, Entity entity) {
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
        key: Key("entity.name"),
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
            if (executionItem.hasTimer()) {
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(
                      builder: (context) => AutoExecSetTimer(
                            automation: _automation.automation,
                            exec: executionItem,
                          ),
                      settings: RouteSettings(name: "/AutoExecSetTimer")));
            } else {
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(
                      builder: (context) => AutoExecSelectDevice(
                            automation: _automation.automation,
                            entity: entity,
                            exec: executionItem,
                          ),
                      settings: RouteSettings(name: "/AutoExecSelectDevice")));
            }
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
      return GetTimeValue.getTimeValue(_automation.automation, context);
    }
  }

  bool settingVal(_UiSetting _uiSetting) {
    if (_uiSetting.titleNum == 0) return false;
    if (_automation.automation.getConditionCount() < COND_COUNT) return false;
    var conditionItem = _automation.automation.getConditionAt(0);
    if (conditionItem == null || !conditionItem.hasCalendarRange())
      return false;
    var beginHour = conditionItem.calendarRange.begin.hour;
    var beginMin = conditionItem.calendarRange.begin.min;
    var endHour = conditionItem.calendarRange.end.hour;
    var endMin = conditionItem.calendarRange.end.min;
    if (beginHour == 0 && beginMin == 0 && endHour == 23 && endMin == 59) {
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
                  Offstage(
                    offstage: settingVal(_uiSetting),
                    child: Text(
                      setSettingItemText(context, _uiSetting),
                      style: TextStyle(
                          fontSize: Adapt.px(46), color: Color(0x732d3b46)),
                    ),
                  ),
                  Offstage(
                    offstage: !settingVal(_uiSetting),
                    child: Container(
                        margin: EdgeInsets.only(right: Adapt.px(24)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              setSettingItemText(context, _uiSetting),
                              style: TextStyle(
                                  fontSize: Adapt.px(46),
                                  color: Color(0xff55585a)),
                            ),
                            Container(
                              child: Text(
                                GetWeekDays.getWeekDayString(
                                    _automation.automation,
                                    context,
                                    _weekdayNames),
                                style: TextStyle(
                                    fontSize: Adapt.px(36),
                                    color: Color(0x80899198)),
                              ),
                            )
                          ],
                        )),
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
        return DefinedLocalizations.of(context).effectiveTime; //特定时段
        break;
      case 2:
        return DefinedLocalizations.of(context).name; //别的
        break;
      default:
        return " ";
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
