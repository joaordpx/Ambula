import 'dart:async';
import 'package:frontend/models/loja.dart';
import 'package:frontend/models/produto.dart';
import 'package:frontend/models/loja_detalhe.dart';

class LojaService {
  LojaService();

  Future<LojaDetalhe> getDetalhesLoja(int lojaId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final loja = Loja(
      id: lojaId,
      nome: 'Delícia de Cookie',
      header:
          'https://images.pexels.com/photos/230325/pexels-photo-230325.jpeg',
      descricao:
          'Oi! Eu sou apaixonado por transformar momentos simples em pequenos prazeres doces. '
          'No Delícia de Cookie, preparo cookies fresquinhos todos os dias, com ingredientes selecionados '
          'e muito carinho para adoçar sua rotina no campus.',
      avaliacao: 4.8,
      disponivelAgora: true,
    );

    final produtos = <Produto>[
      Produto(
        id: 1,
        lojaId: 10,
        nome: 'Chocolate com Gotas de Chocolate ao Leite',
        descricao:
            'Um clássico irresistível! Massa macia, muitas gotas de chocolate ao leite e aquele cheirinho que toma conta do corredor.',
        preco: 6.50,
        imagem:
            'https://images.pexels.com/photos/230325/pexels-photo-230325.jpeg',
      ),
      Produto(
        id: 2,
        lojaId: 20,
        nome: 'Cookie de Doce de Leite com Flor de Sal',
        descricao:
            'Equilíbrio perfeito entre o doce de leite cremoso e o toque de flor de sal. Ideal pra acompanhar um café.',
        preco: 7.00,
        imagem:
            'https://images.pexels.com/photos/230325/pexels-photo-230325.jpeg',
      ),
      Produto(
        id: 3,
        lojaId: 30,
        nome: 'Cookie de Nutella Recheado',
        descricao:
            'Casquinha crocante por fora, coração cremoso de Nutella por dentro. Servido levemente aquecido.',
        preco: 8.00,
        imagem:
            'https://images.pexels.com/photos/230325/pexels-photo-230325.jpeg',
      ),
      Produto(
        id: 4,
        lojaId: 40,
        nome: 'Combo 4 Cookies Sortidos',
        descricao:
            'Escolha seus sabores favoritos e monte seu combo pra dividir (ou não) com os amigos.',
        preco: 24.00,
        imagem:
            'https://images.pexels.com/photos/230325/pexels-photo-230325.jpeg',
      ),
    ];

    return LojaDetalhe(loja: loja, produtos: produtos);
  }
}
