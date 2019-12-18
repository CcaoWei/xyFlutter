//
//  MethodHandler.m
//  Runner
//
//  Created by litao on 2018/11/24.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "MethodHandler.h"

@interface MethodHandler () {
    FlutterMethodChannel *_methodChannel;
    FlutterMethodCall *_call;
    FlutterResult _result;
}
@end

@implementation MethodHandler

+ (instancetype)sharedHandler {
    static MethodHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[MethodHandler alloc] init];
    });
    return instance;
}

- (void)result:(NSDictionary *)args {
    if (_result != nil) {
        _result(args);
    }
}

- (void)resultString:(NSString *)args {
    if (_result != nil) {
        _result(args);
    }
}

- (void)resultBool:(BOOL)args {
    if (_result != nil) {
        _result(@(args));
    }
}

- (void)resultDouble:(double)args {
    if (_result != nil) {
        _result(@(args));
    }
}

- (void)setMethodChannel:(FlutterMethodChannel *)methodChannel {
    _methodChannel = methodChannel;
    [_methodChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
      _call = call;
      _result = result;
      if ([@"updatePrimaryHome" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleUpdatePrimaryHome];
      } else if ([@"addHome" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleAddHome];
      } else if ([@"removeHome" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleRemoveHome];
      } else if ([@"updateHomeName" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleUpdateHomeName];
      } else if ([@"removeAccessory" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleRemoveAccessory];
      } else if ([@"updateAccessoryRoom" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleUpdateAccessoryRoom];
      } else if ([@"addRoom" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleAddRoom];
      } else if ([@"removeRoom" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleRemoveRoom];
      } else if ([@"updateRoomName" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleUpdateRoomName];
      } else if ([@"addActionSet" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleAddActionSet];
      } else if ([@"removeActionSet" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleRemoveActionSet];
      } else if ([@"excuteActionSet" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleExcuteActionSet];
      } else if ([@"addHomeCenter" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleAddHomeCenter];
      } else if ([@"managerUsers" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleManageUsers];
      } else if ([@"updateAccessoryName" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleUpdateAccessoryName];
      } else if ([@"updateServiceName" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleUpdateServiceName];
      } else if ([@"writeValue" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleWriteValue];
      } else if ([@"setAuthorizationData" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleSetAuthorizationData];
      } else if ([@"readValue" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleReadValue];
      } else if ([@"enableNotification" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleEnableNotification];
      } else if ([@"updateActionSetName" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleUpdateActionSetName];
      } else if ([@"addAction" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleAddAction];
      } else if ([@"removeAction" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleRemoveAction];
      } else if ([@"updateTargetValue" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleUpdateTargetValue];
      } else if ([@"getEntities" isEqualToString:call.method]) {
          [HomekitMessageHandler.sharedHandler getHomekitEntities];
      } else if ([@"getHomeEntities" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleGetHomeEntities];
      } else if ([@"getAccessory" isEqualToString:call.method]) {
          [MethodHandler.sharedHandler handleGetAccessory];
      } else if ([@"getClientId" isEqualToString:call.method]) {
          [SystemMethodHandler.sharedHandler handleGetClientId];
      } else if ([@"getClientType" isEqualToString:call.method]) {
          [SystemMethodHandler.sharedHandler handleGetClientType];
      } else if ([@"getPlatform" isEqualToString:call.method]) {
          [SystemMethodHandler.sharedHandler handleGetPlatform];
      } else if ([@"getSystemVersion" isEqualToString:call.method]) {
          [SystemMethodHandler.sharedHandler handleGetSyetemVersion];
      } else if ([@"getAppVersion" isEqualToString:call.method]) {
          [SystemMethodHandler.sharedHandler handleGetAppVersion];
      } else if ([@"getHttpAgent" isEqualToString:call.method]) {
          [SystemMethodHandler.sharedHandler handleGetHttpAgent];
      } else if ([@"scanQRCode" isEqualToString:call.method]) {
          NSDictionary *args = call.arguments;
          [SystemMethodHandler.sharedHandler handleScanQRCode:args[@"title"] text:args[@"text"]];
      } else if ([@"registerWechat" isEqualToString:call.method]) {
          [WXApiHandler.sharedHandler registerApp:call result:result];
      } else if ([@"isWechatInstalled" isEqualToString:call.method]) {
          [WXApiHandler.sharedHandler checkWechatInstallation:call result:result];
      } else if ([@"wechatLogin" isEqualToString:call.method]) {
          isWechatLoginStarted = YES;
          [WXAuthHandler.sharedHandler handleAuth:call result:result];
      } else if ([@"registerQQ" isEqualToString:call.method]) {
          NSDictionary *args = call.arguments;
          [QQMethodHandler.sharedHanler registerQQ:args[@"appId"]];
      } else if ([@"isQQInstalled" isEqualToString:call.method]) {
          [QQMethodHandler.sharedHanler isQQInstalled];
      } else if ([@"qqLogin" isEqualToString:call.method]) {
          isQQLoginStarted = YES;
          [QQMethodHandler.sharedHanler qqLogin:@""];
      } else if ([@"scanLocalService" isEqualToString:call.method]) {
          [SystemMethodHandler.sharedHandler handleScanLocalService];
      } else if ([@"getFoundLocalService" isEqualToString:call.method]) {
          [SystemMethodHandler.sharedHandler handleGetFoundLocalServices];
      }
    }];
}

