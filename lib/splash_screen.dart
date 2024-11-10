import 'package:flutter/material.dart';

import 'features/home/presentation/home/screens/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        const Duration(seconds: 3), () {}); // Adjust duration if needed
    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                   const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: Image.asset(
            'images/Sa7ten.gif',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
