part of data_shared;

class Room extends Entity {
  Room({
    @required String uuid,
    @required String name,
    String identifier,
  }) : super.initRoom(
          uuid: uuid,
          name: name,
          identifier: identifier,
        );

  String getRoomName(BuildContext context) {
    if (name == null || name == '') {
      if (uuid == DEFAULT_ROOM)
        return DefinedLocalizations.of(context).roomDefault;
      if (uuid == 'area-0001')
        return DefinedLocalizations.of(context).roomLivingRoom;
      if (uuid == 'area-0002')
        return DefinedLocalizations.of(context).roomMasterBedroom;
      if (uuid == 'area-0003')
        return DefinedLocalizations.of(context).roomGuestBedroom;
      if (uuid == 'area-0004')
        return DefinedLocalizations.of(context).roomDiningRoom;
      if (uuid == 'area-0005')
        return DefinedLocalizations.of(context).roomKitchen;
      if (uuid == 'area-0006')
        return DefinedLocalizations.of(context).roomBalcony;
      if (uuid == 'area-0007')
        return DefinedLocalizations.of(context).roomStudy;
      if (uuid == 'area-0008')
        return DefinedLocalizations.of(context).roomEntrance;
      if (uuid == 'area-0009')
        return DefinedLocalizations.of(context).roomBathroom;
    }
    return getName();
  }
}