- (void)handleGetHomeEntities {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    [HomekitMessageHandler.sharedHandler getHomeEntities:homeIdentifier];
}

- (void)handleGetAccessory {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *accessoryIdentifier = [args objectForKey:@"accessoryIdentifier"];
    [HomekitMessageHandler.sharedHandler getAccessory:homeIdentifier
                                  accessoryIdentifier:accessoryIdentifier];
}

- (void)handleUpdatePrimaryHome {
    NSDictionary *args = _call.arguments;
    NSString *identifier = [args objectForKey:@"identifier"];
    [HomekitMethodHandler.sharedHanler updatePrimaryHome:identifier];
}

- (void)handleAddHome {
    NSDictionary *args = _call.arguments;
    NSString *name = [args objectForKey:@"name"];
    [HomekitMethodHandler.sharedHanler addHome:name];
}

- (void)handleRemoveHome {
    NSDictionary *args = _call.arguments;
    NSString *identifier = [args objectForKey:@"identifier"];
    [HomekitMethodHandler.sharedHanler removeHome:identifier];
}

- (void)handleUpdateHomeName {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *name = [args objectForKey:@"name"];
    [HomekitMethodHandler.sharedHanler updateHomeName:homeIdentifier name:name];
}

- (void)handleRemoveAccessory {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *accessoryIdentifier = [args objectForKey:@"accessoryIdentifier"];
    [HomekitMethodHandler.sharedHanler removeAccessory:homeIdentifier
                                   accessoryIdentifier:accessoryIdentifier];
}

- (void)handleUpdateAccessoryRoom {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *accessoryIdentifier = [args objectForKey:@"accessoryIdentifier"];
    NSString *roomIdentifier = [args objectForKey:@"roomIdentifier"];
    [HomekitMethodHandler.sharedHanler updateAccessoryRoom:homeIdentifier
                                       accessoryIdentifier:accessoryIdentifier
                                            roomIdentifier:roomIdentifier];
}

- (void)handleAddRoom {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *name = [args objectForKey:@"name"];
    [HomekitMethodHandler.sharedHanler addRoom:homeIdentifier name:name];
}

- (void)handleRemoveRoom {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *roomIdentifier = [args objectForKey:@"roomIdentifier"];
    [HomekitMethodHandler.sharedHanler removeRoom:homeIdentifier roomIdentifier:roomIdentifier];
}

- (void)handleUpdateRoomName {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *roomIdentifier = [args objectForKey:@"roomIdentifier"];
    NSString *newName = [args objectForKey:@"name"];
    [HomekitMethodHandler.sharedHanler updateRoomName:homeIdentifier
                                       roomIdentifier:roomIdentifier
                                              newName:newName];
}

- (void)handleAddActionSet {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *name = [args objectForKey:@"name"];
    [HomekitMethodHandler.sharedHanler addActionSet:homeIdentifier name:name];
}

- (void)handleRemoveActionSet {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *actionSetIdentifier = [args objectForKey:@"actionSetIdentifier"];
    [HomekitMethodHandler.sharedHanler removeActionSet:homeIdentifier
                                   actionSetIdentifier:actionSetIdentifier];
}

- (void)handleExcuteActionSet {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *actionSetIdentifier = [args objectForKey:@"actionSetIdentifier"];
    [HomekitMethodHandler.sharedHanler excuteActionSet:homeIdentifier
                                   actionSetIdentifier:actionSetIdentifier];
}

- (void)handleAddHomeCenter {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    [HomekitMethodHandler.sharedHanler addHomeCeneter:homeIdentifier];
}

- (void)handleManageUsers {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    [HomekitMethodHandler.sharedHanler manageUsers:homeIdentifier];
}

- (void)handleUpdateAccessoryName {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *accessoryIdentifier = [args objectForKey:@"accessoryIdentifier"];
    NSString *name = [args objectForKey:@"name"];
    [HomekitMethodHandler.sharedHanler updateAccessoryName:homeIdentifier
                                       accessoryIdentifier:accessoryIdentifier
                                                      name:name];
}

- (void)handleUpdateServiceName {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *accessoryIdentifier = [args objectForKey:@"accessoryIdentifier"];
    NSString *serviceIdentifier = [args objectForKey:@"serviceIdentifier"];
    NSString *name = [args objectForKey:@"name"];
    [HomekitMethodHandler.sharedHanler updateServiceName:homeIdentifier
                                     accessoryIdentifier:accessoryIdentifier
                                       serviceIdentifier:serviceIdentifier
                                                    name:name];
}

