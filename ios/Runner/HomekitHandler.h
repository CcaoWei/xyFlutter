//
//  HomekitHandler.h
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HomeKit/HomeKit.h>
#import <Flutter/Flutter.h>

#import "HomeStore.h"
#import "HMAccessory+Properties.h"
#import "HMService+Properties.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomekitHandler : NSObject

+ (instancetype) sharedHanler;

- (void) setMethodChannel:(FlutterMethodChannel *) flutterMethodChannel;

- (void) getAccessories:(NSString *)homeCenterUuid;

- (void) getRooms:(NSString *)homeCenterUuid;

- (void) getActionSets:(NSString *) homeCenterUuid;

@end

NS_ASSUME_NONNULL_END
