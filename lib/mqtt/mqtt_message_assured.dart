part of mqtt_shared;

abstract class MqttMessageAssured extends MqttMessage {
  int _msgID_MSB;
  int _msgID_LSB;

  get messageID => (256 * _msgID_MSB + _msgID_LSB);

  int _payloadPos;

  MqttMessageAssured(num type, [this._msgID_MSB = 0, this._msgID_LSB = 0]) : super(type, 4);

  MqttMessageAssured.initWithMessageID(num type, num theMessageID)
        : _msgID_MSB = theMessageID ~/ 256,
          _msgID_LSB = theMessageID % 256,
          super(type);
  
  MqttMessageAssured.decode(List<int> data, [bool debugMessage = false])
        : _msgID_MSB = 0,
          _msgID_LSB = 0,
          _payloadPos = 0,
          super.decode(data, debugMessage);

  num decodeVariableHeader(List<int> data, num numOfFixedHeaderLength) {
    assert(data.length == 2);

    _msgID_MSB = data[0];
    _msgID_LSB = data[1];

    return 2;
  }

  @override
  decodeProtobufPayload(List<int> data) {
    //print('payload length A -> ${data.length}');
    int payloadLen = len - _payloadPos;
    if (payloadLen <= data.length) {
      _protobufPayload = data.sublist(0, payloadLen);
      print('${protobufPayload.length}');
    } else {
      print('WARNING: Payload is truncated - Characters received: ${data.length} - expected: ${payloadLen}');
      _protobufPayload = data;
    }
  }

  encodeVariableHeader() {
    _buf.add(_msgID_MSB);
    _buf.add(_msgID_LSB);
  }
}

  class MqttMessagePuback extends MqttMessageAssured {
    MqttMessagePuback(int msgID_MSB, int msgID_LSB)
          : super(PUBACK, msgID_MSB, msgID_LSB);
    MqttMessagePuback.initWithMessageID(num theMessageID)
          : super.initWithMessageID(PUBACK, theMessageID);
    MqttMessagePuback.initWithPublishMessage(MqttMessagePublish m)
          : super(PUBACK, m._msgID_MSB, m._msgID_LSB);
    MqttMessagePuback.decode(List<int> data, [bool debugMessage = false])
          : super.decode(data, debugMessage);
  }

  class MqttMessagePubrec extends MqttMessageAssured {
    MqttMessagePubrec(int msgID_MSB, int msgID_LSB)
          : super(PUBREC, msgID_MSB, msgID_LSB);
    MqttMessagePubrec.initWithPublishMessage(MqttMessagePublish m)
          : super(PUBREC, m._msgID_MSB, m._msgID_LSB);
    MqttMessagePubrec.decode(List<int> data, [bool debugMessage = false])
          : super.decode(data, debugMessage);
  }

  class MqttMessagePubrel extends MqttMessageAssured {
    MqttMessagePubrel(int msgID_MSB, int msgID_LSB)
          : super(PUBREL, msgID_MSB, msgID_LSB);
    MqttMessagePubrel.initWithPubrecMessage(MqttMessagePubrec m)
          : super(PUBREL, m._msgID_MSB, m._msgID_LSB);
    MqttMessagePubrel.decode(List<int> data, [bool debugMessage = false])
          : super.decode(data, debugMessage);
  }

  class MqttMessagePubcomp extends MqttMessageAssured {
    MqttMessagePubcomp(int msgID_MSB, int msgID_LSB)
          : super(PUBCOMP, msgID_MSB, msgID_LSB);
    MqttMessagePubcomp.initWithPubrelMessage(MqttMessagePubrel m)
          : super(PUBCOMP, m._msgID_MSB, m._msgID_LSB);
    MqttMessagePubcomp.decode(List<int> data, [bool debugMessage])
          : super.decode(data, debugMessage);
  }