//
//  WXApiHandler.m
//  Runner
//
//  Created by litao on 2018/11/15.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "WXApiHandler.h"
#import "AppDelegate.h"
#import "CallResults.h"
#import "StringUtil.h"
#import "WXApi.h"
#import "WXKeys.h"

@implementation WXApiHandler

+ (instancetype)sharedHandler {
    static WXApiHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[WXApiHandler alloc] init];
    });
    return instance;
}

- (void)registerApp:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!call.arguments[wxKeyIOS]) {
        result(@{wxKeyPlatform : wxKeyIOS, wxKeyResult : @NO});
        return;
    }
    if (isWechatRegistered) {
        result(@{wxKeyPlatform : wxKeyIOS, wxKeyResult : @YES});
        return;
    }
    NSString *appId = call.arguments[@"appId"];
    if ([StringUtil isBlank:appId]) {
        result([FlutterError errorWithCode:@"invalid app id"
                                   message:@"are you sure your app id is correct? "
                                   details:appId]);
        return;
    }
    isWechatRegistered = [WXApi registerApp:appId
                                  enableMTA:[call.arguments[@"enableMTA"] boolValue]];
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION |
                      MMAPP_SUPPORT_VIDEO | MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE |
                      MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT |
                      MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX |
                      MMAPP_SUPPORT_PDF;
    [WXApi registerAppSupportContentFlag:typeFlag];
    result(@{wxKeyPlatform : wxKeyIOS, wxKeyResult : @(isWechatRegistered)});
}

- (void)checkWechatInstallation:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!isWechatRegistered) {
        result([FlutterError errorWithCode:resultErrorNeedWechat
                                   message:@"please config wxapi first"
                                   details:nil]);
    } else {
        result(@([WXApi isWXAppInstalled]));
    }
}
@end
