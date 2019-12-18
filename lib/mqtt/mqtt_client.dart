part of mqtt_shared;

class MqttClient<E extends VirtualMqttConnection> {
  final E _mqttConnection;
  final String _clientID;
  final num _qos;
  final bool _cleanSession;
  Completer _connack;
  Map<String, Function> _onSubscribeDataMap = null;
  var onConnectionLost = null;
  Map<int, Completer> _messagesToCompleteMap;
  final String _username;
  final String _password;

  var _liveTimer;

  bool debugMessage;
  MqttWill _will;

  MqttClient(E mqttConnection, {String clientID: '', num qos: 0, bool cleanSession: true, String username: null, String password: null})
      : _mqttConnection = mqttConnection,
        _clientID = clientID,
        _qos = qos,
        _cleanSession = cleanSession,
        debugMessage = false,
        _will = null,
        _username = username,
        _password = password;
  
  void setWill(String topic, String message, {int qos: QOS_0, bool retain: false}) {
    _will = new MqttWill(topic, message, qos, (retain ? 1 : 0));
  }

  Future<int> connect([onConnectionLostCallback]) {
    print('mqtt client connect');
    _connack = new Completer<int>();
    if (onConnectionLostCallback != null) {
      onConnectionLost = onConnectionLostCallback;
    }
    _mqttConnection
      .connect()
      .then((socket) => _handleConnected(socket))
      .catchError((e) => _mqttConnection.handleConnectError(e));

    return _connack.future;
  }

  void disconnect() {
    print('Disconnecting');
    MqttMessageDisconnect m = new MqttMessageDisconnect();
    _mqttConnection.sendMessageToBroker(m, debugMessage);
    _mqttConnection.close();
  }

  Future subscribe(String topic, int QoS, onSubscribeDataCallback, [num messageID = -1]) {
    print('Subscribe to $topic - QoS: $QoS - Message ID: $messageID');
    if (_onSubscribeDataMap == null) {
      _onSubscribeDataMap = new Map<String, Function>();
    }
    _onSubscribeDataMap[topic] = onSubscribeDataCallback;
    if (messageID == -1) {
      messageID = _onSubscribeDataMap.length;
      print('Subscribe Message ID: $messageID');
    }
    Completer suback = _addMessageToComplete(messageID, QOS_1, new MqttMessageSuback());
    MqttMessageSubscribe m = new MqttMessageSubscribe.setOptions(topic, messageID, QoS);
    _mqttConnection.sendMessageToBroker(m, debugMessage);
    return suback.future;
  }

  Future<MqttMessageUnsuback> unsubscribe(String topic, num messageID) {
    print('Unsubscribe from $topic ($messageID)');
    Completer unsuback = _addMessageToComplete(messageID, QOS_1, new MqttMessageUnsuback());
    MqttMessageUnsubscribe m = new MqttMessageUnsubscribe.setOptions(topic, messageID);
    _mqttConnection.sendMessageToBroker(m, debugMessage);
    return unsuback.future;
  }

  Future publish(String topic, String payload, [num messageID = 1, int QoS = 0, bool retain = false]) {
    int retainFlag = retain ? 1 : 0;
    print('Publish $topic: $payload (ID: $messageID - QoS: $QoS - retain: $retainFlag)');
    Completer puback = _addMessageToComplete(messageID, QoS, new MqttMessagePuback.initWithMessageID(messageID));
    MqttMessagePublish m = new MqttMessagePublish.setOptions(topic, payload, messageID, QoS, retainFlag);
    _mqttConnection.sendMessageToBroker(m, debugMessage);
    return puback.future;
  }

  Future publishProtobuf(String topic, List<int> payload, [num messageID = 1, int QoS = 0, bool retain = false]) {
    int retainFlag = retain ? 1 : 0;
    print('Publish $topic: (ID: $messageID - QoS: $QoS - retain: $retainFlag)');
    Completer puback = _addMessageToComplete(messageID, QoS, new MqttMessagePuback.initWithMessageID(messageID));
    MqttMessagePublish m = new MqttMessagePublish.setProtobufOptions(topic, payload, messageID, QoS, retainFlag);
    _mqttConnection.sendProtobufMessageToBroker(m, debugMessage);
    return puback.future;
  }

  Completer _addMessageToComplete(num messageID, int QoS, MqttMessageAssured m) {
    Completer ack = new Completer();
    if (QoS > 0) {
      if (_messagesToCompleteMap == null) {
        _messagesToCompleteMap = new Map<int, Completer>();
      }
      if (_messagesToCompleteMap.containsKey(messageID)) {
        ack.completeError('Message ID $messageID already in used.');
      } else {
        _messagesToCompleteMap[messageID] = ack;
      }
    } else {
      ack.complete(m);
    }
    return ack;
  }

  void _completeMessage(MqttMessageAssured m, String pubAckType) {
    Completer puback = _messagesToCompleteMap[m.messageID];
    if (puback != null) {
      _messagesToCompleteMap.remove(m.messageID);
      puback.complete(m);
    } else {
      throw('Failed to process ${pubAckType}. Cannot find message to complete for message ID ${m.messageID}');
    }
  }

