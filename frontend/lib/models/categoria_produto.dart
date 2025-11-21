class CategoriaProduto {
  final int id;
  final String descricao;
  final String? imagem; // url ou caminho de asset no futuro

  const CategoriaProduto({
    required this.id,
    required this.descricao,
    this.imagem,
  });

  factory CategoriaProduto.fromJson(Map<String, dynamic> json) {
    return CategoriaProduto(
      id: json['id'] as int,
      descricao: (json['descricao'] ?? '').toString(),
      imagem: json['imagem'] as String?,
    );
  }
}
