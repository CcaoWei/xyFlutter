import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/data/data_shared.dart' as xiaoyan;

import 'method_channel.dart' as methodChannel;

import 'dart:async';
//平台之间通信  ios  安卓

const HOME_MANAGER_DID_UPDATE_HOMES = 0x2001;
const HOME_MANAGER_DID_UPDATE_PRIMARY_HOME = 0x2002;
const HOME_MANAGER_DID_ADD_HOME = 0x2003;
const HOME_MANAGER_DID_REMOVE_HOME = 0x2004;

const HOME_DID_UPDATE_NAME = 0x0001;
const HOME_DID_UPDATE_ACCESSORY_CONTROL_FOR_CURRENT_USER = 0x0002;
const HOME_DID_ADD_ACCESSORY = 0x0003;
const HOME_DID_REMOVE_ACCESORY = 0x0004;
const HOME_DID_ADD_USER = 0x0005;
const HOME_DID_REMOVE_USER = 0x0006;
const HOME_DID_UPDATE_ROOM_FOR_ACCESSORY = 0x0007;
const HOME_DID_ADD_ROOM = 0x0008;
const HOME_DID_REMOVE_ROOM = 0x0009;
const HOME_DID_UPDATE_NAME_FOR_ROOM = 0x000A;
const HOME_DID_ADD_ZONE = 0x000B;
const HOME_DID_REMOVE_ZONE = 0x000C;
const HOME_DID_UPDATE_NAME_FOR_ZONE = 0x000D;
const HOME_DID_ADD_ROOM_TO_ZONE = 0x000E;
const HOME_DID_REMOVE_ROOM_FROM_ZONE = 0x000F;
const HOME_DID_ADD_SERVICE_GROUP = 0x0010;
const HOME_DID_REMOVE_SERVICE_GROUP = 0x0011;
const HOME_DID_UPDATE_NAME_FOR_SERVICE_GROUP = 0x0012;
const HOME_DID_ADD_SERVICE_TO_SERVICE_GROUP = 0x0013;
const HOME_DID_REMOVE_SERVICE_FROM_SERVICE_GROUP = 0x0014;
const HOME_DID_ADD_ACTION_SET = 0x0015;
const HOME_DID_REMOVE_ACTION_SET = 0x0016;
const HOME_DID_UPDATE_NAME_FOR_ACTION_SET = 0x0017;
const HOME_DID_UPDATE_ACTIONS_FOR_ACTION_SET = 0x0018;
const HOME_DID_ADD_TRIGGER = 0x0019;
const HOME_DID_REMOVE_TRIGGER = 0x001A;
const HOME_DID_UPDATE_NAME_FOR_TRIGGER = 0x001B;
const HOME_DID_UPDATE_TRIGGER = 0x001C;
const HOME_DID_UNBLOCK_ACCESSORY = 0x001D;
const HOME_DID_ENCOUNTER_ERROR_FOR_ACCESSORY = 0x001E;
const HOME_DID_UPDATE_HOME_HUB_STATE = 0x001F;

const ACCESSORY_DID_UPDATE_NAME = 0x1001;
const ACCESSORY_DID_UPDATE_NAME_FOR_SERVICE = 0x1002;
const ACCESSORY_DID_UPDATE_ASSOCIATED_SERVICE_TYPE_FOR_SERVICE = 0x1003;
const ACCESSORY_DID_UPDATE_SERVICES = 0x1004;
const ACCESSORY_DID_ADD_PROFILE = 0x1005;
const ACCESSORY_DID_REMOVE_PROFILE = 0x1006;
const ACCESSORY_DID_UPDATE_REACHABILITY = 0x1007;
const ACCESSORY_SERVICE_DID_UPDATE_VALUE_FOR_CHARACTERISTIC = 0x1008;
const ACCESSORY_DID_UPDATE_FIRMWARE_VERSION = 0x1009;

const ACCESSORY_AVAILABLE_STATUS_CHANGED = 0x5001;
const ACCESSORY_UPDATING_STATUS_CHANGED = 0x5002;
const CHARACTERISTIC_VALUE_CHANGED = 0x5003;
const ADD_ACTION_RESPONSE = 0x5004;
const REMOVE_ACTION_RESPONSE = 0x5005;
const UPDATE_ACTION_RESPONSE = 0x5006;

const LOCAL_SERVICE_FOUND = 0x3001;
const LOCAL_SERVICE_LOST = 0x3002;

