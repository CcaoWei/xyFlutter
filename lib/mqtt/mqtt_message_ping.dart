part of mqtt_shared;

class MqttMessagePingReq extends MqttMessage {
  MqttMessagePingReq()
        : super(PINGREQ);
}

class MqttMessagePingResp extends MqttMessage {
  MqttMessagePingResp()
        : super(PINGRESP);
}