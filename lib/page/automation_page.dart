import 'dart:ui';

import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/page/auto_light_time_detail_page.dart';
import 'package:xlive/page/auto_timer_page.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/session/network_status_manager.dart';
import 'package:xlive/session/session.dart';
import 'package:xlive/widget/system_padding.dart';
import 'package:xlive/page/automation_type_page.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/page/automation_detail_page.dart';
import 'dart:async';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xlive/widget/automation_cond_icon_device_view.dart';
import 'package:xlive/widget/automation_cond_text.dart';
import 'package:xlive/widget/automation_page_detail_text.dart';
import 'package:xlive/utils/public_fun.dart';

class AutoMations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoMationPage();
  }
}

class _AutoMationPage extends State<AutoMations> {
  final List<_Group> _group = List();
  _HeaderGroup _headerGroup = _HeaderGroup();
  _UiAutomationGroup _uiAutomationGroup = _UiAutomationGroup();
  _UiAutomationSetGroup _uiAutomationSetGroup = _UiAutomationSetGroup();
  String deleteUuid;
  StreamSubscription _subscription; //消息通道
  SlidableController slidableController;

  void initState() {
    //onshow
    slidableController = new SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
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
    _fabColor = isOpen ? Colors.green : Colors.blue;
    setState(() {});
  }

  void _resetData() {
    _group.clear();
    _uiAutomationGroup.clear();
    _uiAutomationSetGroup.clear();
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    if (cache.automations.length > 0) {
      _group.add(_headerGroup);
      var autos = cache.automations;
      for (var i = 0; i < autos.length; i++) {
        Automation automation = cache.findEntity(autos[i].uuid);
        _uiAutomationGroup.add(automation, i + 1);
      }
    }
    if (cache.automationsets.length > 0) {
      for (var m = 0; m < cache.automationsets.length; m++) {
        var automationset = cache.automationsets[m];
        _uiAutomationSetGroup.add(automationset, m + 1);
      }
    }

    _group.add(_uiAutomationGroup);
    _group.add(_uiAutomationSetGroup);
    setState(() {});
  }

