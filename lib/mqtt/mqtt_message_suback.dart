part of mqtt_shared;

class MqttMessageSuback extends MqttMessageAssured {
  num messageID;
  int grantedQoS;

  MqttMessageSuback()
        : messageID = 0,
          grantedQoS = 0,
          super(SUBACK);

  MqttMessageSuback.decode(List<int> data, [bool debugMessage = false])
        : messageID = 0,
          grantedQoS = 0,
          super.decode(data, debugMessage);

  num decodeVariableHeader(List<int> data, num numOfFixedHeaderLength) {
    messageID = 256 * data[0] + data[1];
    return 2;
  }

  decodePayload(List<int> data) {
    grantedQoS = (data[0] & QOS_ALL);
    print('[Suback] Granted QOS level: $grantedQoS');
  }       
}