//
//  HMActionSet+Properties.m
//  Runner
//
//  Created by litao on 2018/11/26.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HMActionSet+Properties.h"

@implementation HMActionSet (Properties)

- (HMAction *)findAction:(NSString *)actionIdentifier {
    for (HMAction *action in [self actions]) {
        if ([action.uniqueIdentifier.UUIDString isEqualToString:actionIdentifier]) return action;
    }
    return nil;
}

@end
