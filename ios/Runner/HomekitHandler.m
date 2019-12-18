//
//  HomekitHandler.m
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HomekitHandler.h"

@implementation HomekitHandler

+ (instancetype)sharedHanler {
    static HomekitHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[self alloc] init];
    });
    return instance;
}

FlutterMethodChannel *methodChannel;

- (void)setMethodChannel:(FlutterMethodChannel *)flutterMethodChannel {
    methodChannel = flutterMethodChannel;
}

- (NSString *)uuidToSerialNumber:(NSString *)uuid {
    if ([uuid hasPrefix:@"box-"]) {
        NSString *temp = [uuid substringFromIndex:4];
        temp = [temp stringByReplacingOccurrencesOfString:@"-" withString:@":"];
        return temp;
    }
    return @"";
}

// Home Center
- (HMAccessory *)getBridgeAccessory:(NSString *)serialNumber {
    NSArray<HMHome *> *homes = HomeStore.sharedStore.homeManager.homes;
    for (HMHome *home in homes) {
        NSArray<HMAccessory *> *accessories = home.accessories;
        for (HMAccessory *accessory in accessories) {
            if (!accessory.isBridged) continue;
            if ([serialNumber isEqualToString:[accessory serialNumber]]) {
                return accessory;
            }
        }
    }
    return nil;
}

// Home contains current bridge accessory
- (HMHome *)getHome:(NSString *)serialNumber {
    NSArray<HMHome *> *homes = HomeStore.sharedStore.homeManager.homes;
    for (HMHome *home in homes) {
        NSArray<HMAccessory *> *accessories = home.accessories;
        for (HMAccessory *accessory in accessories) {
            if (!accessory.isBridged) continue;
            if ([serialNumber isEqualToString:[accessory serialNumber]]) {
                return home;
            }
        }
    }
    return nil;
}

- (void)getAccessories:(NSString *)homeCenterUuid {
    NSArray<HMHome *> *homes = HomeStore.sharedStore.homeManager.homes;
    for (HMHome *home in homes) {
        NSArray<HMAccessory *> *accessories = home.accessories;
        for (HMAccessory *accessory in accessories) {
            if ([homeCenterUuid isEqualToString:[accessory homeCenterUuid]]) {
                NSDictionary *attr = [[NSDictionary alloc] init];

                NSString *identifier = accessory.uniqueIdentifier.UUIDString;
                [attr setValue:identifier forKey:@"identifier"];
                NSString *roomIdentifier = accessory.room.uniqueIdentifier.UUIDString;
                [attr setValue:roomIdentifier forKey:@"roomIdentifier"];
                BOOL available = accessory.available;
                [attr setValue:@(available) forKey:@"available"];
                BOOL isBridged = accessory.isBridged;
                [attr setValue:@(isBridged) forKey:@"isBridged"];

                for (HMService *service in accessory.services) {
                    if (service.type == S_PROPERTY) {
                        [self handlePropertyService:service attr:attr];
                    } else if (service.type == S_LIGHT_SOCKET) {
                        [self handleLightSocketService:service attr:attr];
                    } else if (service.type == S_SMART_PLUG) {
                        [self handleSmartPlugService:service attr:attr];
                    } else if (service.type == S_PLUG_POWER) {
                        [self handlePlugPowerService:service attr:attr];
                    } else if (service.type == S_WALL_SWITCH_LIGHT) {
                        [self handleWallSwitchLightService:service attr:attr];
                    } else if (service.type == S_TEMPERATURE) {
                        [self handleTemperatureService:service attr:attr];
                    } else if (service.type == S_AWARENESS_SWITCH) {
                        [self handleAwarenessSwitchService:service attr:attr];
                    } else if (service.type == S_CONTACT_SENSOR) {
                        [self handleContactSensorService:service attr:attr];
                    } else if (service.type == S_MOTION) {
                        [self handleMotionService:service attr:attr];
                    } else if (service.type == S_NEW_VERSION) {
                        [self handleNewVersionService:service attr:attr];
                    } else if (service.type == S_CURTAIN) {
                        [self handleCurtainService:service attr:attr];
                    } else if (service.type == S_LIGHT_SENSOR) {
                        [self handleLightSensorService:service attr:attr];
                    } else if (service.type == S_LOCK_MECHANISM) {
                        [self handleLockMechanismService:service attr:attr];
                    } else if (service.type == S_CURTAIN_SETTING) {
                        [self handleCurtainSettingSevice:service attr:attr];
                    }
                }
                [methodChannel invokeMethod:@"onAccessoryIncoming" arguments:attr];
            }
        }
    }
}

