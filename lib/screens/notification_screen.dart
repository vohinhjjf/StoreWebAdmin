import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const String id = 'notification-screen';

  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: const Text(
          'Notification Manage Screen',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
