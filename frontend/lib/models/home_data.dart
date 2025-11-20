import 'package:frontend/models/categoria_produto.dart';

class HomeData {
  final Map<String, dynamic> user;
  final List<CategoriaProduto> categorias;
  final List<Map<String, dynamic>> maisAmados;

  const HomeData({
    required this.user,
    required this.categorias,
    required this.maisAmados,
  });
}
