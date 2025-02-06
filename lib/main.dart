import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localpro/launchScreen.dart';
import 'package:localpro/navbar.dart';
import 'package:localpro/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LocalPro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/launch',
      getPages: [
        GetPage(name: '/launch', page: () => const LaunchScreen()),
        GetPage(name: '/signup', page: () => const SignUp()),
        GetPage(name: '/home', page: () => const CustomBottomNavBar()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
