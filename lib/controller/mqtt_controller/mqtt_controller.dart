
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the state classes
abstract class MqttState {}

class MqttInitial extends MqttState {}

class MqttConnecting extends MqttState {}

class MqttConnected extends MqttState {}

class MqttDisconnected extends MqttState {}

class MqttError extends MqttState {
  final String message;
  MqttError(this.message);
}

class MqttTopicChanged extends MqttState {
  final String topic;
  MqttTopicChanged(this.topic);
}

class MqttController extends Cubit<MqttState> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final StreamController<String> _messageController = StreamController<String>.broadcast();
  late MqttServerClient client;
  bool mqttConnected = false;
  bool subAgain = true;

  String _currentTopic = "";
  String get getCurrentTopic => _currentTopic;
  set setCurrentTopic(String val) {
    _currentTopic = val;
    emit(MqttTopicChanged(val));
  }

  MqttController() : super(MqttInitial());

  Future<void> connectMqtt() async {
    emit(MqttConnecting());
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ClientId = prefs.getString('RandomNum');
    print('-----mqtt---- random number----');
    print(ClientId);
    
    client = MqttServerClient("192.168.2.116", "123456");
    client.port = 8051;
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.pongCallback = pong;
    client.onSubscribed = onSubscribed;
    
    final connMess = MqttConnectMessage()
        .withClientIdentifier(ClientId!)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect("Resonent", "India@123");
      print("======Mqtt Connect Succesfully========");
      mqttConnected = true;
      emit(MqttConnected());
    } on NoConnectionException catch (e) {
      print('client exception - $e');
      client.disconnect();
      showErrorMessage('An error occurred');
      emit(MqttError('Connection failed: $e'));
    } on SocketException catch (e) {
      print('======================NOT CONNECT TO MQTT============');
      print('socket exception - $e');
      client.disconnect();
      showErrorMessage('An error occurred');
      emit(MqttError('Socket error: $e'));
    }
    
    client.onDisconnected = () {
      print('MQTT disconnected');
      mqttConnected = false;
      emit(MqttDisconnected());
      _reconnect();
    };

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('client connected');
    } else {
      print('client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      emit(MqttError('Connection failed'));
      exit(-1);
    }
    client.onSubscribed = onSubscribed;
  }

  Future<void> disconnectMqtt() async {
    if (!mqttConnected) {
      print('---mqtt Disconnected----');
      return;
    }
    client.disconnect();
    mqttConnected = false;
    emit(MqttDisconnected());
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    final scaffold = ScaffoldMessenger.of(navigatorKey.currentContext!);
    scaffold.showSnackBar(snackBar);
  }

  Future<void> publish(String topic, Map<String, dynamic> data) async {
    try {
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        String jsonString = jsonEncode(data);
        final builder = MqttClientPayloadBuilder();
        builder.addString(jsonString);
        await client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      }
    } on SocketException catch (e) {
      client.disconnect();
      emit(MqttError('Socket error during publish: $e'));
    } on NoConnectionException catch (e) {
      emit(MqttError('No connection during publish: $e'));
      _reconnect();
    }
  }

  Future<int> generateRandomNumber() async {
    Random random = Random();
    int sixDigitNumber = random.nextInt(900000) + 100000;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("RandomNum", sixDigitNumber.toString());
    String? ClientId = prefs.getString('RandomNum');
    print('---randomNumber---');
    print(ClientId);
    return sixDigitNumber;
  }

  Future<void> subscribe(String topic, void Function(String) onMessage) async {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("==============subscribe return=========");
      print(topic);

      try {
        client.subscribe(topic, MqttQos.atLeastOnce);
      } catch (e) {
        print('Error subscribing to topic: $e');
        showErrorMessage("Unable to subscribe to the topic");
        emit(MqttError('Subscribe error: $e'));
        return;
      }

      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        print('----msg----');
        print(messages);

        MqttPublishMessage receivedMessage = messages.last.payload as MqttPublishMessage;
        String payload = MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message);

        print('----payload----');
        print(payload);

        onMessage(payload);
      });
    } else {
      print('Error: MQTT connection not yet established.');
      showErrorMessage("Unable to subscribe to the topic - MQTT connection not established");
      emit(MqttError('MQTT connection not established'));
    }
  }

  Future<void> _reconnect() async {
    while (true) {
      print('Reconnecting to MQTT...');
      try {
        await connectMqtt();
        print('Reconnected to MQTT successfully');
        break;
      } catch (e) {
        print('Reconnection failed. Retrying in 5 seconds...');
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  void onConnected() {
    print('Connected');
    mqttConnected = true;
    emit(MqttConnected());
  }

  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

  void onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
  }

  void pong() {
    print('Ping response client callback invoked');
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return client.updates;
  }

  @override
  Future<void> close() {
    _messageController.close();
    return super.close();
  }
}
