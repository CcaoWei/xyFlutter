//
//  HomekitMethodHandler.m
//  Runner
//
//  Created by litao on 2018/11/24.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HomekitMethodHandler.h"

@implementation HomekitMethodHandler

+ (instancetype)sharedHanler {
    static HomekitMethodHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[HomekitMethodHandler alloc] init];
    });
    return instance;
}

- (void)updatePrimaryHome:(NSString *)identifier {
    HMHomeManager *homeManager = HomeStore.sharedStore.homeManager;
    HMHome *home = [HomeStore.sharedStore findHome:identifier];
    if (home == nil) return;
    [homeManager updatePrimaryHome:home
                 completionHandler:^(NSError *error) {
                   [HomeStore.sharedStore registerDelegate];
                   [self handleResponse:error];
                 }];
}

- (void)addHome:(NSString *)name {
    HMHomeManager *homeManager = HomeStore.sharedStore.homeManager;
    [homeManager addHomeWithName:name
               completionHandler:^(HMHome *home, NSError *error) {
                 [self handleResponse:error];
               }];
}

- (void)removeHome:(NSString *)identifier {
    HMHomeManager *homeManager = HomeStore.sharedStore.homeManager;
    HMHome *home = [HomeStore.sharedStore findHome:identifier];
    if (home == nil) return;
    [homeManager removeHome:home
          completionHandler:^(NSError *error) {
            [self handleResponse:error];
          }];
}

- (void)updateHomeName:(NSString *)homeIdentifier name:(NSString *)name {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    [home updateName:name
        completionHandler:^(NSError *error) {
          [self handleResponse:error];
        }];
}

- (void)removeAccessory:(NSString *)homeIdentfier
    accessoryIdentifier:(NSString *)accessoryIdentifier {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentfier];
    if (home == nil) return;
    HMAccessory *accessory = [home findAccessory:accessoryIdentifier];
    if (accessory == nil) return;
    [home removeAccessory:accessory
        completionHandler:^(NSError *error) {
          [self handleResponse:error];
        }];
}

- (void)updateAccessoryRoom:(NSString *)homeIdentifier
        accessoryIdentifier:(NSString *)accessoryIdentifier
             roomIdentifier:(NSString *)roomIdentifier {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMAccessory *accessory = [home findAccessory:accessoryIdentifier];
    HMRoom *room = [home findRoom:roomIdentifier];
    [home assignAccessory:accessory
                   toRoom:room
        completionHandler:^(NSError *error) {
          [self handleResponse:error];
        }];
}

- (void)addRoom:(NSString *)homeIdentifier name:(NSString *)name {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    [home addRoomWithName:name
        completionHandler:^(HMRoom *room, NSError *error) {
          [self handleResponse:error];
        }];
}

- (void)removeRoom:(NSString *)homeIdentifier roomIdentifier:(NSString *)roomIdentifier {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMRoom *room = [home findRoom:roomIdentifier];
    if (room == nil) return;
    [home removeRoom:room
        completionHandler:^(NSError *error) {
          [self handleResponse:error];
        }];
}

- (void)updateRoomName:(NSString *)homeIdentifier
        roomIdentifier:(NSString *)roomIdentifier
               newName:(NSString *)newName {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMRoom *room = [home findRoom:roomIdentifier];
    [room updateName:newName
        completionHandler:^(NSError *error) {
          [self handleResponse:error];
        }];
}

- (void)addActionSet:(NSString *)homeIdentifier name:(NSString *)name {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    [home addActionSetWithName:name
             completionHandler:^(HMActionSet *actionSet, NSError *error) {
               [self handleResponse:error];
             }];
}

- (void)removeActionSet:(NSString *)homeIdentifier
    actionSetIdentifier:(NSString *)actionSetIdentifier {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMActionSet *actionSet = [home findActionSet:actionSetIdentifier];
    if (actionSet == nil) return;
    [home removeActionSet:actionSet
        completionHandler:^(NSError *error) {
          [self handleResponse:error];
        }];
}

- (void)excuteActionSet:(NSString *)homeIdentifier
    actionSetIdentifier:(NSString *)actionSetIdentifier {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMActionSet *actionSet = [home findActionSet:actionSetIdentifier];
    if (actionSet == nil) return;
    [home executeActionSet:actionSet
         completionHandler:^(NSError *error) {
           [self handleResponse:error];
         }];
}

- (void)addHomeCeneter:(NSString *)homeIdentifier {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    [home addAndSetupAccessoriesWithCompletionHandler:^(NSError *error) {
      [self handleResponse:error];
    }];
}

