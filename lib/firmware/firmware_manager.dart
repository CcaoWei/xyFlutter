import 'package:xlive/log/log_shared.dart';
import 'package:xlive/data/data_shared.dart';

import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/const/const_shared.dart';

import 'dart:async';
//管理升级的

//Contains all the home centers of the current account.
class FirmwareManager {
  //所有设备
  static const String className = 'FirmwareManager';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  static final FirmwareManager _manager = FirmwareManager._internal();

  FirmwareManager._internal();

  factory FirmwareManager() {
    return _manager;
  }

  final Map<String, HomeCenterFirmwareManager> managers = Map();

  StreamSubscription subscription;

  int numberOfDevicesCanUpgrade(String homeCenterUuid) {
    final String methodName = 'numberOfDevicesCanUpgrade';
    if (managers.containsKey(homeCenterUuid)) {
      return managers[homeCenterUuid].numberOfDevicesCanUpgrade;
    }
    return 0;
  }

  List<FirmwareDeviceGroup> firmwareDeviceGroup(String homeCenterUuid) {
    resetData();
    if (managers.containsKey(homeCenterUuid)) {
      return managers[homeCenterUuid].deviceGroups;
    }
    return List<FirmwareDeviceGroup>();
  }

  void clear(String homeCenterUuid) {
    if (managers.containsKey(homeCenterUuid)) {
      final HomeCenterFirmwareManager hcfm = managers[homeCenterUuid];
      hcfm.clear();
    }
  }

  void addFirmware(String homeCenterUuid, Firmware firmware) {
    HomeCenterFirmwareManager manager;
    if (managers.containsKey(homeCenterUuid)) {
      manager = managers[homeCenterUuid];
    } else {
      manager = HomeCenterFirmwareManager(homeCenterUuid: homeCenterUuid);
      managers[homeCenterUuid] = manager;
    }
    manager.addFirmware(firmware);
  }

  void addPhysicDevice(String homeCenterUuid, PhysicDevice physicDevice) {
    HomeCenterFirmwareManager manager;
    if (managers.containsKey(homeCenterUuid)) {
      manager = managers[homeCenterUuid];
    } else {
      manager = HomeCenterFirmwareManager(homeCenterUuid: homeCenterUuid);
      managers[homeCenterUuid] = manager;
    }
    manager.addPhysicDevice(physicDevice);
  }

