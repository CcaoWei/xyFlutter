import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/session/association_request_manager.dart';
import 'package:xlive/page/association_detail_page.dart';
import 'package:xlive/page/home_center_detail_page.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/session/session.dart';
import 'package:xlive/session/session_manager.dart';
import 'package:xlive/data/data_shared.dart';
//用来给用户展示的提示框
import 'dart:async';

class NotificationView extends StatefulWidget {
  State<StatefulWidget> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'NotificationView');

  HomeCenterNotification _notification;

  bool _errorShown = false;

  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    _notification = AssociationRequestManager().notificationToShown;
    if (SessionManager().defaultSession != null &&
        SessionManager().defaultSession.state != SESSION_STATE_CONNECTED) {
      _errorShown = true;
    } else if (HomeCenterManager().defaultHomeCenter != null &&
        !HomeCenterManager().defaultHomeCenter.online) {
      _errorShown = true;
    } else {
      _errorShown = false;
    }
    setState(() {});
  }

  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void _start() {
    _subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterNotification ||
            event is SessionStateChangedEvent ||
            event is HomeCenterEvent)
        .listen((event) {
      if (event is HomeCenterNotification) {
        _resetData();
      } else if (event is SessionStateChangedEvent) {
        _resetData();
      } else if (event is HomeCenterEvent) {
        _resetData();
      }
    });
  }

  Color get backgroundColor {
    if (_errorShown) {
      return const Color(0xFFFFEEEE);
    } else {
      return const Color(0xFFEEF9FF);
    }
  }

  String get content {
    if (_errorShown) {
      if (SessionManager().defaultSession != null &&
          SessionManager().defaultSession.state != SESSION_STATE_CONNECTED) {
        return DefinedLocalizations.of(context).tryConnecting;
      } else if (HomeCenterManager().defaultHomeCenter != null &&
          !HomeCenterManager().defaultHomeCenter.online) {
        return DefinedLocalizations.of(context).homeCenterOffline;
      }
    } else {
      if (_notification != null) {
        switch (_notification.type) {
          case HomeCenterNotification.NEW_HOME_CENTER:
            return DefinedLocalizations.of(context).newHomeCenterFound +
                ' ' +
                _notification.homeCenterName;
          case HomeCenterNotification.REQUEST:
            return _notification.message.byDisplayName +
                ' ' +
                DefinedLocalizations.of(context).requestToJoinDes +
                ' ' +
                _notification.message.deviceName;
          case HomeCenterNotification.INVITATION:
            return _notification.message.byDisplayName +
                ' ' +
                DefinedLocalizations.of(context).inviteToJoinDes +
                ' ' +
                _notification.message.deviceName;
        }
      }
    }
    return '';
  }

  Widget build(BuildContext context) {
    return Offstage(
      offstage: !(_errorShown || (!_errorShown && _notification != null)),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 42.0,
          color: backgroundColor,
          padding: EdgeInsets.only(left: 13.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildIcon(context),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
              ),
              Container(
                width: 260.0,
                child: Text(
                  content,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 14.0,
                    color: const Color(0xB52D3B46),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          HomeCenterNotification exist = _notification;
          if (_errorShown) return;
          if (exist == null) return;
          if (exist.type == HomeCenterNotification.NEW_HOME_CENTER) {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder: (BuildContext context) => HomeCenterDetailPage(
                      homeCenterUuid: exist.homeCenterUuid,
                      homeCenterName: exist.homeCenterName,
                    ),
                settings: RouteSettings(
                  name: '/HomeCenterDetail',
                ),
              ),
            );
            _notification.showInMain = false;
            _resetData();
          } else {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder: (context) =>
                    AssociationDetailPage(notification: exist),
                settings: RouteSettings(
                  name: '/AssociationDetail',
                ),
              ),
            );
            _notification.showInMain = false;
            _resetData();
          }
        },
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (_errorShown) {
      return CupertinoActivityIndicator();
      // return Image(
      //   width: 18.0,
      //   height: 18.0,
      //   image: AssetImage('images/icon_warning.png'),
      // );
    } else {
      if (_notification != null &&
          _notification.type == HomeCenterNotification.NEW_HOME_CENTER) {
        return Image(
          width: 42.0,
          height: 42.0,
          image: AssetImage('images/picture_home_center.png'),
        );
      }
    }
    return Image(
      width: 18.0,
      height: 18.0,
      image: AssetImage('images/icon_info.png'),
    );
  }
}
