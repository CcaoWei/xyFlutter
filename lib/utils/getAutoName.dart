part of publish_fun;

class GetAutoName {
  static String getAutoName(Automation automation) {
    var condText = "";
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return "";
    if (automation == null) return "";
    if (automation.getConditionCount() <= COND_COUNT) return "";
    protobuf.Condition condition = automation.getConditionAt(COND_COUNT);
    if (condition.hasCalendar()) {
      var times = (condition.calendar.calendarDayTime.hour * 60 * 60 +
              condition.calendar.calendarDayTime.min * 60 +
              condition.calendar.calendarDayTime.sec) *
          1000;
      return GetTimeName.getTimeName(null, times);
    }
    LogicDevice logicDevice = ConditionEntity.conditionEntity(condition);
    if (logicDevice == null) {
      condText = DefinedLocalizations.of(null).cannotFindDevice;
    } else {
      if (condition.hasAngular()) {
        var begin = condition.angular.angleRange.begin;
        var end = condition.angular.angleRange.end;
        if (condition.angular.angleRange.begin < 0) {
          //左旋
          condText = logicDevice.getName() +
              DefinedLocalizations.of(null).sinistrogyrationUntil +
              AngularText.angularText(null, begin, end, "°");
        } else if (condition.angular.angleRange.begin >= 0) {
          //右旋
          condText = logicDevice.getName() +
              DefinedLocalizations.of(null).dextrorotationUntil +
              AngularText.angularText(null, begin, end, "°");
        } else if (condition.angular.angleRange.begin == 0 &&
            condition.angular.angleRange.end == 0) {
          //任意角度
          condText = logicDevice.getName() +
              DefinedLocalizations.of(null).rotationAnyAngle;
        }
        // condText = logicDevice.getName() + ;
      } else if (condition.hasKeypress()) {
        condText = logicDevice.getName() +
            DefinedLocalizations.of(null).clike +
            condition.keypress.pressedTimes.toString() +
            DefinedLocalizations.of(null).selectTime;
      } else if (condition.hasAttributeVariation()) {
        // condText = logicDevice.getName() + attributeVariationText(condition);
      } else if (condition.hasWithinPeriod()) {
      } else if (condition.hasCalendar()) {
      } else if (condition.hasComposed()) {
        if (condition.composed.conditions[0].hasAngular()) {
          var begin = condition.composed.conditions[0].angular.angleRange.begin;
          var end = condition.composed.conditions[0].angular.angleRange.end;
          if (condition.composed.conditions[0].angular.angleRange.begin < 0) {
            //左旋
            condText = logicDevice.getName() +
                DefinedLocalizations.of(null).arbitrarilyRotate +
                AngularText.angularText(null, begin, end, "°");
          } else if (condition
                  .composed.conditions[0].angular.angleRange.begin >=
              0) {
            //右旋
            condText = logicDevice.getName() +
                DefinedLocalizations.of(null).arbitrarilyRotate +
                AngularText.angularText(null, begin, end, "°");
          } else if (condition
                      .composed.conditions[0].angular.angleRange.begin ==
                  0 &&
              condition.composed.conditions[0].angular.angleRange.end == 0) {
            //任意角度
            condText = logicDevice.getName() +
                DefinedLocalizations.of(null).rotationAnyAngle;
          }
        } else if (condition.composed.conditions[0].hasAttributeVariation()) {
          var attrid =
              condition.composed.conditions[0].attributeVariation.attrID;
          if (attrid == ATTRIBUTE_ID_OCCUPANCY_LEFT ||
              attrid == ATTRIBUTE_ID_OCCUPANCY_RIGHT) {
            condText = logicDevice.getName() +
                DefinedLocalizations.of(null).someoneAfter;
          } else {
            condText = logicDevice.getName() +
                DefinedLocalizations.of(null).exerciseState;
          }
        }
      } else if (condition.hasSequenced()) {
        condText =
            logicDevice.getName() + DefinedLocalizations.of(null).someoneAfter;
      } else if (condition.hasLongPress()) {
        condText = logicDevice.getName() +
            DefinedLocalizations.of(null).longPress +
            condition.longPress.pressedSeconds.toString() +
            DefinedLocalizations.of(null).second;
      }
    }
    return condText;
  }
}
