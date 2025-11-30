import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/common_widget/ambula_bottom_nav_bar.dart';
import 'package:frontend/home_comprador/home_comprador_view.dart';
import 'package:frontend/view/search_view.dart';
import 'package:frontend/view/pedidos_view.dart';

class MainTabView extends StatefulWidget {
  /// índice inicial da aba:
  /// 0 = Início, 1 = Buscar, 2 = Pedidos, 3 = Perfil
  final int initialIndex;

  const MainTabView({super.key, this.initialIndex = 0});

  // helper pra acessar o state a partir da Home (ou outras telas)
  static _MainTabViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MainTabViewState>();
  }

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  late int _currentIndex;
  String? _searchInitialTerm;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

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
          const PedidosView(),
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
