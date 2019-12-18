//
//  qqMethodHandler.h
//  Runner
//
//  Created by litao on 2018/11/27.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "QQResponseHandler.h"
#import "MethodHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface QQMethodHandler : NSObject

+ (instancetype) sharedHanler;

- (void) registerQQ:(NSString *)appId;

- (void) isQQInstalled;

- (void) qqLogin:(NSString *)scopes;

- (TencentOAuth *) tencentOauth;

@end

NS_ASSUME_NONNULL_END
