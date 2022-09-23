import 'package:charts_example/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSplashScreen(
          duration: 3000,
          splash: 'assets/images/appIcon.png',
          nextScreen: LoginPage(),
          splashTransition: SplashTransition.slideTransition,
          splashIconSize: 100,
          pageTransitionType: PageTransitionType.rightToLeft,
          backgroundColor: Theme.of(context).backgroundColor)
    );
  }
}