  void resetData() {
    managers.clear();
    var homeCenters = HomeCenterManager().homeCenters.keys;
    for (var uuid in homeCenters) {
      final HomeCenterFirmwareManager manager =
          HomeCenterFirmwareManager(homeCenterUuid: uuid);
      managers[uuid] = manager;

      final HomeCenterCache cache =
          HomeCenterManager().getHomeCenterCache(uuid);
      if (cache == null) continue;
      final List<Firmware> firmwares = cache.firmwares;
      for (var firmware in firmwares) {
        manager.addFirmware(firmware);
      }
      final List<PhysicDevice> physicDevices = cache.addedDevices;
      for (var pd in physicDevices) {
        if (pd.isHomeCenter) {
          manager.addPhysicDevice(pd);
          continue;
        }
        if (!pd.available) continue;
        manager.addPhysicDevice(pd);
      }
    }
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is FirmwareAvailableEvent ||
            event is PhysicDeviceAvailableEvent ||
            event is FirmwareUpgradeStatusChangeEvent ||
            event is DeviceDeleteEvent ||
            event is DeviceOfflineEvent ||
            (event is DeviceAttributeReportEvent &&
                event.attrId == ATTRIBUTE_ID_FIRMWARE_VERSION))
        .listen((event) {
      if (event is FirmwareAvailableEvent) {
        _processFirmwareAvailable(event);
      } else if (event is PhysicDeviceAvailableEvent) {
        _processDeviceAvailable(event);
      } else if (event is DeviceDeleteEvent) {
        _processDeviceDelete(event);
      } else if (event is DeviceOfflineEvent) {
        _processDeviceOffline(event);
      } else if (event is FirmwareUpgradeStatusChangeEvent) {
        _processFirmwareUpgradeStatusChange(event);
      } else if (event is DeviceAttributeReportEvent) {
        _processDeviceAttributeReportEvent(event);
      }
    });
  }

  void stop() {
    if (subscription != null) {
      subscription.cancel();
    }
  }

  void _processFirmwareAvailable(FirmwareAvailableEvent event) {
    final String homeCenterUuid = event.homeCenterUuid;
    final Firmware firmware = event.firmware;
    HomeCenterFirmwareManager manager;
    if (managers.containsKey(homeCenterUuid)) {
      manager = managers[homeCenterUuid];
    } else {
      manager = HomeCenterFirmwareManager(homeCenterUuid: homeCenterUuid);
      managers[homeCenterUuid] = manager;
    }
    manager.addFirmware(firmware);
  }

  void _processDeviceAvailable(PhysicDeviceAvailableEvent event) {
    final String homeCenterUuid = event.homeCenterUuid;
    final PhysicDevice physicDevice = event.physicDevice;
    HomeCenterFirmwareManager manager;
    if (managers.containsKey(homeCenterUuid)) {
      manager = managers[homeCenterUuid];
    } else {
      manager = HomeCenterFirmwareManager(homeCenterUuid: homeCenterUuid);
      managers[homeCenterUuid] = manager;
    }
    manager.addPhysicDevice(physicDevice);
  }

  void _processDeviceDelete(DeviceDeleteEvent event) {
    final String homeCenterUuid = event.homeCenterUuid;
    final Entity entity = event.entity;
    if (entity is PhysicDevice) {
      if (managers.containsKey(homeCenterUuid)) {
        final HomeCenterFirmwareManager manager = managers[homeCenterUuid];
        manager.removePhysicDevice(entity);
      }
    }
  }

  void _processDeviceOffline(DeviceOfflineEvent event) {
    final String homeCenterUuid = event.homeCenterUuid;
    final PhysicDevice physicDevice = event.physicDevice;
    if (managers.containsKey(homeCenterUuid)) {
      final HomeCenterFirmwareManager manager = managers[homeCenterUuid];
      manager.removePhysicDevice(physicDevice);
    }
  }

  void _processFirmwareUpgradeStatusChange(
      FirmwareUpgradeStatusChangeEvent event) {
    final String homeCenterUuid = event.homeCenterUuid;
    final PhysicDevice physicDevice = event.physicDevice;
    final int state = event.upgradeStatus;
    final int percent = event.percent;
    if (managers.containsKey(homeCenterUuid)) {
      final HomeCenterFirmwareManager manager = managers[homeCenterUuid];
      manager.setState(physicDevice, state);
      manager.setPercent(physicDevice, percent);
    }
  }

  void _processDeviceAttributeReportEvent(DeviceAttributeReportEvent event) {
    if (event.attrId == ATTRIBUTE_ID_FIRMWARE_VERSION) {
      print('**** => ATTRIBUTE_ID_FIRMWARE_VERSION: ${event.uuid}');
      final List<FirmwareDeviceGroup> fdg =
          firmwareDeviceGroup(event.homeCenterUuid);
    }
  }
}

//Contains all the devices in a home center that can upgrade.
class HomeCenterFirmwareManager {
  //一个家庭中心
  static const String className = 'HomeCenterFirmwareManager';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  final String homeCenterUuid;

  /**
   * key: firmware image model
   */
  final Map<String, FirmwareDeviceGroup> groups = Map();

  HomeCenterFirmwareManager({
    this.homeCenterUuid,
  });

  void clear() {
    groups.clear();
  }

  int get numberOfDevicesCanUpgrade {
    final String methodName = 'numberOfDevicesCanUpgrade';
    int count = 0;
    for (var deviceGroup in groups.values) {
      count += deviceGroup.numberOfDevicesCanUpgrade;
    }
    return count;
  }

  List<FirmwareDeviceGroup> get deviceGroups {
    final List<FirmwareDeviceGroup> temp = List();
    for (var group in groups.values) {
      if (group.numberOfDevicesCanUpgrade > 0) {
        temp.add(group);
      }
    }
    return temp;
  }

