part of mqtt_shared;

/**
 * mqttWill
 * Define mqttWill
 */
class MqttWill {
  String topic;
  String payload;
  int qos;
  int retain;

  MqttWill(this.topic, this.payload, this.qos, this.retain);
}

/**
 * mqttMessageConnect
 * MQTT CONNECT message
 */
class MqttMessageConnect extends MqttMessage {
  int _cleanSession = 0;
  String _clientID;
  MqttWill _will = null;
  String _username = null;
  String _password = null;

  MqttMessageConnect.setOptions(String clientID, int qos, bool cleanSession)
        : this._clientID = clientID,
          this._cleanSession = (cleanSession ? 1 : 0),
          super.setOptions(CONNECT, 16 + clientID.length, qos); //?? 16 + clientID

  /**
   * setWill
   * Set will for the connection 
   * Must be called before connecting to mqtt broker
   */
  void setWill(MqttWill w) {
    if (w != null) {
      _will = w;
      len += 4 + utf8.encode(_will.topic).length + utf8.encode(_will.payload).length;
    }
  }

  /**
   * setUsername
   */
  void setUsername(String userName) {
    if (userName != null) {
      _username = userName;
      len += 2 + utf8.encode(_username).length;
    }
  }

  /**
   * setUserName and Password
   */
  void setUserNameAndPassword(String userName, String password) {
    setUsername(userName);

    if (password != null) {
      _password = password;
      len += 2 + utf8.encode(_password).length;
    }
  }

  /**
   * buildVariableHeader for CONNECT message
   * 
   * byte 1 - Length MSB (0)
   * byte 2 - Length LSB (6)
   * byte 3 - 'M'
   * byte 4 - 'Q'
   * byte 5 - 'I'
   * byte 6 - 's'
   * byte 7 - 'd'
   * byte 8 - 'p'
   * byte 9 - Protocol version
   * byte 10 - Connect flags
   *   bit 0 - reserved
   *   bit 1 - clean session 
   *   bit 2 - will flag
   *   bit 3 - will QoS
   *   bit 4 - will retain
   *   bit 5 - password flag
   *   bit 6 - username flag
   * byte 11 - keep alive MSB
   * byte 12 - keep alive LSB
   */
  encodeVariableHeader() {
    _buf.add(0x00); // length MSB
    _buf.add(0x06); // length LSB

    _buf.addAll(MQTT_VERSION_IDENTIFIER); // protocol name
    _buf.add(MQTT_VERSION); // protocol version

    //CONNECT flag
    int connectFlag = 0x00;

    //clean flag
    connectFlag |= (_cleanSession << 1);

    //will flag
    if (_will != null) {
      connectFlag |= (0x04 | (_will.qos << 3) | (_will.retain << 5));
    }

    // user / password flag
    int userFlag = (_username != null) ? 1 : 0;
    int passwordFlag = (_password != null) ? 1 : 0;
    connectFlag |= (userFlag << 6) | (passwordFlag << 7);

    _buf.add(connectFlag);

    //keep alive timer
    _buf.add(0x00);
    _buf.add(KEEPALIVE);
  }

  /**
   * encodePayload
   * encode payload for CONNECT message
   * It consists of:
   *   - Client Identifier
   *   - Will Topic
   *   - Will Message
   *   - Username
   *   - Password
   */
  encodePayload() {
    //num payloadLen = len - 14;
    
    // client identifier
    _buf.add(utf8.encode(_clientID).length ~/ 256);
    _buf.add(utf8.encode(_clientID).length % 256);
    _buf.addAll(utf8.encode(_clientID));

    if (_will != null) {
      _buf.add(utf8.encode(_will.topic).length ~/ 256);
      _buf.add(utf8.encode(_will.topic).length % 256);
      _buf.addAll(utf8.encode(_will.topic));
    
      _buf.add(utf8.encode(_will.payload).length ~/ 256);
      _buf.add(utf8.encode(_will.payload).length % 256);
      _buf.addAll(utf8.encode(_will.payload));
    }

    if (_username != null) {
      _buf.add(utf8.encode(_username).length ~/ 256);
      _buf.add(utf8.encode(_username).length % 256);
      _buf.addAll(utf8.encode(_username));
    }

    if (_password != null) {
      _buf.add(utf8.encode(_password).length ~/ 256);
      _buf.add(utf8.encode(_password).length % 256);
      _buf.addAll(utf8.encode(_password));
    }
  }
}
