import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/session/account_manager.dart';

import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';

class BindEmailPage extends StatefulWidget {
  State<StatefulWidget> createState() => BindEmailState();
}

class BindEmailState extends State<BindEmailPage> {
  static const String className = 'BindEmailPage';
  final Log log = LogFactory().getLogger(Log.DEBUG, className);

  final TextEditingController _emailController = TextEditingController();

  bool _isSubmitButtonEnabled = false;

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    print("------------------------------bind_email_page.dart");
    final String methodName = 'build';
    return CommonPage(
      title: DefinedLocalizations.of(context).bindEmail,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    final String methodName = 'buildChild';
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 20.0),
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: DefinedLocalizations.of(context).inputEmail,
                    hintStyle: TEXT_STYLE_INPUT_HINT,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFD9D9D9)),
                    ),
                  ),
                  onChanged: (s) {
                    _isSubmitButtonEnabled = (s.length > 0);
                    setState(() {});
                  },
                ),
                Offstage(
                  offstage: _emailController.text.length == 0,
                  child: GestureDetector(
                    child: Image(
                      width: 15.0,
                      height: 15.0,
                      image: AssetImage('images/delete.png'),
                    ),
                    onTap: () {
                      _emailController.text = '';
                      _isSubmitButtonEnabled =
                          (_emailController.text.length > 0);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
            ),
            Container(
              width: 200.0,
              height: 44.0,
              decoration: BOX_DECORATION_22,
              child: CupertinoButton(
                minSize: 44.0,
                padding: EdgeInsets.only(),
                child: Text(
                  DefinedLocalizations.of(context).submit,
                  style: _isSubmitButtonEnabled
                      ? TEXT_STYLE_BUTTON_ENABLED
                      : TEXT_STYLE_BUTTON_DISABLED,
                ),
                borderRadius: BorderRadius.circular(22.0),
                color: Colors.white,
                disabledColor: Colors.white,
                onPressed: !_isSubmitButtonEnabled
                    ? null
                    : () {
                        final String email = _emailController.text;
                        final String token = LoginManager().token;
                        final String username = LoginManager().username;
                        HttpProxy.addEmail(token, username, email)
                            .then((response) {
                          var body = json.decode(response.body);
                          final int statusCode = body[API_STATUS_CODE];
                          if (statusCode == HTTP_STATUS_CODE_OK) {
                            HttpProxy.getVerificationCode(
                                    VERIFICATION_CODE_TYPE_NUMBER,
                                    NOTIFICATION_TYPE_EMAIL,
                                    email,
                                    LENGTH_VERIFICATION_CODE,
                                    EXPIRE_VRIFICATION_CODE,
                                    VERIFICATION_CODE_PURPOSE_CONFIRM)
                                .then((response) {
                              var body = json.decode(response.body);
                              final int statusCode = body[API_STATUS_CODE];
                              if (statusCode == HTTP_STATUS_CODE_OK) {
                                Fluttertoast.showToast(
                                  msg: DefinedLocalizations.of(context)
                                      .emailSend,
                                );
                              }
                            }).catchError((e) {
                              log.e('ERROR: ${e.toString()}', methodName);
                            });

                            AccountManager().email = email;
                            Navigator.of(context).maybePop();
                          } else if (statusCode == HTTP_STATUS_CODE_CONFLICT) {
                            Fluttertoast.showToast(
                              msg: DefinedLocalizations.of(context).emailBinded,
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: DefinedLocalizations.of(context).failed +
                                  ': $statusCode',
                            );
                          }
                        }).catchError((e) {
                          log.e('ERROR: ${e.toString()}', methodName);
                        });
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
