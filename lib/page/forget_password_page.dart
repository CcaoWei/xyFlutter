import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/const/const_shared.dart';

import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import 'reset_password_page.dart';
import 'account_binding_page.dart';
import 'common_page.dart';

class ForgetPasswordPage extends StatefulWidget {
  State<StatefulWidget> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPasswordPage> {
  String _email = null;
  String _mobile = null;

  bool _emailConfirmed = false;

  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    final String token = LoginManager().token;
    final String username = LoginManager().username;
    HttpProxy.getUserInformation(token, username, '').then((response) {
      var body = json.decode(DECODER.convert(response.bodyBytes));
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        final String email = body[API_EMAIL];
        final String mobile = body[API_MOBILE];
        if (email != null && email.isNotEmpty) {
          _email = email;
          _emailConfirmed = body[API_EMAIL_CONFIRMED];
        }
        if (mobile != null && mobile.isNotEmpty) {
          _mobile = mobile;
        }
      }
    }).catchError((e) {
      print('ERROR: ${e.toString()}');
    });
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    print("------------------------------forget_password_page.dart");
    return CommonPage(
      title: DefinedLocalizations.of(context).resetPassword,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DefinedLocalizations.of(context).resetPasswordDes1,
                style: TextStyle(
                  inherit: false,
                  fontSize: 14.0,
                  color: Color(0x702D3B46),
                ),
              ),
              Text(
                DefinedLocalizations.of(context).resetPasswordDes2,
                style: TextStyle(
                  inherit: false,
                  fontSize: 14.0,
                  color: Color(0x702D3B46),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0),
          ),
          Container(
            width: 220.0,
            height: 44.0,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0x33000000)),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: CupertinoButton(
              minSize: 44.0,
              padding: EdgeInsets.only(),
              color: Colors.white,
              disabledColor: Colors.white,
              borderRadius: BorderRadius.circular(22.0),
              child: Text(
                DefinedLocalizations.of(context).getCodeByMobile,
                style: TextStyle(
                  inherit: false,
                  fontSize: 16.0,
                  color: Color(0xFF606972),
                ),
              ),
              onPressed: () {
                if (_mobile == null) {
                  Fluttertoast.showToast(
                    msg: DefinedLocalizations.of(context).mobileNotBind,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                } else {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ResetPasswordPage(
                          type: NOTIFICATION_TYPE_SMS,
                          idType: 'mobile',
                          target: _mobile),
                      settings: RouteSettings(
                        name: '/ResetPassword',
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
          ),
          Container(
            width: 220.0,
            height: 44.0,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0x33000000)),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: CupertinoButton(
                minSize: 44.0,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                color: Colors.white,
                disabledColor: Colors.white,
                borderRadius: BorderRadius.circular(22.0),
                child: Text(
                  DefinedLocalizations.of(context).getCodeByEmail,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 16.0,
                    color: Color(0xFF606972),
                  ),
                ),
                onPressed: () {
                  if (_email == null) {
                    Fluttertoast.showToast(
                      msg: DefinedLocalizations.of(context).emailNotBind,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else if (!_emailConfirmed) {
                    Fluttertoast.showToast(
                      msg: DefinedLocalizations.of(context).emailNotConfirmed,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ResetPasswordPage(
                            type: NOTIFICATION_TYPE_EMAIL,
                            idType: 'email',
                            target: _email),
                        settings: RouteSettings(
                          name: '/ResetPassword',
                        ),
                      ),
                    );
                  }
                }),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                DefinedLocalizations.of(context).notBindEmailAndMobile,
                style: TextStyle(
                  inherit: false,
                  fontSize: 12.0,
                  color: Color(0x702D3B46),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 8.0)),
              CupertinoButton(
                minSize: 14.0,
                padding: EdgeInsets.only(),
                child: Text(
                  DefinedLocalizations.of(context).bindNow,
                  style: TextStyle(
                      inherit: false, color: Color(0xFF65b9ff), fontSize: 12.0),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => AccountBindingPage(),
                      settings: RouteSettings(
                        name: '/AccountBinding',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