  void addFirmware(Firmware firmware) {
    if (groups.containsKey(firmware.imageModel)) {
      final FirmwareDeviceGroup exist = groups[firmware.imageModel];
      if (exist.firmware == null) {
        exist.firmware = firmware;
      } else if (exist.firmware.version < firmware.version) {
        exist.firmware = firmware;
      }
    } else {
      groups[firmware.imageModel] = FirmwareDeviceGroup(firmware: firmware);
    }
  }

  void addPhysicDevice(PhysicDevice physicDevice) {
    if (groups.containsKey(physicDevice.model)) {
      final FirmwareDeviceGroup deviceGroup = groups[physicDevice.model];
      deviceGroup.addDevice(physicDevice);
    } else {
      final FirmwareDeviceGroup deviceGroup =
          FirmwareDeviceGroup(firmware: null);
      deviceGroup.addDevice(physicDevice);
      groups[physicDevice.model] = deviceGroup;
    }
  }

  void setState(PhysicDevice physicDevice, int state) {
    if (groups.containsKey(physicDevice.model)) {
      final FirmwareDeviceGroup deviceGroup = groups[physicDevice.model];
      deviceGroup.setState(physicDevice, state);
    }
  }

  void setPercent(PhysicDevice physicDevice, int percent) {
    if (groups.containsKey(physicDevice.model)) {
      final FirmwareDeviceGroup deviceGroup = groups[physicDevice.model];
      deviceGroup.setPercent(physicDevice, percent);
    }
  }

  void removePhysicDevice(PhysicDevice physicDevice) {
    if (groups.containsKey(physicDevice.model)) {
      final FirmwareDeviceGroup deviceGroup = groups[physicDevice.model];
      deviceGroup.removeDevice(physicDevice);
    }
  }
}

//An Object which stands for a group of devices that can upgrade to a same firmware version.
class FirmwareDeviceGroup {
  //升级里的一组
  static const String className = 'FirmwareDeviceGroup';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  Firmware firmware;

  final Map<String, FirmwareDevice> devices = Map();

  FirmwareDeviceGroup({
    this.firmware,
  });

  int get numberOfDevicesCanUpgrade {
    final String methodName = 'numberOfDevicesCanUpgrade';
    if (firmware == null) return 0;
    int count = 0;
    for (FirmwareDevice fd in devices.values) {
      if (fd.physicDevice.firmwareVersion < firmware.version) {
        count++;
      }
    }
    return count;
  }

  void addDevice(PhysicDevice physicDevice) {
    if (!devices.containsKey(physicDevice.uuid)) {
      devices[physicDevice.uuid] = FirmwareDevice(physicDevice: physicDevice);
    }
  }

  void setState(PhysicDevice physicDevice, int state) {
    if (devices.containsKey(physicDevice.uuid)) {
      final FirmwareDevice firmwareDevice = devices[physicDevice.uuid];
      firmwareDevice.state = state;
    }
  }

  void setPercent(PhysicDevice physicDevice, int percent) {
    if (devices.containsKey(physicDevice.uuid)) {
      final FirmwareDevice firmwareDevice = devices[physicDevice.uuid];
      firmwareDevice.percent = percent;
    }
  }

  void removeDevice(PhysicDevice physicDevice) {
    if (devices.containsKey(physicDevice.uuid)) {
      devices.remove(physicDevice.uuid);
    }
  }
}

//An Object which stands for a device which appears in FirmwareUpgradePage.
class FirmwareDevice {
  //一个升级的
  final PhysicDevice physicDevice;
  int percent;
  int state;

  FirmwareDevice({
    this.physicDevice,
    this.percent = -1,
    this.state = UPGRADE_STATUS_NONE,
  });

  String get deviceName {
    if (physicDevice.isWallSwitch ||
        physicDevice.isSwitchModule ||
        physicDevice.isHomeCenter ||
        physicDevice.isZHHVRVGateway) {
      return physicDevice.getName();
    } else {
      if (physicDevice.logicDevices[0] != null) {
        return physicDevice.logicDevices[0].getName();
      }
    }
    return '';
  }

  String get versionString {
    if (physicDevice.uuid.startsWith('box-')) {
      return HomeCenter.getVersionString(physicDevice.firmwareVersion);
    } else {
      return physicDevice.firmwareVersion.toString();
    }
  }
}