- (void)manageUsers:(NSString *)homeIdentifer {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifer];
    if (home == nil) return;
    [home manageUsersWithCompletionHandler:^(NSError *error) {
      [self handleResponse:error];
    }];
}

- (void)updateAccessoryName:(NSString *)homeIdentifier
        accessoryIdentifier:(NSString *)accessoryIdentifier
                       name:(NSString *)name {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMAccessory *accessory = [home findAccessory:accessoryIdentifier];
    if (accessory == nil) return;
    [accessory updateName:name
        completionHandler:^(NSError *error) {
          [self handleResponse:error];
        }];
}

- (void)updateServiceName:(NSString *)homeIdentifier
      accessoryIdentifier:(NSString *)accessoryIdentifier
        serviceIdentifier:(NSString *)serviceIdentifier
                     name:(NSString *)name {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMAccessory *accessory = [home findAccessory:accessoryIdentifier];
    if (accessory == nil) return;
    HMService *service = [accessory findService:serviceIdentifier];
    if (service == nil) return;
    [service updateName:name
        completionHandler:^(NSError *error) {
          [self handleResponse:error];
        }];
}

- (void)writeValue:(NSString *)homeIdentifier
         accessoryIdentifier:(NSString *)accessoryIdentifier
           serviceIdentifier:(NSString *)serviceIdentifier
    characteristicIdentifier:(NSString *)characteristicIdentifier
                       value:(id)value {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMAccessory *accessory = [home findAccessory:accessoryIdentifier];
    if (accessory == nil) return;
    HMService *service = [accessory findService:serviceIdentifier];
    if (service == nil) return;
    HMCharacteristic *characteristic = [service findCharacteristic:characteristicIdentifier];
    if (characteristic == nil) return;
    [characteristic writeValue:value
             completionHandler:^(NSError *error) {
               [self handleResponse:error];
             }];
}

- (void)setAuthorizationData:(NSString *)homeIdentifier
         accessoryIdentifier:(NSString *)accessoryIdentifier
           serviceIdentifier:(NSString *)serviceIdentifier
    characteristicIdentifier:(NSString *)characteristicIdentifier
                       value:(NSString *)value {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMAccessory *accessory = [home findAccessory:accessoryIdentifier];
    if (accessory == nil) return;
    HMService *service = [accessory findService:serviceIdentifier];
    if (service == nil) return;
    HMCharacteristic *characteristic = [service findCharacteristic:characteristicIdentifier];
    if (characteristic == nil) return;
    NSData *v = [value dataUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"set aa data to %@ %@", value.debugDescription, v.debugDescription);
    [characteristic updateAuthorizationData:v
             completionHandler:^(NSError *error) {
                 [self handleResponse:error];
             }];
}

- (void)readValue:(NSString *)homeIdentifier
         accessoryIdentifier:(NSString *)accessoryIdentifier
           serviceIdentifier:(NSString *)serviceIdentifier
    characteristicIdentifier:(NSString *)characteristicIdentifier {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMAccessory *accessory = [home findAccessory:accessoryIdentifier];
    if (accessory == nil) return;
    HMService *service = [accessory findService:serviceIdentifier];
    if (service == nil) return;
    HMCharacteristic *characteristic = [service findCharacteristic:characteristicIdentifier];
    if (characteristic == nil) return;
    [characteristic readValueWithCompletionHandler:^(NSError *error) {
      [self handleResponse:error];
    }];
}

- (void)enableNotification:(NSString *)homeIdentifier
         accessoryIdentifier:(NSString *)accessoryIdentifier
           serviceIdentifier:(NSString *)serviceIdentifier
    characteristicIdentifier:(NSString *)characteristicIdentifier
                      enable:(BOOL)enable {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMAccessory *accessory = [home findAccessory:accessoryIdentifier];
    if (accessory == nil) return;
    HMService *service = [accessory findService:serviceIdentifier];
    if (service == nil) return;
    HMCharacteristic *characteristic = [service findCharacteristic:characteristicIdentifier];
    if (characteristic == nil) return;
    [characteristic enableNotification:enable
                     completionHandler:^(NSError *error) {
                       [self handleResponse:error];
                     }];
}

- (void)updateActionSetName:(NSString *)homeIdentifier
        actionSetIdentifier:(NSString *)actionSetIdentifier
                       name:(NSString *)name {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMActionSet *actionSet = [home findActionSet:actionSetIdentifier];
    if (actionSet == nil) return;
    [actionSet updateName:name
        completionHandler:^(NSError *error) {
          [self handleResponse:error];
        }];
}

