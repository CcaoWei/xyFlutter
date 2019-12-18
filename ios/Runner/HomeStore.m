//
//  HomeStore.m
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HomeStore.h"

@interface HomeStore () <HMHomeManagerDelegate, HMHomeDelegate, HMAccessoryDelegate> {
    HMHomeManager *_homeManager;
}
@end

@implementation HomeStore

+ (instancetype)sharedStore {
    static HomeStore *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[HomeStore alloc] init];
    });
    return instance;
}

- (HMHomeManager *)homeManager {
    if (_homeManager == nil) {
        _homeManager = [[HMHomeManager alloc] init];
        _homeManager.delegate = [HomeStore sharedStore];
    }
    return _homeManager;
}

- (void)registerDelegate {
    NSArray<HMHome *> *homes = _homeManager.homes;
    for (HMHome *home in homes) {
        home.delegate = self;
        NSLog(@"home delegate: %@", home.delegate.debugDescription);

        NSArray<HMAccessory *> *accessories = home.accessories;
        for (HMAccessory *accessory in accessories) {
            accessory.delegate = self;
            NSLog(@"accessory delegate: %@", accessory.delegate.debugDescription);
        }
    }
}

- (HMHome *)findHome:(NSString *)identifier {
    NSArray<HMHome *> *homes = [_homeManager homes];
    for (HMHome *home in homes) {
        if ([home.uniqueIdentifier.UUIDString isEqualToString:identifier]) {
            return home;
        }
    }
    return nil;
}

- (BOOL)isNeededFor:(HMCharacteristic *)characteristic accessory:(HMAccessory *)accessory {
    return ([accessory isLightSocket] && characteristic.type == C_ON_OFF) ||
           ([accessory isSmartPlug] && characteristic.type == C_ON_OFF) ||
           ([accessory isAwarenessSwitch] && characteristic.type == C_MOTION) ||
           ([accessory isDoorSensor] && characteristic.type == C_CONTACT_SENSOR) ||
           ([accessory isWallSwitch] && characteristic.type == C_FIRMWARE_VERSION) ||
           ([accessory isWallSwitchUS] && characteristic.type == C_FIRMWARE_VERSION) ||
           ([accessory isCurtain] && characteristic.type == C_CURRENT_STATE) ||
           ([accessory isSmartDial] && characteristic.type == C_FIRMWARE_VERSION) ||
           ([accessory isHomeCenter] && characteristic.type == C_FIRMWARE_VERSION) ||
           ([accessory isSwitchModule] && characteristic.type == C_FIRMWARE_VERSION);
}

- (void)readAllValue:(HMAccessory *)accessory homeIdentifier:(NSString *)homeIdentifier {
    for (HMService *service in accessory.services) {
        for (HMCharacteristic *characteristic in service.characteristics) {
            id oldValue = characteristic.value;
            if ([self isNeededFor:characteristic accessory:accessory]) {
                accessory.updating = YES;
                [self sendUpdatingStatusChangedEvent:YES
                                      homeIdentifier:homeIdentifier
                                 accessoryIdentifier:accessory.uniqueIdentifier.UUIDString];

                [characteristic readValueWithCompletionHandler:^(NSError *error) {
                  accessory.updating = NO;
                  [self sendUpdatingStatusChangedEvent:NO
                                        homeIdentifier:homeIdentifier
                                   accessoryIdentifier:accessory.uniqueIdentifier.UUIDString];

                  accessory.available = (error == nil);
                  [self sendAvailableStatusChangedEvent:accessory.available
                                         homeIdentifier:homeIdentifier
                                    accessoryIdentifier:accessory.uniqueIdentifier.UUIDString];

                  if (characteristic.value != oldValue) {
                      [self
                          sendCharacteristicValueChangedEvent:characteristic.value
                                               homeIdentifier:homeIdentifier
                                          accessoryIdentifier:accessory.uniqueIdentifier.UUIDString
                                            serviceIdentifier:service.uniqueIdentifier.UUIDString
                                     characteristicIdentifier:characteristic.uniqueIdentifier
                                                                  .UUIDString];
                  }
                }];
            } else {
                [characteristic readValueWithCompletionHandler:^(NSError *error) {
                  if (characteristic.value != oldValue) {
                      [self
                          sendCharacteristicValueChangedEvent:characteristic.value
                                               homeIdentifier:homeIdentifier
                                          accessoryIdentifier:accessory.uniqueIdentifier.UUIDString
                                            serviceIdentifier:service.uniqueIdentifier.UUIDString
                                     characteristicIdentifier:characteristic.uniqueIdentifier
                                                                  .UUIDString];
                  }
                }];
            }
        }
    }
}

