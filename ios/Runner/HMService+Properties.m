//
//  HMService+Properties.m
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HMService+Properties.h"

@implementation HMService (Properties)

- (NSString *)homeCenterUuid {
    for (HMCharacteristic *characteristic in [self characteristics]) {
        if (characteristic.type == C_RELATE_HOME_CENTER) {
            return characteristic.value;
        }
    }
    return @"";
}

- (HMCharacteristic *)findCharacteristicWithType:(CharacteristicType)type {
    for (HMCharacteristic *characteristic in [self characteristics]) {
        if (characteristic.type == type) {
            return characteristic;
        }
    }
    return nil;
}

- (HMCharacteristic *)findCharacteristic:(NSString *)characteristicIdentifier {
    for (HMCharacteristic *characteristic in [self characteristics]) {
        if ([characteristic.uniqueIdentifier.UUIDString isEqualToString:characteristicIdentifier])
            return characteristic;
    }
    return nil;
}

- (ServiceType)type {
    if ([[self serviceType] isEqualToString:@"0000003E-0000-1000-8000-0026BB765291"]) {
        return S_PROPERTY;
    } else if ([[self serviceType] isEqualToString:@"00000043-0000-1000-8000-0026BB765291"]) {
        return S_LIGHT_SOCKET;
    } else if ([[self serviceType] isEqualToString:@"00000047-0000-1000-8000-0026BB765291"]) {
        return S_SMART_PLUG;
    } else if ([[self serviceType] isEqualToString:@"A0BD8A47-2D86-4B19-AAE9-CA5769286CDE"]) {
        return S_PLUG_POWER;
    } else if ([[self serviceType] isEqualToString:@"00000049-0000-1000-8000-0026BB765291"]) {
        return S_WALL_SWITCH_LIGHT;
    } else if ([[self serviceType] isEqualToString:@"0000008A-0000-1000-8000-0026BB765291"]) {
        return S_TEMPERATURE;
    } else if ([[self serviceType] isEqualToString:@"00000089-0000-1000-8000-0026BB765291"]) {
        return S_AWARENESS_SWITCH;
    } else if ([[self serviceType] isEqualToString:@"00000080-0000-1000-8000-0026BB765291"]) {
        return S_CONTACT_SENSOR;
    } else if ([[self serviceType] isEqualToString:@"00000085-0000-1000-8000-0026BB765291"]) {
        return S_MOTION;
    } else if ([[self serviceType] isEqualToString:@"00000045-0000-1000-8000-0026BB765291"]) {
        return S_LOCK_MECHANISM;
    } else if ([[self serviceType] isEqualToString:@"A0BD8A43-2D86-4B19-AAE9-CA5769286CDE"]) {
        return S_NEW_VERSION;
    } else if ([[self serviceType] isEqualToString:@"A0BD8A44-2D86-4B19-AAE9-CA5769286CDE"]) {
        return S_DEFINED_PERMIT_JOIN;
    } else if ([[self serviceType] isEqualToString:@"A0BD8A45-2D86-4B19-AAE9-CA5769286CDE"]) {
        return S_DELETE;
    } else if ([[self serviceType] isEqualToString:@"0000008C-0000-1000-8000-0026BB765291"]) {
        return S_CURTAIN;
    } else if ([[self serviceType] isEqualToString:@"00000084-0000-1000-8000-0026BB765291"]) {
        return S_LIGHT_SENSOR;
    } else if ([[self serviceType] isEqualToString:@"A0BD8A46-2D86-4B19-AAE9-CA5769286CDE"]) {
        return S_CURTAIN_SETTING;
    } else if ([[self serviceType] isEqualToString:@""]) {
        return S_RELATE_HOME_CENTER;
    } else {
        return S_UNKNOWN;
    }
}

- (int)typeInt {
    if ([[self serviceType] isEqualToString:@"0000003E-0000-1000-8000-0026BB765291"]) {
        return 0x203E;
    } else if ([[self serviceType] isEqualToString:@"00000043-0000-1000-8000-0026BB765291"]) {
        return 0x2043;
    } else if ([[self serviceType] isEqualToString:@"00000047-0000-1000-8000-0026BB765291"]) {
        return 0x2047;
    } else if ([[self serviceType] isEqualToString:@"00000045-0000-1000-8000-0026BB765291"]) {
        return 0x2045;
    } else if ([[self serviceType] isEqualToString:@"A0BD8A47-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x3047;
    } else if ([[self serviceType] isEqualToString:@"00000049-0000-1000-8000-0026BB765291"]) {
        return 0x2049;
    } else if ([[self serviceType] isEqualToString:@"0000008A-0000-1000-8000-0026BB765291"]) {
        return 0x208A;
    } else if ([[self serviceType] isEqualToString:@"00000089-0000-1000-8000-0026BB765291"]) {
        return 0x2089;
    } else if ([[self serviceType] isEqualToString:@"00000080-0000-1000-8000-0026BB765291"]) {
        return 0x2080;
    } else if ([[self serviceType] isEqualToString:@"00000085-0000-1000-8000-0026BB765291"]) {
        return 0x2085;
    } else if ([[self serviceType] isEqualToString:@"A0BD8A43-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x3043;
    } else if ([[self serviceType] isEqualToString:@"A0BD8A44-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x3044;
    } else if ([[self serviceType] isEqualToString:@"A0BD8A45-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x3045;
    } else if ([[self serviceType] isEqualToString:@"0000008C-0000-1000-8000-0026BB765291"]) {
        return 0x208C;
    } else if ([[self serviceType] isEqualToString:@"00000084-0000-1000-8000-0026BB765291"]) {
        return 0x2084;
    } else if ([[self serviceType] isEqualToString:@"A0BD8A46-2D86-4B19-AAE9-CA5769286CDE"]) {
        return 0x3046;
    } else if ([[self serviceType] isEqualToString:@""]) {
        return 0x0000;
    } else {
        return 0x0000;
    }
}

@end
