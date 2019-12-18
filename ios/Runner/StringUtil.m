//
//  StringUtil.m
//  Runner
//
//  Created by litao on 2018/11/15.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

+ (BOOL)isBlank:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
               length] == 0;
}

+ (NSString *)nilToEmpty:(NSString *)string {
    return string == nil ? @"" : string;
}

@end
