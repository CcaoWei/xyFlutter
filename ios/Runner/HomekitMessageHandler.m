//
//  HomekitMessageHandler.m
//  Runner
//
//  Created by litao on 2018/11/23.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HomekitMessageHandler.h"

@interface HomekitMessageHandler () {
    FlutterBasicMessageChannel *_messageChannel;
}
@end

@implementation HomekitMessageHandler

+ (instancetype)sharedHandler {
    static HomekitMessageHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[HomekitMessageHandler alloc] init];
    });
    return instance;
}

- (void)setMessageChannel:(FlutterBasicMessageChannel *)messageChannel {
    _messageChannel = messageChannel;
}

- (void)getHomeEntities:(NSString *)homeIdentifier {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    [self handleHomeAndEntities:home];
    [MethodHandler.sharedHandler resultBool:YES];
}

- (void)getHomekitEntities {
    NSArray<HMHome *> *homes = HomeStore.sharedStore.homeManager.homes;
    for (HMHome *home in homes) {
        [self handleHomeAndEntities:home];
    }
    [MethodHandler.sharedHandler resultBool:YES];
}

- (void)handleHomeAndEntities:(HMHome *)home {
    [self handleHome:home];

    NSArray<HMAccessory *> *accessories = home.accessories;
    for (HMAccessory *accessory in accessories) {
        [self handleAccessory:accessory homeUuid:home.uniqueIdentifier];

        NSArray<HMService *> *services = accessory.services;
        for (HMService *service in services) {
            [self handleService:service homeUuid:home.uniqueIdentifier];

            NSArray<HMCharacteristic *> *characteristics = service.characteristics;
            for (HMCharacteristic *characteristic in characteristics) {
                [self handleCharacteristic:characteristic homeUuid:home.uniqueIdentifier];
            }
        }
    }

    NSArray<HMRoom *> *rooms = home.rooms;
    for (HMRoom *room in rooms) {
        [self handleRoom:room homeUuid:home.uniqueIdentifier];
    }
    [self handleRoom:home.roomForEntireHome homeUuid:home.uniqueIdentifier];

    NSArray<HMActionSet *> *actionSets = home.actionSets;
    for (HMActionSet *actionSet in actionSets) {
        [self handleActionSet:actionSet homeUuid:home.uniqueIdentifier];

        NSSet<HMAction *> *actions = actionSet.actions;
        for (HMAction *action in actions) {
            [self handleAction:action
                 actionSetUuid:actionSet.uniqueIdentifier
                      homeUuid:home.uniqueIdentifier];

            if ([action isKindOfClass:[HMCharacteristicWriteAction class]]) {
                [self handleCharacteristicWriteAction:(HMCharacteristicWriteAction *)action
                                           actionUuid:action.uniqueIdentifier
                                        actionSetUuid:actionSet.uniqueIdentifier
                                             homeUuid:home.uniqueIdentifier];
            }
        }
    }
    NSLog(@"get entity complete");
}

- (void)getAccessory:(NSString *)homeIdentifier
    accessoryIdentifier:(NSString *)accessoryIdentifier {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMAccessory *accessory = [home findAccessory:accessoryIdentifier];
    if (accessory == nil) return;
    [self handleAccessory:accessory homeUuid:home.uniqueIdentifier];
    NSArray<HMService *> *services = accessory.services;
    for (HMService *service in services) {
        [self handleService:service homeUuid:home.uniqueIdentifier];

        NSArray<HMCharacteristic *> *characteristics = service.characteristics;
        for (HMCharacteristic *characteristic in characteristics) {
            [self handleCharacteristic:characteristic homeUuid:home.uniqueIdentifier];
        }
    }
    [MethodHandler.sharedHandler resultBool:YES];
}

- (void)handleHome:(HMHome *)home {
    NSDictionary *args = [[NSDictionary alloc] init];
    args = @{
        @"type" : @"home",
        @"name" : home.name,
        @"primary" : @(home.primary),
        @"identifier" : home.uniqueIdentifier.UUIDString
    };
    [_messageChannel sendMessage:args];
}

- (void)handleAccessory:(HMAccessory *)accessory homeUuid:(NSUUID *)homeUuid {
    NSDictionary *args = [[NSDictionary alloc] init];
    NSLog(@"%@", accessory.name);
    if (@available(iOS 11.0, *)) {
        args = @{
            @"type" : @"accessory",
            @"name" : accessory.name == nil ? @"" : accessory.name,
            @"identifier" : accessory.uniqueIdentifier.UUIDString,
            @"isBridged" : @(accessory.isBridged),
            @"available" : @(accessory.available),
            @"updating" : @(accessory.updating),
            @"roomIdentifier" : accessory.room.uniqueIdentifier.UUIDString == nil ? @"" : accessory.room.uniqueIdentifier.UUIDString,
            @"homeIdentifier" : homeUuid.UUIDString == nil ? @"" : homeUuid.UUIDString,
            @"model" : accessory.model == nil ? @"" : accessory.model,
            @"manufacturer" : accessory.manufacturer == nil ? @"" : accessory.manufacturer,
            @"firmwareVersion" : accessory.firmwareVersion == nil || [accessory.firmwareVersion length] == 0 ? @"" : accessory.firmwareVersion,
        };
    } else {
        args = @{
            @"type" : @"accessory",
            @"name" : accessory.name,
            @"identifier" : accessory.uniqueIdentifier.UUIDString,
            @"isBridged" : @(accessory.isBridged),
            @"updating" : @(accessory.updating),
            @"available" : @(accessory.available),
            @"roomIdentifier" : accessory.room.uniqueIdentifier.UUIDString,
            @"homeIdentifier" : homeUuid.UUIDString
        };
    }
    [_messageChannel sendMessage:args];
}

