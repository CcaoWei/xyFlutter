import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/session/association_request_manager.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/session/account_manager.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/const/const_shared.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';

import 'dart:convert';
import 'dart:async';

class AssociationDetailPage extends StatefulWidget {
  final HomeCenterNotification notification;

  AssociationDetailPage({
    @required this.notification,
  });

  State<StatefulWidget> createState() => _AssociationDetailState();
}

class _AssociationDetailState extends State<AssociationDetailPage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'AssociationDetailPage');

  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _start();
  }

  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void _start() {}

  String getTitle(BuildContext context) {
    switch (widget.notification.type) {
      case HomeCenterNotification.REQUEST:
        return DefinedLocalizations.of(context).request;
      case HomeCenterNotification.INVITATION:
        return DefinedLocalizations.of(context).invitation;
      default:
        return '';
    }
  }

  void _associateHomeCenter(String homeCenterUuid, String action, String user,
      String userDisplayName, String deviceName) {
    final String methodName = 'associateHomeCenter';
    final String token = LoginManager().token;
    if (token == '') return;
    final String by = LoginManager().username;
    final String byDisplayName = AccountManager().nickname;
    if (by == '') return;
    HttpProxy.associateHomeCenter(token, homeCenterUuid, action, user,
            userDisplayName, by, byDisplayName, deviceName)
        .then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      final String message = body[API_MESSAGE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        Navigator.of(context).maybePop();
      } else if (statusCode == 40000 &&
          message == "the user isn't pending on approval") {
        Navigator.of(context).maybePop();
      } else {
        log.w('associate home center result: $message', methodName);
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed + ': $statusCode',
        );
      }
    }).catchError((e) {
      log.e('ASSOCIATE HOME CENTER ERROR: ${e.toString()}', methodName);
    });
  }

  Widget build(BuildContext context) {
    print("------------------------------associtate_detail_page.dart");
    return CommonPage(
      title: getTitle(context),
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: 13.0, right: 13.0, top: 20.0, bottom: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 33.0,
                    height: 33.0,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('images/avatar_default.png'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                  Text(
                    widget.notification.message.byDisplayName,
                    style: TextStyle(
                      inherit: true,
                      fontSize: 15.0,
                      color: const Color(0xFF00000E),
                    ),
                  ),
                  Text(
                    DefinedLocalizations.of(context).requestToJoin,
                    style: TextStyle(
                      inherit: false,
                      fontSize: 15.0,
                      color: const Color(0xFF00000E),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              Text(
                widget.notification.message.deviceName,
                style: TextStyle(
                  inherit: false,
                  fontSize: 15.0,
                  color: const Color(0xFF00000E),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              Container(
                color: const Color(0xFFFAFAFA),
                padding: EdgeInsets.only(bottom: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                    ),
                    Image(
                      width: 120.0,
                      height: 120.0,
                      image: AssetImage('images/picture_home_center.png'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width:
                              (MediaQuery.of(context).size.width - 26) * 0.45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                DefinedLocalizations.of(context).name + ': ',
                                style: TextStyle(
                                  inherit: false,
                                  fontSize: 15.0,
                                  color: const Color(0xFF1D1F20),
                                ),
                              ),
                              Text(
                                DefinedLocalizations.of(context).serialNumber +
                                    ': ',
                                style: TextStyle(
                                  inherit: false,
                                  fontSize: 15.0,
                                  color: const Color(0xFF1D1F20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width:
                              (MediaQuery.of(context).size.width - 26) * 0.55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.notification.message.deviceName,
                                style: TextStyle(
                                  inherit: false,
                                  fontSize: 15.0,
                                  color: const Color(0xFF1D1F20),
                                ),
                              ),
                              Text(
                                HomeCenter.getSerialNumber(
                                    widget.notification.message.deviceUuid),
                                style: TextStyle(
                                  inherit: false,
                                  fontSize: 15.0,
                                  color: const Color(0xFF1D1F20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CupertinoButton(
                child: Container(
                  width: 140.0,
                  height: 40.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0x3397BAC6)),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    DefinedLocalizations.of(context).reject,
                    style: TextStyle(
                      color: const Color(0xFF2D3B46),
                      fontSize: 16.0,
                      inherit: false,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                disabledColor: Colors.white,
                onPressed: () {
                  if (widget.notification.type ==
                      HomeCenterNotification.REQUEST) {
                    final String homeCenterUuid =
                        widget.notification.message.deviceUuid;
                    final String action = ACTION_REJECT;
                    final String user = widget.notification.message.by;
                    final String userDisplayName =
                        widget.notification.message.byDisplayName;
                    final String deviceName =
                        widget.notification.message.deviceName;
                    _associateHomeCenter(homeCenterUuid, action, user,
                        userDisplayName, deviceName);
                  } else if (widget.notification.type ==
                      HomeCenterNotification.INVITATION) {
                    final String homeCenterUuid =
                        widget.notification.message.deviceUuid;
                    final String action = ACTION_DECLINE;
                    final String user = LoginManager().username;
                    final String userDisplayName = AccountManager().nickname;
                    final String deviceName =
                        widget.notification.message.deviceName;
                    _associateHomeCenter(homeCenterUuid, action, user,
                        userDisplayName, deviceName);
                  }
                },
              ),
              CupertinoButton(
                child: Container(
                  width: 140.0,
                  height: 40.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0x3397BAC6)),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    widget.notification.type == HomeCenterNotification.REQUEST
                        ? DefinedLocalizations.of(context).approve
                        : DefinedLocalizations.of(context).accept,
                    //DefinedLocalizations.of(context).approve,
                    style: TextStyle(
                      color: const Color(0xFF2D3B46),
                      fontSize: 16.0,
                      inherit: false,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                disabledColor: Colors.white,
                onPressed: () {
                  if (widget.notification.type ==
                      HomeCenterNotification.REQUEST) {
                    final String homeCenterUuid =
                        widget.notification.message.deviceUuid;
                    final String action = ACTION_APPROVE;
                    final String user = widget.notification.message.by;
                    final String userDisplayName =
                        widget.notification.message.byDisplayName;
                    final String deviceName =
                        widget.notification.message.deviceName;
                    _associateHomeCenter(homeCenterUuid, action, user,
                        userDisplayName, deviceName);
                  } else if (widget.notification.type ==
                      HomeCenterNotification.INVITATION) {
                    final String homeCenterUuid =
                        widget.notification.message.deviceUuid;
                    final String action = ACTION_ACCEPT;
                    final String user = LoginManager().username;
                    final String userDisplayName = AccountManager().nickname;
                    final String deviceName =
                        widget.notification.message.deviceName;
                    _associateHomeCenter(homeCenterUuid, action, user,
                        userDisplayName, deviceName);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
