import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/common_widget/ambula_bottom_nav_bar.dart';
import 'package:frontend/home_comprador/home_comprador_view.dart';
import 'package:frontend/view/search_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeCompradorView(), // Início
    SearchView(), // Buscar
    Center(child: Text('Tela de pedidos')), // Pedidos
    Center(child: Text('Tela de perfil')), // Perfil
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
