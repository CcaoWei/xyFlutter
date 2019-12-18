part of publish_fun;

class AttributeVariationText {
  static String attributeVariationText(
      BuildContext context, protobuf.Condition cond) {
    int attrValue = cond.attributeVariation.attrID.value;
    int sourceBegin = cond.attributeVariation.sourceRange.begin;
    int targetBegin = cond.attributeVariation.targetRange.begin;
    var targetEnd = cond.attributeVariation.targetRange.end;
    Int64 keepms = cond.attributeVariation.keepTimeMS;
    if (attrValue == ATTRIBUTE_ID_OCCUPANCY_LEFT ||
        attrValue == ATTRIBUTE_ID_OCCUPANCY_RIGHT) {
      if (sourceBegin > targetBegin) {
        return DefinedLocalizations.of(context).forNoOne +
            GetTimeStr.getTimeStr(context, keepms);
      } else {
        return DefinedLocalizations.of(context).forSomeone +
            GetTimeStr.getTimeStr(context, keepms);
      }
    } else if (attrValue == ATTRIBUTE_ID_ON_OFF_STATUS) {
      if (targetBegin == 1) {
        return DefinedLocalizations.of(context).openAndHold +
            GetTimeStr.getTimeStr(context, keepms);
      } else {
        return DefinedLocalizations.of(context).closeAndHold +
            GetTimeStr.getTimeStr(context, keepms);
      }
    } else if (attrValue == ATTRIBUTE_ID_TOTLE_POWER) {
      int end = cond.attributeVariation.targetRange.end ~/ 10;
      int begin = cond.attributeVariation.targetRange.begin ~/ 10;
      SectionText.sectionText(context, begin, end, "W");
    } else if (attrValue == ATTRIBUTE_ID_ACTIVE_POWER) {
    } else if (attrValue == ATTRIBUTE_ID_INSERT_EXTRACT_STATUS) {
    } else if (attrValue == ATTRIBUTE_ID_OCCUPANCY) {
    } else if (attrValue == ATTRIBUTE_ID_LUMINANCE) {
      return DefinedLocalizations.of(context).illuminance +
          SectionText.sectionText(context, targetBegin, targetEnd, "Lux") +
          DefinedLocalizations.of(context).hold +
          GetTimeStr.getTimeStr(context, keepms);
    } else if (attrValue == ATTRIBUTE_ID_TEMPERATURE) {
      int end = cond.attributeVariation.targetRange.end ~/ 10;
      int begin = cond.attributeVariation.targetRange.begin ~/ 10;
      return DefinedLocalizations.of(context).temperature +
          SectionText.sectionText(context, begin, end, "°C") +
          DefinedLocalizations.of(context).hold +
          GetTimeStr.getTimeStr(context, keepms);
    } else if (attrValue == ATTRIBUTE_ID_BINARY_INPUT_STATUS) {
      if (targetBegin == 1) {
        return DefinedLocalizations.of(context).continuedAlarmStatus +
            GetTimeStr.getTimeStr(context, keepms);
      } else {
        return DefinedLocalizations.of(context).securityStatusContinues +
            GetTimeStr.getTimeStr(context, keepms);
      }
    } else if (attrValue == ATTRIBUTE_ID_BATTERY_PERCENT) {
    } else if (attrValue == ATTRIBUTE_ID_FIRMWARE_VERSION) {
    } else if (attrValue == ATTRIBUTE_ID_PERMIT_JOIN) {
    } else if (attrValue == ATTRIBUTE_ID_CURTAIN_DIRECTION) {
      return DefinedLocalizations.of(context).exerciseState;
    } else if (attrValue == ATTRIBUTE_ID_CURTAIN_TARGET_POSITION) {
    } else if (attrValue == ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION) {
      return "开合" +
          SectionText.sectionText(context, targetBegin, targetEnd, "%") +
          DefinedLocalizations.of(context).hold +
          GetTimeStr.getTimeStr(context, keepms);
    } else if (attrValue == ATTRIBUTE_ID_SUPPORT_OTA) {
    } else if (attrValue == ATTRIBUTE_ID_ALERT_LEVEL) {
    } else if (attrValue == ATTRIBUTE_ID_CURTAIN_STATUS) {
      if (targetBegin == 1 && targetEnd == 1) {
        return DefinedLocalizations.of(context).opening +
            DefinedLocalizations.of(context).hold +
            GetTimeStr.getTimeStr(context, keepms);
      } else if (targetBegin == 2 && targetEnd == 2) {
        return DefinedLocalizations.of(context).closing +
            DefinedLocalizations.of(context).hold +
            GetTimeStr.getTimeStr(context, keepms);
      }
      // return "运动状态在"+sectionText(targetBegin,targetEnd,"%")+"并持续"+GetTimeStr.getTimeStr(context,keepms);
    } else if (attrValue == ATTRIBUTE_ID_CURTAIN_TRIP_CONFIGURED) {
    } else if (attrValue == ATTRIBUTE_ID_CURTAIN_TYPE) {
    } else if (attrValue == ATTRIBUTE_ID_CURTAIN_TRIP_ADJUSTING) {
    } else if (attrValue == ATTRIBUTE_ID_ENTITY_IS_NEW) {
    } else if (attrValue == ATTRIBUTE_ID_JOINED_TIME) {
    } else if (attrValue == ATTRIBUTE_ID_CONNECTED_TIME) {
    } else if (attrValue == ATTRIBUTE_ID_CONFIG_INDICATOR_LED) {
    } else if (attrValue == ATTRIBUTE_ID_CONFIG_DISABLE_RELAY) {
    } else if (attrValue == ATTRIBUTE_ID_BUTTON_BINDING_TYPE) {
    } else if (attrValue == ATTRIBUTE_ID_LED_LUMNANCE_THRESHOLD) {
    } else if (attrValue == ATTRIBUTE_ID_FIRMWARE_UPGRADING_VERSION) {
    } else if (attrValue == ATTRIBUTE_ID_FIRMWARE_UPGRADING_PERCENT) {
    } else if (attrValue == ATTRIBUTE_ID_ENABLE_KEEP_ON_OFF_STATUS) {
    } else if (attrValue == ATTRIBUTE_ID_FIRMWARE_RECOMMAND_VERSION) {
    } else if (attrValue == ATTRIBUTE_ID_LAST_KNOB_ANGLE) {
    } else if (attrValue == ATTRIBUTE_ID_LAST_KNOB_USED_MS) {
    } else if (attrValue == ATTRIBUTE_ID_AUTO_ENABLED) {
    } else if (attrValue == ATTRIBUTE_ID_AUTO_RENDER_TYPE) {
    } else if (attrValue == ATTRIBUTE_ID_AUTO_SET_ID) {
    } else if (attrValue == ATTRIBUTE_ID_CFG_SW_PURE_INPUT) {
    } else if (attrValue == ATTRIBUTE_ID_CFG_SW_INPUT_MODE) {
    } else if (attrValue == ATTRIBUTE_ID_CFG_SW_POLARITY) {
    } else if (attrValue == ATTRIBUTE_ID_CFG_BUTTON_LED_STATUS) {
    } else if (attrValue == ATTRIBUTE_ID_AUTO_VERSION) {
    } else if (attrValue == ATTRIBUTE_ID_LC_TARGET_LEVEL) {
    } else if (attrValue == ATTRIBUTE_ID_LC_CURRENT_LEVEL) {
    } else if (attrValue == ATTRIBUTE_ID_DISABLE_RELAY_STATUS) {
    } else if (attrValue == ATTRIBUTE_ID_NumOfTimeoutControls) {
    } else if (attrValue == ATTRIBUTE_ID_ZHH_IS_ONLINE) {
    } else if (attrValue == ATTRIBUTE_ID_ZHH_IS_RUNNING) {
    } else if (attrValue == ATTRIBUTE_ID_AC_TARGET_TEMPERATURE) {
    } else if (attrValue == ATTRIBUTE_ID_AC_CURRENT_TEMPERATURE) {
    } else if (attrValue == ATTRIBUTE_ID_AC_FAN_SPEED) {
    } else if (attrValue == ATTRIBUTE_ID_AC_WORK_MODE) {
    } else if (attrValue == ATTRIBUTE_ID_ZHH_ERROR_CODE) {
    } else if (attrValue == ATTRIBUTE_ID_CFG_MUTEXED_INDEX) {
    } else if (attrValue == ATTRIBUTE_ID_CFG_MUTEXED_DELAYMS) {
    } else if (attrValue == ATTRIBUTE_ID_CFG_BUTTON_LED_POLARITY) {
    } else if (attrValue == ATTRIBUTE_ID_CFG_LOOP_HAS_RELAY) {
    } else if (attrValue == ATTRIBUTE_ID_CFG_SELF_BINDING_ID) {
    } else if (attrValue == ATTRIBUTE_ID_AUTOSET_CLASS) {
    } else if (attrValue == ATTRIBUTE_ID_WINDOW_COVERING_MOTOR_TYPE) {
    } else if (attrValue == ATTRIBUTE_ID_COLOR_TEMPERATURE) {
    } else if (attrValue == ATTRIBUTE_ID_COLOR_CURRENT_X) {
    } else if (attrValue == ATTRIBUTE_ID_COLOR_CURRENT_Y) {
    } else if (attrValue == ATTRIBUTE_ID_COLOR_CIE_YXY) {}
    return " ";
  }
}