- (void)handleCurtainSettingSevice:(HMService *)service attr:(NSDictionary *)attr {
    // TODO: may be changed
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_TYPE) {
            int type = [characteristic.value intValue];
            [attr setValue:@(type) forKey:@"type"];
        } else if (characteristic.type == C_DIRECTION) {
            int direction = [characteristic.value intValue];
            [attr setValue:@(direction) forKey:@"direction"];
        } else if (characteristic.type == C_TRIP_LEARNED) {
            int tripLearned = [characteristic.value intValue];
            [attr setValue:@(tripLearned) forKey:@"tripLearned"];
        } else if (characteristic.type == C_ADJUST_TRIP) {
            int adjustTrip = [characteristic.value intValue];
            [attr setValue:@(adjustTrip) forKey:@"adjustTrip"];
        }
    }
}

- (void)handleLightSensorService:(HMService *)service attr:(NSDictionary *)attr {
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_LIGHT_LEVEL) {
            float lightLevel = [characteristic.value floatValue];
            [attr setValue:@(lightLevel) forKey:@"lightLevel"];
        }
    }
}

- (void)handleLockMechanismService:(HMService *)service attr:(NSDictionary *)attr {
    NSLog(@"handleLockMechanismService");
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_LOCK_CURRENT_STATE) {
            int lockCurrentState = [characteristic.value intValue];
            [attr setValue:@(lockCurrentState) forKey:@"lockCurrentState"];
        }
        if (characteristic.type == C_LOCK_TARGET_STATE) {
            int lockTargetState = [characteristic.value intValue];
            [attr setValue:@(lockTargetState) forKey:@"lockTargetState"];
        }
    }
}

- (void)handleCurtainService:(HMService *)service attr:(NSDictionary *)attr {
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_TARGET_POSITION) {
            int targetPosition = [characteristic.value intValue];
            [attr setValue:@(targetPosition) forKey:@"targetPosition"];
        } else if (characteristic.type == C_CURRENT_POSITION) {
            int currentPosition = [characteristic.value intValue];
            [attr setValue:@(currentPosition) forKey:@"currentPosition"];
        } else if (characteristic.type == C_CURRENT_STATE) {
            int currentState = [characteristic.value intValue];
            [attr setValue:@(currentState) forKey:@"currentState"];
        }
    }
}

- (void)handleNewVersionService:(HMService *)service attr:(NSDictionary *)attr {
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_NEW_VERSION_A) {
            NSString *newVersion = characteristic.value;
            [attr setValue:newVersion forKey:@"newVersion"];
        }
    }
}

- (void)handleMotionService:(HMService *)service attr:(NSDictionary *)attr {
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_MOTION) {
            int motion = [characteristic.value intValue];
            if ([attr objectForKey:@"leftOccupancy"]) {
                [attr setValue:@(motion) forKey:@"rightOccupancy"];
            } else {
                [attr setValue:@(motion) forKey:@"leftOccupancy"];
            }
        }
    }
}

- (void)handleContactSensorService:(HMService *)service attr:(NSDictionary *)attr {
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_CONTACT_SENSOR) {
            int openClose = [characteristic.value intValue];
            [attr setValue:@(openClose) forKey:@"openClose"];
        } else if (characteristic.type == C_LOW_POWER) {
            int lowBattery = [characteristic.value intValue];
            [attr setValue:@(lowBattery) forKey:@"lowBattery"];
        }
    }
}

