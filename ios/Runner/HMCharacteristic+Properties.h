//
//  HMCharacteristic+Properties.h
//  Runner
//
//  Created by litao on 2018/11/20.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//


#import <HomeKit/HomeKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum _CharacteristicType {
    // in service "0000003E-0000-1000-8000-0026BB765291"
    C_NAME,
    C_MANUFACTURER,
    C_MODEL,
    C_SERIAL_NUMBER,
    C_FIRMWARE_VERSION,
    C_HARDWARE_VERSION,
    C_RECOGNITION, //Identify

    // in service "00000049-0000-1000-8000-0026BB765291", home center
    // also in service "00000043-0000-1000-8000-0026BB765291", "00000047-0000-1000-8000-0026BB765291"
    C_ON_OFF,

    // in service "A0BD8A43-2D86-4B19-AAE9-CA5769286CDE", new version
    C_NEW_VERSION_A,
    C_NEW_VERSION_B,
    C_NEW_VERSION_C,

    // in service "A0BD8A44-2D86-4B19-AAE9-CA5769286CDE", defined permit join
    C_DEFINED_PERMIT_JOIN,

    C_DELETE,

    C_MOTION,

    // also in door sensor, 低电量
    C_LOW_POWER,

    // in service "0000008A-0000-1000-8000-0026BB765291", pir temperature
    C_TEMPERATURE,

    // in service "00000089-0000-1000-8000-0026BB765291", pir, 按键
    C_AWARENESS_SWITCH,

    // in service "00000080-0000-1000-8000-0026BB765291", door sensor, 门磁事件
    C_CONTACT_SENSOR,

    // in service "00000047-0000-1000-8000-0026BB765291", door sensor, 插座上有没有插东西
    C_PLUG_BEING_USED,

    //插座电量
    C_PLUG_ACTIVE_POWER,

    //窗帘 目标位置(7C) 当前位置(6D) 当前状态(72)
    C_TARGET_POSITION,
    C_CURRENT_POSITION,
    C_CURRENT_STATE,

    //pir 光照强度 in service "00000084-0000-1000-8000-0026BB765291"
    C_LIGHT_LEVEL,

    //窗帘配置 类型(0F) 方向(10) 是否学习过长度(11)
    C_TYPE,
    C_DIRECTION,
    C_TRIP_LEARNED,
    C_ADJUST_TRIP,

    //检测新版本
    C_CHECK_NEW_VERSION,

    C_RELATE_HOME_CENTER,

    // in service "00000045-0000-1000-8000-0026BB765291", lock mechanism
    C_LOCK_CURRENT_STATE,
    C_LOCK_TARGET_STATE,

    C_UNKNOWN,
} CharacteristicType;

@interface HMCharacteristic (Properties)

- (CharacteristicType) type;

- (int) typeInt;

- (BOOL) supportNotification;

@end

NS_ASSUME_NONNULL_END