const NO_ACCESS_TO_CAMERA = 0x4001;

class EventHandler {
  static EventHandler _instance = EventHandler._internal();

  EventHandler._internal();

  factory EventHandler() {
    return _instance;
  }

  final EventChannel _eventChannel =
      EventChannel('io.xiaoyan.xlive/event_channel');

  Log log = LogFactory().getLogger(Log.DEBUG, 'EventHandler');

  void start() {
    final String methodName = 'start';
    _eventChannel.receiveBroadcastStream().listen((args) {
      if (args is Map) {
        final int eventType = args['eventType'];
        switch (eventType) {
          case HOME_MANAGER_DID_UPDATE_HOMES:
            methodChannel.getEntities().then((result) {
              if (result) {
                final HomesUpdatedEvent event = HomesUpdatedEvent();
                RxBus().post(event);
              }
            });
            break;
          case HOME_MANAGER_DID_UPDATE_PRIMARY_HOME:
            final String primaryHomeIdentifier = args['primaryHomeIdentifier'];

            final Home home = HomeManager().findHome(primaryHomeIdentifier);
            home.primary = true;
            HomeManager().primaryHome.primary = false;
            //HomeManager().primaryHome = home;

            final PrimaryHomeUpdatedEvent event = PrimaryHomeUpdatedEvent(
              primaryHomeIdentifier: primaryHomeIdentifier,
            );
            RxBus().post(event);
            break;
          case HOME_MANAGER_DID_ADD_HOME:
            log.d('home added event', methodName);
            final String homeName = args['homeName'];
            final String homeIdentifier = args['homeIdentifier'];
            final bool primary = args['primary'];
            final Home home = Home(homeName, homeIdentifier);
            home.primary = primary;

            HomeManager().homes.add(home);

            final HomeAddedEvent event = HomeAddedEvent(home: home);
            RxBus().post(event);
            break;
          case HOME_MANAGER_DID_REMOVE_HOME:
            final String homeIdentifier = args['homeIdentfier'];

            final Home home = HomeManager().findHome(homeIdentifier);
            HomeManager().homes.remove(home);

            final HomeRemovedEvent event =
                HomeRemovedEvent(homeIdentifier: homeIdentifier);
            RxBus().post(event);
            break;
          case HOME_DID_UPDATE_NAME:
            final String homeIdentifier = args['homeIdentifier'];
            final String homeName = args['homeName'];

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              home.name = homeName;
            }

            final HomeNameUpdatedEvent event = HomeNameUpdatedEvent(
              homeIdentifier: homeIdentifier,
              newName: homeName,
            );
            RxBus().post(event);
            break;
          case HOME_DID_ADD_ACCESSORY:
            final String homeIdentifier = args['homeIdentifier'];
            Timer(const Duration(seconds: 1), () {
              methodChannel.getHomeEntities(homeIdentifier).then((response) {
                final String accessoryIdentifier = args['accessoryIdentifier'];
                final String homeIdentifier = args['homeIdentifier'];
                final AccessoryAddedEvent event = AccessoryAddedEvent(
                  accessoryIdentifier: accessoryIdentifier,
                  homeIdentifier: homeIdentifier,
                );
                RxBus().post(event);
              });
            });
            break;
          case HOME_DID_REMOVE_ACCESORY:
            final String homeIdentifier = args['homeIdentifier'];
            final String accessoryIdentifier = args['accessoryIdentifier'];

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Accessory accessory =
                  home.findAccessory(accessoryIdentifier);
              home.accessories.remove(accessory);
            }

            final AccessoryRemovedEvent event = AccessoryRemovedEvent(
              homeIdentifier: homeIdentifier,
              accessoryIdentifier: accessoryIdentifier,
            );
            RxBus().post(event);
            break;
          case HOME_DID_UPDATE_ROOM_FOR_ACCESSORY:
            final String homeIdentifier = args['homeIdentifier'];
            final String accessoryIdentifier = args['accessoryIdentifier'];
            final String roomIdentifier = args['roomIdentifier'];

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Accessory accessory =
                  home.findAccessory(accessoryIdentifier);
              //final Room room = home.findRoom(roomIdentifier);
              if (accessory != null) {
                accessory.roomIdentifier = roomIdentifier;
              }
            }

            final AccessoryRoomUpdatedEvent event = AccessoryRoomUpdatedEvent(
              homeIdentifier: homeIdentifier,
              accessoryIdentifier: accessoryIdentifier,
              roomIdentifier: roomIdentifier,
            );
            RxBus().post(event);
            break;
          case HOME_DID_ADD_ROOM:
            final String homeIdentifier = args['homeIdentifier'];
            final String roomName = args['roomName'];
            final String roomIdentifier = args['roomIdentifier'];
            final Room room = Room(roomName, roomIdentifier, homeIdentifier);

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              home.rooms.add(room);
            }

            final RoomAddedEvent event = RoomAddedEvent(room: room);
            RxBus().post(event);
            break;
          case HOME_DID_REMOVE_ROOM:
            final String homeIdentifier = args['homeIdentifier'];
            final String roomIdentifier = args['roomIdentifier'];

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Room room = home.findRoom(roomIdentifier);
              home.rooms.remove(room);
            }

