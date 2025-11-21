// lib/models/search_models.dart

/// Modelo para categoria de produto (tela de busca)
class CategoriaProduto {
  final int? id;
  final String descricao;
  final String? imagem;

  const CategoriaProduto({this.id, required this.descricao, this.imagem});
}

/// Modelo de loja usado na busca e na seção "Lojas mais bem avaliadas".
class Loja {
  final int id;
  final String nome;
  final String categoria; // Ex.: "Lanches", "Doces"
  final String status; // Ex.: "Disponível agora"
  final String descricao; // Texto que vai aparecer cortado com "..."
  final double avaliacao; // Ex.: 4.8
  final String? imagem; // URL opcional para imagem da loja

  const Loja({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.status,
    required this.descricao,
    required this.avaliacao,
    this.imagem,
  });
}

/// Modelo de produto para os resultados da busca.
class Produto {
  final int id;
  final String nome;
  final double valor;
  final String lojaNome;
  final double lojaAvaliacao;
  final String? imagem;

  const Produto({
    required this.id,
    required this.nome,
    required this.valor,
    required this.lojaNome,
    required this.lojaAvaliacao,
    this.imagem,
  });
}

/// Dados usados no modo "descoberta" da tela de busca.
class DadosDescoberta {
  final List<CategoriaProduto> categorias;
  final List<Loja> lojasMaisBemAvaliadas;

  const DadosDescoberta({
    required this.categorias,
    required this.lojasMaisBemAvaliadas,
  });
}

/// Resultado da busca (produtos + lojas).
class ResultadoBusca {
  final List<Produto> produtos;
  final List<Loja> lojas;

  const ResultadoBusca({required this.produtos, required this.lojas});
}
