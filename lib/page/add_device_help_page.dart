import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';

import 'add_device_help_detail_page.dart';
import 'common_page.dart';

class AddDeviceHelpPage extends StatelessWidget {
  String _imageUrl(int index) {
    switch (index) {
      case 0:
        return 'images/picture_light.png';
      case 1:
        return 'images/picture_plug.png';
      case 2:
        return 'images/picture_awareness_switch.png';
      case 3:
        return 'images/picture_door_contact.png';
      default:
        return '';
    }
  }

  String _deviceType(int index) {
    switch (index) {
      case 0:
        return 'light_socket';
      case 1:
        return 'smart_plug';
      case 2:
        return 'awareness_switch';
      case 3:
        return 'door_contact';
      default:
        return 'none';
    }
  }

  Widget build(BuildContext context) {
    print("------------------------------add_device_help_page.dart");
    return CommonPage(
      title: DefinedLocalizations.of(context).addDevice,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0, left: 13.0),
          child: Text(
            DefinedLocalizations.of(context).chooseDeviceType,
            style: TextStyle(
              inherit: false,
              color: Color(0xFFD4D4D4),
              fontSize: 14.0,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 5.0),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return _buildItem(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      child: Container(
        color: Color(0xFFFAFAFA),
        height: 80.0,
        margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image(
                  alignment: Alignment.center,
                  width: 60.0,
                  height: 60.0,
                  image: AssetImage(_imageUrl(index)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0),
                ),
                Text(
                  DefinedLocalizations.of(context)
                      .definedString(_deviceType(index)),
                  style: TextStyle(
                    inherit: false,
                    fontSize: 16.0,
                    color: Color(0xFF55585A),
                  ),
                ),
              ],
            ),
            Image(
              width: 10.0,
              height: 15.0,
              image: AssetImage('images/icon_next.png'),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddDeviceHelpDetailPage(index: index),
          ),
        );
      },
    );
  }
}
