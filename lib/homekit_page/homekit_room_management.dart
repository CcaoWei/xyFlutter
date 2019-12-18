import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/page/common_page.dart';
import 'package:xlive/widget/system_padding.dart';
import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;
import 'dart:async';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/channel/event_channel.dart';

class HomekitRoomManagement extends StatefulWidget {
  //roomManagement
  @override
  State<StatefulWidget> createState() {
    //对象
    // TODO: implement createState
    return _HomekitRoomManagementPageState();
  }
}

class _HomekitRoomManagementPageState extends State<HomekitRoomManagement> {
  //下划线表示私有
  StreamSubscription _subscription; //消息通道
  final List<_UiRoomEntity> _uiRoomEntities = List(); //表示房间数据集合
  TextEditingController _roomNameController =
      TextEditingController(); //input  文字传到那里去 TextEditingController类型
  void initState() {
    //初始化数据 == onload
    // TODO: implement initState

    _resetData(); //初始化数据   函数调用
    _start(); //事件监听   函数调用
    super.initState();
  }

  void dispose() {
    //页面被回收是被调用    回收延时之类的方法
    // TODO: implement dispose
    super.dispose();
  }

  void _resetData() {
    //数据刷新
    _uiRoomEntities.clear();
    if (HomeManager().primaryHome == null) return;
    List<Room> rooms = HomeManager().primaryHome.rooms; //这个是李涛定义好了的room类型 可以直接拿
    for (Room room in rooms) {
      _uiRoomEntities.add(_UiRoomEntity(room: room));
    }
    setState(() {});
  }

  void _start() {
    //数据监听 接受事件
    _subscription = RxBus()
        .toObservable()
        .where((event) => event is HomekitEvent)
        .listen((event) {
      if (event is RoomAddedEvent) {
        _resetData();
      } else if (event is RoomRemovedEvent) {
        _resetData();
      } else if (event is RoomNameUpdatedEvent) {
        _resetData();
      } else if (event is HomekitEntityIncomingCompleteEvent) {
        _resetData();
      }
    });
  }

