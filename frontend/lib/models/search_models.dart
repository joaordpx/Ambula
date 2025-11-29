/// model categoria de produto
class CategoriaProduto {
  final int? id;
  final String descricao;
  final String? imagem;

  const CategoriaProduto({this.id, required this.descricao, this.imagem});
}

/// modelo de loja usado na busca e na seção "Lojas mais bem avaliadas".
class Loja {
  final int id;
  final String nome;
  final String categoria;
  final String status;
  final String descricao;
  final double avaliacao;
  final String? imagem;

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

/// modelo de produto para os resultados da busca
class Produto {
  final int id;
  final int lojaId;
  final String nome;
  final double valor;
  final String lojaNome;
  final double lojaAvaliacao;
  final String? imagem;

  const Produto({
    required this.id,
    required this.lojaId,
    required this.nome,
    required this.valor,
    required this.lojaNome,
    required this.lojaAvaliacao,
    this.imagem,
  });
}

/// dados usados no modo "explorar" da tela de busca
class DadosDescoberta {
  final List<CategoriaProduto> categorias;
  final List<Loja> lojasMaisBemAvaliadas;

  const DadosDescoberta({
    required this.categorias,
    required this.lojasMaisBemAvaliadas,
  });
}

/// resultado da busca (produtos + lojas)
class ResultadoBusca {
  final List<Produto> produtos;
  final List<Loja> lojas;

  const ResultadoBusca({required this.produtos, required this.lojas});
}
