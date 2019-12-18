import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xlive/localization/defined_localization.dart';

class AboutUs extends StatefulWidget {
  State<StatefulWidget> createState() => _AboutUs();
}

class _AboutUs extends State<AboutUs> {
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  void xyUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void dispose() {
    super.dispose();
  }

  PackageInfo _packageInfo;
  void _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true, //输入法框
      navigationBar: CupertinoNavigationBar(
        middle: Text(DefinedLocalizations.of(context).aboutUs),
        trailing: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 120,
            height: 40.0,
            alignment: Alignment.center,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      child: Container(
        padding: EdgeInsets.all(0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[buildAboutUsPage(context)],
        ),
      ),
    );
  }

  Widget buildAboutUsPage(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 80),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            height: 143,
            width: 87,
            image: AssetImage('images/first.png'),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child:
                Text("v" + (_packageInfo == null ? "" : _packageInfo.version)),
          ),
          Container(
            margin: EdgeInsets.only(top: 130),
            child: Text(DefinedLocalizations.of(context).companyName),
          ),
          CupertinoButton(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                "www." + DefinedLocalizations.of(context).officialSiteRoot,
                style: TextStyle(color: Colors.blue),
              ),
            ),
            onPressed: () {
              xyUrl(
                "https://www." +
                    DefinedLocalizations.of(context).officialSiteRoot,
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(DefinedLocalizations.of(context).servicePhone +
                " 400-920-2823"),
          )
        ],
      ),
    );
  }
}
