//
//  WXResponseHandler.h
//  Runner
//
//  Created by litao on 2018/11/15.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "WXApiObject.h"
#import "WXApi.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidReceiveAuthResponse:(SendAuthResp *) response;

@end

@interface WXResponseHandler : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype) defaultManager;

- (void) setMethodChannel:(FlutterMethodChannel *) flutterMethodChannel;

- (void) cancelLogin;

@end

NS_ASSUME_NONNULL_END