            final RoomRemovedEvent event = RoomRemovedEvent(
              homeIdentifier: homeIdentifier,
              roomIdentifier: roomIdentifier,
            );
            RxBus().post(event);
            break;
          case HOME_DID_UPDATE_NAME_FOR_ROOM:
            final String homeIdentifier = args['homeIdentifier'];
            final String roomIdentifier = args['roomIdentifier'];
            final String roomName = args['roomName'];

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Room room = home.findRoom(roomIdentifier);
              if (room != null) {
                room.name = roomName;
              }
            }

            final RoomNameUpdatedEvent event = RoomNameUpdatedEvent(
              homeIdentifier: homeIdentifier,
              roomIdentifier: roomIdentifier,
              newName: roomName,
            );
            RxBus().post(event);
            break;
          case HOME_DID_ADD_ACTION_SET:
            final String homeIdentifier = args['homeIdentifier'];
            final String actionSetIdentifier = args['actionSetIdentifier'];
            final String actionSetName = args['actionSetName'];
            final String actionSetType = args['actionSetType'];
            final ActionSet actionSet = ActionSet(actionSetName, actionSetType,
                actionSetIdentifier, homeIdentifier);

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              home.actionSets.add(actionSet);
            }

            final ActionSetAddedEvent event =
                ActionSetAddedEvent(actionSet: actionSet);
            RxBus().post(event);
            break;
          case HOME_DID_REMOVE_ACTION_SET:
            final String homeIdentifier = args['homeIdentifier'];
            final String actionSetIdentifier = args['actionSetIdentifier'];

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final ActionSet actionSet =
                  home.findActionSet(actionSetIdentifier);
              home.actionSets.remove(actionSet);
            }

            final ActionSetRemovedEvent event = ActionSetRemovedEvent(
              homeIdentifier: homeIdentifier,
              actionSetIdentifier: actionSetIdentifier,
            );
            RxBus().post(event);
            break;
          case HOME_DID_UPDATE_NAME_FOR_ACTION_SET:
            final String homeIdentifier = args['homeIdentifier'];
            final String actionSetIdentifier = args['actionSetIdentifier'];
            final String newName = args['actionSetName'];

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final ActionSet actionSet =
                  home.findActionSet(actionSetIdentifier);
              if (actionSet != null) {
                actionSet.name = newName;
              }
            }

            final ActionSetNameUpdatedEvent event = ActionSetNameUpdatedEvent(
              homeIdentifier: homeIdentifier,
              actionSetIdentifier: actionSetIdentifier,
              newName: newName,
            );
            RxBus().post(event);
            break;
          case HOME_DID_UPDATE_ACTIONS_FOR_ACTION_SET:
            final ActionSetActionsUpdatedEvent event =
                ActionSetActionsUpdatedEvent();
            RxBus().post(event);
            break;
          case ACCESSORY_DID_UPDATE_NAME:
            final String homeIdentifier = args['homeIdentifier'];
            final String accessoryIdentifier = args['accessoryIdentifier'];
            final String newName = args['accessoryName'];

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Accessory accessory =
                  home.findAccessory(accessoryIdentifier);
              if (accessory != null) {
                accessory.name = newName;
              }
            }

            final AccessoryNameUpdatedEvent event = AccessoryNameUpdatedEvent(
              homeIdentifier: homeIdentifier,
              accessoryIdentifier: accessoryIdentifier,
              newName: newName,
            );
            RxBus().post(event);
            break;
          case ACCESSORY_DID_UPDATE_NAME_FOR_SERVICE:
            final String homeIdentifier = args['homeIdentifier'];
            final String accessoryIdentifier = args['accessoryIdentifier'];
            final String serviceIdentifier = args['serviceIdentifier'];
            final String newName = args['serviceName'];

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Accessory accessory =
                  home.findAccessory(accessoryIdentifier);
              if (accessory != null) {
                final Service service =
                    accessory.findService(serviceIdentifier);
                if (service != null) {
                  service.name = newName;
                }
              }
            }

            final ServiceNameUpdatedEvent event = ServiceNameUpdatedEvent(
              homeIdentifier: homeIdentifier,
              accessoryIdentifier: accessoryIdentifier,
              serviceIdentifier: serviceIdentifier,
              newName: newName,
            );
            RxBus().post(event);
            break;
          case ACCESSORY_DID_UPDATE_SERVICES:
            print('accessory did update services');
            final String homeIdentifier = args['homeIdentifier'];
            final String accessoryIdentifier = args['accessoryIdentifier'];
            methodChannel
                .getAccessory(homeIdentifier, accessoryIdentifier)
                .then((response) {
              final AccessoryServicesUpdatedEvent event =
                  AccessoryServicesUpdatedEvent();
              RxBus().post(event);
            });
            break;
          case ACCESSORY_SERVICE_DID_UPDATE_VALUE_FOR_CHARACTERISTIC:
            final String homeIdentifier = args['homeIdentifier'];
            final String accessoryIdentifier = args['accessoryIdentifier'];
            final String serviceIdentifier = args['serviceIdentifier'];
            final String characteristicIdentifier =
                args['characteristicIdentifier'];
            var value = args['value'];

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Accessory accessory =
                  home.findAccessory(accessoryIdentifier);
              if (accessory != null) {
                final Service service =
                    accessory.findService(serviceIdentifier);
                if (service != null) {
                  final Characteristic characteristic =
                      service.findCharacteristic(characteristicIdentifier);
                  if (characteristic != null) {
                    if (characteristic.type == C_OTA_STATUS) {
                      //print('GGGGG ****** ${characteristic.value}');
                    }
                    characteristic.value = value;
                  }
                }
              }
            }

            final CharacteristicVaulueUpdatedEvent event =
                CharacteristicVaulueUpdatedEvent(
              homeIdentifier: homeIdentifier,
              accessoryIdentifier: accessoryIdentifier,
              serviceIdentifier: serviceIdentifier,
              characteristicIdentifier: characteristicIdentifier,
              value: value,
            );
            RxBus().post(event);
            break;
          case ACCESSORY_DID_UPDATE_FIRMWARE_VERSION:
            final String homeIdentifier = args['homeIdentifier'];
            final String accessoryIdentifier = args['accessoryIdentifier'];
            final String firmwareVersion = args['firmwareVersion'];

            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Accessory accessory =
                  home.findAccessory(accessoryIdentifier);
              if (accessory != null) {
                accessory.firmwareVersion = firmwareVersion;
              }
            }

            final AccessoryFirmwareVersionUpdatedEvent event =
                AccessoryFirmwareVersionUpdatedEvent(
              homeIdentifier: homeIdentifier,
              accessoryIdentifier: accessoryIdentifier,
              firmwareVersion: firmwareVersion,
            );
            RxBus().post(event);
            break;
          case LOCAL_SERVICE_FOUND:
            final xiaoyan.HomeCenter homeCenter =
                xiaoyan.HomeCenter.fromMap(args);
            final LocalServiceFoundEvent event = LocalServiceFoundEvent(
              homeCenter: homeCenter,
            );
            RxBus().post(event);
            break;
          case LOCAL_SERVICE_LOST:
            final String uuid = args['uuid'];
            final LocalServiceLostEvent event = LocalServiceLostEvent(
              uuid: uuid,
            );
            RxBus().post(event);
            break;
          case NO_ACCESS_TO_CAMERA:
            RxBus().post(NoAccessToCameraEvent());
            break;
          case ACCESSORY_AVAILABLE_STATUS_CHANGED:
            final String homeIdentifier = args['homeIdentifier'];
            final String accessoryIdentifier = args['accessoryIdentifier'];
            final bool available = args['available'];
            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Accessory accessory =
                  home.findAccessory(accessoryIdentifier);
              if (accessory != null) {
                accessory.available = available;
                RxBus().post(AccessoryAvailableStatusChangedEvent());
              }
            }
            break;
          case ACCESSORY_UPDATING_STATUS_CHANGED:
            final String homeIdentifier = args['homeIdentifier'];
            final String accessoryIdentifier = args['accessoryIdentifier'];
            final bool updating = args['updating'];
            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Accessory accessory =
                  home.findAccessory(accessoryIdentifier);
              if (accessory != null) {
                accessory.updating = updating;
                RxBus().post(AccessoryUpdatingStatusChangedEvent());
              }
            }
            break;
          case ADD_ACTION_RESPONSE:
            final String homeIdentifier = args['homeIdentifier'];
            final String actionSetIdentifier = args['actionSetIdentifier'];
            final String actionIdentifeir = args['actionIdentifier'];
            final String accessoryIdentifier = args['accessoryIdentifier'];
            final String serviceIdentifeir = args['serviceIdentifier'];
            final String characteristicIdentifier =
                args['characteristicIdentifier'];
            var targetValue = args['targetValue'];
            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Accessory accessory =
                  home.findAccessory(accessoryIdentifier);
              final ActionSet actionSet =
                  home.findActionSet(actionSetIdentifier);
              Characteristic characteristic;
              if (accessory != null) {
                final Service service =
                    accessory.findService(serviceIdentifeir);
                if (service != null) {
                  characteristic =
                      service.findCharacteristic(characteristicIdentifier);
                }
              }
              if (actionSet != null) {
                final xyAction action = xyAction.fromMap(args);
                action.targetValue = targetValue;
                action.characteristic = characteristic;
                actionSet.actions.add(action);
              }
            }
            break;
          case REMOVE_ACTION_RESPONSE:
            final String homeIdentifier = args['homeIdentifier'];
            final String actionSetIdentifeir = args['actionSetIdentifier'];
            final String actionIdentifier = args['actionIdentifier'];
            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final ActionSet actionSet =
                  home.findActionSet(actionSetIdentifeir);
              if (actionSet != null) {
                actionSet.removeAction(actionIdentifier);
              }
            }
            break;
          case UPDATE_ACTION_RESPONSE:
            final String homeIdentfier = args['homeIdentifier'];
            final String actionSetIdentifeir = args['actionSetIdentifier'];
            final String actionIdentifier = args['actionIdentifier'];
            var targetValue = args['targetValue'];
            final Home home = HomeManager().findHome(homeIdentfier);
            if (home != null) {
              final ActionSet actionSet =
                  home.findActionSet(actionSetIdentifeir);
              if (actionSet != null) {
                final xyAction action = actionSet.findAction(actionIdentifier);
                if (action != null) {
                  action.targetValue = targetValue;
                }
              }
            }
            break;
          case CHARACTERISTIC_VALUE_CHANGED:
            final String homeIdentifier = args['homeIdentifier'];
            final String accessoryIdentifier = args['accessoryIdentifier'];
            final String serviceIdentifier = args['serviceIdentifier'];
            final String characteristicIdentifier =
                args['characteristicIdentifier'];
            var value = args['value'];
            final Home home = HomeManager().findHome(homeIdentifier);
            if (home != null) {
              final Accessory accessory =
                  home.findAccessory(accessoryIdentifier);
              if (accessory != null) {
                final Service service =
                    accessory.findService(serviceIdentifier);
                if (service != null) {
                  final Characteristic characteristic =
                      service.findCharacteristic(characteristicIdentifier);
                  if (characteristic != null) {
                    characteristic.value = value;
                    RxBus().post(CharacteristicValueChangedEvent());
                  }
                }
              }
            }
            break;
          default:
            break;
        }
      }
    });
  }
}

