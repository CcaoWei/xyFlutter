part of publish_fun;

class GetExecutionName {
  static String getExecutionName(
      BuildContext context, protobuf.Execution execution, Entity entity) {
    if (entity == null || entity is Scene) {
      return "";
    }
    var room =
        HomeCenterManager().defaultHomeCenterCache.findEntity(entity.roomUuid);

    var roomname;
    if (room == null) {
      roomname = DefinedLocalizations.of(context).roomDefault;
    } else {
      roomname = HomeCenterManager()
          .defaultHomeCenterCache
          .findEntity(entity.roomUuid)
          .name;
      if (roomname == "" || roomname == null) {
        roomname = DefinedLocalizations.of(context).roomDefault;
      }
    }

    if (entity != null) {
      return roomname + "的" + entity.getName();
    }
    return "";
  }
}
