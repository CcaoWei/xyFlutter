import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/page/auto_light_time_set_page.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/data/data_shared.dart';
import 'dart:ui';
import 'dart:async';

import 'package:xlive/rxbus/rxbus.dart';

class AutoDeviceLight extends StatefulWidget {
  //这个一定要跟着createstate
  final AutomationSet automationSet;
  AutoDeviceLight({
    this.automationSet,
  });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AutoDeviceLightPage();
  }
}

class _AutoDeviceLightPage extends State<AutoDeviceLight> {
  StreamSubscription _subscription; //消息通道
  _DeviceGroup _deviceGroup = _DeviceGroup();
  List deviceSelectList = List();
  void initState() {
    //onshow
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    print("-------------------------_AutoDeviceLightPage.dart");
    _deviceGroup.clear();
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    final List<Automation> auto = cache.automations;
    final List<Scene> scenes = cache.scenes;
    final List<PhysicDevice> physicDevice = cache.addedDevices;
    for (var devices in physicDevice) {
      if (devices.isLightSocketPhilips) {
        for (var logicD in devices.logicDevices) {
          for (var attr in logicD.attributes.keys) {
            if (attr == 43) {
              _deviceGroup.add(logicD);
            }
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

  @override
  Widget build(BuildContext context) {
    return CommonPage(
        title: widget.automationSet.name,
        showBackIcon: true,
        trailing: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            alignment: Alignment.centerRight,
            width: Adapt.px(200),
            child: Text(DefinedLocalizations.of(context).next,
                style: TEXT_STYLE_NEXT_STEP),
          ),
          onTap: () {
            for (var i = 0; i < _deviceGroup.size(); i++) {
              _deviceGroup.get(i);
              _UiDeviceEntity _uiDeviceEntity = _deviceGroup.get(i);
              if (_uiDeviceEntity.selected == true) {
                deviceSelectList.add(_uiDeviceEntity.logicDevice);
              }
            }
            if (deviceSelectList.length == 0) {
              Fluttertoast.showToast(
                  msg: DefinedLocalizations.of(context).selectLeastDevice,
                  gravity: ToastGravity.BOTTOM);
              return;
            }

            Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                builder: (context) => AutoLightTimeSet(
                      automationSet: widget.automationSet,
                      deviceList: deviceSelectList,
                    ),
                settings: RouteSettings(name: "/AutoLightTimeSet")));
          },
        ),
        child: _buildDevice(context));
  }
  // slideToDismissDelegate: new SlideToDismissDrawerDelegate(
  //   onDismissed: (actionType) {
  // _showSnackBar(
  //     context,
  //     actionType == SlideActionType.primary
  //         ? 'Dismiss Archive'
  //         : 'Dimiss Delete');
  // setState(() {
  //   items.removeAt(index);
  // });
  //   },
  // ),

  Widget _buildDevice(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: Adapt.px(40)),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Offstage(
              offstage: _deviceGroup.size() == 0,
              child: Container(
                margin: EdgeInsets.only(
                    top: Adapt.px(40),
                    left: Adapt.px(40),
                    bottom: Adapt.px(42)),
                color: Color(0x33f6f6f6),
                child: Text(
                  DefinedLocalizations.of(context).device,
                  style: TextStyle(
                      fontSize: Adapt.px(42), color: Color(0xff9b9b9b)),
                ),
              ),
            ),
            Container(
                height: (_deviceGroup.size() * 100).toDouble(),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 0),
                  itemCount: _deviceGroup.size(),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildDeviceItem(
                        context, _deviceGroup.get(index), index);
                  },
                )),
          ],
        )
      ],
    );
  }

  Widget _buildDeviceItem(
      BuildContext context, _UiDeviceEntity _uiDeviceEntity, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
          height: Adapt.px(240),
          margin: EdgeInsets.only(
              bottom: Adapt.px(15), left: Adapt.px(40), right: Adapt.px(40)),
          padding: EdgeInsets.only(left: Adapt.px(40)),
          color: Color(0xffF9F9F9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Image(
                      width: Adapt.px(105),
                      height: Adapt.px(108),
                      image: AssetImage('images/icon_light_off.png'),
                    ),
                    margin: EdgeInsets.only(
                        left: Adapt.px(40), right: Adapt.px(40)),
                  ),
                  Container(
                      child: Text(
                    _uiDeviceEntity.logicDevice.getName(),
                    style: TextStyle(
                        fontSize: Adapt.px(45), color: Color(0xff55585a)),
                  )),
                ],
              ),
              Container(
                width: Adapt.px(63),
                height: Adapt.px(63),
                margin: EdgeInsets.only(right: Adapt.px(40)),
                alignment: Alignment.center,
                child: Image(
                  width: _uiDeviceEntity.selected ? Adapt.px(63) : Adapt.px(31),
                  height:
                      _uiDeviceEntity.selected ? Adapt.px(63) : Adapt.px(31),
                  image: AssetImage(_uiDeviceEntity.selected
                      ? "images/icon_check.png"
                      : 'images/icon_uncheck.png'),
                ),
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
}

class _DeviceGroup {
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

class _UiDeviceEntity extends _UiEntity {
  final LogicDevice logicDevice;
  _UiDeviceEntity({
    @required this.logicDevice,
  });

  String getDeviceRoomName(BuildContext context, String roomUuid) {
    final HomeCenterCache entities = HomeCenterManager().defaultHomeCenterCache;
    final List<Room> rooms = entities.rooms;
    // return "默认";
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
