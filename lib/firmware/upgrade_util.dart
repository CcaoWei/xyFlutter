import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'dart:async';

//家庭中心升级的假的事件
class UpgradeUtil {
  //Used for home center, to create a serial of UpgradeStatusChangedEvent to enable the progress.
  static void startHomeCenterUpgrade(String homeCenterUuid, String firmwareUuid,
      String firmwareVersion, PhysicDevice physicDevice) {
    int percent = 0;
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        percent++;
        print('upgrade *** uuid: $homeCenterUuid *** percent: $percent');
        if (percent == 100) {
          final HomeCenterCache cache =
              HomeCenterManager().getHomeCenterCache(homeCenterUuid);
          if (cache != null) {
            final HomeCenter homeCenter =
                HomeCenterManager().getHomeCenter(homeCenterUuid);
            homeCenter.physicDevice.setAttribute(
                ATTRIBUTE_ID_FIRMWARE_VERSION, int.parse(firmwareVersion));
            final Entity entity = cache.findEntity(homeCenterUuid);
            if (entity != null) {
              entity.setAttribute(
                  ATTRIBUTE_ID_FIRMWARE_VERSION, int.parse(firmwareVersion));
            }
          }
        }
        final FirmwareUpgradeStatusChangeEvent event =
            FirmwareUpgradeStatusChangeEvent(
          homeCenterUuid: homeCenterUuid,
          uuid: homeCenterUuid,
          firmwareUuid: firmwareUuid,
          firmwareVersion: firmwareVersion,
          upgradeStatus:
              percent == 100 ? UPGRADE_STATUS_FINISHED : UPGRADE_STATUS_ONGOING,
          percent: percent,
          physicDevice: physicDevice,
        );
        RxBus().post(event);
        if (percent == 100) {
          timer.cancel();
        }
      },
    );
  }
}
