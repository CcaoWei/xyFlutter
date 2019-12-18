import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/session/account_manager.dart';
import 'package:xlive/session/session_manager.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;
import 'package:xlive/channel/event_channel.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/session/session.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'login_page.dart';
import 'home_center_detail_page.dart';
import 'common_page.dart';
import 'home_page.dart';

import 'dart:convert';
import 'dart:async';

class AddHomeCenterPage extends StatefulWidget {
  final bool showBackIcon;

  AddHomeCenterPage({
    this.showBackIcon = true,
  });

  State<StatefulWidget> createState() => _AddHomeCenterState();
}

class _AddHomeCenterState extends State<AddHomeCenterPage> {
  static const String className = 'AddHomeCenterPage';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  static const String HEADER = 'X-HM://';

  List<_UiEntity> uiEntities = List();

  StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void dispose() {
    super.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
  }

  void resetData() {
    print("------------------------------add_home_center_page.dart");
    uiEntities.clear();
    final List<HomeCenter> homeCenters =
        HomeCenterManager().localFoundHomeCenters;
    for (HomeCenter homeCenter in homeCenters) {
      final HomeCenter exist =
          HomeCenterManager().getHomeCenter(homeCenter.uuid);
      if (exist == null) {
        uiEntities.add(_UiEntity(homeCenter: homeCenter));
      } else if (exist.state == ASSOCIATION_TYPE_NONE) {
        uiEntities.add(_UiEntity(homeCenter: homeCenter));
      }
    }
    setState(() {});
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is LocalServiceEvent ||
            event is DeviceAssociationNotificationEvent ||
            event is AssociationMessage)
        .listen((event) {
      resetData();
      if (event is AssociationMessage) {
        print('got association message -> ${event.eventType}');
      }
      if (event is AssociationMessage && event.eventType == REQUEST_APPROVE) {
        if (HomeCenterManager().numberOfAddedHomeCenter == 1) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (BuildContext context) => HomePage(),
              settings: RouteSettings(
                name: '/Home',
              ),
            ),
            (route) => false,
          );
        }
      }
    });
  }

  void _getDeviceInformation(BuildContext context, String result) {
    final String methodName = 'getDeviceInformation';
    log.d('try to get device information', methodName);
    if (result == null || result == '') return;
    String serialNumber;
    if (result.startsWith(HEADER)) {
      serialNumber = result.substring(7);
    } else if (result.startsWith('box-')) {
      serialNumber = null;
    } else {
      serialNumber = result;
    }

    if (serialNumber != null && serialNumber != '') {
      final String token = LoginManager().token;
      HttpProxy.getDeviceInformation(token, serialNumber).then((response) {
        //var body = json.decode(response.body);
        var body = json.decode(DECODER.convert(response.bodyBytes));
        final int statusCode = body[API_STATUS_CODE];
        if (statusCode == HTTP_STATUS_CODE_OK) {
          final String deviceId = body[API_DEVICE_ID];
          final String name = body[API_NAME];

          final HomeCenter homeCenter =
              HomeCenterManager().getHomeCenter(deviceId);
          if (homeCenter == null) {
            HomeCenterManager()
                .addHomeCenter(HomeCenter(uuid: deviceId, name: name));
          } else {
            homeCenter.name = name;
          }

          //PLATFORM.invokeMethod('stopScan');
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (BuildContext context) => HomeCenterDetailPage(
                    homeCenterUuid: deviceId,
                    homeCenterName: name,
                  ),
              settings: RouteSettings(
                name: '/HomeCenterDetail',
              ),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': $statusCode',
          );
        }
      }).catchError((e) {
        log.e('ERROR: ${e.toString()}', methodName);
      });
    }
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).addHomeCenter,
      showBackIcon: widget.showBackIcon,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(left: 13.0, right: 13.0, top: 20.0, bottom: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            DefinedLocalizations.of(context).setupTip,
            style: TextStyle(
              inherit: false,
              fontSize: 14.0,
              color: const Color(0xFF6E889A),
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.0),
          ),
          Text(
            DefinedLocalizations.of(context).setupTip1,
            style: TextStyle(
              inherit: false,
              fontSize: 14.0,
              color: const Color(0xFF6E889A),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.0),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: DefinedLocalizations.of(context).automaticFound,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 14.0,
                    color: const Color(0xFF6E889A),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(
                  text: DefinedLocalizations.of(context).or,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 14.0,
                    color: const Color(0xFF6E889A),
                  ),
                ),
                TextSpan(
                  text: DefinedLocalizations.of(context).scanCode,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 14.0,
                    color: const Color(0xFF6E889A),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(
                  text: DefinedLocalizations.of(context).setupTip2,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 14.0,
                    color: const Color(0xFF6E889A),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
          ),
          Text(
            DefinedLocalizations.of(context).automaticFound,
            style: TextStyle(
              inherit: false,
              color: const Color(0xFF6E889A),
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.0),
          ),
          Text(
            DefinedLocalizations.of(context).automaticFoundDes,
            style: TextStyle(
              inherit: false,
              color: const Color(0xFF6E889A),
              fontSize: 14.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                uiEntities.length == 0
                    ? DefinedLocalizations.of(context).foundNone
                    : DefinedLocalizations.of(context).found1 +
                        ' ' +
                        uiEntities.length.toString() +
                        ' ' +
                        DefinedLocalizations.of(context).found2,
                style: TextStyle(
                  inherit: false,
                  fontSize: 14.0,
                  color: const Color(0xFFFDB557),
                ),
              ),
              Offstage(
                offstage: uiEntities.length == 0,
                child: CupertinoActivityIndicator(),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
            height: 165,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Offstage(
                  offstage: uiEntities.length != 0,
                  child: CupertinoActivityIndicator(),
                ),
                Offstage(
                  offstage: uiEntities.length == 0,
                  child: ListView.builder(
                    padding: EdgeInsets.only(),
                    itemCount: uiEntities.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildHomeCenterItem(context, uiEntities[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
          ),
          Text(
            DefinedLocalizations.of(context).foundNoneDes,
            style: TextStyle(
              inherit: false,
              fontSize: 14.0,
              color: const Color(0xFFB6C2CB),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
          ),
          Text(
            DefinedLocalizations.of(context).scanCode,
            style: TextStyle(
              inherit: false,
              color: const Color(0xFF6E889A),
              fontSize: 14.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.0),
          ),
          Text(
            DefinedLocalizations.of(context).scanCodeDes,
            style: TextStyle(
              inherit: false,
              color: const Color(0xFF6E889A),
              fontSize: 14.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.0),
          ),
          CupertinoButton(
            minSize: 16.0,
            color: Colors.white,
            disabledColor: Colors.white,
            pressedOpacity: 1.0,
            padding: EdgeInsets.only(),
            child: Text(
              DefinedLocalizations.of(context).beginScanning,
              style: TextStyle(
                inherit: false,
                fontSize: 14.0,
                color: const Color(0xFF69AAFC),
              ),
            ),
            onPressed: () {
              final Map<String, Object> argument = Map();
              argument['scanType'] = 2;
              argument['handlePermissions'] = true;
              argument['executeAfterPermissionGranted'] = true;
              argument['title'] = DefinedLocalizations.of(context).scanCode;
              argument['text'] = DefinedLocalizations.of(context).putCode;
              methodChannel.scanQRCode(argument).then((result) {
                log.d('result: $result', 'build');
                _getDeviceInformation(context, result);
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
          ),
          CupertinoButton(
            minSize: 16.0,
            color: Colors.white,
            disabledColor: Colors.white,
            pressedOpacity: 1.0,
            padding: EdgeInsets.only(),
            child: Text(
              DefinedLocalizations.of(context).logOut,
              style: TextStyle(
                inherit: false,
                fontSize: 14.0,
                color: const Color(0xFF69AAFC),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                      title: Text(
                        DefinedLocalizations.of(context).sureToLogOut,
                        style: TextStyle(
                          inherit: false,
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text(
                            DefinedLocalizations.of(context).cancel,
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .maybePop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(
                            DefinedLocalizations.of(context).out,
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            SessionManager().clearSessions();
                            HomeCenterManager().logout();
                            LoginManager().logout();
                            AccountManager().clear();
                            Navigator.of(context, rootNavigator: true)
                                .pushAndRemoveUntil(
                              CupertinoPageRoute(
                                builder: (context) => LoginPage(),
                                settings: RouteSettings(
                                  name: '/Login',
                                ),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildHomeCenterItem(BuildContext context, _UiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        height: 80.0,
        color: const Color(0xFFFAFAFA),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Image(
                        width: 33.0,
                        height: 33.0,
                        image: AssetImage('images/home_center_unselected.png'),
                      ),
                      Image(
                        width: 10.0,
                        height: 10.0,
                        image: AssetImage('images/home_center_icon_new.png'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      uiEntity.homeCenter.getName(),
                      style: TextStyle(
                        inherit: false,
                        fontSize: 16.0,
                        color: const Color(0xFF55585A),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    Text(
                      DefinedLocalizations.of(context).serialNumber +
                          ': ${uiEntity.homeCenter.serialNumber}',
                      style: TextStyle(
                        inherit: false,
                        fontSize: 14.0,
                        color: const Color(0x7F899198),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Offstage(
                  offstage: false,
                  child: Image(
                    width: 8.0,
                    height: 8.0,
                    image: AssetImage('images/red_point.png'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                ),
                Image(
                  width: 7.0,
                  height: 11.0,
                  image: AssetImage('images/icon_next.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 13.0),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (BuildContext context) => HomeCenterDetailPage(
                  homeCenterUuid: uiEntity.homeCenter.uuid,
                  homeCenterName: uiEntity.homeCenter.name,
                ),
            settings: RouteSettings(
              name: '/HomeCenterDetail',
            ),
          ),
        );
      },
    );
  }
}

class _UiEntity {
  final HomeCenter homeCenter;

  _UiEntity({
    this.homeCenter,
  });
}
