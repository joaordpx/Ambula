import 'package:flutter/material.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => StartupViewState();
}

class StartupViewState extends State<StartupView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
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
