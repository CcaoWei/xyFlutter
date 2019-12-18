//
//  MethodHandler.h
//  Runner
//
//  Created by litao on 2018/11/24.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

#import "HomekitMethodHandler.h"
#import "SystemMethodHandler.h"
#import "WXApiHandler.h"
#import "WXAuthHandler.h"
#import "HomekitMessageHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface MethodHandler : NSObject

+ (instancetype) sharedHandler;

- (void) setMethodChannel:(FlutterMethodChannel *)methodChannel;

- (void) result:(NSDictionary *)args;

- (void) resultString:(NSString *)args;

- (void) resultBool:(BOOL)args;

- (void) resultDouble:(double)args;

@end

NS_ASSUME_NONNULL_END
