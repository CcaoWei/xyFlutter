import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/session/associate_account_manager.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';

import 'dart:convert';

const int TYPE_MOBILE = 0;
const int TYPE_EMAIL = 1;
const int TYPE_DELETE = 2;

class UserInformationPage extends StatefulWidget {
  final String username;
  final String nickname;
  final String homeCenterUuid;
  final String homeCenterName;

  UserInformationPage({
    @required this.username,
    @required this.nickname,
    @required this.homeCenterUuid,
    @required this.homeCenterName,
  });

  State<StatefulWidget> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformationPage> {
  final List<_UiEntity> uiEntities = List();
  _UiEntity mobileEntity;
  _UiEntity emailEntity;
  _UiEntity deleteEntity;

  void initState() {
    super.initState();
    initData();
    start();
  }

  void initData() {
    mobileEntity = _UiEntity(type: TYPE_MOBILE, binded: false, id: '');
    emailEntity = _UiEntity(type: TYPE_EMAIL, binded: false, id: '');
    deleteEntity = _UiEntity(type: TYPE_DELETE, binded: false, id: '');
    uiEntities.add(mobileEntity);
    uiEntities.add(emailEntity);
    uiEntities.add(deleteEntity);
    setState(() {});
  }

  void start() {
    final String token = LoginManager().token;
    HttpProxy.getUserInformation(token, widget.username, '').then((response) {
      var body = json.decode(DECODER.convert(response.bodyBytes));
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        final String mobile = body[API_MOBILE];
        final String email = body[API_EMAIL];
        if (mobile != null && mobile != '') {
          mobileEntity.id = mobile;
          mobileEntity.binded = true;
        }
        if (email != null && email != '') {
          emailEntity.id = email;
          emailEntity.binded = true;
        }
        setState(() {});
      }
    }).catchError((e) {});
  }

  void dispose() {
    super.dispose();
  }

  void displayDeleteUserDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              DefinedLocalizations.of(context).sureToDeleteUser,
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
                child: Text(
                  DefinedLocalizations.of(context).delete,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  deleteUser(context);
                },
              ),
            ],
          );
        });
  }

  void deleteUser(BuildContext context) {
    final String token = LoginManager().token;
    final String by = LoginManager().username;
    final String byDisplayName = AssociateAccountManager().nickname(by);
    HttpProxy.associateHomeCenter(
            token,
            widget.homeCenterUuid,
            ACTION_REMOVE,
            widget.username,
            widget.nickname,
            by,
            byDisplayName,
            widget.homeCenterName)
        .then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg:
                DefinedLocalizations.of(context).failed + ': ${response.code}');
      }
    }).catchError((e) {});
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: widget.nickname,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(),
        itemCount: uiEntities.length,
        itemBuilder: (BuildContext context, int index) {
          return buildItem(context, uiEntities.elementAt(index));
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, _UiEntity uiEntity) {
    if (uiEntity.type == TYPE_DELETE) {
      return buildDeleteItem(context, uiEntity);
    } else {
      return buildInformationItem(context, uiEntity);
    }
  }

  Widget buildInformationItem(BuildContext context, _UiEntity uiEntity) {
    return Container(
      margin: EdgeInsets.only(left: 13.0, right: 13.0),
      height: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 78.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Image(
                    width: 33.0,
                    height: 33.0,
                    image: AssetImage(uiEntity.imageUrl),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        uiEntity.getBindingState(context),
                        style: TextStyle(
                          inherit: false,
                          color: const Color(0xB42D3B46),
                          fontSize: 14.0,
                        ),
                      ),
                      Offstage(
                        offstage: uiEntity.id == null,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Text(
                            uiEntity.id,
                            style: TextStyle(
                              inherit: false,
                              color: const Color(0xB42D3B46),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 2.0,
            color: const Color(0x33101B25),
          ),
        ],
      ),
    );
  }

  Widget buildDeleteItem(BuildContext context, _UiEntity uiEntity) {
    return Offstage(
      offstage: widget.username == LoginManager().username,
      child: Container(
        padding: EdgeInsets.only(
            top: 100.0,
            left: MediaQuery.of(context).size.width / 2 - 100.0,
            right: MediaQuery.of(context).size.width / 2 - 100.0),
        child: CupertinoButton(
          child: Container(
            width: 200.0,
            height: 44.0,
            alignment: Alignment.center,
            child: Text(
              DefinedLocalizations.of(context).delete,
              style: TEXT_STYLE_DELETE_BUTTON,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFF8443)),
              borderRadius: BorderRadius.circular(22.0),
            ),
          ),
          color: const Color(0xFFFF8443),
          padding: EdgeInsets.only(),
          pressedOpacity: 0.7,
          borderRadius: BorderRadius.circular(22.0),
          onPressed: () {
            displayDeleteUserDialog(context);
          },
        ),
      ),
    );
  }
}

class _UiEntity {
  final int type;
  bool binded = false;
  String id;

  _UiEntity({
    Key key,
    @required this.type,
    this.binded,
    this.id,
  });

  String get imageUrl {
    switch (type) {
      case TYPE_MOBILE:
        return 'images/binding_mobile.png';
      case TYPE_EMAIL:
        return 'images/binding_email.png';
      default:
        return '';
    }
  }

  String getBindingState(BuildContext context) {
    if (binded) {
      return DefinedLocalizations.of(context).binded;
    } else {
      return DefinedLocalizations.of(context).notBind;
    }
  }
}
