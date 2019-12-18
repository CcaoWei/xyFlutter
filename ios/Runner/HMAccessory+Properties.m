//
//  HMAccessory+Properties.m
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HMAccessory+Properties.h"

static void *kAvailable = &kAvailable;
static void *kUpdateing = &kUpdateing;

@implementation HMAccessory (Properties)

@dynamic available;
@dynamic updating;

- (void)setAvailable:(BOOL)available {
    objc_setAssociatedObject(self, kAvailable, @(available), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setUpdating:(BOOL)updating {
    objc_setAssociatedObject(self, kUpdateing, @(updating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)available {
    return [objc_getAssociatedObject(self, &kAvailable) boolValue];
}

- (BOOL)updating {
    return [objc_getAssociatedObject(self, kUpdateing) boolValue];
}

- (NSString *)homeCenterUuid {
    for (HMService *service in [self services]) {
        if (service.type == S_RELATE_HOME_CENTER) {
            return service.homeCenterUuid;
        }
    }
    return @"";
}

- (HMService *)findServiceWithType:(ServiceType)type {
    for (HMService *service in [self services]) {
        if (service.type == type) {
            return service;
        }
    }
    return nil;
}

- (NSString *)serialNumber {
    HMService *property = [self findServiceWithType:S_PROPERTY];
    if (property != nil) {
        HMCharacteristic *serialNumber = [property findCharacteristicWithType:C_SERIAL_NUMBER];
        if (serialNumber != nil) {
            return serialNumber.value;
        }
    }
    return @"";
}

- (HMService *)findService:(NSString *)serviceIdentifier {
    for (HMService *service in [self services]) {
        if ([service.uniqueIdentifier.UUIDString isEqualToString:serviceIdentifier]) return service;
    }
    return nil;
}

- (BOOL)isLightSocket {
    return [[self accessoryModel] isEqualToString:@"TERNCY-LS01"];
}

- (BOOL)isSmartPlug {
    return [[self accessoryModel] isEqualToString:@"TERNCY-SP01"];
}

- (BOOL)isAwarenessSwitch {
    return [[self accessoryModel] isEqualToString:@"TERNCY-PP01"];
}

- (BOOL)isDoorSensor {
    return [[self accessoryModel] isEqualToString:@"TERNCY-DC01"];
}

- (BOOL)isCurtain {
    return [[self accessoryModel] isEqualToString:@"TERNCY-CM01"];
}

- (BOOL)isWallSwitch {
    return [[self accessoryModel] isEqualToString:@"TERNCY-WS01-S1"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-WS01-S2"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-WS01-S3"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-WS01-S4"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-WS01-D1"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-WS01-D2"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-WS01-D3"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-WS01-D4"];
}

- (BOOL)isWallSwitchUS {
    return [[self accessoryModel] isEqualToString:@"TERNCY-WS01-US-X1"];
}

- (BOOL)isSmartDial {
    return [[self accessoryModel] isEqualToString:@"TERNCY-SD01"];
}

- (BOOL)isHomeCenter {
    return [[self accessoryModel] isEqualToString:@"TERNCY-GW01"];
}

- (BOOL)isSwitchModule {
    return [[self accessoryModel] isEqualToString:@"TERNCY-SM01-S1"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-SM01-S2"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-SM01-S3"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-SM01-S4"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-SM01-D1"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-SM01-D2"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-SM01-D3"] ||
           [[self accessoryModel] isEqualToString:@"TERNCY-SM01-D4"];
}

- (NSString *)accessoryModel {
    NSString *mod = @"";
    if (@available(iOS 11.0, *)) {
        mod = [self model];
    } else {
        for (HMService *service in [self services]) {
            if (service.type == S_PROPERTY) {
                for (HMCharacteristic *characteristic in service.characteristics) {
                    if (characteristic.type == C_MODEL) {
                        mod = [characteristic.value stringValue];
                    }
                }
            }
        }
    }
    return mod;
}

@end
