import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'set_curtain_type_page.dart';
import 'add_room_page.dart';
import 'common_page.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'dart:async';

class ConfigInfoPage extends StatefulWidget {
  final Entity entity;

  ConfigInfoPage({
    @required this.entity,
  });

  State<StatefulWidget> createState() => _ConfigInfoState();
}

class _ConfigInfoState extends State<ConfigInfoPage> {
  final TextEditingController _nameController = TextEditingController();

  final List<_UiEntity> _uiEntities = List();
  final List<Entity> _existDevices = List();

  StreamSubscription subscription;

  List<_UiEntity> get uiEntities {
    // _uiEntities.sort((a, b) {
    //   if (a.isAdd) return 1;
    //   if (b.isAdd) return -1;
    //   if (a.isDefault) return 1;
    //   if (b.isDefault) return -1;
    //   return a.room.uuid.compareTo(b.room.uuid);
    // });
    return _uiEntities;
  }

  String get roomUuid {
    for (var uiEntity in _uiEntities) {
      if (uiEntity.isCurrentRoom) {
        return uiEntity.room.uuid;
      }
    }
    return '';
  }

  bool _isNameCanBeUse(String name) {
    for (var entity in _existDevices) {
      if (entity.getName() == name) return false;
    }
    return true;
  }

  String namePrifix(BuildContext context, Entity entity) {
    if (entity is PhysicDevice) {
      if (entity.isWallSwitch || entity.isWallSwitchUS) {
        return DefinedLocalizations.of(context).wallSwitch;
      }
    } else if (entity is LogicDevice) {
      if (entity.isOnOffLight) {
        return DefinedLocalizations.of(context).lightSocket;
      } else if (entity.isSmartPlug) {
        return DefinedLocalizations.of(context).smartPlug;
      } else if (entity.isAwarenessSwitch) {
        return DefinedLocalizations.of(context).awarenessSwitch;
      } else if (entity.isDoorContact) {
        return DefinedLocalizations.of(context).doorContact;
      } else if (entity.isCurtain) {
        return DefinedLocalizations.of(context).smartCurtain;
      } else if (entity.isSmartDial) {
        return DefinedLocalizations.of(context).smartDial;
      }
    }
    return '';
  }

  String _autoCreateNewDeviceName(BuildContext context, Entity entity) {
    int index = 1;
    String newName = namePrifix(context, entity) + '0' + index.toString();
    while (!_isNameCanBeUse(newName)) {
      index++;
      if (index < 10) {
        newName = namePrifix(context, entity) + '0' + index.toString();
      } else {
        newName = namePrifix(context, entity) + index.toString();
      }
    }
    return newName;
  }

  bool get _showNext {
    if (widget.entity is LogicDevice) {
      final LogicDevice ld = widget.entity as LogicDevice;
      return ld.isCurtain;
    }
    return false;
  }

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void resetData() {
    print("------------------------------config_info_page.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    _uiEntities.clear();

    final List<Room> rooms = cache.rooms;
    bool hasDefaultRoom = false;
    for (var room in rooms) {
      if (room.uuid == DEFAULT_ROOM) {
        hasDefaultRoom = true;
      }

      final _UiEntity uiEntity = _UiEntity(room: room);
      uiEntity.isCurrentRoom = (room.uuid == widget.entity.roomUuid);
      _uiEntities.add(uiEntity);
    }

    if (!hasDefaultRoom) {
      _uiEntities.add(_UiEntity(room: Room(uuid: DEFAULT_ROOM, name: '')));
    }
    _uiEntities.add(_UiEntity(room: null));
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
      resetData();
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    final List<PhysicDevice> pds = cache.addedDevices;
    for (var pd in pds) {
      if (pd.isWallSwitch) {
        _existDevices.add(pd);
        for (var ld in pd.logicDevices) {
          _existDevices.add(ld);
        }
      } else {
        for (var ld in pd.logicDevices) {
          _existDevices.add(ld);
        }
      }
    }
    if (widget.entity.name == null ||
        widget.entity.uuid.endsWith(widget.entity.name)) {
      _nameController.text = _autoCreateNewDeviceName(context, widget.entity);
    } else {
      _nameController.text = widget.entity.getName();
    }
    setState(() {});
  }

  void dispose() {
    super.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
  }

  void _configInfo() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.configEntityInfo(
            homeCenterUuid, widget.entity.uuid, _nameController.text, roomUuid)
        .listen((response) {
      if (response.success) {
        if (_showNext) return;
        String uuid;
        if (widget.entity is LogicDevice) {
          final LogicDevice ld = widget.entity as LogicDevice;
          uuid = ld.parent.uuid;
        } else {
          uuid = widget.entity.uuid;
        }
        final Entity entity = cache.findEntity(uuid);
        entity.setAttribute(ATTRIBUTE_ID_ENTITY_IS_NEW, 0);
        //entity.isNew = false;
        final List<PhysicDevice> newDevices = cache.newDevices;
        Navigator.of(context).popUntil(
          ModalRoute.withName(newDevices.length == 0 ? '/Home' : '/AddDevice'),
        );
      } else {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
        );
      }
    });
    if (_showNext) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (BuildContext context) => SetCurtainTypePage(
                originType: CURTAIN_TYPE_NONE,
                isAdding: true,
                uuid: widget.entity.uuid,
              ),
          settings: RouteSettings(
            name: '/SetCurtainType',
          ),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).fastName,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Offstage(
              offstage: _showNext,
              child: Container(
                width: Adapt.px(200),
                alignment: Alignment.centerRight,
                child: Image(
                  width: 21.0,
                  height: 20.0,
                  image: AssetImage('images/edit_done.png'),
                ),
              ),
            ),
            Offstage(
              offstage: !_showNext,
              child: Container(
                  width: Adapt.px(200),
                  alignment: Alignment.centerRight,
                  child: Text(DefinedLocalizations.of(context).next,
                      style: TEXT_STYLE_NEXT_STEP)),
            ),
          ],
        ),
        onTap: () {
          _configInfo();
        },
      ),
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 20.0, left: 13.0, right: 13.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                  ),
                ),
                Image(
                  width: 17.0,
                  height: 14.0,
                  image: AssetImage('images/edit_flag.png'),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            Text(
              DefinedLocalizations.of(context).chooseArea,
              style: TextStyle(
                inherit: false,
                color: Color(0x662D3B46),
                fontSize: 14.0,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                itemCount: _uiEntities.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildItem(context, uiEntities.elementAt(index));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, _UiEntity uiEntity) {
    if (uiEntity.isAdd) {
      return buildAddItem(context, uiEntity);
    } else {
      return buildRoomItem(context, uiEntity);
    }
  }

  Widget buildRoomItem(BuildContext context, _UiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 2.5, bottom: 2.5),
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
                  width: uiEntity.isCurrentRoom ? 21.0 : 10.5,
                  height: uiEntity.isCurrentRoom ? 21.0 : 10.5,
                  image: AssetImage(uiEntity.isCurrentRoom
                      ? 'images/icon_check.png'
                      : 'images/icon_uncheck.png'),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        for (_UiEntity ue in _uiEntities) {
          ue.isCurrentRoom = false;
        }
        uiEntity.isCurrentRoom = true;
        setState(() {});
      },
    );
  }

  Widget buildAddItem(BuildContext context, _UiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 2.5, bottom: 2.5),
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
  bool isCurrentRoom;

  _UiEntity({
    @required this.room,
    this.isCurrentRoom = false,
  });

  bool get isAdd => room == null;

  bool get isDefault => room != null && room.uuid == DEFAULT_ROOM;
}
