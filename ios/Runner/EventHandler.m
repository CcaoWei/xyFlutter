//
//  EventHandler.m
//  Runner
//
//  Created by litao on 2018/11/26.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "EventHandler.h"

@interface EventHandler () <FlutterStreamHandler> {
    FlutterEventChannel *_eventChannel;
    FlutterEventSink _eventSink;
}
@end

@implementation EventHandler

+ (instancetype)sharedHandler {
    static EventHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[EventHandler alloc] init];
    });
    return instance;
}

- (void)setEventChannel:(FlutterEventChannel *)eventChannel {
    _eventChannel = eventChannel;
    [_eventChannel setStreamHandler:self];
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    _eventSink = events;
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    //_eventSink = nil;
    return nil;
}

- (void)sendEvent:(id)arguments {
    _eventSink(arguments);
}

- (void)homeManagerDidUpdateHomes {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_MANAGER_DID_UPDATE_HOMES) forKey:@"eventType"];
    _eventSink(args);
}

- (void)homeManagerDidUpdatePrimaryHome {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_MANAGER_DID_UPDATE_PRIMARY_HOME) forKey:@"eventType"];
    HMHome *primaryHome = HomeStore.sharedStore.homeManager.primaryHome;
    [args setValue:primaryHome.uniqueIdentifier.UUIDString forKey:@"primaryHomeIdentifier"];
    _eventSink(args);
}

- (void)homeManagerDidAddHome:(HMHome *)home {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_MANAGER_DID_ADD_HOME) forKey:@"eventType"];
    [args setValue:home.name forKey:@"homeName"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:@(home.primary) forKey:@"primary"];
    _eventSink(args);
}

- (void)homeManagerDidRemoveHome:(HMHome *)home {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_MANAEGR_DID_REMOVE_HOME) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    _eventSink(args);
}

- (void)homeDidUpdateName:(HMHome *)home {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_DID_UPDATE_NAME) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:home.name forKey:@"homeName"];
    _eventSink(args);
}

- (void)homeDidAddAccessory:(HMHome *)home accessory:(HMAccessory *)accessory {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_DID_ADD_ACCESSORY) forKey:@"eventType"];
    [args setValue:accessory.uniqueIdentifier.UUIDString forKey:@"accessoryIdentifier"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    _eventSink(args);
}

- (void)homeDidRemoveAccessory:(HMHome *)home accessory:(HMAccessory *)accessory {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_DID_REMOVE_ACCESORY) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:accessory.uniqueIdentifier.UUIDString forKey:@"accessoryIdentifier"];
    _eventSink(args);
}

- (void)homeDidUpdateRoomForAccessory:(HMHome *)home
                                 room:(HMRoom *)room
                            accessory:(HMAccessory *)accessory {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_DID_UPDATE_ROOM_FOR_ACCESSORY) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:room.uniqueIdentifier.UUIDString forKey:@"roomIdentifier"];
    [args setValue:accessory.uniqueIdentifier.UUIDString forKey:@"accessoryIdentifier"];
    _eventSink(args);
}

- (void)homeDidAddRoom:(HMHome *)home room:(HMRoom *)room {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_DID_ADD_ROOM) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:room.name forKey:@"roomName"];
    [args setValue:room.uniqueIdentifier.UUIDString forKey:@"roomIdentifier"];
    _eventSink(args);
}

- (void)homeDidRemoveRoom:(HMHome *)home room:(HMRoom *)room {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_DID_REMOVE_ROOM) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:room.uniqueIdentifier.UUIDString forKey:@"roomIdentifier"];
    _eventSink(args);
}

- (void)homeDidUpdateNameForRoom:(HMHome *)home room:(HMRoom *)room {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_DID_UPDATE_NAME_FOR_ROOM) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:room.uniqueIdentifier.UUIDString forKey:@"roomIdentifier"];
    [args setValue:room.name forKey:@"roomName"];
    _eventSink(args);
}

- (void)homeDidAddActionSet:(HMHome *)home actionSet:(HMActionSet *)actionSet {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_DID_ADD_ACTION_SET) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:actionSet.uniqueIdentifier.UUIDString forKey:@"actionSetIdentifier"];
    [args setValue:actionSet.name forKey:@"actionSetName"];
    [args setValue:actionSet.actionSetType forKey:@"actionSetType"];
    _eventSink(args);
}

