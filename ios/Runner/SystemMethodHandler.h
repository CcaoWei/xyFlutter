//
//  SystemMethodHandle.h
//  Runner
//
//  Created by litao on 2018/11/26.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "MethodHandler.h"
#import "MessageHandler.h"
//#import "SVProgressHUD.h"
#import "UIView+Toast.h"


NS_ASSUME_NONNULL_BEGIN

@interface SystemMethodHandler : NSObject

+ (instancetype) sharedHandler;

- (void) handleGetClientType;

- (void) handleGetClientId;

- (void) handleGetPlatform;

- (void) handleGetSyetemVersion;

- (void) handleGetAppVersion;

- (void) handleGetHttpAgent;

- (void) handleScanQRCode:(NSString *)title text:(NSString *)text;

- (void) handleScanLocalService;

- (void) handleGetFoundLocalServices;

@end

NS_ASSUME_NONNULL_END
