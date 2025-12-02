/// Modelo de categoria usado na tela de busca/descoberta.
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
  final String categoria;

  /// Texto pronto pra exibição (ex: "Aberto agora", "Fechado no momento").
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

  factory Loja.fromJson(Map<String, dynamic> json) {
    final bool aberta =
        (json['statusAberta'] as bool?) ?? (json['status'] == true);
    final statusTexto = aberta ? 'Aberto agora' : 'Fechado no momento';

    return Loja(
      id: (json['id'] as num).toInt(),
      nome: (json['nome'] ?? '') as String,
      categoria: (json['categoria'] ?? '') as String,
      status: statusTexto,
      descricao: (json['descricao'] ?? '') as String,
      avaliacao: (json['avaliacao'] is num)
          ? (json['avaliacao'] as num).toDouble()
          : double.tryParse(json['avaliacao']?.toString() ?? '0') ?? 0.0,
      imagem: json['imagem'] as String?,
    );
  }
}

/// Modelo de produto retornado na busca.
class Produto {
  final int id;
  final int lojaId;
  final String nome;
  final double valor;
  final String lojaNome;
  final double lojaAvaliacao;

  const Produto({
    required this.id,
    required this.lojaId,
    required this.nome,
    required this.valor,
    required this.lojaNome,
    required this.lojaAvaliacao,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: (json['id'] as num).toInt(),
      lojaId: (json['lojaId'] as num).toInt(),
      nome: (json['nome'] ?? '') as String,
      valor: (json['valor'] is num)
          ? (json['valor'] as num).toDouble()
          : double.tryParse(json['valor']?.toString() ?? '0') ?? 0.0,
      lojaNome: (json['lojaNome'] ?? '') as String,
      lojaAvaliacao: (json['lojaAvaliacao'] is num)
          ? (json['lojaAvaliacao'] as num).toDouble()
          : double.tryParse(json['lojaAvaliacao']?.toString() ?? '0') ?? 0.0,
    );
  }
}

/// Dados do modo "descoberta" da tela de busca.
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
