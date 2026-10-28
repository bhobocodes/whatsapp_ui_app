import 'dart:async';
import 'package:flutter/material.dart';
import 'views/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
          () {
        Navigator.push(
          context, MaterialPageRoute(
          builder: (context) {
            return const HomeView();
          }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
