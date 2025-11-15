import 'package:flutter/material.dart';
import 'package:frontend/view/login/welcome_view.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => StartupViewState();
}

class StartupViewState extends State<StartupView> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/imgs/logo.png",
          width: media.width * 0.5,
          height: media.height * 0.8,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