- (void)handleService:(HMService *)service homeUuid:(NSUUID *)homeUuid {
    NSDictionary *args = [[NSDictionary alloc] init];
    args = @{
        @"type" : @"service",
        @"accessoryIdentifier" : service.accessory.uniqueIdentifier.UUIDString,
        @"serviceType" : @(service.typeInt),
        @"name" : service.name == nil ? @"" : service.name,
        @"identifier" : service.uniqueIdentifier.UUIDString,
        @"homeIdentifier" : homeUuid.UUIDString
    };
    [_messageChannel sendMessage:args];
}

- (void)handleCharacteristic:(HMCharacteristic *)characteristic homeUuid:(NSUUID *)homeUuid {
    //[characteristic supportNotification];
    NSDictionary *args = [[NSDictionary alloc] init];
    id value = characteristic.value;
    if (value == nil) {
        value = @(-1);
    }
    args = @{
        @"type" : @"characteristic",
        @"characteristicType" : @(characteristic.typeInt),
        @"serviceIdentifier" : characteristic.service.uniqueIdentifier.UUIDString,
        @"accessoryIdentifier" : characteristic.service.accessory.uniqueIdentifier.UUIDString,
        @"value" : value,
        @"isNotificationEnabled" : @(characteristic.isNotificationEnabled),
        @"identifier" : characteristic.uniqueIdentifier.UUIDString,
        @"homeIdentifier" : homeUuid.UUIDString,
        @"supportNotification" : @(characteristic.supportNotification),
    };
    [_messageChannel sendMessage:args];

    if (characteristic.supportNotification && !characteristic.isNotificationEnabled) {
        [characteristic enableNotification:true
                         completionHandler:^(NSError *error) {
                           if (error != nil) {
                               NSLog(@"enable notification error: %@", error.description);
                           }
                         }];
    }
}

- (void)handleRoom:(HMRoom *)room homeUuid:(NSUUID *)homeUuid {
    NSDictionary *args = [[NSDictionary alloc] init];
    args = @{
        @"type" : @"room",
        @"name" : room.name,
        @"identifier" : room.uniqueIdentifier.UUIDString,
        @"homeIdentifier" : homeUuid.UUIDString
    };
    [_messageChannel sendMessage:args];
}

- (void)handleActionSet:(HMActionSet *)actionSet homeUuid:(NSUUID *)homeUuid {
    if ([actionSet.actionSetType isEqualToString:HMActionSetTypeSleep] ||
        [actionSet.actionSetType isEqualToString:HMActionSetTypeWakeUp] ||
        [actionSet.actionSetType isEqualToString:HMActionSetTypeHomeArrival] ||
        [actionSet.actionSetType isEqualToString:HMActionSetTypeHomeDeparture] ||
        [actionSet.actionSetType isEqualToString:HMActionSetTypeUserDefined]) {
        NSDictionary *args = [[NSDictionary alloc] init];

        NSString *type = @"";
        if ([actionSet.actionSetType isEqualToString:HMActionSetTypeSleep]) {
            type = @"sleep";
        } else if ([actionSet.actionSetType isEqualToString:HMActionSetTypeWakeUp]) {
            type = @"wakeUp";
        } else if ([actionSet.actionSetType isEqualToString:HMActionSetTypeHomeArrival]) {
            type = @"homeArrival";
        } else if ([actionSet.actionSetType isEqualToString:HMActionSetTypeHomeDeparture]) {
            type = @"homeDeparture";
        } else {
            type = @"userDefined";
        }
        args = @{
            @"type" : @"actionSet",
            @"name" : actionSet.name,
            @"identifier" : actionSet.uniqueIdentifier.UUIDString,
            @"homeIdentifier" : homeUuid.UUIDString,
            @"actionSetType" : type
        };
        [_messageChannel sendMessage:args];
    }
}

- (void)handleAction:(HMAction *)action
       actionSetUuid:(NSUUID *)actionSetUuid
            homeUuid:(NSUUID *)homeUuid {
    NSDictionary *args = [[NSDictionary alloc] init];
    args = @{
        @"type" : @"action",
        @"actionSetIdentifier" : actionSetUuid.UUIDString,
        @"homeIdentifier" : homeUuid.UUIDString,
        @"identifier" : action.uniqueIdentifier.UUIDString
    };
    [_messageChannel sendMessage:args];
}

- (void)handleCharacteristicWriteAction:(HMCharacteristicWriteAction *)action
                             actionUuid:(NSUUID *)actionUuid
                          actionSetUuid:(NSUUID *)actionSetUuid
                               homeUuid:(NSUUID *)homeUuid {
    NSDictionary *args = [[NSDictionary alloc] init];
    args = @{
        @"type" : @"characteristicWriteAction",
        @"characteristicIdentifier" : action.characteristic.uniqueIdentifier.UUIDString,
        @"serviceIdentifier" : action.characteristic.service.uniqueIdentifier.UUIDString,
        @"accessoryIdentifier" :
            action.characteristic.service.accessory.uniqueIdentifier.UUIDString,
        @"targetValue" : action.targetValue,
        @"actionIdentifier" : actionUuid.UUIDString,
        @"actionSetIdentifier" : actionSetUuid.UUIDString,
        @"homeIdentifier" : homeUuid.UUIDString
    };
    [_messageChannel sendMessage:args];
}

@end
