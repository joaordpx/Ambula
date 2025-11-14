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
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/imgs/logo.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
