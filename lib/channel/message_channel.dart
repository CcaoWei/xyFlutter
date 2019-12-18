import 'package:flutter/services.dart';

import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/data/data_shared.dart' as xiaoyan;

const String LOCAL_SERVICE = 'localService';

void start() {
  BasicMessageChannel(
      'io.xiaoyan.xlive/message_channel', StandardMessageCodec())
    ..setMessageHandler(_messageHandler);
}

Future<dynamic> _messageHandler(message) {
  if (message is Map) {
    final String type = message['type'];
    if (type == 'home') {
      final Home home = Home.fromMap(message);
      final Home exist = HomeManager().findHome(home.identifier);
      if (exist == null) {
        HomeManager().homes.add(home);
      } else {
        exist.update(home.name);
      }
      // if (home.primary) {
      //   HomeManager().primaryHome = home;
      // }
    } else if (type == 'accessory') {
      Accessory accessory;
      if (LoginManager().systemVersion >= 11.0) {
        accessory = Accessory.fromMap2(message);
      } else {
        accessory = Accessory.fromMap(message);
        final Service property = accessory.findServiceByType(S_PROPERTY);
        if (property != null) {
          final Characteristic model =
              property.findCharacteristicByType(C_MODEL);
          if (model != null) {
            accessory.model = model.value;
          }
          final Characteristic manufacturer =
              property.findCharacteristicByType(C_MANUFACTURER);
          if (manufacturer != null) {
            accessory.manufacturer = manufacturer.value;
          }
          final Characteristic firmwareVersion =
              property.findCharacteristicByType(C_FIRMWARE_VERSION);
          if (firmwareVersion != null) {
            accessory.firmwareVersion = firmwareVersion.value;
          }
        }
      }
      final Home home = HomeManager().findHome(accessory.homeIdentifier);
      if (home != null) {
        final Accessory exist = home.findAccessory(accessory.identifier);
        if (exist == null) {
          home.accessories.add(accessory);
        } else {
          exist.update(accessory.name, accessory.available, accessory.updating);
        }
      }
    } else if (type == 'service') {
      final Service service = Service.fromMap(message);
      final Home home = HomeManager().findHome(service.homeIdentifier);
      if (home != null) {
        final Accessory accessory =
            home.findAccessory(service.accessoryIdentifier);
        if (accessory != null) {
          final Service exist = accessory.findService(service.identifier);
          if (exist == null) {
            accessory.services.add(service);
          } else {
            exist.update(service.name);
          }
        }
      }
    } else if (type == 'characteristic') {
      final Characteristic characteristic = Characteristic.fromMap(message);
      final Home home = HomeManager().findHome(characteristic.homeIdentifier);
      if (home != null) {
        final Accessory accessory =
            home.findAccessory(characteristic.accessoryIdentifier);
        if (accessory != null) {
          final Service service =
              accessory.findService(characteristic.serviceIdentifier);
          if (service != null) {
            final Characteristic exist =
                service.findCharacteristic(characteristic.identifier);
            if (exist == null) {
              service.characteristics.add(characteristic);
            } else {
              exist.update(characteristic.value);
            }
          }
        }
      }
    } else if (type == 'actionSet') {
      final ActionSet actionSet = ActionSet.fromMap(message);
      final Home home = HomeManager().findHome(actionSet.homeIdentifier);
      if (home != null) {
        final ActionSet exist = home.findActionSet(actionSet.identifier);
        if (exist == null) {
          home.actionSets.add(actionSet);
        } else {
          exist.update(actionSet.name);
        }
      }
    } else if (type == 'action') {
      final xyAction action = xyAction.fromMap(message);
      //print('*** *** *** action identifier: ${action.identifier}');
      final Home home = HomeManager().findHome(action.homeIdentifier);
      if (home != null) {
        final ActionSet actionSet =
            home.findActionSet(action.actionSetIdentifier);
        if (actionSet != null) {
          final xyAction exist = actionSet.findAction(action.identifier);
          if (exist == null) {
            actionSet.actions.add(action);
          }
        }
      }
    } else if (type == 'room') {
      final Room room = Room.fromMap(message);
      final Home home = HomeManager().findHome(room.homeIdentifier);
      if (home != null) {
        final Room exist = home.findRoom(room.identifier);
        if (exist == null) {
          home.rooms.add(room);
        } else {
          exist.update(room.name);
        }
      }
    } else if (type == 'characteristicWriteAction') {
      final CharacteristicWriteAction writeAction =
          CharacteristicWriteAction.fromMap(message);
      final Home home = HomeManager().findHome(writeAction.homeIdentifier);
      if (home != null) {
        xyAction action;
        Characteristic characteristic;

        final ActionSet actionSet =
            home.findActionSet(writeAction.actionSetIdentifier);
        if (actionSet != null) {
          action = actionSet.findAction(writeAction.actionIdentifier);
        }
        final Accessory accessory =
            home.findAccessory(writeAction.accessoryIdentifier);
        if (accessory != null) {
          final Service service =
              accessory.findService(writeAction.serviceIdentifier);
          if (service != null) {
            characteristic = service
                .findCharacteristic(writeAction.characteristicIdentifier);
          }
        }
        if (action != null && characteristic != null) {
          action.characteristic = characteristic;
          action.targetValue = writeAction.targetValue;
        }
      }
    } else if (type == LOCAL_SERVICE) {
      final xiaoyan.HomeCenter homeCenter = xiaoyan.HomeCenter.fromMap(message);
      xiaoyan.HomeCenterManager().addLocalFoundHomeCenter(homeCenter);
    }
  }
  return Future.value(true);
}
