part of data_shared;

class ZigbeeSystem extends Entity {
  bool available;
  int panId;
  int channel;
  int version;

  ZigbeeSystem(
      {@required String uuid,
      String name,
      this.available,
      this.panId,
      this.channel,
      this.version})
      : super.initZigbeeSystem(
          uuid: uuid,
          name: name,
        );
}
