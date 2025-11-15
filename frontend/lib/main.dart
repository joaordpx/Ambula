import 'package:flutter/material.dart';
import 'package:frontend/view/on_boarding/startup_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StartupView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
