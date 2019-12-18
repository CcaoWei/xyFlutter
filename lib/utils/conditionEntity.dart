part of publish_fun;

class ConditionEntity {
  static Entity conditionEntity(protobuf.Condition c) {
    if (c == null) return null;
    //获得条件里面设备的logicdevice
    var uuid = null;
    if (c.hasKeypress()) {
      uuid = c.keypress.uUID;
    } else if (c.hasLongPress()) {
      uuid = c.longPress.uUID;
    } else if (c.hasAttributeVariation()) {
      uuid = c.attributeVariation.uUID;
    } else if (c.hasSequenced()) {
      uuid = c.sequenced.conditions[COND_COUNT].innerCondition
          .attributeVariation.uUID;
    } else if (c.hasAttributeVariation()) {
      uuid = c.attributeVariation.uUID;
    } else if (c.hasAngular()) {
      uuid = c.angular.uUID;
    } else if (c.hasComposed()) {
      if (c.composed.conditions[COND_COUNT].hasAngular()) {
        uuid = c.composed.conditions[COND_COUNT].angular.uUID;
      } else if (c.composed.conditions[COND_COUNT].hasAttributeVariation()) {
        uuid = c.composed.conditions[COND_COUNT].attributeVariation.uUID;
      }
    }
    if (uuid == null) return null;
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    for (var phyd in cache.addedDevices) {
      for (var logd in phyd.logicDevices) {
        if (logd.uuid == uuid) {
          return logd;
        }
      }
    }
    return null;
  }

  static int getDeviceType(Entity entity) {
    if (entity is PhysicDevice) {
      if (entity.isWallSwitch) return IMAGE_WALL_SWITCH;
      if (entity.isWallSwitchUS) return IMAGE_WALL_SWITCH;
      if (entity.isSwitchModule) return IMAGE_SWITCH_MODULE;
    } else if (entity is LogicDevice) {
      if (entity.parent.isSwitchModule) return IMAGE_SWITCH_MODULE;
      if (entity.isOnOffLight) return IMAGE_LIGHT;
      if (entity.isSmartPlug) return IMAGE_PLUG;
      if (entity.isAwarenessSwitch) return IMAGE_AWARENESS_SWITCH;
      if (entity.isDoorContact) return IMAGE_DOOR_SENSOR;
      if (entity.isCurtain) return IMAGE_CURTAIN;
      if (entity.isSmartDial) return IMAGE_SMART_DIAL;
      if (entity.isWallSwitchButton) return IMAGE_WALL_SWITCH;
    } else if (entity is Scene) {
      return IMAGE_SCENE;
    }
    return IMAGE_UNKNOWN;
  }
}
