part of data_shared;

class Firmware extends Entity {
  String systemUuid;
  String imageModel;
  int version;

  Firmware(
      {@required String uuid,
      @required this.systemUuid,
      @required this.imageModel,
      @required this.version})
      : super.initFirmware(
          uuid: uuid,
        );

  //Home Center: 2.3.15
  String get versionString {
    if (version > 9999) {
      final int v1 = int.parse(version.toString().substring(0, 1));
      final int v2 = int.parse(version.toString().substring(1, 3));
      final int v3 = int.parse(version.toString().substring(3, 5));
      return v1.toString() + '.' + v2.toString() + '.' + v3.toString();
    } else {
      return version.toString();
    }
  }

  //Home Center: 2-3-15
  String get versionString2 {
    if (version > 9999) {
      final int v1 = int.parse(version.toString().substring(0, 1));
      final int v2 = int.parse(version.toString().substring(1, 3));
      final int v3 = int.parse(version.toString().substring(3, 5));
      return v1.toString() + '-' + v2.toString() + '-' + v3.toString();
    } else {
      return version.toString();
    }
  }
}
