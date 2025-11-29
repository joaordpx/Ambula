import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/common_widget/ambula_bottom_nav_bar.dart';
import 'package:frontend/home_comprador/home_comprador_view.dart';
import 'package:frontend/view/search_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  // helper pra acessar o state a partir da Home (ou outras telas)
  static _MainTabViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MainTabViewState>();
  }

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _currentIndex = 0;
  String? _searchInitialTerm;

  /// chamada pela home quando o usuário toca em uma categoria.
  /// troca pra aba buscar e injeta o termo inicial.
  void openSearchWithTerm(String term) {
    setState(() {
      _currentIndex = 1; // índice da aba buscar
      _searchInitialTerm = term;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeCompradorView(), // Início
          SearchView(termoInicial: _searchInitialTerm), // Buscar
          const Center(child: Text('Tela de pedidos')), // Pedidos
          const Center(child: Text('Tela de perfil')), // Perfil
        ],
      ),
      bottomNavigationBar: AmbulaBottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;

            // se saiu da aba buscar, zerar termo
            if (index != 1) {
              _searchInitialTerm = null;
            }
          });
        },
      ),
    );
  }
}
