import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  static const String id = 'settings-screen';
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: Text(
          'Setting',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
