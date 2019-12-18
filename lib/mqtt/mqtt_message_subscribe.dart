part of mqtt_shared;

class MqttMessageSubscribe extends MqttMessage {
  String _topic;
  num _messageID;

  MqttMessageSubscribe.setOptions(String topic, num messageID, int Qos)
        : this._topic = topic,
          this._messageID = messageID,
          super.setOptions(SUBSCRIBE, 7 + topic.length, Qos);
  
  encodeVariableHeader() {
    _buf.add(_messageID ~/ 256);
    _buf.add(_messageID % 256);
  }

  encodePayload() {
    _buf.add(_topic.length ~/ 256);
    _buf.add(_topic.length % 256);

    _buf.addAll(utf8.encode(_topic));

    _buf.add(QoS);
  }
}