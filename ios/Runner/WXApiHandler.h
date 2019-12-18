//
//  WXApiHandler.h
//  Runner
//
//  Created by litao on 2018/11/15.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXApiHandler : NSObject

+ (instancetype) sharedHandler;

- (void) registerApp:(FlutterMethodCall *) call result:(FlutterResult)result;
- (void) checkWechatInstallation:(FlutterMethodCall *) call result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
