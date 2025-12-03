class Produto {
  final int id;
  final int lojaId;
  final String nome;
  final String descricao;
  final double preco;
  final String imagem;
  final String? categoria; // texto da categoria
  final int? categoriaId; // usado no PUT/POST

  Produto({
    required this.id,
    required this.lojaId,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagem,
    this.categoria,
    this.categoriaId,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    // backend usa "valor"
    final precoRaw = json['preco'] ?? json['valor'] ?? 0;

    // loja_id pode ser 0 (quando vem do ProdutoController)
    final lojaIdRaw = json['loja_id'] ?? json['lojaId'] ?? 0;

    return Produto(
      id: (json['id'] as num).toInt(),
      lojaId: (lojaIdRaw is num) ? lojaIdRaw.toInt() : 0,
      nome: json['nome']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? '',
      preco: precoRaw is num
          ? precoRaw.toDouble()
          : double.tryParse(precoRaw.toString()) ?? 0.0,
      imagem: json['imagem']?.toString() ?? '',
      categoria: json['categoria']?.toString(),
      categoriaId: json['categoria_produto_id'] as int?,
    );
  }

  /// usado ao enviar para PUT/POST
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'valor': preco,
      'categoria_produto_id': categoriaId,
      'imagem': imagem,
    };
  }
}
