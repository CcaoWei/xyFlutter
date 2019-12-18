import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;
import 'package:xlive/session/app_info_manager.dart';

class UpgradeAppDialog extends StatefulWidget {
  final String version;
  final String url;

  UpgradeAppDialog({
    @required this.version,
    @required this.url,
  });

  State<StatefulWidget> createState() => _UpgradeAppState();
}

class _UpgradeAppState extends State<UpgradeAppDialog> {
  bool checked = false;

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        DefinedLocalizations.of(context).foundNewVersion + ' ' + widget.version,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Card(
              elevation: 0.0,
              margin: EdgeInsets.only(),
              child: Checkbox(
                value: checked,
                activeColor: Colors.grey,
                onChanged: (bool value) {
                  AppInfoManager().showNewVersion = value;
                  setState(() {
                    checked = value;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, right: 10.0),
            child: Text(
              DefinedLocalizations.of(context).ignoreMessage,
              style: TextStyle(
                inherit: false,
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
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
            DefinedLocalizations.of(context).getUpgradePackage,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            downloadApp(widget.version, widget.url);
          },
        ),
      ],
    );
  }

  void downloadApp(String version, String url) {
    final Map map = Map();
    map['url'] = url;
    map['title'] = DefinedLocalizations.of(context).xiaoyanHome + version;
    map['description'] = DefinedLocalizations.of(context).downloadDescription;
    map['appName'] = 'XiaoyanHome_' + version + '.apk';
    print("download apk: $url $map");
    methodChannel.downloadApk(map);
  }
}
