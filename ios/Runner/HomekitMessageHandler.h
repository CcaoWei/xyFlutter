//
//  HomekitMessageHandler.h
//  Runner
//
//  Created by litao on 2018/11/23.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HomeKit/HomeKit.h>
#import <Flutter/Flutter.h>

#import "HomeStore.h"
#import "HMService+Properties.h"
#import "HMCharacteristic+Properties.h"
#import "MethodHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomekitMessageHandler : NSObject

+ (instancetype) sharedHandler;

- (void) setMessageChannel:(FlutterBasicMessageChannel *) messageChannel;

- (void) getHomekitEntities;

- (void)getHomeEntities:(NSString *)homeIdentifier;

- (void)getAccessory:(NSString *)homeIdentifier accessoryIdentifier:(NSString *)accessoryIdentifier;

@end

NS_ASSUME_NONNULL_END