class HomekitEvent {}

class HomesUpdatedEvent extends HomekitEvent {}

class PrimaryHomeUpdatedEvent extends HomekitEvent {
  final String primaryHomeIdentifier;

  PrimaryHomeUpdatedEvent({
    this.primaryHomeIdentifier,
  });
}

class HomeAddedEvent extends HomekitEvent {
  final Home home;

  HomeAddedEvent({
    this.home,
  });
}

class HomeRemovedEvent extends HomekitEvent {
  final String homeIdentifier;

  HomeRemovedEvent({
    this.homeIdentifier,
  });
}

class HomeNameUpdatedEvent extends HomekitEvent {
  final String homeIdentifier;
  final String newName;

  HomeNameUpdatedEvent({
    this.homeIdentifier,
    this.newName,
  });
}

class AccessoryAddedEvent extends HomekitEvent {
  final String accessoryIdentifier;
  final String homeIdentifier;

  AccessoryAddedEvent({
    @required this.accessoryIdentifier,
    @required this.homeIdentifier,
  });
}

class AccessoryRemovedEvent extends HomekitEvent {
  final String homeIdentifier;
  final String accessoryIdentifier;

  AccessoryRemovedEvent({
    this.homeIdentifier,
    this.accessoryIdentifier,
  });
}

