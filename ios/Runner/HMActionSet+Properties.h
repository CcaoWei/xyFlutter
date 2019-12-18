//
//  HMActionSet+Properties.h
//  Runner
//
//  Created by litao on 2018/11/26.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <HomeKit/HomeKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMActionSet (Properties)

- (HMAction *) findAction:(NSString *)actionIdentifier;

@end

NS_ASSUME_NONNULL_END
