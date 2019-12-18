part of mqtt_shared;

class MqttMessageDisconnect extends MqttMessage {
  MqttMessageDisconnect()
        : super(DISCONNECT);
  
  encodeVariableHeader() {}
}