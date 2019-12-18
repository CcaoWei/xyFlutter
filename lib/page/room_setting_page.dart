import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';

class RoomSettingPage extends StatefulWidget {
  final String homeCenterUuid;
  final String roomUuid;
  final String roomName;

  RoomSettingPage({
    @required this.homeCenterUuid,
    @required this.roomUuid,
    @required this.roomName,
  });

  State<StatefulWidget> createState() => _RoomSettingState();
}

class _RoomSettingState extends State<RoomSettingPage> {
  final TextEditingController _nameController = TextEditingController();

  void initState() {
    super.initState();
    _nameController.text = widget.roomName;
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

  void _renameRoom(BuildContext context) {
    if (_checkRoomName(context)) {
      final String roomName = _nameController.text;
      MqttProxy.configEntityInfo(
              widget.homeCenterUuid, widget.roomUuid, roomName, '')
          .listen((response) {
        if (response is ConfigInfoResponse) {
          if (response.success) {
            Navigator.of(context).pop();
          } else {
            Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).failed +
                  ': ${response.code}',
            );
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

  void _displayDeleteRoomDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              DefinedLocalizations.of(context).sureToDeleteRoom,
              style: TEXT_STYLE_DIALOG_TITLE,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).cancel),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).delete),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _deleteRoom(context);
                },
              ),
            ],
          );
        });
  }

  void _deleteRoom(BuildContext context) {
    final HomeCenterCache cache =
        HomeCenterManager().getHomeCenterCache(widget.homeCenterUuid);
    List<PhysicDevice> physicDevices = cache.addedDevices;
    // print(widget.roomUuid+'------------------');
    MqttProxy.deleteRoom(widget.homeCenterUuid, widget.roomUuid)
        .listen((response) {
      if (response is DeleteRoomResponse) {
        if (response.success) {
          // for (var pd in physicDevices) {
          //   if (pd.isZHHVRVGateway) {
          //     for (var ld in pd.logicDevices) {
          //       if (ld.roomUuid == widget.roomUuid) {
          //         ld.roomUuid = pd.roomUuid;
          //       }
          //     }
          //   }
          // }
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
      title: DefinedLocalizations.of(context).configRoom,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: Adapt.px(200),
          alignment: Alignment.centerRight,
          child: Image(
            width: 21.0,
            height: 20.0,
            image: AssetImage('images/edit_done.png'),
          ),
        ),
        onTap: () {
          _renameRoom(context);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
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
            Padding(
              padding: EdgeInsets.only(top: 50.0),
            ),
            CupertinoButton(
              padding: EdgeInsets.only(),
              child: Container(
                width: 200.0,
                height: 44.0,
                alignment: Alignment.center,
                child: Text(
                  DefinedLocalizations.of(context).delete,
                  style: TEXT_STYLE_DELETE_BUTTON,
                ),
              ),
              color: const Color(0xFFFF8443),
              pressedOpacity: 0.7,
              borderRadius: BorderRadius.circular(22.0),
              onPressed: () {
                _displayDeleteRoomDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
