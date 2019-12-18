import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'add_room_page.dart';
import 'room_setting_page.dart';
import 'common_page.dart';

import 'dart:async';

class ManageRoomPage extends StatefulWidget {
  final String homeCenterUuid;

  ManageRoomPage({
    @required this.homeCenterUuid,
  });

  State<ManageRoomPage> createState() => _ManageRoomState();
}

class _ManageRoomState extends State<ManageRoomPage> {
  final List<_UiEntity> _uiEntities = List();

  List<_UiEntity> get _sortedUiEntities {
    // _uiEntities.sort((a, b) {
    //   if (a.isAdd) return 1;
    //   if (b.isAdd) return -1;
    //   if (a.isDefault) return 1;
    //   if (b.isDefault) return -1;
    //   return a.room.uuid.compareTo(b.room.uuid);
    // });
    return _uiEntities;
  }

  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _resetData();
    _start();
  }

  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void _resetData() {
    print("------------------------------manage_room_page.dart");
    final HomeCenterCache cache =
        HomeCenterManager().getHomeCenterCache(widget.homeCenterUuid);
    if (cache == null) return;
    _uiEntities.clear();
    final List<Room> rooms = cache.rooms;
    bool hasDefaultRoom = false;
    for (var room in rooms) {
      _uiEntities.add(_UiEntity(room));
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

  void _start() {
    _subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == widget.homeCenterUuid)
        .where((event) =>
            event is RoomCreateEvent ||
            event is RoomRenameEvent ||
            event is RoomDeleteEvent)
        .listen((event) {
      _resetData();
    });
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).manageRooms,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: ListView.builder(
        itemCount: _uiEntities.length,
        itemBuilder: (BuildContext context, int index) {
          final _UiEntity uiEntity = _sortedUiEntities.elementAt(index);
          return _buildItem(context, uiEntity);
        },
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
        margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 2.5, bottom: 2.5),
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
              child: Offstage(
                offstage: uiEntity.isDefault,
                child: Image(
                  width: 7.0,
                  height: 11.0,
                  image: AssetImage('images/icon_next.png'),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (!uiEntity.isDefault) {
          final String roomUuid = uiEntity.room.uuid;
          final String roomName = uiEntity.room.getRoomName(context);
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (BuildContext context) => RoomSettingPage(
                  homeCenterUuid: widget.homeCenterUuid,
                  roomUuid: roomUuid,
                  roomName: roomName),
              settings: RouteSettings(
                name: '/RoomSettings',
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAddItem(BuildContext context, _UiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 2.5, bottom: 2.5),
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
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (BuildContext context) =>
                AddRoomPage(homeCenterUuid: widget.homeCenterUuid),
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

  _UiEntity(this.room);

  bool get isAdd => room == null;

  bool get isDefault => room != null && room.uuid == DEFAULT_ROOM;
}
