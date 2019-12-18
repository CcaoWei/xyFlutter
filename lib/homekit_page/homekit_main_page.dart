import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/channel/event_channel.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;
import 'package:xlive/channel/message_channel.dart' as messageChannel;

import 'homekit_home_page.dart';
import 'homekit_device_page.dart';
import 'homekit_mine_page.dart';
import 'homekit_scene_page.dart';

const Color TAB_COLOR_ACTIVE = const Color(0xFF5D86CA);
const Color TAB_COLOR_NORMAL = const Color(0xFF2684F6);

class HomekitMainPage extends StatefulWidget {
  State<StatefulWidget> createState() => _HomekitMainState();
}

class _HomekitMainState extends State<HomekitMainPage> {
  int currentIndex = 0;

  void initState() {
    super.initState();
    EventHandler().start();
    messageChannel.start();
    methodChannel.getEntities();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/hk_tab_home.png',
              width: 22.0,
              height: 22.0,
              gaplessPlayback: true,
            ),
            activeIcon: Image.asset(
              'images/hk_tab_home_active.png',
              width: 22.0,
              height: 22.0,
              gaplessPlayback: true,
            ),
            title: Text(
              DefinedLocalizations.of(context).home,
              style: TextStyle(
                  fontSize: 11.0,
                  color:
                      currentIndex == 0 ? TAB_COLOR_ACTIVE : TAB_COLOR_NORMAL),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/hk_tab_device.png',
              width: 22.0,
              height: 22.0,
              gaplessPlayback: true,
            ),
            activeIcon: Image.asset(
              'images/hk_tab_device_active.png',
              width: 22.0,
              height: 22.0,
              gaplessPlayback: true,
            ),
            title: Text(
              DefinedLocalizations.of(context).device,
              style: TextStyle(
                  fontSize: 11.0,
                  color:
                      currentIndex == 1 ? TAB_COLOR_ACTIVE : TAB_COLOR_NORMAL),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/hk_tab_scene.png',
              width: 22.0,
              height: 22.0,
              gaplessPlayback: true,
            ),
            activeIcon: Image.asset(
              'images/hk_tab_scene_active.png',
              width: 22.0,
              height: 22.0,
              gaplessPlayback: true,
            ),
            title: Text(
              DefinedLocalizations.of(context).scene,
              style: TextStyle(
                  fontSize: 11.0,
                  color:
                      currentIndex == 2 ? TAB_COLOR_ACTIVE : TAB_COLOR_NORMAL),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/hk_tab_about.png',
              width: 22.0,
              height: 22.0,
              gaplessPlayback: true,
            ),
            activeIcon: Image.asset(
              'images/hk_tab_about_active.png',
              width: 22.0,
              height: 22.0,
              gaplessPlayback: true,
            ),
            title: Text(
              DefinedLocalizations.of(context).my,
              style: TextStyle(
                  fontSize: 11.0,
                  color:
                      currentIndex == 3 ? TAB_COLOR_ACTIVE : TAB_COLOR_NORMAL),
            ),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return _buildHomekitHome(context);
          case 1:
            return _buildHomekitDevice(context);
          case 2:
            return _buildHomekitScene(context);
          case 3:
            return _buildHomekitManager(context);
        }
        return Text("");
      },
    );
  }

  CupertinoTabView _buildHomekitHome(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return HomekitHomePage();
      },
    );
  }

  CupertinoTabView _buildHomekitDevice(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return HomekitDevicePage();
      },
    );
  }

  CupertinoTabView _buildHomekitScene(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return HomekitScenePage();
      },
    );
  }

  CupertinoTabView _buildHomekitManager(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return HomekitHomePages();
      },
    );
  }
}
