//
//  qqResponseHandler.m
//  Runner
//
//  Created by litao on 2018/11/27.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "QQResponseHandler.h"

@implementation QQResponseHandler

+ (instancetype)sharedHanler {
    static QQResponseHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[QQResponseHandler alloc] init];
    });
    return instance;
}

- (void)onReq:(QQBaseReq *)req {
}

- (void)onResp:(QQBaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        NSMutableDictionary *body = @{@"type" : @"QQShareResponse"}.mutableCopy;
        SendMessageToQQResp *sendResp = (SendMessageToQQResp *)resp;
        if (sendResp.errorDescription) {
            body[@"Code"] = @(1);
        } else {
            body[@"Code"] = @(0);
        }
        body[@"Message"] = sendResp.result;
        [MethodHandler.sharedHandler result:body];
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
}

- (void)tencentDidLogin {
    isQQLoginStarted = NO;
    NSMutableDictionary *body = @{@"type" : @"QQAuthorizeResponse"}.mutableCopy;
    body[@"Code"] = @(0);
    body[@"Message"] = @"OK";
    TencentOAuth *oauth = [QQMethodHandler.sharedHanler tencentOauth];
    NSMutableDictionary *response = @{@"openid" : oauth.openId}.mutableCopy;
    response[@"openid"] = oauth.openId;
    response[@"accessToken"] = oauth.accessToken;
    response[@"expiresAt"] = @([oauth.expirationDate timeIntervalSince1970] * 1000);
    response[@"appId"] = oauth.appId;
    body[@"Response"] = response;
    [MethodHandler.sharedHandler result:body];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    isQQLoginStarted = NO;
    NSMutableDictionary *body = @{@"type" : @"QQAuthorizeResponse"}.mutableCopy;
    if (cancelled) {
        body[@"Code"] = @(2);
        body[@"Message"] = @"login canceled";
    } else {
        body[@"Code"] = @(1);
        body[@"Message"] = @"login failed";
    }
    [MethodHandler.sharedHandler result:body];
}

- (void)cancelQQLogin {
    NSMutableDictionary *body = @{@"type" : @"QQAuthorizeResponse"}.mutableCopy;
    body[@"Code"] = @(2);
    body[@"Message"] = @"login canceled";
    [MethodHandler.sharedHandler result:body];
}

- (void)tencentDidNotNetWork {
}

- (void)tencentDidNotWork {
}

@end
