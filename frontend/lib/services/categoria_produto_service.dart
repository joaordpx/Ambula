import 'dart:async';
import 'package:frontend/models/categoria_produto.dart';

class CategoriaProdutoService {
  /// No futuro, isso aqui vai chamar a API:
  /// GET /api/categorias-produto
  ///
  /// Por enquanto, estamos usando uma lista mockada.
  static Future<List<CategoriaProduto>> fetchCategorias() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: substituir pelos dados vindos do backend
    return const [
      CategoriaProduto(id: 1, descricao: 'Bebidas'),
      CategoriaProduto(id: 2, descricao: 'Salgados'),
      CategoriaProduto(id: 3, descricao: 'Sobremesas'),
      CategoriaProduto(id: 4, descricao: 'Promoções'),
      CategoriaProduto(id: 5, descricao: 'Lanches'),
      CategoriaProduto(id: 6, descricao: 'Café'),
    ];
  }
}
