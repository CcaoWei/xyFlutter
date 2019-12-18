part of mqtt_shared;

class MqttMessageUnsuback extends MqttMessageAssured {
  num messageID;

  MqttMessageUnsuback()
        : messageID = 0,
          super(UNSUBACK);
  
  MqttMessageUnsuback.decode(List<int> data, [bool debugMessage = false])
        : messageID = 0,
        super.decode(data, debugMessage);
  
  num decodeVariableHeader(List<int> data, num numOfFixedHeaderLength) {
    assert(data.length == 2);
    messageID = 256 * data[0] + data[1];
    return 2;
  }
}