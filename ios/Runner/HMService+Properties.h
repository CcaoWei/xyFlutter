//
//  HMService+Properties.h
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <HomeKit/HomeKit.h>
#import "HMCharacteristic+Properties.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum _ServiceType {
    S_PROPERTY, //属性
    S_LIGHT_SOCKET, //灯座
    S_SMART_PLUG, //插座
    S_PLUG_POWER, //插座电量
    S_WALL_SWITCH_LIGHT, //墙壁开关灯座
    S_TEMPERATURE, //温度
    S_AWARENESS_SWITCH, //感应开关按键
    S_CONTACT_SENSOR, //门磁
    S_MOTION, //感应开关红外探测
    S_NEW_VERSION, //版本升级
    S_DEFINED_PERMIT_JOIN,
    S_DELETE,
    S_CURTAIN, //窗帘状态
    S_LIGHT_SENSOR, //光照强度
    S_CURTAIN_SETTING, //窗帘设置
    S_RELATE_HOME_CENTER,
    S_LOCK_MECHANISM,
    S_UNKNOWN,
} ServiceType;

@interface HMService (Properties)

- (ServiceType) type;

- (int) typeInt;

- (NSString *) homeCenterUuid;

- (HMCharacteristic *) findCharacteristicWithType:(CharacteristicType)type;

- (HMCharacteristic *) findCharacteristic:(NSString *)characteristicIdentifier;

@end

NS_ASSUME_NONNULL_END