- (void)handleSetAuthorizationData {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *accessoryIdentifier = [args objectForKey:@"accessoryIdentifier"];
    NSString *serviceIdentifier = [args objectForKey:@"serviceIdentifier"];
    NSString *characteristicIdentifier = [args objectForKey:@"characteristicIdentifier"];
    NSString *valueStr = [args objectForKey:@"value"];
    [HomekitMethodHandler.sharedHanler setAuthorizationData:homeIdentifier
                              accessoryIdentifier:accessoryIdentifier
                                serviceIdentifier:serviceIdentifier
                         characteristicIdentifier:characteristicIdentifier
                                            value:valueStr];
}

- (void)handleWriteValue {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *accessoryIdentifier = [args objectForKey:@"accessoryIdentifier"];
    NSString *serviceIdentifier = [args objectForKey:@"serviceIdentifier"];
    NSString *characteristicIdentifier = [args objectForKey:@"characteristicIdentifier"];
    id value = [args objectForKey:@"value"];
    [HomekitMethodHandler.sharedHanler writeValue:homeIdentifier
                              accessoryIdentifier:accessoryIdentifier
                                serviceIdentifier:serviceIdentifier
                         characteristicIdentifier:characteristicIdentifier
                                            value:value];
}

- (void)handleReadValue {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *accessoryIdentifier = [args objectForKey:@"accessoryIdentifier"];
    NSString *serviceIdentifier = [args objectForKey:@"serviceIdentifier"];
    NSString *characteristicIdentifier = [args objectForKey:@"characteristicIdentifier"];
    [HomekitMethodHandler.sharedHanler readValue:homeIdentifier
                             accessoryIdentifier:accessoryIdentifier
                               serviceIdentifier:serviceIdentifier
                        characteristicIdentifier:characteristicIdentifier];
}

- (void)handleEnableNotification {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *accessoryIdentifier = [args objectForKey:@"accessoryIdentifier"];
    NSString *serviceIdentifier = [args objectForKey:@"serviceIdentifier"];
    NSString *characteristicIdentifier = [args objectForKey:@"characteristicIdentifier"];
    BOOL enable = [[args objectForKey:@"enable"] boolValue];
    [HomekitMethodHandler.sharedHanler enableNotification:homeIdentifier
                                      accessoryIdentifier:accessoryIdentifier
                                        serviceIdentifier:serviceIdentifier
                                 characteristicIdentifier:characteristicIdentifier
                                                   enable:enable];
}

- (void)handleUpdateActionSetName {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *actionSetIdentifier = [args objectForKey:@"actionSetIdentifier"];
    NSString *name = [args objectForKey:@"name"];
    [HomekitMethodHandler.sharedHanler updateActionSetName:homeIdentifier
                                       actionSetIdentifier:actionSetIdentifier
                                                      name:name];
}

- (void)handleAddAction {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *actionSetIdentifier = [args objectForKey:@"actionSetIdentifier"];
    NSString *accessoryIdentifier = [args objectForKey:@"accessoryIdentifier"];
    NSString *serviceIdentifier = [args objectForKey:@"serviceIdentifier"];
    NSString *characteristicIdentifier = [args objectForKey:@"characteristicIdentifier"];
    id targetValue = [args objectForKey:@"targetValue"];
    [HomekitMethodHandler.sharedHanler addAction:homeIdentifier
                             actionSetIdentifier:actionSetIdentifier
                             accessoryIdentifier:accessoryIdentifier
                               serviceIdentifier:serviceIdentifier
                        characteristicIdentifier:characteristicIdentifier
                                     targetValue:targetValue];
}

- (void)handleRemoveAction {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *actionSetIdentifier = [args objectForKey:@"actionSetIdentifier"];
    NSString *actionIdentifier = [args objectForKey:@"actionIdentifier"];
    [HomekitMethodHandler.sharedHanler removeAction:homeIdentifier
                                actionSetIdentifier:actionSetIdentifier
                                   actionIdentifier:actionIdentifier];
}

- (void)handleUpdateTargetValue {
    NSDictionary *args = _call.arguments;
    NSString *homeIdentifier = [args objectForKey:@"homeIdentifier"];
    NSString *actionSetIdentifier = [args objectForKey:@"actionSetIdentifier"];
    NSString *actionIdentifier = [args objectForKey:@"actionIdentifier"];
    id targetValue = [args objectForKey:@"targetValue"];
    [HomekitMethodHandler.sharedHanler updateTargetValue:homeIdentifier
                                     actionSetIdentifier:actionSetIdentifier
                                        actionIdentifier:actionIdentifier
                                             targetValue:targetValue];
}

@end
