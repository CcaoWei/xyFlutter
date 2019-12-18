//
//  MessageHandler.m
//  Runner
//
//  Created by litao on 2018/12/21.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "MessageHandler.h"

@interface MessageHandler () {
    FlutterBasicMessageChannel *_messageChannel;
}

@end

@implementation MessageHandler

+ (instancetype)sharedHandler {
    static MessageHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[MessageHandler alloc] init];
    });
    return instance;
}

- (void)setMessageChannel:(FlutterBasicMessageChannel *)messageChannel {
    _messageChannel = messageChannel;
}

- (void)handleGetFoundedLocalServices {
    NSMutableArray<HomeCenter *> *homeCenters =
        [ServiceDetector.sharedInstance discoveredHomeCenters];
    for (HomeCenter *homeCenter in homeCenters) {
        NSDictionary *args = [[NSDictionary alloc] init];
        args = @{
            @"type" : @"localService",
            @"uuid" : homeCenter.uuid,
            @"name" : homeCenter.name,
            @"ip" : homeCenter.ip,
        };
        [_messageChannel sendMessage:args];
    }
}

@end
