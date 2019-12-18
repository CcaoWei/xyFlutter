//
//  HomeCenter.m
//  Runner
//
//  Created by litao on 2018/12/21.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HomeCenter.h"

@implementation HomeCenter

- (instancetype)initWithUuid:(NSString *)uuid
                        name:(NSString *)name
                          ip:(NSString *)ip
               versionString:(NSString *)versionString {
    self = [[HomeCenter alloc] init];
    self.uuid = uuid;
    self.name = name;
    self.ip = ip;
    self.versionString = versionString;
    return self;
}

@end