- (void)readValue:(HMAccessory *)accessory homeIdentifier:(NSString *)homeIdentifier {
    HMCharacteristic *characteristic = nil;
    NSString *serviceUuid;
    if ([accessory isLightSocket]) {
        HMService *service = [accessory findServiceWithType:S_LIGHT_SOCKET];
        if (service != nil) {
            characteristic = [service findCharacteristicWithType:C_ON_OFF];
            serviceUuid = service.uniqueIdentifier.UUIDString;
        }
    } else if ([accessory isSmartPlug]) {
        HMService *service = [accessory findServiceWithType:S_SMART_PLUG];
        if (service != nil) {
            characteristic = [service findCharacteristicWithType:C_ON_OFF];
            serviceUuid = service.uniqueIdentifier.UUIDString;
        }
    } else if ([accessory isAwarenessSwitch]) {
        HMService *service = [accessory findServiceWithType:S_MOTION];
        if (service != nil) {
            characteristic = [service findCharacteristicWithType:C_MOTION];
            serviceUuid = service.uniqueIdentifier.UUIDString;
        }
    } else if ([accessory isDoorSensor]) {
        HMService *service = [accessory findServiceWithType:S_CONTACT_SENSOR];
        if (service != nil) {
            characteristic = [service findCharacteristicWithType:C_CONTACT_SENSOR];
            serviceUuid = service.uniqueIdentifier.UUIDString;
        }
    } else if ([accessory isWallSwitch]) {
        HMService *service = [accessory findServiceWithType:S_NEW_VERSION];
        if (service != nil) {
            characteristic = [service findCharacteristicWithType:C_NEW_VERSION_A];
            serviceUuid = service.uniqueIdentifier.UUIDString;
        }
    } else if ([accessory isWallSwitchUS]) {
        HMService *service = [accessory findServiceWithType:S_NEW_VERSION];
        if (service != nil) {
            characteristic = [service findCharacteristicWithType:C_NEW_VERSION_A];
            serviceUuid = service.uniqueIdentifier.UUIDString;
        }
    } else if ([accessory isCurtain]) {
        HMService *service = [accessory findServiceWithType:S_CURTAIN];
        if (service != nil) {
            characteristic = [service findCharacteristicWithType:C_CURRENT_POSITION];
            serviceUuid = service.uniqueIdentifier.UUIDString;
        }
    } else if ([accessory isSmartDial]) {
        HMService *service = [accessory findServiceWithType:S_NEW_VERSION];
        if (service != nil) {
            characteristic = [service findCharacteristicWithType:C_NEW_VERSION_A];
            serviceUuid = service.uniqueIdentifier.UUIDString;
        }
    } else if ([accessory isHomeCenter]) {
        HMService *service = [accessory findServiceWithType:S_NEW_VERSION];
        if (service != nil) {
            characteristic = [service findCharacteristicWithType:C_NEW_VERSION_A];
            serviceUuid = service.uniqueIdentifier.UUIDString;
        }
    } else if ([accessory isSwitchModule]) {
        HMService *service = [accessory findServiceWithType:S_NEW_VERSION];
        if (service != nil) {
            characteristic = [service findCharacteristicWithType:C_NEW_VERSION_A];
            serviceUuid = service.uniqueIdentifier.UUIDString;
        }
    }
    if (characteristic != nil) {
        id oldValue = characteristic.value;

        accessory.updating = YES;
        [self sendUpdatingStatusChangedEvent:YES
                              homeIdentifier:homeIdentifier
                         accessoryIdentifier:accessory.uniqueIdentifier.UUIDString];

        [characteristic readValueWithCompletionHandler:^(NSError *error) {
          accessory.updating = NO;
          [self sendUpdatingStatusChangedEvent:NO
                                homeIdentifier:homeIdentifier
                           accessoryIdentifier:accessory.uniqueIdentifier.UUIDString];

          accessory.available = (error == nil);
          [self sendAvailableStatusChangedEvent:accessory.available
                                 homeIdentifier:homeIdentifier
                            accessoryIdentifier:accessory.uniqueIdentifier.UUIDString];

          if (oldValue != characteristic.value) {
              [self sendCharacteristicValueChangedEvent:characteristic.value
                                         homeIdentifier:homeIdentifier
                                    accessoryIdentifier:accessory.uniqueIdentifier.UUIDString
                                      serviceIdentifier:serviceUuid
                               characteristicIdentifier:characteristic.uniqueIdentifier.UUIDString];
          }
        }];
    }
}

