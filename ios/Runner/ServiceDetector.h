//
//  ServiceDetector.h
//  Runner
//
//  Created by litao on 2018/12/21.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <arpa/inet.h>

#import "HomeCenter.h"
#import "EventHandler.h"


NS_ASSUME_NONNULL_BEGIN

@interface ServiceDetector : NSObject

@property(strong, nonatomic) NSNetServiceBrowser *browser;

+ (instancetype) sharedInstance;

- (void) startBrowsing;

- (void) stopBrowsing;

- (NSMutableArray<HomeCenter *> *) discoveredHomeCenters;

@end

NS_ASSUME_NONNULL_END
