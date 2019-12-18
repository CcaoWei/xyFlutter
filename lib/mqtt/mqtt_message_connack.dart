part of mqtt_shared;

class MqttMessageConnack extends MqttMessage {
  String connAckStatus = 'unknown';
  num returnCode;

  MqttMessageConnack.decode(List<int> data, [bool debugMessage = false])
      : super.decode(data, debugMessage);

  num decodeVariableHeader(List<int> data, num numOfFixedHeaderLength) {
    assert(data.length == 2);
    returnCode = data[1];
    connAckStatus = MqttConnackRC.decodeConnackRC(data[1]);
    return 2;
  }
}