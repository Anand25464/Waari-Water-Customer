
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? _client;
  final Map<String, Completer<String>> _pendingRequests = {};

  Future<void> connect() async {
    _client = MqttServerClient.withPort('your-mqtt-server.com', 'client_id', 1883);
    _client!.logging(on: false);
    _client!.onConnected = _onConnected;
    _client!.onDisconnected = _onDisconnected;
    _client!.onUnsubscribed = _onUnsubscribed;
    _client!.onSubscribed = _onSubscribed;
    _client!.onSubscribeFail = _onSubscribeFail;
    _client!.pongCallback = _pong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('client_id')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    
    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect();
    } on Exception catch (e) {
      print('MQTT connection exception - $e');
      _client!.disconnect();
    }

    if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT client connected');
    } else {
      print('MQTT client connection failed - disconnecting, status is ${_client!.connectionStatus}');
      _client!.disconnect();
    }
  }

  Future<String> publishAndSubscribe(String publishTopic, String subscribeTopic, Map<String, dynamic> data) async {
    if (_client == null || _client!.connectionStatus!.state != MqttConnectionState.connected) {
      throw Exception('MQTT client not connected');
    }

    final completer = Completer<String>();
    _pendingRequests[subscribeTopic] = completer;

    // Subscribe to response topic
    _client!.subscribe(subscribeTopic, MqttQos.atMostOnce);

    // Set up message listener
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final topic = c[0].topic;
      
      if (_pendingRequests.containsKey(topic)) {
        _pendingRequests[topic]!.complete(message);
        _pendingRequests.remove(topic);
        _client!.unsubscribe(topic);
      }
    });

    // Publish message
    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonEncode(data));
    _client!.publishMessage(publishTopic, MqttQos.atMostOnce, builder.payload!);

    return completer.future.timeout(const Duration(seconds: 30));
  }

  void _onConnected() {
    print('MQTT client connected');
  }

  void _onDisconnected() {
    print('MQTT client disconnected');
  }

  void _onSubscribed(String topic) {
    print('MQTT subscription confirmed for topic $topic');
  }

  void _onSubscribeFail(String topic) {
    print('MQTT subscription failed for topic $topic');
  }

  void _onUnsubscribed(String? topic) {
    print('MQTT unsubscribed topic $topic');
  }

  void _pong() {
    print('MQTT ping response client callback invoked');
  }

  void disconnect() {
    _client?.disconnect();
  }
}