- (void)accessoryReadCharacteristicValue {
    HMHome *home = self.homeManager.primaryHome;
    if (home != nil) {
        for (HMAccessory *accessory in home.accessories) {
            [self readAllValue:accessory homeIdentifier:home.uniqueIdentifier.UUIDString];
        }
    }
}

- (void)checkAvailableState {
    HMHome *home = self.homeManager.primaryHome;
    if (home != nil) {
        for (HMAccessory *accessory in home.accessories) {
            [self readValue:accessory homeIdentifier:home.uniqueIdentifier.UUIDString];
        }
    }
}

- (void)sendUpdatingStatusChangedEvent:(BOOL)updating
                        homeIdentifier:(NSString *)homeIdentifier
                   accessoryIdentifier:(NSString *)accessoryIdentifier {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(ACCESSORY_UPDATING_STATUS_CHANGED) forKey:@"eventType"];
    [args setValue:@(updating) forKey:@"updating"];
    [args setValue:homeIdentifier forKey:@"homeIdentifier"];
    [args setValue:accessoryIdentifier forKey:@"accessoryIdentifier"];
    [EventHandler.sharedHandler sendEvent:args];
}

- (void)sendAvailableStatusChangedEvent:(BOOL)available
                         homeIdentifier:(NSString *)homeIdentifier
                    accessoryIdentifier:(NSString *)accessoryIdentifier {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(ACCESSORY_AVAILABLE_STATUS_CHANGED) forKey:@"eventType"];
    [args setValue:@(available) forKey:@"available"];
    [args setValue:homeIdentifier forKey:@"homeIdentifier"];
    [args setValue:accessoryIdentifier forKey:@"accessoryIdentifier"];
    [EventHandler.sharedHandler sendEvent:args];
}

- (void)sendCharacteristicValueChangedEvent:(id)value
                             homeIdentifier:(NSString *)homeIdentifier
                        accessoryIdentifier:(NSString *)accessoryIdentifier
                          serviceIdentifier:(NSString *)serviceIdentifier
                   characteristicIdentifier:(NSString *)characteristicIdentifier {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@(CHARACTERISTIC_VALUE_CHANGED) forKey:@"eventType"];
    [args setValue:homeIdentifier forKey:@"homeIdentifier"];
    [args setValue:accessoryIdentifier forKey:@"accessoryIdentifier"];
    [args setValue:serviceIdentifier forKey:@"serviceIdentifier"];
    [args setValue:characteristicIdentifier forKey:@"characteristicIdentifier"];
    [args setValue:value forKey:@"value"];
    [EventHandler.sharedHandler sendEvent:args];
}

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
    NSLog(@"home manager did update homes");
    [self registerDelegate];
    [EventHandler.sharedHandler homeManagerDidUpdateHomes];
    [self accessoryReadCharacteristicValue];
}

- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager {
    [EventHandler.sharedHandler homeManagerDidUpdatePrimaryHome];
}

