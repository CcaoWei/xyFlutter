//
//  qqMethodHandler.m
//  Runner
//
//  Created by litao on 2018/11/27.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "QQMethodHandler.h"

@interface QQMethodHandler () {
    TencentOAuth *_oauth;
}
@end

@implementation QQMethodHandler

+ (instancetype)sharedHanler {
    static QQMethodHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[QQMethodHandler alloc] init];
    });
    return instance;
}

- (void)registerQQ:(NSString *)appId {
    _oauth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:QQResponseHandler.sharedHanler];
    [MethodHandler.sharedHandler resultBool:YES];
}

- (void)isQQInstalled {
    if ([QQApiInterface isQQInstalled]) {
        [MethodHandler.sharedHandler resultBool:YES];
    } else {
        [MethodHandler.sharedHandler resultBool:NO];
    }
}

- (void)qqLogin:(NSString *)scopes {
    NSArray *scopeArray = nil;
    if (scopes && scopes.length) {
        scopeArray = [scopes componentsSeparatedByString:@","];
    }
    if (scopeArray == nil) {
        scopeArray = @[ @"get_user_info", @"get_simple_userinfo" ];
    }
    if (![_oauth authorize:scopeArray]) {
        NSMutableDictionary *body = @{@"type" : @"QQAuthorizeResponse"}.mutableCopy;
        body[@"Code"] = @(1);
        body[@"Message"] = @"login failed";
        [MethodHandler.sharedHandler result:body];
    }
}

- (TencentOAuth *)tencentOauth {
    return _oauth;
}

@end
