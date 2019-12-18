//
//  EventType.h
//  Runner
//
//  Created by litao on 2018/11/26.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern int const HOME_MANAGER_DID_UPDATE_HOMES;
extern int const HOME_MANAGER_DID_UPDATE_PRIMARY_HOME;
extern int const HOME_MANAGER_DID_ADD_HOME;
extern int const HOME_MANAEGR_DID_REMOVE_HOME;

extern int const HOME_DID_UPDATE_NAME;
extern int const HOME_DID_UPDATE_ACCESSORY_CONTROL_FOR_CURRENT_USER;
extern int const HOME_DID_ADD_ACCESSORY;
extern int const HOME_DID_REMOVE_ACCESORY;
extern int const HOME_DID_ADD_USER;
extern int const HOME_DID_REMOVE_USER;
extern int const HOME_DID_UPDATE_ROOM_FOR_ACCESSORY;
extern int const HOME_DID_ADD_ROOM;
extern int const HOME_DID_REMOVE_ROOM;
extern int const HOME_DID_UPDATE_NAME_FOR_ROOM;
extern int const HOME_DID_ADD_ZONE;
extern int const HOME_DID_REMOVE_ZONE;
extern int const HOME_DID_UPDATE_NAME_FOR_ZONE;
extern int const HOME_DID_ADD_ROOM_TO_ZONE;
extern int const HOME_DID_REMOVE_ROOM_FROM_ZONE;
extern int const HOME_DID_ADD_SERVICE_GROUP;
extern int const HOME_DID_REMOVE_SERVICE_GROUP;
extern int const HOME_DID_UPDATE_NAME_FOR_SERVICE_GROUP;
extern int const HOME_DID_ADD_SERVICE_TO_SERVICE_GROUP;
extern int const HOME_DID_REMOVE_SERVICE_FROM_SERVICE_GROUP;
extern int const HOME_DID_ADD_ACTION_SET;
extern int const HOME_DID_REMOVE_ACTION_SET;
extern int const HOME_DID_UPDATE_NAME_FOR_ACTION_SET;
extern int const HOME_DID_UPDATE_ACTIONS_FOR_ACTION_SET;
extern int const HOME_DID_ADD_TRIGGER;
extern int const HOME_DID_REMOVE_TRIGGER;
extern int const HOME_DID_UPDATE_NAME_FOR_TRIGGER;
extern int const HOME_DID_UPDATE_TRIGGER;
extern int const HOME_DID_UNBLOCK_ACCESSORY;
extern int const HOME_DID_ENCOUNTER_ERROR_FOR_ACCESSORY;
extern int const HOME_DID_UPDATE_HOME_HUB_STATE;

extern int const ACCESSORY_DID_UPDATE_NAME;
extern int const ACCESSORY_DID_UPDATE_NAME_FOR_SERVICE;
extern int const ACCESSORY_DID_UPDATE_ASSOCIATED_SERVICE_TYPE_FOR_SERVICE;
extern int const ACCESSORY_DID_UPDATE_SERVICES;
extern int const ACCESSORY_DID_ADD_PROFILE;
extern int const ACCESSORY_DID_REMOVE_PROFILE;
extern int const ACCESSORY_DID_UPDATE_REACHABILITY;
extern int const ACCESSORY_SERVICE_DID_UPDATE_VALUE_FOR_CHARACTERISTIC;
extern int const ACCESSORY_DID_UPDATE_FIRMWARE_VERSION;

extern int const ACCESSORY_AVAILABLE_STATUS_CHANGED;
extern int const ACCESSORY_UPDATING_STATUS_CHANGED;
extern int const CHARACTERISTIC_VALUE_CHANGED;
extern int const ADD_ACTION_RESPONSE;
extern int const REMOVE_ACTION_RESPONSE;
extern int const UPDATE_ACTION_RESPONSE;

extern int const LOCAL_SERVICE_DID_FOUND;
extern int const LOCAL_SERVICE_DID_LOST;

extern int const NO_ACCESS_TO_CAMERA;

@interface EventType : NSObject

@end

NS_ASSUME_NONNULL_END
