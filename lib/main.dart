import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xlive/session/session.dart';

import 'localization/defined_localization_delegate.dart';
import 'session/login_manager.dart';
import 'firmware/firmware_manager.dart';
import 'localization/full_back_localizations_delega.dart';

import 'session/association_request_manager.dart';
import 'channel/method_channel.dart' as channel;
import 'channel/event_channel.dart';
import 'const/const_shared.dart';
import 'data/data_shared.dart';
import 'session/network_status_manager.dart';
import 'session/session_manager.dart';
import 'session/associate_account_manager.dart';
import 'session/app_info_manager.dart';

import 'page/first_page.dart';

class XyHttpOvverides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        print("got bad certificate from $host");
        bool isIP4 = false, isIP6 = false;
        try {
          Uri.parseIPv4Address(host);
          isIP4 = true;
        } catch (e) {
          print("not a valid ip v4 $e");
        }
        try {
          Uri.parseIPv6Address(host);
          isIP6 = true;
        } catch (e) {
          print("not a valid ip v6 $e");
        }

        return isIP4 || isIP6;
      };
  }
}

void main() {
  HttpOverrides.global = new XyHttpOvverides();
  var app = MyApp();
  runApp(app); //g构建myapp框架初始
  channel.getHttpAgent().then((agent) {
    AppInfoManager().httpAgent = agent;
  });

  LoginManager().start();
  FirmwareManager().start();
  AssociationRequestManager().start();

  channel.getPlatform().then((platform) {
    LoginManager().platform = platform;
    if (platform == PLATFORM_IOS) {
      channel.getSystemVersion().then((version) {
        LoginManager().systemVersion = version;
      });
    }
  });
  LoginManager().channel = CHANNEL_HOMEKIT;

  HomeCenterManager().start();
  EventHandler().start();
  channel.scanLocalService();

  SessionManager().start();
  NetworkStatusManager().start();
  AssociateAccountManager().start();
  AppInfoManager().initData();

  WidgetsBinding.instance.addObserver(app);
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("xiaoyan app state change to ${state}");
    if (state == AppLifecycleState.resumed) {
      print(
          "state change to resumed, check if need to restart sessions ${SessionManager().sessions.length}");
      SessionManager().sessions.forEach((id, session) {
        if (session.state != SESSION_STATE_CONNECTED) {
          print('need to start session ${id}');
          session.start();
        } else {
          print('session ${id} is already connected');
        }
      });
    }
  }

  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails errDetails) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text(
          errDetails.exceptionAsString() + "\n" + errDetails.stack.toString(),
          style:
              Theme.of(context).textTheme.title.copyWith(color: Colors.black),
        ),
      );
    };

    if (LoginManager().platform == PLATFORM_ANDROID) {
      return MaterialApp(
        home: FirstPage(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefinedLocalizationDelegate.delegate,
          FullbackCupertinoLocalizationsDelegate(),
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
      );
    } else {
      return CupertinoApp(
        home: FirstPage(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefinedLocalizationDelegate.delegate,
          FullbackCupertinoLocalizationsDelegate(),
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
      );
    }
  }
}
