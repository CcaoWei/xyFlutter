import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/data/data_shared.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'common_page.dart';

class AddRoomPage extends StatefulWidget {
  final String homeCenterUuid;

  AddRoomPage({
    @required this.homeCenterUuid,
  });

  State<StatefulWidget> createState() => AddRoomState();
}

class AddRoomState extends State<AddRoomPage> {
  final TextEditingController _nameController = TextEditingController();

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  bool _checkRoomName(BuildContext context) {
    final String roomName = _nameController.text;
    if (roomName == DefinedLocalizations.of(context).roomDefault) return false;
    final HomeCenterCache cache =
        HomeCenterManager().getHomeCenterCache(widget.homeCenterUuid);
    if (cache == null) return true;
    final List<Room> rooms = cache.rooms;
    for (var room in rooms) {
      if (room.getRoomName(context) == roomName) return false;
    }
    return true;
  }

  void _addRoom(BuildContext context) {
    if (_checkRoomName(context)) {
      final String roomName = _nameController.text;
      MqttProxy.createRoom(widget.homeCenterUuid, roomName).listen((response) {
        if (response is CreateRoomResponse) {
          if (response.success) {
            Navigator.of(context).maybePop();
          } else {
            Fluttertoast.showToast(
                msg: DefinedLocalizations.of(context).failed +
                    ': ${response.code}');
          }
        }
      });
    } else {
      Fluttertoast.showToast(
        msg: _nameController.text +
            ' ' +
            DefinedLocalizations.of(context).alreadyExist,
      );
    }
  }

  Widget build(BuildContext context) {
    print("------------------------------add_room_page.dart");
    return CommonPage(
      title: DefinedLocalizations.of(context).createRoom,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.centerRight,
          width: Adapt.px(200),
          child: Image(
            width: 21.0,
            height: 20.0,
            image: AssetImage('images/edit_done.png'),
          ),
        ),
        onTap: () {
          _addRoom(context);
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
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: DefinedLocalizations.of(context).inputRoomName,
                hintStyle: TEXT_STYLE_INPUT_HINT,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFFD9D9D9)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFFD9D9D9)),
                ),
              ),
              onChanged: (s) {
                setState(() {});
              },
            ),
            GestureDetector(
              child: Image(
                width: 17.0,
                height: 14.0,
                image: AssetImage('images/edit_flag.png'),
              ),
              onTap: () {
                _nameController.text = '';
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
