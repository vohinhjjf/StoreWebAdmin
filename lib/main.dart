import 'package:eshop_admin/screens/admin_users.dart';
import 'package:eshop_admin/screens/category_screen.dart';
import 'package:eshop_admin/screens/dashboard.dart';
import 'package:eshop_admin/screens/request_screen.dart';
import 'package:eshop_admin/screens/voucher_screen.dart';
import 'package:eshop_admin/screens/login_screen.dart';
import 'package:eshop_admin/screens/manage_banners.dart';
import 'package:eshop_admin/screens/notification_screen.dart';
import 'package:eshop_admin/screens/store_screen.dart';
import 'package:eshop_admin/screens/settings_screen.dart';
import 'package:eshop_admin/screens/splash_screen.dart';
import 'package:eshop_admin/screens/product_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';
import 'screens/statistic_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBJoftig49geI7Nv8uZf5gT3NJFgWySLWQ", // Your apiKey
      appId: "1:251921225698:web:00e7c5ed1967a5076a8bbb", // Your appId
      messagingSenderId: "251921225698", // Your messagingSenderId
      projectId: "storeapp-b5b72", // Your projectId
      authDomain: "storeapp-b5b72.firebaseapp.com",
      storageBucket: "storeapp-b5b72.appspot.com"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery App Admin Dash Board',
      theme: ThemeData(
        primaryColor: Color(0xFF84c225),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        DashBoardScreen.id:(context)=>DashBoardScreen(),
        BannerScreen.id:(context)=>BannerScreen(),
        CategoryScreen.id:(context)=>CategoryScreen(),
        StoreScreen.id:(context)=>StoreScreen(),
        NotificationScreen.id:(context)=>NotificationScreen(),
        AdminUsers.id:(context)=>AdminUsers(),
        SettingScreen.id:(context)=>SettingScreen(),
        ProductScreen.id:(context)=>ProductScreen(),
        VoucherScreen.id:(context)=>VoucherScreen(),
        RequestScreen.id:(context)=>RequestScreen(),
        ChatWidget.id:(context)=>ChatWidget(),
        StatisticScreen.id:(context)=>StatisticScreen(),
      },
    );
  }
}
