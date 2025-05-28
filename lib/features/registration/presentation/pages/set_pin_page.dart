
import 'package:flutter/material.dart';

class SetPinPage extends StatelessWidget {
  final String userMobile;
  
  const SetPinPage({super.key, required this.userMobile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set PIN'),
      ),
      body: Center(
        child: Text('Set PIN for: $userMobile'),
      ),
    );
  }
}
