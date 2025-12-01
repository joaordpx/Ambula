class Produto {
  final int id;
  final int lojaId;
  final String nome;
  final String descricao;
  final double preco;
  final String? imagem;
  final String? categoria;

  Produto({
    required this.id,
    required this.lojaId,
    required this.nome,
    this.categoria,
    required this.descricao,
    required this.preco,
    this.imagem,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      lojaId: json['loja_id'] as int,
      nome: json['nome'],
      descricao: json['descricao'] ?? '',
      preco: (json['preco'] ?? 0).toDouble(),
      imagem: json['imagem'] ?? '',
      categoria: json['categoria'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loja_id': lojaId,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'imagem': imagem,
      'categoria': categoria,
    };
  }
}
