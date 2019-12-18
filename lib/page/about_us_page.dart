import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/http/http_proxy.dart';

import 'package:package_info/package_info.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';
import 'upgrade_app_dialog.dart';

import 'dart:convert';

class AboutUsPage extends StatefulWidget {
  State<StatefulWidget> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUsPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  void initState() {
    print("------------------------------about_us_page.dart");
    super.initState();

    _initPackageInfo();
  }

  void _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void dispose() {
    super.dispose();
  }

  void checkNewAppVersion() {
    HttpProxy.getAndroidAppNewVersion(_packageInfo.version).then((respoonse) {
      var body = json.decode(respoonse.body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode != HTTP_STATUS_CODE_OK) {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).currentIsLatest,
        );
      } else {
        final String version = body['version'];
        final String url = body['url'];
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return UpgradeAppDialog(
                version: version,
                url: url,
              );
            });
      }
    }).catchError((e) {
      print('${e.toString()}');
    });
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).aboutUs,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              Image(
                width: 84.0,
                height: 138.0,
                image: AssetImage('images/first.png'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
              ),
              Text(
                _packageInfo.appName + ' ' + _packageInfo.version,
                style: TextStyle(
                  inherit: false,
                  fontSize: 16.0,
                  color: const Color(0x662D3B46),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50.0),
              ),
              Offstage(
                offstage: LoginManager().platform == PLATFORM_IOS,
                child: Divider(
                  height: 2.0,
                  color: const Color(0x33101B25),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
              ),
              Offstage(
                offstage: LoginManager().platform == PLATFORM_IOS,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 48.0,
                    padding: EdgeInsets.only(left: 13.0, right: 13.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DefinedLocalizations.of(context).checkNewVersion,
                      style: TextStyle(
                        inherit: false,
                        fontSize: 15.0,
                        color: const Color(0xFF2D3B46),
                      ),
                    ),
                  ),
                  onTap: () {
                    if (LoginManager().platform == PLATFORM_ANDROID) {
                      checkNewAppVersion();
                    } else {
                      Fluttertoast.showToast(
                        msg: DefinedLocalizations.of(context).notSurpport,
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
              ),
              Divider(
                height: 2.0,
                color: const Color(0x33101B25),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                DefinedLocalizations.of(context).aboutUsDes1,
                style: TextStyle(
                  inherit: false,
                  color: const Color(0xFF997A9EAF),
                  fontSize: 12.0,
                ),
              ),
              Text(
                DefinedLocalizations.of(context).aboutUsDes2,
                style: TextStyle(
                  inherit: false,
                  color: const Color(0xFFC0D3DC),
                  fontSize: 10.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
