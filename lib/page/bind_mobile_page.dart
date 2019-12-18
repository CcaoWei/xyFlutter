import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:xlive/const/const_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/session/account_manager.dart';

import 'dart:async';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';

class BindMobilePage extends StatefulWidget {
  State<StatefulWidget> createState() => BindMobileState();
}

class BindMobileState extends State<BindMobilePage> {
  static const String className = 'BindMobilePage';
  final Log log = LogFactory().getLogger(Log.DEBUG, className);

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  bool _isGetCodeButtonEnabled = false;
  bool _isSubmitButtonEnabled = false;

  Timer _timer;
  int _seconds = 0;

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (time) {
      if (_seconds == 0) {
        _timer.cancel();
        _isGetCodeButtonEnabled = (_mobileController.text.length > 0);
        setState(() {});
        return;
      }
      _isGetCodeButtonEnabled = false;
      _seconds--;
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    print("------------------------------bind_mobile_page.dart");
    final String methodName = "build";
    return CommonPage(
      title: DefinedLocalizations.of(context).bindMobile,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    final String methodName = 'buildChild';
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 20.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                TextField(
                  controller: _mobileController,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: DefinedLocalizations.of(context).inputMobile,
                    hintStyle: TEXT_STYLE_INPUT_HINT,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFD9D9D9)),
                    ),
                  ),
                  onChanged: (s) {
                    _isGetCodeButtonEnabled = (s.length > 0) && (_seconds == 0);
                    _isSubmitButtonEnabled = (s.length > 0) &&
                        (_verificationCodeController.text.length > 0);
                    setState(() {});
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Offstage(
                      offstage: _mobileController.text.length == 0,
                      child: GestureDetector(
                          child: Image(
                            width: 15.0,
                            height: 15.0,
                            image: AssetImage('images/delete.png'),
                          ),
                          onTap: () {
                            _mobileController.text = '';
                            setState(() {});
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.0),
                    ),
                    Container(
                      width: 90.0,
                      height: 24.0,
                      decoration: BOX_DECORATION_12,
                      child: CupertinoButton(
                        minSize: 24.0,
                        padding: EdgeInsets.only(),
                        child: Text(
                          _seconds == 0
                              ? DefinedLocalizations.of(context).getCode
                              : DefinedLocalizations.of(context).sendAgain +
                                  '(${_seconds.toString()})',
                          style: _isGetCodeButtonEnabled
                              ? TEXT_STYLE_GET_CODE_BUTTON_ENABLED
                              : TEXT_STYLE_GET_CODE_BUTTON_DISABLED,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                        disabledColor: Colors.white,
                        onPressed: !_isGetCodeButtonEnabled
                            ? null
                            : () {
                                _startTimer();

                                final String mobile = _mobileController.text;
                                HttpProxy.getVerificationCode(
                                        VERIFICATION_CODE_TYPE_NUMBER,
                                        NOTIFICATION_TYPE_SMS,
                                        mobile,
                                        LENGTH_VERIFICATION_CODE,
                                        EXPIRE_VRIFICATION_CODE,
                                        VERIFICATION_CODE_PURPOSE_CONFIRM)
                                    .then((response) {
                                  var body = json.decode(response.body);
                                  final int statusCode = body[API_STATUS_CODE];
                                  if (statusCode == HTTP_STATUS_CODE_OK) {
                                    LoginManager().verificationCodeId =
                                        body[API_VERIFICATION_CODE_ID];
                                  }
                                }).catchError((e) {
                                  log.e('ERROR: ${e.toString()}', methodName);
                                });
                              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                TextField(
                  controller: _verificationCodeController,
                  maxLength: 6,
                  decoration: InputDecoration(
                    hintText: DefinedLocalizations.of(context).inputCode,
                    hintStyle: TEXT_STYLE_INPUT_HINT,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFD9D9D9)),
                    ),
                  ),
                  onChanged: (s) {
                    _isSubmitButtonEnabled =
                        (s.length > 0) && (_mobileController.text.length > 0);
                    setState(() {});
                  },
                ),
                Offstage(
                  offstage: _verificationCodeController.text.length == 0,
                  child: GestureDetector(
                    child: Image(
                      width: 15.0,
                      height: 15.0,
                      image: AssetImage('images/delete.png'),
                    ),
                    onTap: () {
                      _verificationCodeController.text = '';
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
                        final String mobile = _mobileController.text;
                        final String verificationCode =
                            _verificationCodeController.text;
                        final String username = LoginManager().username;
                        final String token = LoginManager().token;
                        final String verificationCodeId =
                            LoginManager().verificationCodeId;
                        HttpProxy.confirmMobile(token, username, mobile,
                                verificationCode, verificationCodeId)
                            .then((response) {
                          var body = json.decode(response.body);
                          final int statusCode = body[API_STATUS_CODE];
                          if (statusCode == HTTP_STATUS_CODE_OK) {
                            AccountManager().mobile = mobile;

                            //RxBus().post(AccountBindEvent(type: ACCOUNT_BIND_TYPE_MOBILE));

                            Navigator.of(context).maybePop();
                          } else if (statusCode == HTTP_STATUS_CODE_CONFLICT) {
                            Fluttertoast.showToast(
                              msg:
                                  DefinedLocalizations.of(context).mobileBinded,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: DefinedLocalizations.of(context).failed +
                                  ': $statusCode',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
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
