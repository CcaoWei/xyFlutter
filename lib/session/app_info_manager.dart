import 'package:package_info/package_info.dart';

import 'package:shared_preferences/shared_preferences.dart';

//版本号 版本名称
class AppInfoManager {
  static final AppInfoManager _instance = AppInfoManager._internal();

  factory AppInfoManager() {
    return _instance;
  }

  AppInfoManager._internal();

  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  bool _showNewVersion = true;
  bool get showNewVersion => _showNewVersion;
  set showNewVersion(bool showNewVersion) {
    _showNewVersion = showNewVersion;

    storeShowNewVersion(showNewVersion);
  }

  void storeShowNewVersion(bool showNewVersion) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showNewVersion', showNewVersion);
  }

  void initData() async {
    _packageInfo = await PackageInfo.fromPlatform();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> keys = prefs.getKeys();
    if (keys.contains('showNewVersion')) {
      _showNewVersion = prefs.getBool('showNewVersion');
    }
  }

  String get appName => _packageInfo.appName;

  String get packageName => _packageInfo.packageName;

  String get version => _packageInfo.version;

  String get buildNumber => _packageInfo.buildNumber;

  String _httpAgent = '';
  String get httpAgent => _httpAgent;
  set httpAgent(String httpAgent) => _httpAgent = httpAgent;
}
