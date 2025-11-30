import 'dart:async';
import 'package:frontend/models/search_models.dart';

/// Service responsável pelos dados do modo "descoberta"
/// (categorias + lojas mais bem avaliadas).
class SearchDiscoveryService {
  static Future<DadosDescoberta> loadDiscoveryData() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final categorias = <CategoriaProduto>[
      const CategoriaProduto(descricao: 'Lanches'),
      const CategoriaProduto(descricao: 'Doces'),
      const CategoriaProduto(descricao: 'Bebidas'),
      const CategoriaProduto(descricao: 'Salgados'),
      const CategoriaProduto(descricao: 'Saudáveis'),
      const CategoriaProduto(descricao: 'Outros'),
    ];

    final lojas = <Loja>[
      const Loja(
        id: 1,
        nome: 'Delícia de cookie',
        categoria: 'Doces',
        status: 'Disponível agora',
        descricao:
            'Um clássico irresistível! Feito com massa macia e sabor intenso de chocolate.',
        avaliacao: 4.8,
        imagem: null,
      ),
      const Loja(
        id: 2,
        nome: 'Doce Encanto',
        categoria: 'Doces',
        status: 'Disponível agora',
        descricao:
            'Doces caseiros preparados com ingredientes selecionados, perfeitos para qualquer momento.',
        avaliacao: 4.7,
        imagem: null,
      ),
      const Loja(
        id: 3,
        nome: 'Sucos & Cia',
        categoria: 'Bebidas',
        status: 'Fechado no momento',
        descricao:
            'Variedade de sucos naturais, combinações especiais e opções sem açúcar.',
        avaliacao: 4.6,
        imagem: null,
      ),
    ];

    return DadosDescoberta(
      categorias: categorias,
      lojasMaisBemAvaliadas: lojas,
    );
  }
}
