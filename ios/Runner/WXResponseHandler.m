//
//  WXResponseHandler.m
//  Runner
//
//  Created by litao on 2018/11/15.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "WXResponseHandler.h"
#import "AppDelegate.h"
#import "StringUtil.h"
#import "WXKeys.h"

@implementation WXResponseHandler

const NSString *errStr = @"errStr";
const NSString *errCode = @"errCode";
const NSString *openId = @"openId";
const NSString *type = @"type";
const NSString *lang = @"lang";
const NSString *country = @"country";
const NSString *description = @"description";

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static WXResponseHandler *instance;
    dispatch_once(&onceToken, ^{
      instance = [[WXResponseHandler alloc] init];
    });
    return instance;
}

FlutterMethodChannel *fluwexMethodChannel = nil;

- (void)setMethodChannel:(FlutterMethodChannel *)flutterMethodChannel {
    fluwexMethodChannel = flutterMethodChannel;
}

- (void)onResp:(BaseResp *)resp {
    NSLog(@"response");
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        isWechatLoginStarted = NO;
        NSLog(@"auth response %@", resp.debugDescription);
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidReceiveAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidReceiveAuthResponse:authResp];
        }
        SendAuthResp *authResp = (SendAuthResp *)resp;
        NSDictionary *result = @{
            description : authResp.description == nil ? @"" : authResp.description,
            errStr : authResp.errStr == nil ? @"" : authResp.errStr,
            errCode : @(authResp.errCode),
            type : authResp.type == nil ? @1 : @(authResp.type),
            country : authResp.country == nil ? @"" : authResp.country,
            lang : authResp.lang == nil ? @"" : authResp.lang,
            wxKeyPlatform : wxKeyIOS,
            @"code" : [StringUtil nilToEmpty:authResp.code],
            @"state" : [StringUtil nilToEmpty:authResp.state]
        };
        [fluwexMethodChannel invokeMethod:@"onAuthResponse" arguments:(id _Nullable)result];
    }
}

- (void)cancelLogin {
    NSLog(@"cancel login");
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    [args setValue:@"" forKey:@"description"];
    [args setValue:@"" forKey:@"errStr"];
    [args setValue:@(-2) forKey:@"errCode"];
    [args setValue:@(1) forKey:@"type"];
    [args setValue:@"" forKey:@"country"];
    [args setValue:@"" forKey:@"lang"];
    [args setValue:@"iOS" forKey:@"platform"];
    [args setValue:@"" forKey:@"code"];
    [args setValue:@"" forKey:@"state"];
    [fluwexMethodChannel invokeMethod:@"onAuthResponse" arguments:(id _Nullable)args];
}

@end