- (void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home {
    NSLog(@"home manager did add home");
    [EventHandler.sharedHandler homeManagerDidAddHome:home];
}

- (void)homeManager:(HMHomeManager *)manager didRemoveHome:(HMHome *)home {
    NSLog(@"home manager did remove home");
    [EventHandler.sharedHandler homeManagerDidRemoveHome:home];
}

- (void)homeDidUpdateName:(HMHome *)home {
    [EventHandler.sharedHandler homeDidUpdateName:home];
}

- (void)home:(HMHome *)home didAddAccessory:(HMAccessory *)accessory {
    [accessory setUpdating:NO];
    [accessory setAvailable:YES];
    [EventHandler.sharedHandler homeDidAddAccessory:home accessory:accessory];
}

- (void)home:(HMHome *)home didRemoveAccessory:(HMAccessory *)accessory {
    [EventHandler.sharedHandler homeDidRemoveAccessory:home accessory:accessory];
}

- (void)home:(HMHome *)home didUpdateRoom:(HMRoom *)room forAccessory:(HMAccessory *)accessory {
    [EventHandler.sharedHandler homeDidUpdateRoomForAccessory:home room:room accessory:accessory];
}

- (void)home:(HMHome *)home didAddRoom:(HMRoom *)room {
    [EventHandler.sharedHandler homeDidAddRoom:home room:room];
}

- (void)home:(HMHome *)home didRemoveRoom:(HMRoom *)room {
    [EventHandler.sharedHandler homeDidRemoveRoom:home room:room];
}

- (void)home:(HMHome *)home didUpdateNameForRoom:(HMRoom *)room {
    [EventHandler.sharedHandler homeDidUpdateNameForRoom:home room:room];
}

- (void)home:(HMHome *)home didAddActionSet:(HMActionSet *)actionSet {
    [EventHandler.sharedHandler homeDidAddActionSet:home actionSet:actionSet];
}

- (void)home:(HMHome *)home didRemoveActionSet:(HMActionSet *)actionSet {
    [EventHandler.sharedHandler homeDidRemoveActionSet:home actionSet:actionSet];
}

- (void)home:(HMHome *)home didUpdateNameForActionSet:(HMActionSet *)actionSet {
    [EventHandler.sharedHandler homeDidUpdateNameForActionSet:home actionSet:actionSet];
}

- (void)home:(HMHome *)home didUpdateActionsForActionSet:(HMActionSet *)actionSet {
    [EventHandler.sharedHandler homeDidUpdateActionsForActionSet:home actionSet:actionSet];
}

- (void)accessoryDidUpdateName:(HMAccessory *)accessory {
    HMHome *home = [self findHomeByAccessoryIdentifier:accessory.uniqueIdentifier.UUIDString];
    if (home == nil) return;
    [EventHandler.sharedHandler accessoryDidUpdateName:home accessory:accessory];
}

- (void)accessory:(HMAccessory *)accessory didUpdateNameForService:(HMService *)service {
    HMHome *home = [self findHomeByAccessoryIdentifier:accessory.uniqueIdentifier.UUIDString];
    if (home == nil) return;
    [EventHandler.sharedHandler accessoryDidUpdateNameForService:home
                                                       accessory:accessory
                                                         service:service];
}

- (void)accessoryDidUpdateServices:(HMAccessory *)accessory {
    HMHome *home = [self findHomeByAccessoryIdentifier:accessory.uniqueIdentifier.UUIDString];
    if (home == nil) return;
    [EventHandler.sharedHandler accessoryDidUpdateService:home accessory:accessory];
}

- (void)accessory:(HMAccessory *)accessory
                            service:(HMService *)service
    didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic {
    NSLog(@"HomeStore accessoryDidUpdateValueForCharacteristic");
    HMHome *home = [self findHomeByAccessoryIdentifier:accessory.uniqueIdentifier.UUIDString];
    if (home == nil) return;
    [EventHandler.sharedHandler accessoryDidUpdateValueForCharacteristic:home
                                                               accessory:accessory
                                                                 service:service
                                                          characteristic:characteristic];
}

- (void)accessory:(HMAccessory *)accessory didUpdateFirmwareVersion:(NSString *)firmwareVersion {
    HMHome *home = [self findHomeByAccessoryIdentifier:accessory.uniqueIdentifier.UUIDString];
    if (home == nil) return;
    [EventHandler.sharedHandler accessoryDidUpdateFirmwareVersion:home
                                                        accessory:accessory
                                                  firmwareVersion:firmwareVersion];
}

- (HMHome *)findHomeByAccessoryIdentifier:(NSString *)accessoryIdentifier {
    for (HMHome *home in _homeManager.homes) {
        for (HMAccessory *accessory in home.accessories) {
            if ([accessory.uniqueIdentifier.UUIDString isEqualToString:accessoryIdentifier])
                return home;
        }
    }
    return nil;
}

@end
