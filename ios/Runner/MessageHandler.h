//
//  MessageHandler.h
//  Runner
//
//  Created by litao on 2018/12/21.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

#import "ServiceDetector.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageHandler : NSObject

+ (instancetype) sharedHandler;

- (void) setMessageChannel:(FlutterBasicMessageChannel *)messageChannel;

- (void) handleGetFoundedLocalServices;

@end

NS_ASSUME_NONNULL_END
