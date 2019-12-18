//
//  HomeStore.h
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HomeKit/HomeKit.h>

#import "EventHandler.h"
#import "HMAccessory+Properties.h"
#import "HMCharacteristic+Properties.h"
#import "HMService+Properties.h"
#import "EventType.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeStore : NSObject

+ (instancetype) sharedStore;

- (HMHomeManager *) homeManager;

- (HMHome *) findHome:(NSString *)identifier;

- (void) checkAvailableState;
- (void) accessoryReadCharacteristicValue;
- (void) registerDelegate;

@end

NS_ASSUME_NONNULL_END
