import 'dart:async';
import 'package:eshop_admin/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 2),(){
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      );
    }
    );

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
