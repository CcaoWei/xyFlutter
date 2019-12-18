//
//  WXAuthHandler.m
//  Runner
//
//  Created by litao on 2018/11/15.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "WXAuthHandler.h"
#import "CallResults.h"
#import "WXKeys.h"

@implementation WXAuthHandler

+ (instancetype)sharedHandler {
    static WXAuthHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[WXAuthHandler alloc] init];
    });
    return instance;
}

- (void)handleAuth:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSLog(@"auth in auth handler");
    NSString *openId = call.arguments[@"openId"];
    [WXApiRequestHandler sendAuthResuestScope:call.arguments[@"scope"]
                                        State:call.arguments[@"state"]
                                       OpenID:(openId == (id)[NSNull null]) ? nil : openId];
}

@end