class AccessoryRoomUpdatedEvent extends HomekitEvent {
  final String homeIdentifier;
  final String accessoryIdentifier;
  final String roomIdentifier;

  AccessoryRoomUpdatedEvent({
    this.homeIdentifier,
    this.accessoryIdentifier,
    this.roomIdentifier,
  });
}

class RoomAddedEvent extends HomekitEvent {
  final Room room;

  RoomAddedEvent({
    this.room,
  });
}

class RoomRemovedEvent extends HomekitEvent {
  final String homeIdentifier;
  final String roomIdentifier;

  RoomRemovedEvent({
    this.homeIdentifier,
    this.roomIdentifier,
  });
}

class RoomNameUpdatedEvent extends HomekitEvent {
  final String homeIdentifier;
  final String roomIdentifier;
  final String newName;

  RoomNameUpdatedEvent({
    this.homeIdentifier,
    this.roomIdentifier,
    this.newName,
  });
}

class ActionSetAddedEvent extends HomekitEvent {
  final ActionSet actionSet;

  ActionSetAddedEvent({
    this.actionSet,
  });
}

class ActionSetRemovedEvent extends HomekitEvent {
  final String homeIdentifier;
  final String actionSetIdentifier;

  ActionSetRemovedEvent({
    this.homeIdentifier,
    this.actionSetIdentifier,
  });
}

