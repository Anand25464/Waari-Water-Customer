import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:waari_water/utils/topics.dart';

// MQTT State
class MqttState {
  final bool isConnected;
  final String? message;
  final bool isLoading;
  final String? error;

  const MqttState({
    this.isConnected = false,
    this.message,
    this.isLoading = false,
    this.error,
  });

  MqttState copyWith({
    bool? isConnected,
    String? message,
    bool? isLoading,
    String? error,
  }) {
    return MqttState(
      isConnected: isConnected ?? this.isConnected,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// MQTT Controller using Riverpod
class MqttController extends StateNotifier<MqttState> {
  MqttController() : super(const MqttState());

  MqttServerClient? client;
  int? randomNumber;

  void generateRandomNumber() {
    randomNumber = Random().nextInt(1000000);
  }

  Future<void> connectMqtt() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      if (randomNumber == null) {
        generateRandomNumber();
      }

      client = MqttServerClient.withPort(
        'broker.hivemq.com',
        'client_$randomNumber',
        1883,
      );

      client!.logging(on: true);
      client!.onConnected = onConnected;
      client!.onDisconnected = onDisconnected;
      client!.onUnsubscribed = onUnsubscribed;
      client!.onSubscribed = onSubscribed;
      client!.onSubscribeFail = onSubscribeFail;
      client!.pongCallback = pong;

      final connMessage = MqttConnectMessage()
          .withClientIdentifier('client_$randomNumber')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      client!.connectionMessage = connMessage;

      await client!.connect();

      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        state = state.copyWith(isConnected: true, isLoading: false);
        subscribeToTopics();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to connect: ${e.toString()}',
      );
    }
  }

  void subscribeToTopics() {
    if (client != null && client!.connectionStatus!.state == MqttConnectionState.connected) {
      client!.subscribe(Topics.testTopic, MqttQos.atMostOnce);
      client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        state = state.copyWith(message: pt);
      });
    }
  }

  void publishMessage(String topic, String message) {
    if (client != null && client!.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  void onConnected() {
    state = state.copyWith(isConnected: true);
  }

  void onDisconnected() {
    state = state.copyWith(isConnected: false);
    client = null;
  }

  void onSubscribed(String topic) {
    // Handle subscription success
  }

  void onSubscribeFail(String topic) {
    state = state.copyWith(error: 'Failed to subscribe to $topic');
  }

  void onUnsubscribed(String? topic) {
    // Handle unsubscription
  }

  void pong() {
    // Handle pong
  }

  void disconnect() {
    client?.disconnect();
    state = state.copyWith(isConnected: false);
  }
}

// Provider for MQTT Controller
final mqttControllerProvider = StateNotifierProvider<MqttController, MqttState>((ref) {
  return MqttController();
});