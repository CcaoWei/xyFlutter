//
//  WXApiRequestHandler.m
//  Runner
//
//  Created by litao on 2018/11/15.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "WXApiRequestHandler.h"
#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"
#import "StringUtil.h"
#import "WXApi.h"
#import "WXMediaMessage+messageConstruct.h"

@implementation WXApiRequestHandler

+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = scope;
    req.state = state;
    req.openID = openID;
    NSLog(@"send request 1");
    return [WXApi sendAuthReq:req
               viewController:viewController
                     delegate:[WXResponseHandler defaultManager]];
}

+ (BOOL)sendAuthResuestScope:(NSString *)scope State:(NSString *)state OpenID:(NSString *)openID {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = scope;
    req.state = state;
    req.openID = openID;
    NSLog(@"send request 2");
    return [WXApi sendReq:req];
}

+ (BOOL)openUrl:(NSString *)url {
    OpenWebviewReq *req = [[OpenWebviewReq alloc] init];
    req.url = url;
    return [WXApi sendReq:req];
}

@end
