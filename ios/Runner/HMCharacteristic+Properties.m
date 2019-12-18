//
//  HMCharacteristic+Properties.m
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HMCharacteristic+Properties.h"

@implementation HMCharacteristic (Properties)

- (CharacteristicType)type {
    if ([[self characteristicType] isEqualToString:@"00000023-0000-1000-8000-0026BB765291"]) {
        return C_NAME;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000020-0000-1000-8000-0026BB765291"]) {
        return C_MANUFACTURER;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000021-0000-1000-8000-0026BB765291"]) {
        return C_MODEL;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000030-0000-1000-8000-0026BB765291"]) {
        return C_SERIAL_NUMBER;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000052-0000-1000-8000-0026BB765291"]) {
        return C_FIRMWARE_VERSION;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000053-0000-1000-8000-0026BB765291"]) {
        return C_HARDWARE_VERSION;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000014-0000-1000-8000-0026BB765291"]) {
        return C_RECOGNITION;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000025-0000-1000-8000-0026BB765291"]) {
        return C_ON_OFF;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020A-2D86-4B19-AAE9-CA5769286CDE"]) {
        return C_NEW_VERSION_A;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020B-2D86-4B19-AAE9-CA5769286CDE"]) {
        return C_NEW_VERSION_B;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020C-2D86-4B19-AAE9-CA5769286CDE"]) {
        return C_NEW_VERSION_C;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020D-2D86-4B19-AAE9-CA5769286CDE"]) {
        return C_DEFINED_PERMIT_JOIN;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020E-2D86-4B19-AAE9-CA5769286CDE"]) {
        return C_DELETE;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000022-0000-1000-8000-0026BB765291"]) {
        return C_MOTION;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000079-0000-1000-8000-0026BB765291"]) {
        return C_LOW_POWER;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000011-0000-1000-8000-0026BB765291"]) {
        return C_TEMPERATURE;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000073-0000-1000-8000-0026BB765291"]) {
        return C_AWARENESS_SWITCH;
    } else if ([[self characteristicType]
                   isEqualToString:@"0000006A-0000-1000-8000-0026BB765291"]) {
        return C_CONTACT_SENSOR;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000026-0000-1000-8000-0026BB765291"]) {
        return C_PLUG_BEING_USED;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E030213-2D86-4B19-AAE9-CA5769286CDE"]) {
        return C_PLUG_ACTIVE_POWER;
    } else if ([[self characteristicType]
                   isEqualToString:@"0000007C-0000-1000-8000-0026BB765291"]) {
        return C_TARGET_POSITION;
    } else if ([[self characteristicType]
                   isEqualToString:@"0000006D-0000-1000-8000-0026BB765291"]) {
        return C_CURRENT_POSITION;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000072-0000-1000-8000-0026BB765291"]) {
        return C_CURRENT_STATE;
    } else if ([[self characteristicType]
                   isEqualToString:@"0000006B-0000-1000-8000-0026BB765291"]) {
        return C_LIGHT_LEVEL;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020F-2D86-4B19-AAE9-CA5769286CDE"]) {
        return C_TYPE;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E030210-2D86-4B19-AAE9-CA5769286CDE"]) {
        return C_DIRECTION;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E030211-2D86-4B19-AAE9-CA5769286CDE"]) {
        return C_TRIP_LEARNED;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E030212-2D86-4B19-AAE9-CA5769286CDE"]) {
        return C_ADJUST_TRIP;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E030214-2D86-4B19-AAE9-CA5769286CDE"]) {
        return C_CHECK_NEW_VERSION;
    } else if ([[self characteristicType]
            isEqualToString:@"0000001D-0000-1000-8000-0026BB765291"]) {
        return C_LOCK_CURRENT_STATE;
    } else if ([[self characteristicType]
                isEqualToString:@"0000001E-0000-1000-8000-0026BB765291"]) {
        return C_LOCK_TARGET_STATE;
    } else if ([[self characteristicType] isEqualToString:@""]) {
        return C_RELATE_HOME_CENTER;
    } else {
        return C_UNKNOWN;
    }
}

- (int)typeInt {
    if ([[self characteristicType] isEqualToString:@"00000023-0000-1000-8000-0026BB765291"]) {
        return 0x0023;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000020-0000-1000-8000-0026BB765291"]) {
        return 0x0020;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000021-0000-1000-8000-0026BB765291"]) {
        return 0x0021;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000030-0000-1000-8000-0026BB765291"]) {
        return 0x0030;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000052-0000-1000-8000-0026BB765291"]) {
        return 0x0052;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000053-0000-1000-8000-0026BB765291"]) {
        return 0x0053;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000014-0000-1000-8000-0026BB765291"]) {
        return 0x0014;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000025-0000-1000-8000-0026BB765291"]) {
        return 0x0025;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020A-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x100A;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020B-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x100B;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020C-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x100C;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020D-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x100D;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020E-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0X100E;
    } else if ([[self characteristicType]
                   isEqualToString:@"0000001D-0000-1000-8000-0026BB765291"]) {
        return 0x001D;
    } else if ([[self characteristicType]
                isEqualToString:@"0000001E-0000-1000-8000-0026BB765291"]) {
        return 0x001E;
    } else if ([[self characteristicType]
                isEqualToString:@"00000022-0000-1000-8000-0026BB765291"]) {
        return 0x0022;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000079-0000-1000-8000-0026BB765291"]) {
        return 0x0079;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000011-0000-1000-8000-0026BB765291"]) {
        return 0x0011;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000073-0000-1000-8000-0026BB765291"]) {
        return 0x0073;
    } else if ([[self characteristicType]
                   isEqualToString:@"0000006A-0000-1000-8000-0026BB765291"]) {
        return 0x006A;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000026-0000-1000-8000-0026BB765291"]) {
        return 0x0026;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E030213-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x1013;
    } else if ([[self characteristicType]
                   isEqualToString:@"0000007C-0000-1000-8000-0026BB765291"]) {
        return 0x007C;
    } else if ([[self characteristicType]
                   isEqualToString:@"0000006D-0000-1000-8000-0026BB765291"]) {
        return 0x006D;
    } else if ([[self characteristicType]
                   isEqualToString:@"00000072-0000-1000-8000-0026BB765291"]) {
        return 0x0072;
    } else if ([[self characteristicType]
                   isEqualToString:@"0000006B-0000-1000-8000-0026BB765291"]) {
        return 0x006B;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E03020F-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x100F;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E030210-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x1010;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E030211-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x1011;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E030212-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x1012;
    } else if ([[self characteristicType]
                   isEqualToString:@"2E030214-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x1014;
    } else if ([[self characteristicType] isEqualToString:@""]) {
        return 0x0000;
    } else {
        return 0x0000;
    }
}

- (BOOL)supportNotification {
    return [self.properties containsObject:@"HMCharacteristicPropertySupportsEventNotification"];
    //    NSLog(@"++++++++++");
    //    for (NSString *ss in self.properties) {
    //        NSLog(@"%@", ss);
    //    }
    //    NSLog(@"==========");
    //    return true;
}

@end
