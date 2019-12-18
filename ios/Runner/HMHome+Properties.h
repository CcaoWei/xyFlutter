//
//  HMHome+Properties.h
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <HomeKit/HomeKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMHome (Properties)

- (HMAccessory *) findAccessory:(NSString *)accessoryIdentifier;
- (HMRoom *) findRoom:(NSString *)roomIdentifier;
- (HMActionSet *) findActionSet:(NSString *)actionSetIdentifier;

@end

NS_ASSUME_NONNULL_END
