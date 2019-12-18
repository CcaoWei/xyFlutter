import 'package:flutter/material.dart'; //安卓风格控件
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/protocol/entity.pb.dart' as protobuf;
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/page/common_page.dart';
import 'dart:async';
import 'dart:ui';

class InputInterlockPage extends StatefulWidget {
  final LogicDevice entity;
  final int _originalMutexedIndex;
  final int _ldIndex;

  InputInterlockPage(this.entity, this._originalMutexedIndex, this._ldIndex) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _InputInterlockPage();
  }
}

class _InputInterlockPage extends State<InputInterlockPage> {
  _Group _group = _Group();

  StreamSubscription _subscription; //消息通道

  void initState() {
    //onshow
    super.initState();
    _resetData();
    _start();
  }

  int getMutexedIndex() {
    int mutexedIndex = 0;
    for (var item in _group._uiItems) {
      if (item.selected) mutexedIndex |= (0x01 << item.ldIndex);
    }
    if (mutexedIndex != 0) mutexedIndex |= 0x01 << widget._ldIndex;
    return mutexedIndex;
  }

  void _resetData() {
    print("--------------------input_interlock_page.dart");
    _group.clear();
    int mutexedIndex =
        widget.entity.getAttributeValue(ATTRIBUTE_ID_CFG_MUTEXED_INDEX);
    int index = 0;
    for (var item in widget.entity.parent.logicDevices) {
      bool interlocked = 0 != (mutexedIndex & (0x01 << index));
      if (item.uuid != widget.entity.uuid &&
          item.profile == PROFILE_ON_OFF_LIGHT) {
        _group.add(interlocked, item, index);
      }
      ++index;
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
    // _subscription = RxBus()
    //     .toObservable()
    //     .where((event) => event is HomekitEvent)
    //     .listen((event) {
    //   if (event is CharacteristicVaulueUpdatedEvent) {
    //     setState(() {}); //刷新界面 相当于setData
    //   } else {
    //     _resetData();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    var caldt = protobuf.DayTime.create();
    return CommonPage(
        title: widget.entity.getName() +
            " " +
            DefinedLocalizations.of(context).interlockSetting,
        showBackIcon: true,
        trailing: Container(
          alignment: Alignment.centerRight,
          width: Adapt.px(250),
          child: Offstage(
            offstage: getMutexedIndex() == widget._originalMutexedIndex,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.only(left: OK_BUTTON_LEFT_PADDING),
                child: Image(
                  width: Adapt.px(63),
                  height: Adapt.px(61),
                  image: AssetImage("images/edit_done.png"),
                ),
              ),
              onTap: () {
                print("tapped save button");
                MqttProxy.writeAttribute(
                        HomeCenterManager().defaultHomeCenterUuid,
                        widget.entity.uuid,
                        ATTRIBUTE_ID_CFG_MUTEXED_INDEX,
                        getMutexedIndex())
                    .listen((res) {
                  if (res.success) {
                    print("update mutex index ok");
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                      msg: DefinedLocalizations.of(context).failed +
                          ': ${res.code}',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    print("update mutex index failed ${res.code}");
                  }
                });
              },
            ),
          ),
        ),
        child: _buildInterlockList(context));
  }

  Widget _buildInterlockList(BuildContext context) {
    return ListView.builder(
      itemCount: _group.size(),
      itemBuilder: (BuildContext context, int index) {
        final Object obj = _group.get(index);
        return _buildInterlockItem(context, obj, index);
      },
    );
  }

  Widget _buildInterlockItem(BuildContext context, _UiItem _item, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Adapt.px(160),
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: Color(0x33000000),
                    style: BorderStyle.solid))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(
                    _item.entity.getName(),
                    style: TextStyle(
                        fontSize: Adapt.px(46), color: Color(0xff55585a)),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Image(
                  width: _item.selected ? Adapt.px(63) : Adapt.px(31),
                  height: _item.selected ? Adapt.px(63) : Adapt.px(31),
                  image: AssetImage(_item.selected
                      ? "images/icon_check.png"
                      : 'images/icon_uncheck.png'),
                ),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        _item.selected = !_item.selected;
        setState(() {});
      },
    );
  }
}

class _UiItem {
  bool selected;
  int ldIndex;
  LogicDevice entity;
  _UiItem({this.selected, this.entity, this.ldIndex});
}

class _Group {
  final List<_UiItem> _uiItems = List();
  void add(bool selected, LogicDevice entity, int ldIndex) {
    _uiItems.add(_UiItem(selected: selected, entity: entity, ldIndex: ldIndex));
  }

  void clear() {
    _uiItems.clear();
  }

  int size() {
    return _uiItems.length > 0 ? _uiItems.length : 0;
  }

  Object get(int index) => _uiItems[index];
}
