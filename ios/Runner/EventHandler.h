//
//  EventHandler.h
//  Runner
//
//  Created by litao on 2018/11/26.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HomeKit/HomeKit.h>
#import <Flutter/Flutter.h>

#import "EventType.h"
#import "HomeStore.h"
#import "HomeCenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventHandler : NSObject

+ (instancetype) sharedHandler;

- (void) setEventChannel:(FlutterEventChannel *)eventChannel;

- (void) sendEvent:(id)arguments;

- (void) homeManagerDidUpdateHomes;
- (void) homeManagerDidUpdatePrimaryHome;
- (void) homeManagerDidAddHome:(HMHome *)home;
- (void) homeManagerDidRemoveHome:(HMHome *)home;

- (void) homeDidUpdateName:(HMHome *)home;
- (void) homeDidAddAccessory:(HMHome *)home accessory:(HMAccessory *)accessory;
- (void) homeDidRemoveAccessory:(HMHome *)home accessory:(HMAccessory *)accessory;
- (void) homeDidUpdateRoomForAccessory:(HMHome *)home room:(HMRoom *)room accessory:(HMAccessory *)accessory;
- (void) homeDidAddRoom:(HMHome *)home room:(HMRoom *)room;
- (void) homeDidRemoveRoom:(HMHome *)home room:(HMRoom *)room;
- (void) homeDidUpdateNameForRoom:(HMHome *)home room:(HMRoom *)room;
- (void) homeDidAddActionSet:(HMHome *)home actionSet:(HMActionSet *)actionSet;
- (void) homeDidRemoveActionSet:(HMHome *)home actionSet:(HMActionSet *)actionSet;
- (void) homeDidUpdateNameForActionSet:(HMHome *)home actionSet:(HMActionSet *)actionSet;
- (void) homeDidUpdateActionsForActionSet:(HMHome *)home actionSet:(HMActionSet *)actionSet;

- (void) accessoryDidUpdateName:(HMHome *)home accessory:(HMAccessory *)accessory;
- (void) accessoryDidUpdateNameForService:(HMHome *)home accessory:(HMAccessory *)accessory service:(HMService *)service;
- (void) accessoryDidUpdateService:(HMHome *)home accessory:(HMAccessory *)accessory;
- (void) accessoryDidUpdateValueForCharacteristic:(HMHome *)home accessory:(HMAccessory *)accessory service:(HMService *)service characteristic:(HMCharacteristic *)characteristic;
- (void) accessoryDidUpdateFirmwareVersion:(HMHome *)home accessory:(HMAccessory *)accessory firmwareVersion:(NSString *)firmwareVersion;

- (void) localServiceDidFound:(HomeCenter *)homeCenter;
- (void) localServiceDidLost:(NSString *)uuid;

- (void) noAccessToCamera;

@end

NS_ASSUME_NONNULL_END