  void _handleConnected(cnx) {
    _mqttConnection.setConnection(cnx);
    _mqttConnection.startListening(_processData, _handleDone, _handleError);
    _openSession();
  }

  void _openSession() {
    print('Opening session');
    MqttMessageConnect m = new MqttMessageConnect.setOptions(_clientID, _qos, _cleanSession);
    if (_username != null && _password != null) {
      m.setUserNameAndPassword(_username, _password);
    }
    m.setWill(_will);
    _mqttConnection.sendMessageToBroker(m, debugMessage);
  }

  void _processData(data) {
    var remData = data;
    do {
      remData = _processMqttMessage(remData);
    } while (remData != null);
  }

  List<int> _processMqttMessage(data) {
    num type = data[0] >> 4;
    int msgProcessedLength = data.length;
    //print("Get a message , type: $type , length: ${data.length}");
    switch(type) {
      case RESERVED:
        break;
      case CONNACK:
        msgProcessedLength = _handleConnack(data);
        break;
      case PUBLISH:
        msgProcessedLength = _handlePublish(data);
        break;
      case PUBACK:
        msgProcessedLength = _handlePuback(data);
        break;
      case PUBREC:
        msgProcessedLength = _handlePubrec(data);
        break;
      case PUBREL:
        msgProcessedLength = _handlePubrel(data);
        break;
      case PUBCOMP:
        msgProcessedLength = _handlePubcomp(data);
        break;
      case SUBACK:
        msgProcessedLength = _handleSuback(data);
        break;
      case UNSUBACK:
        msgProcessedLength = _handleUnsuback(data);
        break;
      case PINGRESP:
        break;
      default:
        print('WARNING: Unknown message type received: $type');
        break;
    }
    return (data.length > msgProcessedLength) ? data.sublist(msgProcessedLength) : null;
  }

  void _handleDone() {
    print('Connection to broker lost');
    if (_liveTimer != null) {
      _liveTimer.cancel();
    }
    if (onConnectionLost != null) {
      onConnectionLost();
    }
  }

  void _handleError(e) {
    print('error : $e');
    _connack.completeError(e);
  }

  int _handleConnack(data) {
    MqttMessageConnack m = new MqttMessageConnack.decode(data, debugMessage);
    print('${m.connAckStatus}');
    if (m.returnCode == 0) {
      _liveTimer = new Timer(const Duration(seconds: 25), _live);
      _connack.complete(m.returnCode);
    } else {
      _connack.completeError(m.connAckStatus);
    }
    return m.len;
  }

  int _handleSuback(data) {
    MqttMessageSuback m = new MqttMessageSuback.decode(data, debugMessage);
    _completeMessage(m, 'SUBACK');
    return m.len;
  }

  int _handleUnsuback(data) {
    MqttMessageUnsuback m = new MqttMessageUnsuback.decode(data, debugMessage);
    _completeMessage(m, 'UNSUBACK');
    return m.len;
  }

  int _handlePublish(data) {
    MqttMessagePublish m = new MqttMessagePublish.decode(data, debugMessage);
    
    //_completeMessage(m, 'PUBLISH');
    
    if (m.QoS > 0) {
      MqttMessageAssured mAck = ((m.QoS == 1) ? new MqttMessagePuback.initWithPublishMessage(m)
                                              : new MqttMessagePubrec.initWithPublishMessage(m));
      //_mqttConnection.sendMessageToBroker(mAck, debugMessage);
      _mqttConnection.sendProtobufMessageToBroker(mAck, debugMessage);
      _resetTimer();
    }
    //print('[mqttClient] [' + m._topic + '][' + m._payload + ']');
    if (_onSubscribeDataMap != null && _onSubscribeDataMap[m._topic] != null) {
      _onSubscribeDataMap[m._topic](m._topic, m.protobufPayload);
    }
    return m.len;
  }

  int _handlePuback(data) {
    MqttMessagePuback m = new MqttMessagePuback.decode(data, debugMessage);
    print('[PUBBACK] -> ${m.toString()}');
    _completeMessage(m, 'PUBACK');
    return m.len;
  }

  int _handlePubrec(data) {
    MqttMessagePubrec mpr = new MqttMessagePubrec.decode(data, debugMessage);
    MqttMessagePubrel m = new MqttMessagePubrel.initWithPubrecMessage(mpr);
    _mqttConnection.sendMessageToBroker(m, debugMessage);
    _resetTimer();
    return m.len;
  }

  int _handlePubrel(data) {
    MqttMessagePubcomp m = new MqttMessagePubcomp.initWithPubrelMessage(new MqttMessagePubrel.decode(data, debugMessage));
    _mqttConnection.sendMessageToBroker(m, debugMessage);
    _resetTimer();
    return m.len;
  }

  int _handlePubcomp(data) {
    MqttMessagePubcomp m = new MqttMessagePubcomp.decode(data, debugMessage);
    _completeMessage(m, 'PUBCOMP');
    return m.len;
  }

  void _resetTimer() {
    _liveTimer.cancel();
    _liveTimer = new Timer(const Duration(seconds: 25), _live);
  }

  void _live() {
    _mqttConnection.sendMessageToBroker(new MqttMessagePingReq(), debugMessage);
    _resetTimer();
  }
}