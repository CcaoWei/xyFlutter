//
//  qqResponseHandler.h
//  Runner
//
//  Created by litao on 2018/11/27.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

#import "MethodHandler.h"
#import "QQMethodHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface QQResponseHandler : NSObject<QQApiInterfaceDelegate, TencentSessionDelegate>

+ (instancetype) sharedHanler;

- (void) cancelQQLogin;

@end

NS_ASSUME_NONNULL_END
