import 'package:frontend/models/categoria_produto.dart';

class HomeData {
  final Map<String, dynamic> user;
  final List<CategoriaProduto> categorias;
  final List<Map<String, dynamic>> maisAmados;
  final List<Map<String, dynamic>> lojasPopulares;
  final List<Map<String, dynamic>> disponiveisAgora;

  const HomeData({
    required this.user,
    required this.categorias,
    required this.maisAmados,
    required this.lojasPopulares,
    required this.disponiveisAgora,
  });
}
