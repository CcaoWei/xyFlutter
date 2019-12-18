part of mqtt_shared;

/**
 * MqttMessagePublish
 * MQTT PUBLISH message
 */
class MqttMessagePublish extends MqttMessage {
  int _msgID_MSB;
  int _msgID_LSB;
  get messageID => (256 * _msgID_MSB + _msgID_LSB);

  String _topic;
  String _payload;

  int _payloadPos;

  //Constructors
  MqttMessagePublish.setOptions(String topic, String payload, [num msgID = 1, int QoS = 0, int retain = 0])
      : this._topic = topic,
        this._payload = payload,
        this._msgID_MSB = ((QoS > 0) ? (msgID ~/ 256) : 0),
        this._msgID_LSB = ((QoS > 0) ? (msgID % 256) : 0),
        super.setOptions(PUBLISH, (QoS > 0) ? (2 + 2 + 2 + utf8.encode(topic).length + utf8.encode(payload).length) 
                                            : (2 + 2 + utf8.encode(topic).length + utf8.encode(payload).length),
                        QoS, retain);
  
  MqttMessagePublish.setProtobufOptions(String topic, List<int> payload, [num msgID = 1, int QoS = 0, int retain = 0])
      : this._topic = topic,
        this._msgID_MSB = ((QoS > 0) ? (msgID ~/ 256) : 0),
        this._msgID_LSB = ((QoS > 0) ? (msgID % 256) : 0),
        super.setProtobufOptions(PUBLISH, payload, (QoS > 0) ? (6 + utf8.encode(topic).length + payload.length) 
                                                             : (4 + utf8.encode(topic).length + payload.length), //len会重新计算
                               QoS, retain);

  
  MqttMessagePublish.decode(List<int> data, [bool debugMessage = false]) 
      : _msgID_MSB = 0, 
        _msgID_LSB = 0, 
        _payload = '', 
        _payloadPos = 0, 
        super.decode(data, debugMessage);

  bool operator == (Object other) {
    return (
      other is MqttMessagePublish
      && super == (other)
      && _msgID_MSB == other._msgID_MSB
      && _msgID_LSB == other._msgID_LSB
      && _topic == other._topic
      && _payload == other._payload
    );
  }

  @override
  String getTopic() {
    return _topic;
  }

  /**
   * encodeVariableHeader
   * encode variable header for PUBLISH message
   * 
   * topic name
   * byte 1 : topic length MSB
   * byte 2 : topic length LSB
   * byte 3 -> topic length : topic name
   * 
   * Msg ID
   * byte topic length + 2 : message ID MSB
   * byte topic length + 3 : messgae ID LSB
   */
  encodeVariableHeader() {
    // get topic length MSB and LSB
    //print('topic length 1 -> ${_topic.length}');
    //print('topic length 2 -> ${utf8.encode(_topic).length}');
    //_buf.add(_topic.length ~/ 256);
    //_buf.add(_topic.length % 256);
    _buf.add(utf8.encode(_topic).length ~/ 256);
    _buf.add(utf8.encode(_topic).length % 256);

    // add topic 
    _buf.addAll(utf8.encode(_topic));

    // msg ID - only required for QoS 1 or 2
    if (QoS > 0) {
      _buf.add(_msgID_MSB);
      _buf.add(_msgID_LSB);
    }
  }

  encodePayload() {
    // payload
    _buf.addAll(utf8.encode(_payload));
  }

  encodeProtobufPayload() {
    _buf.addAll(_protobufPayload);
  }

  /**
   * decodeVariableHeader
   * decode PUBLISH variable header
   * 
   * topic name
   * byte 1 : topic length MSB
   * byte 2 : topic length LSB
   * byte 3 -> topic length : topic name
   * 
   * Msg ID
   * byte topic length + 2 : message ID MSB
   * byte topic length + 3 : message ID LSB
   * 
   * return the length of the variable header
   */
  num decodeVariableHeader(List<int> data, num numOfFixedHeaderLength) {
    int pos = 0;
    num topicLength = 256 * data[pos++] + data[pos++];
    _topic = utf8.decode(data.sublist(pos, topicLength + pos));
    pos += topicLength;

    if (QoS > 0) {
      _msgID_MSB = data[pos++];
      _msgID_LSB = data[pos++];
    }

    _payloadPos = numOfFixedHeaderLength + pos;

    return pos;
  }

  decodePayload(List<int> data) {
    int payloadLen = len - _payloadPos;
    if (payloadLen <= data.length) {
      _payload = utf8.decode(data.sublist(0, payloadLen));
      //Event evt = Event.fromBuffer(data);
      //var event = evt.deviceAttrReport;
      //print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      //print('${event.toDebugString()}');
      //print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
    } else {
      print('WARNING: Payload is truncated - Characters received: ${data.length} - expected: ${payloadLen}');
      _payload = utf8.decode(data);
    }
  }

  decodeProtobufPayload(List<int> data) {
    //print('payload length A -> ${data.length}');
    int payloadLen = len - _payloadPos;
    if (payloadLen <= data.length) {
      _protobufPayload = data.sublist(0, payloadLen);
    } else {
      print('WARNING: Payload is truncated - Characters received: ${data.length} - expected: ${payloadLen}');
      _protobufPayload = data;
    }
  }
}