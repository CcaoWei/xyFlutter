part of data_shared;

class HomeCenter {
  String uuid;
  String name;

  int state;
  bool online;

  int port;
  //TODO:
  String host; //ip

  String versionString;

  PhysicDevice physicDevice;

  int _autoVersion;

  HomeCenter({
    @required this.uuid,
    @required this.name,
    this.physicDevice,
    this.state = ASSOCIATION_TYPE_NONE,
    this.online = false,
  });

  HomeCenter.fromMap(Map map)
      : uuid = map['uuid'],
        name = map['name'],
        host = map['ip'],
        versionString = map['versionString'] {
    state = ASSOCIATION_TYPE_NONE;
    online = false;
  }

  String getName() {
    if (physicDevice != null) {
      return physicDevice.getName();
    }
    if (name == null || name.isEmpty) {
      var strs = uuid.split('-');
      return strs[1] + strs[2] + strs[3] + strs[4] + strs[5] + strs[6];
    }
    return name;
  }

  String get serialNumber {
    var strs = uuid.split('-');
    return strs[1] + strs[2] + strs[3] + strs[4] + strs[5] + strs[6];
  }

  int get supportAutoVersion {
    int result = -1;
    print(physicDevice);
    if (physicDevice == null) return -1;
    physicDevice.attributes.forEach((k, v) {
      if (v.id == protoc.AttributeID.AttrIDAutoVersion.value) {
        result = v.value;
      }
    });
    return result;
  }

  static String getSerialNumber(String uuid) {
    var strs = uuid.split('-');
    return strs[1] + strs[2] + strs[3] + strs[4] + strs[5] + strs[6];
  }

  //aa:bb:cc:dd:ee:ff -> box-aa-bb-cc-dd-ee-ff
  static String serialNumberToUuid(String serialNumber) {
    final String temp = serialNumber.replaceAll(RegExp(r':'), '-');
    return 'box-' + temp;
  }

  int getVersion() {
    String v = versionString;
    v = v.replaceAll("v", "");
    var s = v.split(".");
    int vi = 0;
    for (var i in s) {
      vi = vi * 100 + int.parse(i);
    }
    return vi;
  }

  static String getVersionString(int version) {
    final String v = version.toString();
    if (v.length == 5) {
      final int v1 = int.parse(v.substring(0, 1));
      final int v2 = int.parse(v.substring(1, 3));
      final int v3 = int.parse(v.substring(3, 5));
      return v1.toString() + '.' + v2.toString() + '.' + v3.toString();
    } else if (v.length == 6) {
      final int v1 = int.parse(v.substring(0, 1));
      final int v2 = int.parse(v.substring(1, 3));
      final int v3 = int.parse(v.substring(3, 5));
      return v1.toString() + '.' + v2.toString() + '.' + v3.toString();
    } else {
      return '-1';
    }
  }
}
