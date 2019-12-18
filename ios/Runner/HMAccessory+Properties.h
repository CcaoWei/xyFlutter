//
//  HMAccessory+Properties.h
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <HomeKit/HomeKit.h>
#import <objc/runtime.h>

#import "HMService+Properties.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMAccessory (Properties)

@property(nonatomic, assign) BOOL available;
@property(nonatomic, assign) BOOL updating;

- (NSString *) homeCenterUuid;


- (HMService *) findServiceWithType:(ServiceType)type;

- (NSString *) serialNumber;

- (HMService *) findService:(NSString *)serviceIdentifier;

- (BOOL) isLightSocket;
- (BOOL) isSmartPlug;
- (BOOL) isDoorSensor;
- (BOOL) isAwarenessSwitch;
- (BOOL) isWallSwitch;
- (BOOL) isWallSwitchUS;
- (BOOL) isCurtain;
- (BOOL) isSmartDial;
- (BOOL) isHomeCenter;
- (BOOL) isSwitchModule;

@end

NS_ASSUME_NONNULL_END
