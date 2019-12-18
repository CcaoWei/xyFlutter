//
//  StringUtil.h
//  Runner
//
//  Created by litao on 2018/11/15.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StringUtil : NSObject
+ (BOOL) isBlank:(NSString *)string;
+ (NSString *) nilToEmpty:(NSString *) string;
@end

NS_ASSUME_NONNULL_END
