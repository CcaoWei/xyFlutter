//
//  HMHome+Properties.m
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HMHome+Properties.h"

@implementation HMHome (Properties)

- (HMAccessory *)findAccessory:(NSString *)accessoryIdentifier {
    for (HMAccessory *accessory in [self accessories]) {
        if ([accessory.uniqueIdentifier.UUIDString isEqualToString:accessoryIdentifier]) {
            return accessory;
        }
    }
    return nil;
}

- (HMRoom *)findRoom:(NSString *)roomIdentifier {
    for (HMRoom *room in [self rooms]) {
        if ([room.uniqueIdentifier.UUIDString isEqualToString:roomIdentifier]) {
            return room;
        }
    }
    if ([roomIdentifier isEqualToString:[self.roomForEntireHome.uniqueIdentifier UUIDString]]) {
        return self.roomForEntireHome;
    }
    return nil;
}

- (HMActionSet *)findActionSet:(NSString *)actionSetIdentifier {
    for (HMActionSet *actionSet in [self actionSets]) {
        if ([actionSet.uniqueIdentifier.UUIDString isEqualToString:actionSetIdentifier]) {
            return actionSet;
        }
    }
    return nil;
}

@end
