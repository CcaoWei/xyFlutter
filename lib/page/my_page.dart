import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/session/session_manager.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/homekit_page/homekit_main_page.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/session/account_manager.dart';
import 'package:xlive/firmware/firmware_manager.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'login_page.dart';
import 'change_password_page.dart';
import 'about_us_page.dart';
import 'associate_account_page.dart';
import 'account_binding_page.dart';
import 'common_page.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:async';

class MyPage extends StatefulWidget {
  State<StatefulWidget> createState() => _MyState();
}

class _MyState extends State<MyPage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'MyPage');

  final List<_UiEntity> _uiEntities = List();

  StreamSubscription subscription;

  void initState() {
    super.initState();
    print(_UiEntity(_UiEntity.ACCOUNT_BINDING));
    _uiEntities.add(_UiEntity(_UiEntity.ACCOUNT_BINDING));
    _uiEntities.add(_UiEntity(_UiEntity.CHANGE_PASSWORD));
    _uiEntities.add(_UiEntity(_UiEntity.FAMILY));
    if (LoginManager().platform == PLATFORM_IOS) {
      // TODO:
      _uiEntities.add(_UiEntity(_UiEntity.HOMEKIT));
    }
    _uiEntities.add(_UiEntity(_UiEntity.LOG_OUT));
    _uiEntities.add(_UiEntity(_UiEntity.HELP));
    _uiEntities.add(_UiEntity(_UiEntity.ABOUT_US));
    AccountManager().refreshAccountInformation();

    setState(() {});

    start();
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => event is HomeCenterEvent)
        .listen((event) {
      final HomeCenterEvent evt = event as HomeCenterEvent;
      if (evt.type == HOME_CENTER_CHANGED) {
        setState(() {});
      }
    });
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    super.dispose();
  }

  void _launchUrl() async {
    var url = 'https://www.' +
        DefinedLocalizations.of(context).officialSiteRoot +
        '/blog';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  bool get showIndicatorRedPoint {
    final List<HomeCenter> temp1 = HomeCenterManager().localFoundHomeCenters;
    for (HomeCenter homeCenter in temp1) {
      if (homeCenter.state == ASSOCIATION_TYPE_NONE) return true;
    }
    final Map<String, HomeCenter> temp2 = HomeCenterManager().homeCenters;
    for (String uuid in temp2.keys) {
      final int number = FirmwareManager().numberOfDevicesCanUpgrade(uuid);
      if (number > 0) return true;
    }
    return false;
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: HomeCenterManager().defaultHomeCenter == null
          ? DefinedLocalizations.of(context).my
          : HomeCenterManager().defaultHomeCenter.getName(),
      showBackIcon: false,
      showMenuIcon: true,
      showRedPoint: showIndicatorRedPoint,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(),
              itemCount: _uiEntities.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildItem(context, _uiEntities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFFFCFCFC),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 40.0,
            backgroundImage: AssetImage('images/avatar_default.png'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Text(
            AccountManager().nickname,
            style: TextStyle(
              inherit: false,
              color: const Color(0xFF2D3B46),
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, _UiEntity uiEntity) {
    final String methodName = 'buildItem';
    return GestureDetector(
      child: Container(
        height: 48.0,
        padding: EdgeInsets.only(left: 13.0, right: 0.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  uiEntity.getTitle(context),
                  //DefinedLocalizations.of(context).definedString(uiEntity.title),
                  style: TextStyle(
                    inherit: false,
                    color: Color(0xB22D3B46),
                    fontSize: 16.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 13.0),
                  child: Image(
                    width: 9.0,
                    height: 15.0,
                    image: AssetImage('images/icon_next.png'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.0),
            ),
            Divider(
              height: 2.0,
              color: Color(0x33000000),
            ),
          ],
        ),
      ),
      onTap: () {
        if (uiEntity.type == _UiEntity.LOG_OUT) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text(
                  DefinedLocalizations.of(context).sureToLogOut,
                  style: TEXT_STYLE_DIALOG_TITLE,
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
                            name: '/My',
                          ),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else if (uiEntity.type == _UiEntity.FAMILY) {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (context) => AssociateAccountPage(
                    homeCenterUuid: null,
                    type: MY_FAMILY,
                  ),
              settings: RouteSettings(
                name: '/Family',
              ),
            ),
          );
        } else if (uiEntity.type == _UiEntity.ABOUT_US) {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (context) => AboutUsPage(),
              settings: RouteSettings(
                name: '/AboutUs',
              ),
            ),
          );
        } else if (uiEntity.type == _UiEntity.HELP) {
          _launchUrl();
        } else if (uiEntity.type == _UiEntity.CHANGE_PASSWORD) {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (context) => ChangePasswordPage(),
              settings: RouteSettings(
                name: '/ChangePassword',
              ),
            ),
          );
        } else if (uiEntity.type == _UiEntity.ACCOUNT_BINDING) {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (context) => AccountBindingPage(),
              settings: RouteSettings(
                name: '/AccountBinding',
              ),
            ),
          );
        } else if (uiEntity.type == _UiEntity.HOMEKIT) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => HomekitMainPage(),
              settings: RouteSettings(
                name: '/HomekitMain',
              ),
            ),
            (route) => false,
          );
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).notSurpport,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
    );
  }
}

class _UiEntity {
  static const FAMILY = 0;
  static const ABOUT_US = 1;
  static const ACCOUNT_BINDING = 2;
  static const CHANGE_PASSWORD = 3;
  static const HELP = 4;
  static const LOG_OUT = 5;
  static const HOMEKIT = 6;

  final int _type;
  int get type => _type;

  _UiEntity(this._type);

  String getTitle(BuildContext context) {
    switch (_type) {
      case FAMILY:
        return DefinedLocalizations.of(context).myFamily;
      case ABOUT_US:
        return DefinedLocalizations.of(context).aboutUs;
      case ACCOUNT_BINDING:
        return DefinedLocalizations.of(context).accountBinding;
      case CHANGE_PASSWORD:
        return DefinedLocalizations.of(context).changePassword;
      case HELP:
        return DefinedLocalizations.of(context).help;
      case LOG_OUT:
        return DefinedLocalizations.of(context).logOut;
      case HOMEKIT:
        return 'HomeKit';
      default:
        return '';
    }
  }
}
