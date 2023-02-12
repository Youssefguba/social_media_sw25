import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_media_sw25/screens/login_screen.dart';
import 'package:social_media_sw25/services/firebase_authentication.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 5000), () {
      if (Auth.instance.user == null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/animation/welcome.json'),
      ),
    );
  }
}
