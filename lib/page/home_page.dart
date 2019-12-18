import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/session/app_info_manager.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/session/session.dart';
import 'package:xlive/session/app_state_manager.dart';
import 'package:xlive/page/automation_page.dart';
import 'device_page.dart';
import 'home_center_manager_page.dart';
import 'scene_page.dart';
import 'my_page.dart';
import 'add_home_center_page.dart';
import 'upgrade_app_dialog.dart';

import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  int _currentIndex = 0;

  StreamSubscription subscription;

  void initState() {
    super.initState();
    Timer(const Duration(microseconds: 300), () {
      if (HomeCenterManager().numberOfAddedHomeCenter == 0) {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (BuildContext context) =>
                  AddHomeCenterPage(showBackIcon: false),
              settings: RouteSettings(
                name: '/AddHomeCenter',
              ),
            ),
            (route) => false);
      }
    });
    start();

    if (LoginManager().platform == PLATFORM_ANDROID) {
      if (AppInfoManager().showNewVersion) {
        checkForNewAndroidVersion();
      }
    }
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    super.dispose();
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where(
            (event) => event is AssociationMessage && event.eventType == REMOVE)
        .listen((event) {
      final AssociationMessage msg = event as AssociationMessage;
      if (msg.isDefaultHomeCenterRemoved &&
          AppStateManager().history.last.settings.name != '/HomeCenterDetail') {
        displayMessage(msg.deviceUuid, msg.deviceName);
      }
    });
  }

  void displayMessage(String homeCenterUuid, String homeCenterName) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              DefinedLocalizations.of(context).homeCenterRemovedDes1 +
                  homeCenterName +
                  ', ' +
                  DefinedLocalizations.of(context).homeCenterRemovedDes2,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).cancel,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  if (HomeCenterManager().numberOfAddedHomeCenter > 0) {
                    switchToHomePage();
                  } else {
                    switchToAddHomeCenterPage();
                  }
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).confirm,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  switchToAddHomeCenterPage();
                },
              ),
            ],
          );
        });
  }

  void switchToHomePage() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (BuildContext context) => HomePage(),
        settings: RouteSettings(
          name: '/Scene',
        ),
      ),
      (route) => false,
    );
  }

  void switchToAddHomeCenterPage() {
    if (HomeCenterManager().numberOfAddedHomeCenter > 0) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (BuildContext context) => AddHomeCenterPage(),
          settings: RouteSettings(
            name: '/AddHomeCenter',
          ),
        ),
        ModalRoute.withName('/Home'),
      );
    } else {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (BuildContext context) => AddHomeCenterPage(
                showBackIcon: false,
              ),
          settings: RouteSettings(
            name: '/AddHomeCenter',
          ),
        ),
        (route) => false,
      );
    }
  }

  void checkForNewAndroidVersion() {
    Timer(const Duration(milliseconds: 300), () {
      final String currentVersion = AppInfoManager().version;
      HttpProxy.getAndroidAppNewVersion(currentVersion).then((response) {
        var body = json.decode(response.body);
        final int statusCode = body[API_STATUS_CODE];
        print('status code: $statusCode');
        //log.d('status code: $statusCode', 'checkForNewAndroidVersion');
        if (statusCode != HTTP_STATUS_CODE_OK) return;
        final String version = body['version'];
        final String url = body['url'];
        displayNewVersion(version, url);
      }).catchError((e) {
        print('${e.toString()}');
        //log.d('${e.toString()}', 'checkForNewAndroidVersion');
      });
    });
  }

  void displayNewVersion(String version, String url) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return UpgradeAppDialog(
            version: version,
            url: url,
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: HomeCenterManagerPage(),
      ),
      body: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Colors.white,
          onTap: (int index) {
            onTabTapped(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/tab_scene.png',
                width: 22.0,
                height: 22.0,
                gaplessPlayback: true,
              ),
              activeIcon: Image.asset(
                'images/tab_scene_active.png',
                width: 22.0,
                height: 22.0,
                gaplessPlayback: true,
              ),
              title: Text(
                DefinedLocalizations.of(context).scene,
                style: TextStyle(
                  fontSize: 11.0,
                  color: _currentIndex == 0
                      ? const Color(0xFF5D86AC)
                      : const Color(0xFFBACCDC),
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/tab_device.png',
                width: 22.0,
                height: 22.0,
                gaplessPlayback: true,
              ),
              activeIcon: Image.asset(
                'images/tab_device_active.png',
                width: 22.0,
                height: 22.0,
                gaplessPlayback: true,
              ),
              title: Text(
                DefinedLocalizations.of(context).device,
                style: TextStyle(
                  fontSize: 11.0,
                  color: _currentIndex == 1
                      ? const Color(0xFF5D86AC)
                      : const Color(0xFFBACCDC),
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/tab_automation.png',
                width: 22.0,
                height: 22.0,
                gaplessPlayback: true,
              ),
              activeIcon: Image.asset(
                'images/tab_automation_active.png',
                width: 22.0,
                height: 22.0,
                gaplessPlayback: true,
              ),
              title: Text(
                DefinedLocalizations.of(context).automation,
                style: TextStyle(
                  fontSize: 11.0,
                  color: _currentIndex == 2
                      ? const Color(0xFF5D86AC)
                      : const Color(0xFFBACCDC),
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/tab_my.png',
                width: 22.0,
                height: 22.0,
                gaplessPlayback: true,
              ),
              activeIcon: Image.asset(
                'images/tab_my_active.png',
                width: 22.0,
                height: 22.0,
                gaplessPlayback: true,
              ),
              title: Text(
                DefinedLocalizations.of(context).my,
                style: TextStyle(
                  fontSize: 11.0,
                  color: _currentIndex == 3
                      ? const Color(0xFF5D86AC)
                      : const Color(0xFFBACCDC),
                ),
              ),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return _buildScene(context);
            case 1:
              return _buildDevice(context);
            case 2:
              return _buildAutomation(context);
            case 3:
              return _buildMy(context);
          }
          return Text("");
        },
      ),
    );
  }

  CupertinoTabView _buildScene(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return ScenePage();
      },
    );
  }

  CupertinoTabView _buildDevice(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return DevicePage();
      },
    );
  }

  CupertinoTabView _buildAutomation(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return AutoMations();
      },
    );
  }

  CupertinoTabView _buildMy(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return MyPage();
      },
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
