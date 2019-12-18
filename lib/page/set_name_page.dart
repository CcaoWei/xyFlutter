import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'package:xlive/const/const_shared.dart';
import 'dart:ui';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/log/log_shared.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';

class SetNamePage extends StatefulWidget {
  final Entity entity;
  final HomeCenter homeCenter;

  SetNamePage({
    this.entity,
    this.homeCenter,
  });

  State<StatefulWidget> createState() => _SetNameState();
}

class _SetNameState extends State<SetNamePage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'SetNamePage');

  TextEditingController _nameController = TextEditingController();

  void initState() {
    super.initState();
    print("----------------------set-name-page.dart");
    if (widget.entity != null) {
      _nameController.text = widget.entity.getName();
      _nameController.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.entity.getName().length));
    }
    if (widget.homeCenter != null) {
      _nameController.text = widget.homeCenter.getName();
      _nameController.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.homeCenter.getName().length));
    }
  }

  void _setName(BuildContext context) {
    final String methodName = 'setName';
    if (widget.entity != null) {
      final String newName = _nameController.text;
      final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
      final String uuid = widget.entity.uuid;
      MqttProxy.setName(homeCenterUuid, uuid, newName).listen((response) {
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
    } else if (widget.homeCenter != null) {
      final String newName = _nameController.text;
      final String homeCenterUuid = widget.homeCenter.uuid;
      final String uuid = widget.homeCenter.uuid;
      MqttProxy.setName(homeCenterUuid, uuid, newName).listen((response) {
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
    }
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).changeDeviceName,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.centerRight,
          width: Adapt.px(200),
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
          _setName(context);
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
              onChanged: (s) {
                //_nameController.text = s;
                setState(() {});
              },
            ),
            GestureDetector(
              onTap: () {
                _nameController.text = '';
                setState(() {});
              },
              child: Image(
                width: 17.0,
                height: 14.0,
                image: AssetImage('images/edit_flag.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