- (void)handleAwarenessSwitchService:(HMService *)service attr:(NSDictionary *)attr {
    HMCharacteristic *modelCha = [service findCharacteristicWithType:C_MODEL];
    NSString *model = modelCha.value;
    if ([model isEqualToString:@"TERNCY-PP01"]) {
        for (HMCharacteristic *characteristic in service.characteristics) {
            if (characteristic.type == C_NAME) {
                NSString *name = characteristic.value;
                [attr setValue:name forKey:@"serviceName"];
            }
        }
    } else if ([model isEqualToString:@"TERNCY-WS01-S1"] ||
               [model isEqualToString:@"TERNCY-WS01-S2"] ||
               [model isEqualToString:@"TERNCY-WS01-S3"] ||
               [model isEqualToString:@"TERNCY-WS01-S4"] ||
               [model isEqualToString:@"TERNCY-WS01-D1"] ||
               [model isEqualToString:@"TERNCY-WS01-D2"] ||
               [model isEqualToString:@"TERNCY-WS01-D3"] ||
               [model isEqualToString:@"TERNCY-WS01-D4"]) {
        if ([attr objectForKey:@"serviceName01"]) {
            for (HMCharacteristic *characteristic in service.characteristics) {
                if (characteristic.type == C_NAME) {
                    NSString *name = characteristic.value;
                    [attr setValue:name forKey:@"serviceName01"];
                } else if (characteristic.type == C_AWARENESS_SWITCH) {
                    [attr setValue:@(2) forKey:@"type01"];
                }
            }
        } else if ([attr objectForKey:@"serviceName02"]) {
            for (HMCharacteristic *characteristic in service.characteristics) {
                if (characteristic.type == C_NAME) {
                    NSString *name = characteristic.value;
                    [attr setValue:name forKey:@"serviceName02"];
                } else if (characteristic.type == C_AWARENESS_SWITCH) {
                    [attr setValue:@(2) forKey:@"type02"];
                }
            }
        } else if ([attr objectForKey:@"serviceName03"]) {
            for (HMCharacteristic *characteristic in service.characteristics) {
                if (characteristic.type == C_NAME) {
                    NSString *name = characteristic.value;
                    [attr setValue:name forKey:@"serviceName03"];
                } else if (characteristic.type == C_AWARENESS_SWITCH) {
                    [attr setValue:@(2) forKey:@"type03"];
                }
            }
        } else {
            for (HMCharacteristic *characteristic in service.characteristics) {
                if (characteristic.type == C_NAME) {
                    NSString *name = characteristic.value;
                    [attr setValue:name forKey:@"serviceName04"];
                } else if (characteristic.type == C_AWARENESS_SWITCH) {
                    [attr setValue:@(2) forKey:@"type04"];
                }
            }
        }
    }
}

- (void)handleTemperatureService:(HMService *)service attr:(NSDictionary *)attr {
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_TEMPERATURE) {
            float temperature = [characteristic.value floatValue];
            [attr setValue:@(temperature) forKey:@"temperature"];
        }
    }
}

- (void)handleWallSwitchLightService:(HMService *)service attr:(NSDictionary *)attr {
    if (![attr objectForKey:@"serviceName01"]) {
        for (HMCharacteristic *characteristic in service.characteristics) {
            if (characteristic.type == C_NAME) {
                NSString *name = characteristic.value;
                [attr setValue:name forKey:@"serviceName01"];
            } else if (characteristic.type == C_ON_OFF) {
                int onOff = [characteristic.value intValue];
                [attr setValue:@(onOff) forKey:@"onOff01"];
                [attr setValue:@(1) forKey:@"type01"];
            }
        }
    } else if (![attr objectForKey:@"serviceName02"]) {
        for (HMCharacteristic *characteristic in service.characteristics) {
            if (characteristic.type == C_NAME) {
                NSString *name = characteristic.value;
                [attr setValue:name forKey:@"serviceName02"];
            } else if (characteristic.type == C_ON_OFF) {
                int onOff = [characteristic.value intValue];
                [attr setValue:@(onOff) forKey:@"onOff02"];
                [attr setValue:@(1) forKey:@"type02"];
            }
        }
    } else if (![attr objectForKey:@"serviceName03"]) {
        for (HMCharacteristic *characteristic in service.characteristics) {
            if (characteristic.type == C_NAME) {
                NSString *name = characteristic.value;
                [attr setValue:name forKey:@"serviceName03"];
            } else if (characteristic.type == C_ON_OFF) {
                int onOff = [characteristic.value intValue];
                [attr setValue:@(onOff) forKey:@"onOff03"];
                [attr setValue:@(1) forKey:@"type03"];
            }
        }
    } else {
        for (HMCharacteristic *characteristic in service.characteristics) {
            if (characteristic.type == C_NAME) {
                NSString *name = characteristic.value;
                [attr setValue:name forKey:@"serviceName04"];
            } else if (characteristic.type == C_ON_OFF) {
                int onOff = [characteristic.value intValue];
                [attr setValue:@(onOff) forKey:@"onOff04"];
                [attr setValue:@(1) forKey:@"type04"];
            }
        }
    }
}

- (void)handlePlugPowerService:(HMService *)service attr:(NSDictionary *)attr {
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_PLUG_ACTIVE_POWER) {
            int activePower = [characteristic.value intValue];
            [attr setValue:@(activePower) forKey:@"activePower"];
        }
    }
}

