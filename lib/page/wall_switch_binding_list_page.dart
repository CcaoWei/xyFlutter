import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';

import 'key_press_binding_list_page.dart';
import 'binding_setting_page.dart';
import 'common_page.dart';

const int TOP_LEFT_BUTTON = 1;
const int TOP_RIGHT_BUTTON = 2;
const int BOTTOM_LEFT_BUTTON = 3;
const int BOTTOM_RIGHT_BUTTON = 4;
const int FIRST_BUTTON = 5;
const int SECOND_BUTTON = 6;
const int THIRD_BUTTON = 7;

class WallSwitchBindingListPage extends StatefulWidget {
  final int buttonType;
  final String triggerAddress;

  WallSwitchBindingListPage({
    @required this.buttonType,
    @required this.triggerAddress,
  });

  State<StatefulWidget> createState() => _WallSwitchBindingListState();
}

class _WallSwitchBindingListState extends State<WallSwitchBindingListPage> {
  List<_BindingUiEntity> _uiEntities = List();

  void initState() {
    super.initState();
    _uiEntities.add(_BindingUiEntity(
        _BindingUiEntity.CLICK_TYPE_SINGLE, widget.buttonType));
    _uiEntities.add(_BindingUiEntity(
        _BindingUiEntity.CLICK_TYPE_DOUBLE, widget.buttonType));
    setState(() {});
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).clickBinding,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(),
      child: ListView.builder(
          padding: EdgeInsets.only(),
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            final _BindingUiEntity uiEntity = _uiEntities[index];
            return _buildBindingItem(context, uiEntity);
          }),
    );
  }

  Widget _buildBindingItem(BuildContext context, _BindingUiEntity uiEntity) {
    return Container(
      margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
      padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
      height: 85.0,
      color: const Color(0xFFF9F9F9),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  width: 39.0,
                  height: 39.0,
                  image: AssetImage(uiEntity.bindingImageLeftUrl),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.0),
                ),
                Image(
                  width: 7.0,
                  height: 9.0,
                  image: AssetImage('images/binding_arrow.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.0),
                ),
                Image(
                  width: 39.0,
                  height: 39.0,
                  image: AssetImage(uiEntity.bindingImageRightUrl),
                  //image: AssetImage('images/binding_wall_switch_key_press.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DefinedLocalizations.of(context)
                          .definedString(uiEntity.bindingNameDescription),
                      style: TEXT_STYLE_BINDING_NAME,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    Text(
                      DefinedLocalizations.of(context)
                          .definedString(uiEntity.bindingDescription),
                      style: TEXT_STYLE_BINDING_DESCRIPTION,
                    ),
                  ],
                ),
              ],
            ),
            Image(
              width: 7.0,
              height: 11.0,
              image: AssetImage('images/icon_next.png'),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (BuildContext context) => KeyPressBindingListPage(
                    triggerAddress: widget.triggerAddress,
                    parameter: uiEntity.clickType,
                    keyPressType: uiEntity.keyPressType,
                  ),
              settings: RouteSettings(
                name: 'KeyPressBindingList',
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BindingUiEntity {
  static const int CLICK_TYPE_SINGLE = 1;
  static const int CLICK_TYPE_DOUBLE = 2;

  int clickType;
  int buttonType;

  _BindingUiEntity(this.clickType, this.buttonType);

  String get bindingImageLeftUrl {
    switch (buttonType) {
      case TOP_LEFT_BUTTON:
        return 'images/binding_wall_switch_left_top.png';
      case TOP_RIGHT_BUTTON:
        return 'images/binding_wall_switch_top.png';
      case BOTTOM_LEFT_BUTTON:
        return 'images/binding_wall_switch_left.png';
      case BOTTOM_RIGHT_BUTTON:
        return 'images/binding_wall_switch_right.png';
      case FIRST_BUTTON:
        return 'images/binding_ws_us_top.png';
      case SECOND_BUTTON:
        return 'images/binding_ws_us_mid.png';
      case THIRD_BUTTON:
        return 'images/binding_ws_us_bot.png';
      default:
        return 'images/binding_wall_switch_left_top.png';
    }
  }

  String get bindingImageRightUrl {
    switch (buttonType) {
      case TOP_LEFT_BUTTON:
      case TOP_RIGHT_BUTTON:
      case BOTTOM_LEFT_BUTTON:
      case BOTTOM_RIGHT_BUTTON:
        return 'images/binding_wall_switch_key_press.png';
      case FIRST_BUTTON:
      case SECOND_BUTTON:
      case THIRD_BUTTON:
        return 'images/binding_ws_us_press.png';
      default:
        return 'images/binding_wall_switch_key_press.png';
    }
  }

  String get bindingNameDescription {
    switch (clickType) {
      case CLICK_TYPE_SINGLE:
        return 'click_button';
      case CLICK_TYPE_DOUBLE:
        return 'double_click_button';
      default:
        return '';
    }
  }

  String get bindingDescription {
    switch (clickType) {
      case CLICK_TYPE_SINGLE:
        return 'key_press_description';
      case CLICK_TYPE_DOUBLE:
        return 'double_click_description';
      default:
        return '';
    }
  }

  int get keyPressType {
    switch (buttonType) {
      case TOP_LEFT_BUTTON:
      case TOP_RIGHT_BUTTON:
      case BOTTOM_LEFT_BUTTON:
      case BOTTOM_RIGHT_BUTTON:
        return KEY_PRESS_TYPE_WS;
      case FIRST_BUTTON:
      case SECOND_BUTTON:
      case THIRD_BUTTON:
        return KEY_PRESS_TYPE_WS_US;
      default:
        return KEY_PRESS_TYPE_WS;
    }
  }
}
