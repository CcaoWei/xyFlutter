import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'add_room_page.dart';
import 'common_page.dart';

import 'dart:async';

class SetRoomPage extends StatefulWidget {
  final Entity entity;

  SetRoomPage({@required this.entity});

  State<StatefulWidget> createState() => _SetRoomState();
}

class _SetRoomState extends State<SetRoomPage> {
  final List<_UiEntity> _uiEntities = List();

  StreamSubscription subscription;

  List<_UiEntity> get uiEntities {
    // _uiEntities.sort((a, b) {
    //   if (a.isAdd) return 1;
    //   if (b.isAdd) return -1;
    //   if (a.room.uuid == widget.entity.roomUuid) return -1;
    //   if (b.room.uuid == widget.entity.roomUuid) return 1;
    //   if (a.isDefault) return 1;
    //   if (b.isDefault) return -1;
    //   return a.room.uuid.compareTo(b.room.uuid);
    // });
    return _uiEntities;
  }

  String get areaUuid {
    for (var uiEntity in _uiEntities) {
      if (uiEntity.selected) {
        return uiEntity.room.uuid;
      }
    }
    return '';
  }

  void initState() {
    super.initState();
    _resetData();
    start();
  }

  void dispose() {
    super.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
  }

  void _resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    assert(cache != null);
    _uiEntities.clear();
    bool hasDefaultRoom = false;
    final List<Room> rooms = cache.rooms;
    for (var room in rooms) {
      final _UiEntity uiEntity = _UiEntity(room);
      uiEntity.selected = (room.uuid == widget.entity.roomUuid);
      _uiEntities.add(uiEntity);
      if (room.uuid == DEFAULT_ROOM) {
        hasDefaultRoom = true;
      }
    }
    if (!hasDefaultRoom) {
      _uiEntities.add(_UiEntity(Room(uuid: DEFAULT_ROOM, name: '')));
    }
    _uiEntities.add(_UiEntity(null));
    setState(() {});
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
        .where((event) =>
            event is RoomCreateEvent ||
            event is RoomDeleteEvent ||
            event is RoomRenameEvent)
        .listen((event) {
      _resetData();
    });
  }

  void _setArea(BuildContext context) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    if (homeCenterUuid == null || widget.entity.uuid == null) return;
    final String uuid = widget.entity.uuid;
    MqttProxy.setRoom(homeCenterUuid, uuid, areaUuid).listen((response) {
      if (response is ConfigInfoResponse) {
        if (response.success) {
          Navigator.of(context).pop();
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).setArea,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.centerRight,
          width: Adapt.px(250),
          child: Container(
            padding: EdgeInsets.only(left: OK_BUTTON_LEFT_PADDING),
            child: Image(
              width: 21.0,
              height: 20.0,
              image: AssetImage('images/edit_done.png'),
            ),
          ),
        ),
        onTap: () {
          _setArea(context);
        },
      ),
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 20.0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(DefinedLocalizations.of(context).chooseArea,
              style: TextStyle(
                inherit: false,
                color: Color(0x662d3B46),
                fontSize: 14.0,
              )),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: _uiEntities.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildItem(context, uiEntities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, _UiEntity uiEntity) {
    if (uiEntity.isAdd) {
      return _buildAddItem(context, uiEntity);
    }
    return _buildRoomItem(context, uiEntity);
  }

  Widget _buildRoomItem(BuildContext context, _UiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(top: 2.5, bottom: 2.5),
        height: 80.0,
        color: const Color(0xFFFAFAFA),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text(
                uiEntity.room.getRoomName(context),
                style: TextStyle(
                  inherit: false,
                  fontSize: 16.0,
                  color: const Color(0xFF575859),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: Container(
                width: 21.0,
                height: 21.0,
                alignment: Alignment.center,
                child: Image(
                  width: uiEntity.selected ? 21.0 : 10.5,
                  height: uiEntity.selected ? 21.0 : 10.5,
                  image: AssetImage(uiEntity.selected
                      ? 'images/icon_check.png'
                      : 'images/icon_uncheck.png'),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        for (var uiEntity in _uiEntities) {
          if (uiEntity.isAdd) continue;
          uiEntity.selected = false;
        }
        uiEntity.selected = !uiEntity.selected;
        setState(() {});
      },
    );
  }

  Widget _buildAddItem(BuildContext context, _UiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(top: 2.5, bottom: 2.5),
        height: 80.0,
        color: const Color(0xFFFAFAFA),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text(
                DefinedLocalizations.of(context).createRoom,
                style: TEXT_STYLE_CREATE_ROOM,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: Image(
                width: 21.0,
                height: 21.0,
                image: AssetImage('images/add_room.png'),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (BuildContext context) =>
                AddRoomPage(homeCenterUuid: homeCenterUuid),
            settings: RouteSettings(
              name: '/AddRoom',
            ),
          ),
        );
      },
    );
  }
}

class _UiEntity {
  final Room room;

  bool selected = false;

  _UiEntity(this.room);

  bool get isAdd => room == null;

  bool get isDefault => room != null && room.uuid == DEFAULT_ROOM;
}
