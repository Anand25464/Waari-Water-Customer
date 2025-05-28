import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  MqttServerClient? _client;
  StreamController<String> _messageController = StreamController<String>.broadcast();

  Stream<String> get messageStream => _messageController.stream;

  void connect(String clientId) async {
    _client = MqttServerClient('your-broker-url', clientId);
    _client!.port = 1883;

    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = _onDisconnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .keepAliveFor(20)
        .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMess;

    try {
      await _client!.connect();
    } catch (e) {
      print('Exception: $e');
      _client!.disconnect();
    }

    if (_client!.connectionStatus?.state == MqttConnectionState.connected) {
      print('Connected to the broker');
      _client!.subscribe('your-subscribe-topic', MqttQos.atLeastOnce);
      _client!.updates?.listen(_onMessageReceived);
    } else {
      print('Connection failed - disconnecting, status is ${_client!.connectionStatus}');
      _client!.disconnect();
    }
  }

  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage>> event) {
    final MqttPublishMessage receivedMessage = event[0].payload as MqttPublishMessage;
    String payload = '';
    final String message = MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message);

    _messageController.add(message);
  }

  void publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  }

  void disconnect() {
    _client?.disconnect();
    _messageController.close();
  }

  void _onDisconnected() {
    print('Disconnected');
    // Implement any reconnection logic here if needed
  }
}
