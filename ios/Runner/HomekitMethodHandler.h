//
//  HomekitMethodHandler.h
//  Runner
//
//  Created by litao on 2018/11/24.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HomeKit/HomeKit.h>
#import <Flutter/Flutter.h>

#import "HomeStore.h"
#import "HMHome+Properties.h"
#import "HMAccessory+Properties.h"
#import "HMService+Properties.h"
#import "HMCharacteristic+Properties.h"
#import "HMActionSet+Properties.h"
#import "MethodHandler.h"
#import "EventType.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomekitMethodHandler : NSObject

+ (instancetype) sharedHanler;

//- (void) setMethodHandler:(FlutterMethodCall *)methodCall;

- (void) updatePrimaryHome:(NSString *)identifier;
- (void) addHome:(NSString *)name;
- (void) removeHome:(NSString *)identifier;

- (void) updateHomeName:(NSString *)homeIdentifier name:(NSString *)name;
- (void) removeAccessory:(NSString *)homeIdentfier accessoryIdentifier:(NSString *)accessoryIdentifier;
- (void) updateAccessoryRoom:(NSString *)homeIdentifier accessoryIdentifier:(NSString *)accessoryIdentifier roomIdentifier:(NSString *)roomIdentifier;
- (void) addRoom:(NSString *)homeIdentifier name:(NSString *)name;
- (void) removeRoom:(NSString *)homeIdentifier roomIdentifier:(NSString *)roomIdentifier;
- (void) updateRoomName:(NSString *)homeIdentifier roomIdentifier:(NSString *)roomIdentifier newName:(NSString *)newName;
- (void) addActionSet:(NSString *)homeIdentifier name:(NSString *)name;
- (void) removeActionSet:(NSString *)homeIdentifier actionSetIdentifier:(NSString *)actionSetIdentifier;
- (void) excuteActionSet:(NSString *)homeIdentifier actionSetIdentifier:(NSString *)actionSetIdentifier;
- (void) addHomeCeneter:(NSString *)homeIdentifier;
- (void) manageUsers:(NSString *)homeIdentifer;

- (void) updateAccessoryName:(NSString *)homeIdentifier accessoryIdentifier:(NSString *)accessoryIdentifier name:(NSString *)name;

- (void) updateServiceName:(NSString *)homeIdentifier accessoryIdentifier:(NSString *)accessoryIdentifier serviceIdentifier:(NSString *)serviceIdentifier name:(NSString *)name;

- (void) setAuthorizationData:(NSString *)homeIdentifier accessoryIdentifier:(NSString *)accessoryIdentifier serviceIdentifier:(NSString *)serviceIdentifier characteristicIdentifier:(NSString *)characteristicIdentifier value:(NSString *) value;
- (void) writeValue:(NSString *)homeIdentifier accessoryIdentifier:(NSString *)accessoryIdentifier serviceIdentifier:(NSString *)serviceIdentifier characteristicIdentifier:(NSString *)characteristicIdentifier value:(id) value;
- (void) readValue:(NSString *)homeIdentifier accessoryIdentifier:(NSString *)accessoryIdentifier serviceIdentifier:(NSString *)serviceIdentifier characteristicIdentifier:(NSString *)characteristicIdentifier;
- (void) enableNotification:(NSString *)homeIdentifier accessoryIdentifier:(NSString *)accessoryIdentifier serviceIdentifier:(NSString *)serviceIdentifier characteristicIdentifier:(NSString *)characteristicIdentifier enable:(BOOL)enable;

- (void) updateActionSetName:(NSString *)homeIdentifier actionSetIdentifier:(NSString *)actionSetIdentifier name:(NSString *)name;
- (void) addAction:(NSString *)homeIdentifier actionSetIdentifier:(NSString *)actionSetIdentifier accessoryIdentifier:(NSString *)accessoryIdentifier serviceIdentifier:(NSString *)serviceIdentifier characteristicIdentifier:(NSString *)characteristicIdentifier targetValue:(id)targetValue;
- (void) removeAction:(NSString *)homeIdentifier actionSetIdentifier:(NSString *)actionSetIdentifier actionIdentifier:(NSString *)actionIdentifier;
- (void) updateTargetValue:(NSString *)homeIdentifier actionSetIdentifier:(NSString *)actionSetIdentifier actionIdentifier:(NSString *)actionIdentifier targetValue:(id)targetValue;

@end

NS_ASSUME_NONNULL_END
