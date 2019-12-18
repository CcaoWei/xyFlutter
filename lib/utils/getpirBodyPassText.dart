part of publish_fun;

class GetPirBodyPassText {
  static String getpirBodyPassText(
      BuildContext context, Entity entity, protobuf.Condition condition) {
    if (condition
            .sequenced.conditions[0].innerCondition.attributeVariation.attrID ==
        pbConst.AttributeID.AttrIDOccupancyRight) {
      return entity.name +
          (DefinedLocalizations.of(context).directionRightToLeft +
                  DefinedLocalizations.of(context).hasPeopleAction)
              .toLowerCase();
    } else {
      return entity.name +
          (DefinedLocalizations.of(context).directionLeftToRight +
                  DefinedLocalizations.of(context).hasPeopleAction)
              .toLowerCase();
    }
  }
}
