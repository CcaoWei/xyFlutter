part of mqtt_shared;

//默认值改为45
final num KEEPALIVE = 45;

/**
 * mqttMessage
 * This abstract class describes an mqttMessage
 * It will be extended for each specifiic mqtt message (CONNECT, PUBLISH ...)
 */
abstract class MqttMessage {
  List<int> _buf;
  List<int> get buf => _buf;

  List<int> _protobufPayload;
  List<int> get protobufPayload => _protobufPayload;

  int type;
  num len;
  int QoS;
  int DUP;
  int retain;

  /**
   * default constructor
   */
  MqttMessage(this.type, [this.len = 0]) : QoS = QOS_0, DUP = 0, retain = 0 {
    _buf = new List<int>();
  }

  /**
   * setOptions constructor
   * Set the message options
   */
  MqttMessage.setOptions(this.type, this.len, [this.QoS = 0, this.retain = 0]) : DUP = 0 {
    _buf = new List<int>();
  }

  MqttMessage.setProtobufOptions(this.type, this._protobufPayload, this.len, [this.QoS = 0, this.retain = 0]) : DUP = 0 {
    _buf = new List<int>();
    len = 0;
    len += _protobufPayload.length;
    if (QoS > 0) {
      len += 2;
    }
    len += (2 + utf8.encode(getTopic()).length);
    if (len <= 128) {
      len += 2;
    } else if (len <= 128 + 128 * 128) {
      len += 3;
    } else {
      len += 4;
    }
  }

  /**
   * decode constructor
   * Decode data to initialize the mqtt message
   * 
   * a message is made of
   *   - a fixed header
   *   - a variable header (message specific)
   *   - a payload (message specific)
   */
  MqttMessage.decode(List<int> data, [bool debugMessage = false]) {
    num numOfLengthByte = decodeFixedHeader(data);
    num vhLen = decodeVariableHeader(data.sublist(numOfLengthByte + 1), numOfLengthByte + 1);
    if (data.length > numOfLengthByte + 1 + vhLen) {
      //使用protobuf代替json
      //decodePayload(data.sublist(numOfLengthByte + 1 + vhLen));
      decodeProtobufPayload(data.sublist(numOfLengthByte + 1 + vhLen));
    }
    if (debugMessage) {
      print('<<< ${this.toString()}');
    }
  }

  String toString() {
    String bufString = '';
    if (_buf != null) {
      _buf.forEach((b) => bufString = bufString + b.toString());
    }
    if (_protobufPayload != null) {
      _protobufPayload.forEach((b) => bufString = bufString + b.toString());
    }
    return 'Type(${type}) Len(${len}) Qos(${QoS}) DUP(${DUP}) retain(${retain}) <${bufString}>]';
  }

  /**
   * operator ==
   */
  bool operator == (Object other) {
    return (other is MqttMessage
          && type == other.type
          && len == other.len
          && QoS == other.QoS
          && DUP == other.DUP
          && retain == other.retain
    );
  }

  /**
   * encode
   * encode a mqtt message
   * a message is made of 
   *   - a fixed header
   *   - a variable header (message specific)
   *   - a payload (message specific)
   */
  encode() {
    encodeFixedHeader();
    encodeVariableHeader();
    encodePayload();
  }

  encodeProtobuf() {
    encodeFixedHeader();
    encodeVariableHeader();
    encodeProtobufPayload();
  }

  /**
   * encodeFixedHeader
   * Build the 2 bytes mqtt Fixed header
   * Byte 1:
   *   bit 7 - 4 : Message type
   *   bit 3     : DUP flag
   *   bit 2 - 2 : Qos level
   *   bit 0     : RETAIN
   * 
   * Byte 2 : Remaining length (表示剩余长度的可能会有第3、4、5个字节)
   */
  encodeFixedHeader() {
    _buf.add(((type << 4) | (DUP << 3) | (QoS << 1) | retain)); // byte 1
    // byte 2 - encode remaining length
    if (len > 2) {
      //FIXME: 此处-2不对 需要修改
      num remainLength;
      if (len <= 2 + 128) {
        remainLength = len - 2;
      } else if (len <= 3 + 128 + 128 * 128) {
        remainLength = len - 3;
      } else {
        remainLength = len - 4;
      }
      int digit;
      do {
        digit = remainLength % 128;
        remainLength = remainLength ~/ 128;
        if (remainLength > 0) {
          digit = (digit | 0x80);
        }
        _buf.add(digit);
      } while (remainLength > 0);
    } else {
      _buf.add(0);
    }
  }

  int fixHeaderLength() {
    int remainLength = 0;
    remainLength += _protobufPayload.length;
    if (QoS > 0) {
      remainLength += 2;
    }
    remainLength += 2 + utf8.encode(getTopic()).length;
    if (remainLength <= 128) {
      return 2;
    } else if (remainLength < 128 + 128 * 128) {
      return 3;
    } else {
      return 4;
    }
  }

  String getTopic() {
    return '';
  }

  /**
   * encodeVariableHeader
   * Message specific - to be defined in extende classes
   */
  encodeVariableHeader() {}

  /**
   * encodePayload
   * Message specific (Optional) - to be defined in extened classes
   */
  encodePayload() {}

  encodeProtobufPayload() {}

  /**
   * decodeFixedHeader
   * Decode mqtt fixed fixed header
   * Byte 1 :
   *   bit 7 - 4 : Message type
   *   bit 3     : DUP flag
   *   bit 2 - 1 : Qos Level
   *   bit 0     : RETAIN
   * 
   * Byte 2 : Remaining length (可能还有3个字节)
   * 
   * retuen the number of byte of fixed header
   */
  num decodeFixedHeader(data) {
    type = data[0] >> 4;
    DUP = data[0] & 0x1000;
    QoS = (data[0] >> 1) & QOS_ALL;
    retain = data[0] & 0x01;

    num pos = 1;
    int digit;
    num remLength = 0;
    num multiplier = 1;
    num numberOfLengthByte = 0;

    // remaining length
    do {
      digit = data[pos++];
      numberOfLengthByte++;
      remLength += ((digit & 127) * multiplier);
      multiplier *= 128;
    } while ((digit & 0x80) != 0);

    len = remLength + numberOfLengthByte + 1;

    return numberOfLengthByte;
  }

  /**
   * decodeVariableHeader
   * Message specific - to be defined in extended classed
   * 
   * Return the length of the variable header
   */
  num decodeVariableHeader(List<int> data, num numOfFixedHeaderLength) {
    return 0;
  }

  /**
   * decodePayload
   * Message specific (Optional) - to be defined in extened classes
   */
  decodePayload(List<int> data) {}

  decodeProtobufPayload(List<int> data) {}
}