class ActionSetNameUpdatedEvent extends HomekitEvent {
  final String homeIdentifier;
  final String actionSetIdentifier;
  final String newName;

  ActionSetNameUpdatedEvent({
    this.homeIdentifier,
    this.actionSetIdentifier,
    this.newName,
  });
}

class ActionSetActionsUpdatedEvent extends HomekitEvent {}

class AccessoryNameUpdatedEvent extends HomekitEvent {
  final String homeIdentifier;
  final String accessoryIdentifier;
  final String newName;

  AccessoryNameUpdatedEvent({
    this.homeIdentifier,
    this.accessoryIdentifier,
    this.newName,
  });
}

class ServiceNameUpdatedEvent extends HomekitEvent {
  final String homeIdentifier;
  final String accessoryIdentifier;
  final String serviceIdentifier;
  final String newName;

  ServiceNameUpdatedEvent({
    this.homeIdentifier,
    this.accessoryIdentifier,
    this.serviceIdentifier,
    this.newName,
  });
}

class AccessoryServicesUpdatedEvent extends HomekitEvent {}

class CharacteristicVaulueUpdatedEvent extends HomekitEvent {
  final String homeIdentifier;
  final String accessoryIdentifier;
  final String serviceIdentifier;
  final String characteristicIdentifier; //c v start 1 2 3
  var value;

  CharacteristicVaulueUpdatedEvent({
    this.homeIdentifier,
    this.accessoryIdentifier,
    this.serviceIdentifier,
    this.characteristicIdentifier,
    this.value,
  });
}

class AccessoryFirmwareVersionUpdatedEvent extends HomekitEvent {
  final String homeIdentifier;
  final String accessoryIdentifier;
  final String firmwareVersion;

  AccessoryFirmwareVersionUpdatedEvent({
    this.homeIdentifier,
    this.accessoryIdentifier,
    this.firmwareVersion,
  });
}

class HomekitEntityIncomingCompleteEvent extends HomekitEvent {}

class AccessoryAvailableStatusChangedEvent extends HomekitEvent {}

class AccessoryUpdatingStatusChangedEvent extends HomekitEvent {}

class CharacteristicValueChangedEvent extends HomekitEvent {}

class LocalServiceEvent {}

class LocalServiceFoundEvent extends LocalServiceEvent {
  final xiaoyan.HomeCenter homeCenter;

  LocalServiceFoundEvent({
    this.homeCenter,
  });
}

class LocalServiceLostEvent extends LocalServiceEvent {
  final String uuid;

  LocalServiceLostEvent({
    this.uuid,
  });
}

class NoAccessToCameraEvent {}
