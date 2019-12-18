part of publish_fun;

class GetConditionName {
  static String getConditionName(
      BuildContext context, Entity entity, protobuf.Condition condition) {
    var conditionText = " ";
    if (entity is PhysicDevice) {
    } else if (entity is LogicDevice) {
      if (condition.hasKeypress()) {
        if (condition.keypress.pressedTimes == 1) {
          conditionText = DefinedLocalizations.of(context).autoClick;
        } else {
          conditionText = DefinedLocalizations.of(context).autoDblclick;
        }
      } else if (condition.hasLongPress()) {
        conditionText = DefinedLocalizations.of(context).longPress;
      } else if (condition.hasAttributeVariation()) {
        if (condition.attributeVariation.attrID.value ==
            ATTRIBUTE_ID_OCCUPANCY_LEFT) {
          conditionText = DefinedLocalizations.of(context).motionDetectedLeft;
        } else if (condition.attributeVariation.attrID.value ==
            ATTRIBUTE_ID_OCCUPANCY_RIGHT) {
          conditionText = DefinedLocalizations.of(context).motionDetectedRight;
        } else if (condition.attributeVariation.attrID.value ==
            ATTRIBUTE_ID_ON_OFF_STATUS) {
          conditionText = DefinedLocalizations.of(context).powerState;
        } else if (condition.attributeVariation.attrID.value ==
            ATTRIBUTE_ID_TOTLE_POWER) {
          conditionText = DefinedLocalizations.of(context).totalPower;
        } else if (condition.attributeVariation.attrID.value ==
            ATTRIBUTE_ID_ACTIVE_POWER) {
          conditionText = DefinedLocalizations.of(context).immediatelyPower;
        } else if (condition.attributeVariation.attrID.value ==
            ATTRIBUTE_ID_LUMINANCE) {
          conditionText = DefinedLocalizations.of(context).illuminance;
        } else if (condition.attributeVariation.attrID.value ==
            ATTRIBUTE_ID_TEMPERATURE) {
          conditionText = DefinedLocalizations.of(context).temperature;
        } else if (condition.attributeVariation.attrID.value ==
            ATTRIBUTE_ID_BINARY_INPUT_STATUS) {
          conditionText = DefinedLocalizations.of(context).openingClosingAction;
        } else if (condition.attributeVariation.attrID.value ==
            ATTRIBUTE_ID_CURTAIN_STATUS) {
          conditionText = DefinedLocalizations.of(context).exerciseState;
        } else if (condition.attributeVariation.attrID.value ==
            ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION) {
          conditionText = DefinedLocalizations.of(context).openingClosingAction;
        }
      } else if (condition.hasAngular()) {
        conditionText = DefinedLocalizations.of(context).rotationAngle;
      } else if (condition.hasComposed()) {
        if (entity == null)
          return DefinedLocalizations.of(context).deviceRemoved;
        for (var item in condition.composed.conditions) {
          if (item.hasAngular()) {
            return entity.getName() +
                DefinedLocalizations.of(context).leftOrRight;
          } else if (item.hasAttributeVariation()) {
            return entity.getName() +
                DefinedLocalizations.of(context).exerciseState;
          }
        }
        return DefinedLocalizations.of(context).deviceRemoved;
      } else if (condition.hasSequenced()) {
        if (condition.sequenced.conditions[0].innerCondition.attributeVariation
                .attrID ==
            pbConst.AttributeID.AttrIDOccupancyRight) {
          return entity.name +
              (DefinedLocalizations.of(context).directionRightToLeft +
                      DefinedLocalizations.of(context).hasPeopleAction)
                  .toLowerCase();
        } else if (condition.sequenced.conditions[0].innerCondition
                .attributeVariation.attrID ==
            pbConst.AttributeID.AttrIDOccupancyLeft) {
          return entity.name +
              (DefinedLocalizations.of(context).directionLeftToRight +
                      DefinedLocalizations.of(context).hasPeopleAction)
                  .toLowerCase();
        }
      }
      return entity.getName() + conditionText;
    }
    return DefinedLocalizations.of(context).deviceRemoved;
  }
}
