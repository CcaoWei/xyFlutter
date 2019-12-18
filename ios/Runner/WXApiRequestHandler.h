//
//  WXApiRequestHandler.h
//  Runner
//
//  Created by litao on 2018/11/15.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"
#import "WXResponseHandler.h"


NS_ASSUME_NONNULL_BEGIN

@interface WXApiRequestHandler : NSObject

+ (BOOL) sendAuthRequestScope:(NSString *)scope
                        State:(NSString *)state
                       OpenID:(NSString *)openID
             InViewController:(UIViewController *)viewController;

+ (BOOL) sendAuthResuestScope:(NSString *)scope
                        State:(NSString *)state
                       OpenID:(NSString *)openID;

+ (BOOL) openUrl:(NSString *) url;

@end

NS_ASSUME_NONNULL_END
