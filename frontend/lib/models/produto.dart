class Produto {
  final int id;
  final int lojaId;
  final String nome;
  final String descricao;
  final double preco;
  final String imagem;

  Produto({
    required this.id,
    required this.lojaId,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagem,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    final dynamic precoRaw = json['preco'] ?? json['valor'] ?? 0;
    final double preco = precoRaw is num
        ? precoRaw.toDouble()
        : double.tryParse(precoRaw.toString()) ?? 0.0;

    final dynamic lojaIdRaw = json['loja_id'] ?? json['lojaId'] ?? 0;

    return Produto(
      id: (json['id'] as num).toInt(),
      lojaId: (lojaIdRaw as num).toInt(),
      nome: (json['nome'] ?? '') as String,
      descricao: (json['descricao'] ?? '') as String,
      preco: preco,
      imagem: (json['imagem'] ?? '') as String,
    );
  }
}
