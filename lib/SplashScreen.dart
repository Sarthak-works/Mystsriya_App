import 'dart:async';

import 'package:flutter/material.dart';
import 'package:momworkapp/Screen/IntroPage.dart';
import 'package:momworkapp/Screen/auth/LoginHomeScreen.dart';
import 'package:momworkapp/Screen/widgets/custom_bottom_tab_bar.dart';
import 'package:momworkapp/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/auth/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    timerFun();
  }

  timerFun() async {
    Utils.prefs = await SharedPreferences.getInstance();
    bool loginStatus = Utils.prefs!.getBool('loginStatus') ?? false;
    bool firstTimeAppOpen = Utils.prefs!.getBool('firstTime') ?? true;

    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => loginStatus
                    ? const CustomBottomTabBar()
                    : firstTimeAppOpen ? const IntroPage() : const LoginHomeScreen())));
  }

//appLogo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/newLogo.png',
          height: 150,
        ),
      ),
    );
  }
}
