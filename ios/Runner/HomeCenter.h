//
//  HomeCenter.h
//  Runner
//
//  Created by litao on 2018/12/21.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCenter : NSObject

@property(nonatomic, copy) NSString *uuid;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *ip;
@property(nonatomic, copy) NSString *versionString;

- (instancetype) initWithUuid:(NSString *)uuid name:(NSString *)name ip:(NSString *)ip versionString:(NSString *)versionString;

@end

NS_ASSUME_NONNULL_END