- (void)homeDidRemoveActionSet:(HMHome *)home actionSet:(HMActionSet *)actionSet {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_DID_REMOVE_ACTION_SET) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:actionSet.uniqueIdentifier.UUIDString forKey:@"actionSetIdentifier"];
    _eventSink(args);
}

- (void)homeDidUpdateNameForActionSet:(HMHome *)home actionSet:(HMActionSet *)actionSet {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_DID_UPDATE_NAME_FOR_ACTION_SET) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:actionSet.uniqueIdentifier.UUIDString forKey:@"actionSetIdentifier"];
    [args setValue:actionSet.name forKey:@"actionSetName"];
    _eventSink(args);
}

- (void)homeDidUpdateActionsForActionSet:(HMHome *)home actionSet:(HMActionSet *)actionSet {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(HOME_DID_UPDATE_ACTIONS_FOR_ACTION_SET) forKey:@"eventType"];
    _eventSink(args);
}

- (void)accessoryDidUpdateName:(HMHome *)home accessory:(HMAccessory *)accessory {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(ACCESSORY_DID_UPDATE_NAME) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:accessory.uniqueIdentifier.UUIDString forKey:@"accessoryIdentifier"];
    [args setValue:accessory.name forKey:@"accessoryName"];
    _eventSink(args);
}

- (void)accessoryDidUpdateNameForService:(HMHome *)home
                               accessory:(HMAccessory *)accessory
                                 service:(HMService *)service {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(ACCESSORY_DID_UPDATE_NAME_FOR_SERVICE) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:accessory.uniqueIdentifier.UUIDString forKey:@"accessoryIdentifier"];
    [args setValue:service.uniqueIdentifier.UUIDString forKey:@"serviceIdentifier"];
    [args setValue:service.name forKey:@"serviceName"];
    _eventSink(args);
}

- (void)accessoryDidUpdateService:(HMHome *)home accessory:(HMAccessory *)accessory {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(ACCESSORY_DID_UPDATE_SERVICES) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:accessory.uniqueIdentifier.UUIDString forKey:@"accessoryIdentifier"];
    _eventSink(args);
}

- (void)accessoryDidUpdateValueForCharacteristic:(HMHome *)home
                                       accessory:(HMAccessory *)accessory
                                         service:(HMService *)service
                                  characteristic:(HMCharacteristic *)characteristic {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(ACCESSORY_SERVICE_DID_UPDATE_VALUE_FOR_CHARACTERISTIC) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:accessory.uniqueIdentifier.UUIDString forKey:@"accessoryIdentifier"];
    [args setValue:service.uniqueIdentifier.UUIDString forKey:@"serviceIdentifier"];
    [args setValue:characteristic.uniqueIdentifier.UUIDString forKey:@"characteristicIdentifier"];
    [args setValue:characteristic.value forKey:@"value"];
    _eventSink(args);
}

- (void)accessoryDidUpdateFirmwareVersion:(HMHome *)home
                                accessory:(HMAccessory *)accessory
                          firmwareVersion:(NSString *)firmwareVersion {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(ACCESSORY_DID_UPDATE_FIRMWARE_VERSION) forKey:@"eventType"];
    [args setValue:home.uniqueIdentifier.UUIDString forKey:@"homeIdentifier"];
    [args setValue:accessory.uniqueIdentifier.UUIDString forKey:@"accessoryIdentifier"];
    [args setValue:firmwareVersion forKey:@"firmwareVersion"];
    _eventSink(args);
}

- (void)localServiceDidFound:(HomeCenter *)homeCenter {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(LOCAL_SERVICE_DID_FOUND) forKey:@"eventType"];
    [args setValue:homeCenter.uuid forKey:@"uuid"];
    [args setValue:homeCenter.name forKey:@"name"];
    [args setValue:homeCenter.ip forKey:@"ip"];
    [args setValue:homeCenter.versionString forKey:@"versionString"];
    _eventSink(args);
}

- (void)localServiceDidLost:(NSString *)uuid {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(LOCAL_SERVICE_DID_LOST) forKey:@"eventType"];
    [args setValue:uuid forKey:@"uuid"];
    _eventSink(args);
}

- (void)noAccessToCamera {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(NO_ACCESS_TO_CAMERA) forKey:@"eventType"];
    _eventSink(args);
}

@end
