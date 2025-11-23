import 'dart:async';
import 'package:frontend/models/search_models.dart';

/// service responsável pela busca de produtos e lojas.
class SearchService {
  static Future<ResultadoBusca> search(String query) async {
    // TODO: substituir mocks por chamada real, ex:
    // final response = await http.get(Uri.parse('$baseUrl/search?query=$query'));
    await Future.delayed(const Duration(milliseconds: 800));

    final termoMinusculo = query.toLowerCase();

    final todosProdutos = <Produto>[
      const Produto(
        id: 1,
        lojaId: 1,
        nome: 'X-Burguer',
        valor: 15.90,
        lojaNome: 'Lanchonete do Campus',
        lojaAvaliacao: 4.8,
        imagem: null,
      ),
      const Produto(
        id: 2,
        lojaId: 2,
        nome: 'Açaí 500ml',
        valor: 18.00,
        lojaNome: 'Delícia de cookie',
        lojaAvaliacao: 4.8,
        imagem: null,
      ),
      const Produto(
        id: 3,
        lojaId: 3,
        nome: 'Suco de Laranja',
        valor: 7.50,
        lojaNome: 'Sucos & Cia',
        lojaAvaliacao: 4.6,
        imagem: null,
      ),
    ];

    final todasLojas = <Loja>[
      const Loja(
        id: 1,
        nome: 'Lanchonete do Campus',
        categoria: 'Lanches',
        status: 'Disponível agora',
        descricao:
            'Lanches rápidos, hambúrgueres e opções para matar a fome entre as aulas.',
        avaliacao: 4.8,
        imagem: null,
      ),
      const Loja(
        id: 2,
        nome: 'Delícia de cookie',
        categoria: 'Doces',
        status: 'Disponível agora',
        descricao:
            'Cookies, brownies e sobremesas fresquinhas preparadas diariamente.',
        avaliacao: 4.8,
        imagem: null,
      ),
      const Loja(
        id: 3,
        nome: 'Sucos & Cia',
        categoria: 'Bebidas',
        status: 'Fechado no momento',
        descricao:
            'Sucos naturais, vitaminas e bebidas geladas para refrescar o dia.',
        avaliacao: 4.6,
        imagem: null,
      ),
    ];

    final produtosFiltrados = todosProdutos
        .where((p) => p.nome.toLowerCase().contains(termoMinusculo))
        .toList();

    final lojasFiltradas = todasLojas
        .where((l) => l.nome.toLowerCase().contains(termoMinusculo))
        .toList();

    return ResultadoBusca(produtos: produtosFiltrados, lojas: lojasFiltradas);
  }
}
