//
//  WXAuthHandler.h
//  Runner
//
//  Created by litao on 2018/11/15.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "AppDelegate.h"
#import "WXApi.h"
#import "WXApiRequestHandler.h"
@class StringUtil;

NS_ASSUME_NONNULL_BEGIN

@interface WXAuthHandler : NSObject

+ (instancetype) sharedHandler;

//- (instancetype) initWithRegistrar:(NSObject<FlutterPluginRegistrar> *) registrar;
- (void) handleAuth:(FlutterMethodCall *)call result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
