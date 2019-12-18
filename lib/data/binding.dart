part of data_shared;

class Binding extends Entity {
  int bindingType;
  bool enabled;
  String triggerAddress;
  List<xyAction> actions;
  int parameter;

  Binding(
      {@required String uuid,
      @required this.bindingType,
      @required this.triggerAddress,
      this.enabled,
      this.parameter})
      : super.initBinding(uuid: uuid);

  bool get isCurtainBinding {
    if (actions == null || actions.length == 0) return false;
    final xyAction action = actions[0];
    return action.attrId == ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION;
  }
}
