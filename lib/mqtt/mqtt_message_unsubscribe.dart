part of mqtt_shared;

class MqttMessageUnsubscribe extends MqttMessage {
  String _topic;
  num _messageID;

  MqttMessageUnsubscribe.setOptions(String topic, num messageID)
        : this._topic = topic,
          this._messageID = messageID,
          super.setOptions(UNSUBSCRIBE, 4 + topic.length, QOS_1);

  encodeVariableHeader() {
    _buf.add(_messageID ~/ 256);
    _buf.add(_messageID % 256);
  }

  encodePayload() {
    _buf.add(_topic.length ~/ 256);
    _buf.add(_topic.length % 256);
    _buf.addAll(utf8.encode(_topic));
  }
}