  void dispose() {
    _group.clear();
    //页面卸载是执行的
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
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
      if (event is HomeCenterEvent) {
        if (event.type == HOME_CENTER_CHANGED ||
            event.type == HOME_CENTER_OFFLINE ||
            event.type == HOME_CENTER_ONLINE) {
          _resetData();
        }
      } else if (event is AutomationCreatedEvent) {
        _resetData();
      } else if (event is GetEntityCompletedEvent) {
        _resetData();
      } else if (event is AutomationUpdatedEvent) {
        _resetData();
      } else if (event is AutomationSetCreatedEvent) {
        _resetData();
      } else if (event is AutomationSetUpdatedEvent) {
        _resetData();
      } else if (event is EntityDeleteEvent) {
        _resetData();
      } else if (event is NetworkStatusChangedEvent) {
        if (event.networkType == NETWORK_TYPE_NONE) _resetData();
      } else if (event is SessionStateChangedEvent) {
        _resetData();
      }
      if (event is EntityInfoConfigureEvent) {
        _resetData();
      }
    });
  }

  int _itemCount() {
    int count = 0;
    count = 1 + _uiAutomationGroup.size() + _uiAutomationSetGroup.size();
    return count;
  }

  _getItem(int index) {
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

  void _deleteAutomation(_UiAutomaion _uiAutomation) async {
    //删除自动化弹窗
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return SystemPadding(
          child: CupertinoAlertDialog(
            title: Text(DefinedLocalizations.of(context).warn),
            content:
                Text(DefinedLocalizations.of(context).sureToDeleteAutomation),
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
                  Navigator.of(context, rootNavigator: true).maybePop();
                  final String homeCenterUuid =
                      HomeCenterManager().defaultHomeCenterUuid;
                  MqttProxy.deleteEntity(
                          homeCenterUuid, _uiAutomation.automation.uuid)
                      .listen((response) {
                    // if (response is de) {
                    if (response.success) {
                      deleteUuid = '';
                      Fluttertoast.showToast(
                          msg: DefinedLocalizations.of(context).deleteSuccess,
                          gravity: ToastGravity.CENTER);
                    } else if (response.code == -1) {
                    } else {
                      Fluttertoast.showToast(
                        msg: DefinedLocalizations.of(context).failed +
                            ': ${response.code}',
                      );
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteAutomationSet(_UiAutomationSet _uiAutomationSet) async {
    //删除自动化弹窗
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return SystemPadding(
          child: CupertinoAlertDialog(
            title: Text(DefinedLocalizations.of(context).warn),
            content:
                Text(DefinedLocalizations.of(context).sureToDeleteAutomation),
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
                  Navigator.of(context, rootNavigator: true).maybePop();
                  final String homeCenterUuid =
                      HomeCenterManager().defaultHomeCenterUuid;
                  MqttProxy.deleteEntity(
                          homeCenterUuid, _uiAutomationSet.automationSet.uuid)
                      .listen((response) {
                    // if (response is de) {
                    if (response.success) {
                      deleteUuid = '';
                      Fluttertoast.showToast(
                          msg: DefinedLocalizations.of(context).deleteSuccess,
                          gravity: ToastGravity.CENTER);
                    } else if (response.code == -1) {
                    } else {
                      Fluttertoast.showToast(
                        msg: DefinedLocalizations.of(context).failed +
                            ': ${response.code}',
                      );
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    // _resetData();

    return CommonPage(
      title: HomeCenterManager().defaultHomeCenter == null
          ? DefinedLocalizations.of(context).device
          : HomeCenterManager().defaultHomeCenter.getName(),
      showBackIcon: false,
      showMenuIcon: true,
      trailing: Offstage(
        offstage: HomeCenterManager().defaultHomeCenter.supportAutoVersion < 0,
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              alignment: Alignment.centerRight,
              width: Adapt.px(250),
              child: Text(
                DefinedLocalizations.of(context).createAutoMation,
                style: TEXT_STYLE_ADD_TEXT,
              ),
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(//进入下一个页面
                  CupertinoPageRoute(
                builder: (context) => AutomationType(),
                settings: RouteSettings(
                  name: '/AutomationType',
                ),
              ));
            }),
      ),
      child: _buildAutoMation(context),
    );
  }

  Widget _buildAutoMation(BuildContext context) {
    if (_itemCount() <= 1) {
      return Column(
        children: <Widget>[
          Offstage(
            offstage:
                HomeCenterManager().defaultHomeCenter.supportAutoVersion >= 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: Adapt.px(166)),
                ),
                Image(
                  height: Adapt.px(295),
                  image: AssetImage("images/box_old.png"),
                ),
                Container(
                    margin: EdgeInsets.only(top: Adapt.px(50)),
                    height: Adapt.px(124),
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            DefinedLocalizations.of(context)
                                .homecenterDoesntSupportAutomation1,
                            style: TextStyle(
                              fontSize: Adapt.px(42),
                              color: Color(0xff9b9b9b),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Center(
                          child: Text(
                            DefinedLocalizations.of(context)
                                .homecenterDoesntSupportAutomation2,
                            style: TextStyle(
                              fontSize: Adapt.px(42),
                              color: Color(0xff9b9b9b),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          Offstage(
            offstage:
                HomeCenterManager().defaultHomeCenter.supportAutoVersion < 0,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: Adapt.px(166)),
                ),
                Image(
                  height: Adapt.px(343),
                  image: AssetImage("images/auto_list_null.png"),
                ),
                Container(
                    height: Adapt.px(224),
                    margin: EdgeInsets.only(top: Adapt.px(50)),
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            DefinedLocalizations.of(context).noAutomaionRules1,
                            style: TextStyle(
                              fontSize: Adapt.px(42),
                              color: Color(0xff9b9b9b),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Center(
                          child: Text(
                            DefinedLocalizations.of(context).noAutomaionRules2,
                            style: TextStyle(
                              fontSize: Adapt.px(42),
                              color: Color(0xff9b9b9b),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ))
              ],
            ),
          )
        ],
      );
    } else {
      return ListView.builder(
        itemCount: _itemCount(),
        // scrollDirection: direction,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Container(
              padding: EdgeInsets.only(left: 15.0),
              margin: EdgeInsets.only(bottom: 20.0),
              child: Text(
                DefinedLocalizations.of(context).autoMationBt,
                style:
                    TextStyle(fontSize: Adapt.px(42), color: Color(0xff9b9b9b)),
              ),
            );
          } else {
            final _Automation _automation = _getItem(index);
            if (_automation is _UiAutomaion) {
              return _buildAutoMationItem(_automation, index);
            } else if (_automation is _UiAutomationSet) {
              return _buildAutoMationSetItem(_automation, index);
            }
          }
          return Text("");
        },
      );
    }
  }

  Widget _getAutomationTitle(_UiAutomaion _uiAutomation) {
    if (_uiAutomation.automation.name.length > 0)
      return Text(_uiAutomation.automation.name,
          style: TextStyle(fontSize: Adapt.px(45), color: Color(0xff55585a)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis);

    return AutomationCondText(
        condition: _uiAutomation.automation.getConditionAt(COND_COUNT),
        width: Adapt.px(600),
        automation: _uiAutomation.automation,
        maxLine: 1,
        style: TextStyle(fontSize: Adapt.px(45), color: Color(0xff55585a)));
  }

  Widget _buildAutoMationItem(_UiAutomaion _uiAutomation, int index) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
      child: Slidable(
        delegate: SlidableDrawerDelegate(),
        key: Key(_uiAutomation.hashCode.toString()),
        controller: slidableController,
        actionExtentRatio: 0.25,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: <Widget>[
              Container(
                height: Adapt.px(240),
                color: Color(0xfff9f9f9),
                padding: EdgeInsets.only(right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Offstage(
                          offstage:
                              _uiAutomation.automation.getConditionCount() == 0,
                          child: AutomationCondIconDeviceView(
                            entity: ConditionEntity.conditionEntity(
                                _uiAutomation.automation
                                    .getConditionAt(COND_COUNT)),
                            cond: _uiAutomation.automation
                                .getConditionAt(COND_COUNT),
                          ),
                        ),
                        Container(
                          width: Adapt.px(630),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _getAutomationTitle(_uiAutomation),
                              AutomationPageDetailText(
                                automation: _uiAutomation.automation,
                                width: Adapt.px(600),
                                maxLine: 1,
                                style: TextStyle(
                                    fontSize: Adapt.px(36),
                                    color: Color(0x50899198)),
                              )
                              // Text(
                              //   DefinedLocalizations.of(context).autoMationBt,
                              //   style: TextStyle(
                              //       fontSize: Adapt.px(36),
                              //       color: Color(0x50899198)),
                              // )
                            ],
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
            ],
          ),
          onTap: () {
            if (_uiAutomation.automation.getConditionCount() <= 0) return;
            if (_uiAutomation
                .automation.auto.cond.composed.conditions[COND_COUNT]
                .hasTimer()) {
              Navigator.of(context, rootNavigator: true).push(//进入下一个页面
                  CupertinoPageRoute(
                builder: (context) => AutoTimer(
                      automation: _uiAutomation.automation,
                    ),
                settings: RouteSettings(
                  name: '/AutoTimer',
                ),
              ));
              return;
            }

            Navigator.of(context, rootNavigator: true).push(//进入下一个页面
                CupertinoPageRoute(
              builder: (context) => AutomationDetail(
                    automation: _uiAutomation.automation,
                    newAuto: false,
                  ),
              settings: RouteSettings(
                name: '/AutomationDetail',
              ),
            ));
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
              _deleteAutomation(_uiAutomation);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAutoMationSetItem(_UiAutomationSet _uiAutomationSet, int index) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
      child: Slidable(
        delegate: SlidableDrawerDelegate(),
        key: Key(_uiAutomationSet.automationSet.getName()),
        controller: slidableController,
        actionExtentRatio: 0.25,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: <Widget>[
              Container(
                height: Adapt.px(240),
                color: Color(0xfff9f9f9),
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image(
                          width: Adapt.px(65),
                          height: Adapt.px(64),
                          image: AssetImage("images/tab_automation.png"),
                        ), //getAutoItemIcon(_uiAutomation)
                        Container(
                          margin: EdgeInsets.only(left: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _uiAutomationSet.automationSet.name == null
                                    ? _uiAutomationSet.automationSet.uuid
                                    : _uiAutomationSet.automationSet.getName(),
                                // overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: Adapt.px(45),
                                    color: Color(0xff55585a)),
                              ),
                              Text(
                                DefinedLocalizations.of(context).autoMationBt,
                                style: TextStyle(
                                    fontSize: Adapt.px(36),
                                    color: Color(0x50899198)),
                              )
                            ],
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
            ],
          ),
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(//进入下一个页面
                CupertinoPageRoute(
              builder: (context) => AutoLightTimeDetail(
                  automationSet: _uiAutomationSet.automationSet),
              settings: RouteSettings(
                name: '/AutoLightTimeDetail',
              ),
            ));
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
              _deleteAutomationSet(_uiAutomationSet);
              setState(() {});
            },
          ),
        ],
      ),
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

class _HeaderGroup extends _Group {
  int size() {
    return 1;
  }
}

class _UiAutomationGroup extends _Group {
  final List<_UiAutomaion> _uiAutomaion = List();
  void add(Automation automation, int index) {
    _uiAutomaion.add(
      _UiAutomaion(automation: automation, index: index),
    );
  }

  void clear() {
    _uiAutomaion.clear();
  }

  int size() {
    return _uiAutomaion.length > 0 ? _uiAutomaion.length : 0;
  }

  Object get(int index) => _uiAutomaion[index];
}

class _UiAutomationSetGroup extends _Group {
  final List<_UiAutomationSet> _uiAutomationSet = List();
  void add(AutomationSet automationSet, int index) {
    _uiAutomationSet.add(
      _UiAutomationSet(automationSet: automationSet, index: index),
    );
  }

  void clear() {
    _uiAutomationSet.clear();
  }

  int size() {
    return _uiAutomationSet.length > 0 ? _uiAutomationSet.length : 0;
  }

  Object get(int index) => _uiAutomationSet[index];
}

class _Automation {}

class _UiAutomaion extends _Automation {
  Automation automation;
  int index;
  _UiAutomaion({this.automation, this.index});
}

class _UiAutomationSet extends _Automation {
  AutomationSet automationSet;
  int index;
  _UiAutomationSet({this.automationSet, this.index});
}