- (void)handleSmartPlugService:(HMService *)service attr:(NSDictionary *)attr {
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_NAME) {
            NSString *name = characteristic.value;
            [attr setValue:name forKey:@"serviceName"];
        } else if (characteristic.type == C_ON_OFF) {
            int onOff = [characteristic.value intValue];
            [attr setValue:@(onOff) forKey:@"onOff"];
        } else if (characteristic.type == C_PLUG_BEING_USED) {
            BOOL plugBeingUsed = [characteristic.value boolValue];
            [attr setValue:@(plugBeingUsed) forKey:@"plugBeingUsed"];
        }
    }
}

- (void)handleLightSocketService:(HMService *)service attr:(NSDictionary *)attr {
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_ON_OFF) {
            int onOff = [characteristic.value intValue];
            [attr setValue:@(onOff) forKey:@"onOff"];
        } else if (characteristic.type == C_NAME) {
            NSString *name = characteristic.value;
            [attr setValue:name forKey:@"serviceName"];
        }
    }
}

- (void)handlePropertyService:(HMService *)service attr:(NSDictionary *)attr {
    for (HMCharacteristic *characteristic in service.characteristics) {
        if (characteristic.type == C_NAME) {
            NSString *name = characteristic.value;
            [attr setValue:name forKey:@"name"];
        } else if (characteristic.type == C_MANUFACTURER) {
            NSString *manufacturer = characteristic.value;
            [attr setValue:manufacturer forKey:@"manufacturer"];
        } else if (characteristic.type == C_MODEL) {
            NSString *model = characteristic.value;
            [attr setValue:model forKey:@"model"];
        } else if (characteristic.type == C_SERIAL_NUMBER) {
            NSString *serialNumber = characteristic.value;
            [attr setValue:serialNumber forKey:@"serialNumber"];
        } else if (characteristic.type == C_FIRMWARE_VERSION) {
            NSString *firmwareVersion = characteristic.value;
            [attr setValue:firmwareVersion forKey:@"firmwareVersion"];
        } else if (characteristic.type == C_HARDWARE_VERSION) {
            NSString *hardwareVersion = characteristic.value;
            [attr setValue:hardwareVersion forKey:@"hardwareVersion"];
        }
    }
}

//获取当前家庭中心所属Home的Rooms
- (void)getRooms:(NSString *)homeCenterUuid {
    NSString *serialNumber = [self uuidToSerialNumber:homeCenterUuid];
    HMHome *home = [self getHome:serialNumber];
    if (home != nil) {
        NSArray<HMRoom *> *rooms = home.rooms;
        for (HMRoom *room in rooms) {
            NSDictionary *args = [[NSDictionary alloc] init];
            NSString *name = room.name;
            NSString *identifier = [room.uniqueIdentifier UUIDString];
            [args setValue:name forKey:@"name"];
            [args setValue:identifier forKey:@"identifier"];
            [methodChannel invokeMethod:@"onRoomIncoming" arguments:args];
        }
    }
}

- (void)getActionSets:(NSString *)homeCenterUuid {
    NSString *serialNumber = [self uuidToSerialNumber:homeCenterUuid];
    HMHome *home = [self getHome:serialNumber];
    if (home != nil) {
        NSArray<HMActionSet *> *actionSets = home.actionSets;
        for (HMActionSet *actionSet in actionSets) {
            NSDictionary *args = [[NSDictionary alloc] init];
            NSString *type = actionSet.actionSetType;
            if ([type isEqualToString:HMActionSetTypeHomeDeparture] ||
                [type isEqualToString:HMActionSetTypeHomeArrival] ||
                [type isEqualToString:HMActionSetTypeSleep] ||
                [type isEqualToString:HMActionSetTypeWakeUp]) {
                [args setValue:@"default" forKey:@"type"];
            } else if ([type isEqualToString:HMActionSetTypeUserDefined]) {
                [args setValue:@"userDefined" forKey:@"type"];
            } else {
                continue;
            }

            NSString *name = actionSet.name;
            NSString *identifier = actionSet.uniqueIdentifier.UUIDString;
            [args setValue:name forKey:@"name"];
            [args setValue:identifier forKey:@"identifier"];

            NSSet<HMAction *> *actions = actionSet.actions;
            int number = 0;
            for (HMAction *action in actions) {
                NSString *key = [NSString stringWithFormat:@"action%d", number];
                [args setValue:key forKey:action.uniqueIdentifier.UUIDString];
                number++;
            }
            [args setValue:@(number) forKey:@"actionNumber"];
            [methodChannel invokeMethod:@"onActionSetIncoming" arguments:args];
        }
    }
}

@end
