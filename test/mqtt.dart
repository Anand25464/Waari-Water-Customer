import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MqttController extends GetxController{
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late MqttServerClient client;
  bool mqttConnected = false;


  Future<void> connectMqtt() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String?  ClientId = prefs.getString('RandomNum');
    print('-----mqtt---- random number----');
    print(ClientId);
    client = MqttServerClient("192.168.2.116",ClientId! );
    client.port = 8051;
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    //client.onDisconnected = disconnectMqtt;
    client.onConnected = onConnected;
    client.pongCallback = pong;
    client.onSubscribed = onSubscribed;
    final connMess = MqttConnectMessage()
        .withClientIdentifier(ClientId)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('client connecting....');
    client.connectionMessage = connMess;

    try{
      await client.connect("Resonent", "India@123");
      print("======Mqtt Connect Succesfully========");
    }
    on NoConnectionException catch (e) {
      print('client exception - $e');
      client.disconnect();
      showErrorMessage('An error occurred');
    } on SocketException catch (e) {
      print('======================NOT CONNECT TO MQTT============');
      print('socket exception - $e');
      client.disconnect();
      showErrorMessage('An error occurred');
    }
    client.onDisconnected = () {
      print('MQTT disconnected');
      // Handle reconnection here
      _reconnect();
    };


    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('client connected');
    } else {
      print('client connection failed - disconnecting, status is ${client
          .connectionStatus}');
      client.disconnect();
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
    mqttConnected = false; // Set connection flag to false
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
    try{
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        String jsonString = jsonEncode(data);
        final builder = MqttClientPayloadBuilder();
        builder.addString(jsonString);
        await client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      }
      /*else{
        print("==============connecting to Server=============");
        _reconnect().then((value)async {
          if (client.connectionStatus!.state == MqttConnectionState.connected) {
            String jsonString = jsonEncode(data);
            final builder = MqttClientPayloadBuilder();
            builder.addString(jsonString);
            await client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
          }
        }).onError((error, stackTrace) {
          Get.snackbar("Error", error.toString());
          disconnectMqtt();

        });
      }*/
    } on SocketException catch(e){
      client.disconnect();
    } on NoConnectionException catch(e){
      _reconnect();
    }
    /*if (client.connectionStatus!.state == MqttConnectionState.connected) {
      String jsonString = jsonEncode(data);
      final builder = MqttClientPayloadBuilder();
      builder.addString(jsonString);
      await client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    }
    else {
      print('Error: MQTT connection not yet established.');
      Get.snackbar("Error", "Unable to publish msg");
      // Handle the error or retry the operation as needed
    }*/
  }
  Future<int> generateRandomNumber() async{
    Random random = Random();
    int sixDigitNumber = random.nextInt(900000) + 100000;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("RandomNum",sixDigitNumber.toString());
    String?  ClientId = prefs.getString('RandomNum');
    print('---randomNumber---');
    print(ClientId);
    return sixDigitNumber;

  }

  Future<void> subscribe(String topic, void Function(String) onMessage) async {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("==============subsribe return=========");
      print(topic);
      client.subscribe(topic, MqttQos.atLeastOnce);
      client.updates?.asBroadcastStream().listen((event) {
        print("==============broadcard============");
        event.forEach((element) {
          MqttPublishMessage receivedMessage = MqttPublishMessage();
          receivedMessage = element.payload as MqttPublishMessage;
          //print( MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message));


        });
      });
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {


        MqttPublishMessage receivedMessage = MqttPublishMessage();
        receivedMessage = messages.last.payload as MqttPublishMessage;
        String payload = '';
        payload =  MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message);
        onMessage(payload);

      });
    }
    else {
      print('Error: MQTT connection not yet established.');
      Get.snackbar("Error", "Unable to subscribe msg");
      // Handle the error or retry the operation as needed
    }
  }

  Future<void> _reconnect() async {
    while (true) {
      print('Reconnecting to MQTT...');
      try {
        // Attempt to reconnect
        await connectMqtt();
        print('Reconnected to MQTT successfully');
        break; // Exit the loop if reconnection successful
      } catch (e) {
        print('Reconnection failed. Retrying in 5 seconds...');
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  void onConnected() {
    print('Connected');
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


}