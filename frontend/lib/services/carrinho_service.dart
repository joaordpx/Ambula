import 'package:flutter/material.dart';

class CartItem {
  final int produtoId;
  final String nome;
  final double preco;
  int quantidade;

  CartItem({
    required this.produtoId,
    required this.nome,
    required this.preco,
    this.quantidade = 1,
  });
}

class CartState {
  int? lojaId;
  String? lojaNome;
  final List<CartItem> itens = [];

  bool get isEmpty => itens.isEmpty;

  int get totalItens => itens.fold(0, (total, item) => total + item.quantidade);

  double get subtotal =>
      itens.fold(0, (total, item) => total + (item.preco * item.quantidade));
}

class CarrinhoService {
  static final CartState _state = CartState();

  static CartState get state => _state;

  static void clear() {
    _state.lojaId = null;
    _state.lojaNome = null;
    _state.itens.clear();
  }

  static void removeItem(int produtoId) {
    _state.itens.removeWhere((item) => item.produtoId == produtoId);
    if (_state.itens.isEmpty) {
      _state.lojaId = null;
      _state.lojaNome = null;
    }
  }

  static void updateQuantity(int produtoId, int novaQuantidade) {
    final index = _state.itens.indexWhere(
      (item) => item.produtoId == produtoId,
    );

    if (index == -1) return;

    if (novaQuantidade <= 0) {
      removeItem(produtoId);
    } else {
      _state.itens[index].quantidade = novaQuantidade;
    }
  }

  /// só itens de uma loja por vez
  static Future<void> addItemWithSingleStoreRule(
    BuildContext context, {
    required int lojaId,
    required String lojaNome,
    required int produtoId,
    required String nome,
    required double preco,
    int quantidade = 1,
  }) async {
    // carrinho vazio -> define loja
    if (_state.lojaId == null) {
      _state.lojaId = lojaId;
      _state.lojaNome = lojaNome;
    }

    // carrinho de outra loja -> perguntar se quer limpar e trocar
    if (_state.lojaId != lojaId) {
      final confirmou = await _showTrocarLojaDialog(context, lojaNome);
      if (!confirmou) return;

      clear();
      _state.lojaId = lojaId;
      _state.lojaNome = lojaNome;
    }

    // adiciona ou aumenta quantidade
    final index = _state.itens.indexWhere(
      (item) => item.produtoId == produtoId,
    );

    if (index != -1) {
      _state.itens[index].quantidade += quantidade;
    } else {
      _state.itens.add(
        CartItem(
          produtoId: produtoId,
          nome: nome,
          preco: preco,
          quantidade: quantidade,
        ),
      );
    }
  }

  static Future<bool> _showTrocarLojaDialog(
    BuildContext context,
    String novaLojaNome,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Carrinho de outra loja'),
              content: Text(
                'Seu carrinho atual possui itens de outra loja.\n\n'
                'Deseja limpar o carrinho e adicionar produtos de "$novaLojaNome"?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Limpar e trocar'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