  void _displayMessage(
      String messageType, String message, BuildContext context) {
    //错误消息提示模板
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(messageType),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).confirm),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          );
        });
  }

  void _renameRoom(_UiRoomEntity uiRoomEntity) async {
    //给房间重命名
    // await
    await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return SystemPadding(
            child: CupertinoAlertDialog(
              title: Text(DefinedLocalizations.of(context).rename),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(DefinedLocalizations.of(context).inputName),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                  ),
                  CupertinoTextField(
                    //文本输入框
                    autocorrect: true,
                    controller: _roomNameController,
                  )
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    DefinedLocalizations.of(context).cancel,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(DefinedLocalizations.of(context).rename),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    _renameRoomSelect(uiRoomEntity); //确定重命名
                  },
                ),
              ],
            ),
          );
        });
  }

  void _addRoomInput(BuildContext context) async {
    //显示添加房间的名字的输入框
    await showCupertinoDialog(
        //模态框
        context: context,
        builder: (BuildContext context) {
          return SystemPadding(
            child: CupertinoAlertDialog(
              title: Text(DefinedLocalizations.of(context).addRoom),
              content: Column(
                //name + input
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DefinedLocalizations.of(context).inputName,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                  ),
                  CupertinoTextField(
                    autocorrect: true,
                    controller: _roomNameController,
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
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    DefinedLocalizations.of(context).addRoom,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    methodChannel
                        .addRoom(HomeManager().primaryHome.identifier,
                            _roomNameController.text)
                        .then((response) {
                      final int code = response['code'];
                      if (code != 0) {
                        final String messageType =
                            DefinedLocalizations.of(context).error;
                        final String message = response['message'];
                        _displayMessage(messageType, message, context);
                      } else {
                        _roomNameController.text = '';
                        _resetData();
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  void _renameRoomSelect(_UiRoomEntity uiRoomEntity) {
    //确定重命名房间 真的重命名了   暂时没有方法 先搁置吧
    // methodChannel
    print("!!!!!!!!!!! 等待方法");

    // uiRoomEntity.room.
    methodChannel
        .updateRoomName(uiRoomEntity.room.homeIdentifier,
            uiRoomEntity.room.identifier, _roomNameController.text)
        .then((response) {
      final int code = response['code'];
      if (code != 0) {
        final String messageType = DefinedLocalizations.of(context).warning;
        final String message = response['message'];
        _displayMessage(messageType, message, context);
      } else {
        _resetData();
      }
    });
  }

  void _addRoomPopup(BuildContext context) {
    //添加房间选项 从下弹出来的那个
    showCupertinoModalPopup(
        // 调用控件   从下弹出的控件 return的是CupertinoActionSheet
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                // onpress要用的？？
                child: Text(
                  DefinedLocalizations.of(context).addRoom, //调用字符串
                  style: TextStyle(color: Color(0xFF2D3B46)),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(); //隐藏自身控件
                  _addRoomInput(context);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                DefinedLocalizations.of(context).cancel,
                style: TextStyle(color: Color(0xFF2D3B46)),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(); //这个是隐藏弹出的控件
              },
            ),
          );
        });
  }

  void _deleteRoom(_UiRoomEntity uiRoomEntity) {
    //删除房间  真的删除了
    methodChannel
        .removeRoom(
            uiRoomEntity.room.homeIdentifier, uiRoomEntity.room.identifier)
        .then((response) {
      final int code = response['code'];
      if (code != 0) {
        final String messageType = DefinedLocalizations.of(context).warning;
        final String message = response['message'];
        _displayMessage(messageType, message, context);
      } else {
        _resetData();
      }
    });
  }

  void _roomDelete(_UiRoomEntity uiRoomEntity) async {
    //删除房间弹窗
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return SystemPadding(
          child: CupertinoAlertDialog(
            title: Text(DefinedLocalizations.of(context).warn),
            content: Text(DefinedLocalizations.of(context).sureToDeleteRoom),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).cancel,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).delete,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _deleteRoom(uiRoomEntity);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoomItem(_UiRoomEntity uiRoomEntity) {
    //每一个房间列表
    final String methodName = 'buildRoomItem';
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
        height: 80.0,
        color: const Color(0xFFF9F9F9),
        // child: Text(uiRoomEntity.room.name),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image(
              width: 24.0,
              height: 24.0,
              image: AssetImage('images/hk_room.png'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0),
            ),
            Text(
              uiRoomEntity.room.name,
              style: TextStyle(
                inherit: false,
                color: const Color(0xFF2D3B46),
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
      onLongPress: () {
        return _editerRoom(uiRoomEntity); //弹出要编辑的框
      },
    );
  }

  void _editerRoom(_UiRoomEntity uiRoomEntity) async {
    //这个是编辑房间的模态框
    await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          //到这一步出来一个遮罩
          return SystemPadding(
              child: CupertinoAlertDialog(
            title: Text(DefinedLocalizations.of(context).setArea),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).rename),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _renameRoom(uiRoomEntity);
                },
              ),
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).delete),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _roomDelete(uiRoomEntity);
                },
              ),
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).cancel),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          ));
        });
  }

  Widget build(BuildContext context) {
    //所有的包含   包含开始的头部 和中间的部分 也就是整个页面的开始
    // TODO: implement build
    return CommonPage(
      title: "房间管理",
      trailing: GestureDetector(
        //图片要有ontap 而ontap 需要这个控件 用这个控件子集里面一定要有的是 behavior: HitTestBehavior.opaque,
        behavior: HitTestBehavior.opaque, //是啥意思
        child: Image(
            height: 27.0, width: 27.0, image: AssetImage("images/add.png")),
        onTap: () {
          _addRoomPopup(context);
        },
      ),
      child: Container(
          // child: Text(_uiRoomEntities[0].room.name)
          child: ListView.builder(
        itemCount: _uiRoomEntities.length,
        itemBuilder: (BuildContext context, int index) {
          final _UiRoomEntity uiRoomEntity = _uiRoomEntities.elementAt(index);
          return _buildRoomItem(uiRoomEntity); //room每一项
        },
      )),
    );
  }
}

class _UiRoomEntity {
  final Room room;
  _UiRoomEntity({this.room});
}