- (void)addAction:(NSString *)homeIdentifier
         actionSetIdentifier:(NSString *)actionSetIdentifier
         accessoryIdentifier:(NSString *)accessoryIdentifier
           serviceIdentifier:(NSString *)serviceIdentifier
    characteristicIdentifier:(NSString *)characteristicIdentifier
                 targetValue:(id)targetValue {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMActionSet *actionSet = [home findActionSet:actionSetIdentifier];
    if (actionSet == nil) return;
    HMAccessory *accessory = [home findAccessory:accessoryIdentifier];
    if (accessory == nil) return;
    HMService *service = [accessory findService:serviceIdentifier];
    if (service == nil) return;
    HMCharacteristic *characteristic = [service findCharacteristic:characteristicIdentifier];
    if (characteristic == nil) return;
    HMCharacteristicWriteAction *writeAction =
        [[HMCharacteristicWriteAction alloc] initWithCharacteristic:characteristic
                                                        targetValue:targetValue];
    [actionSet addAction:writeAction
        completionHandler:^(NSError *error) {
          //[self handleResponse:error];
          NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
          [args setValue:@(ADD_ACTION_RESPONSE) forKey:@"eventType"];
          [args setValue:homeIdentifier forKey:@"homeIdentifier"];
          [args setValue:actionSetIdentifier forKey:@"actionSetIdentifier"];
          [args setValue:accessoryIdentifier forKey:@"accessoryIdentifier"];
          [args setValue:serviceIdentifier forKey:@"serviceIdentifier"];
          [args setValue:characteristicIdentifier forKey:@"characteristicIdentifier"];
          [args setValue:targetValue forKey:@"targetValue"];
          [EventHandler.sharedHandler sendEvent:args];
        }];
}

- (void)removeAction:(NSString *)homeIdentifier
    actionSetIdentifier:(NSString *)actionSetIdentifier
       actionIdentifier:(NSString *)actionIdentifier {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMActionSet *actionSet = [home findActionSet:actionSetIdentifier];
    if (actionSet == nil) return;
    HMAction *action = [actionSet findAction:actionIdentifier];
    if (action == nil) return;
    [actionSet removeAction:action
          completionHandler:^(NSError *error) {
            //[self handleResponse:error];
            NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
            [args setValue:@(REMOVE_ACTION_RESPONSE) forKey:@"eventType"];
            [args setValue:homeIdentifier forKey:@"homeIdentifier"];
            [args setValue:actionSetIdentifier forKey:@"actionSetIdentifier"];
            [args setValue:actionIdentifier forKey:@"actionIdentifier"];
            [EventHandler.sharedHandler sendEvent:args];
          }];
}

- (void)updateTargetValue:(NSString *)homeIdentifier
      actionSetIdentifier:(NSString *)actionSetIdentifier
         actionIdentifier:(NSString *)actionIdentifier
              targetValue:(id)targetValue {
    HMHome *home = [HomeStore.sharedStore findHome:homeIdentifier];
    if (home == nil) return;
    HMActionSet *actionSet = [home findActionSet:actionSetIdentifier];
    if (actionSet == nil) return;
    HMAction *action = [actionSet findAction:actionIdentifier];
    if (action == nil) return;
    if ([action isKindOfClass:[HMCharacteristicWriteAction class]]) {
        HMCharacteristicWriteAction *writeAction = (HMCharacteristicWriteAction *)action;
        [writeAction updateTargetValue:targetValue
                     completionHandler:^(NSError *error) {
                       NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
                       [args setValue:@(UPDATE_ACTION_RESPONSE) forKey:@"eventType"];
                       [args setValue:homeIdentifier forKey:@"homeIdentifier"];
                       [args setValue:actionSetIdentifier forKey:@"actionSetIdentifier"];
                       [args setValue:actionIdentifier forKey:@"actionIdentifier"];
                       [args setValue:targetValue forKey:@"targetValue"];
                       [EventHandler.sharedHandler sendEvent:args];
                       //[self handleResponse:error];
                     }];
    }
}

- (void)handleResponse:(NSError *)error {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    if (error == nil) {
        [args setValue:@(0) forKey:@"code"];
    } else {
        [args setValue:@(error.code) forKey:@"code"];
        [args setValue:error.description forKey:@"message"];
    }
    [MethodHandler.sharedHandler result:args];
}

@end
