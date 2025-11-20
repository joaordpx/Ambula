import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/common_widget/ambula_bottom_nav_bar.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Início')),
    Center(child: Text('Buscar')),
    Center(child: Text('Pedidos')),
    Center(child: Text('Perfil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: _pages[_currentIndex],

      bottomNavigationBar: AmbulaBottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
