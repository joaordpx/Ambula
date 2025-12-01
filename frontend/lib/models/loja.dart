class Loja {
  final int id;
  final String nome;
  final String header;
  final String descricao;
  final double avaliacao;
  final bool disponivelAgora;

  /// Campos extras pensados para o painel do vendedor / perfil da loja
  final String? telefone;
  final String? localAtuacao;
  final bool aceitaPedidosAmbula;

  Loja({
    required this.id,
    required this.nome,
    required this.header,
    required this.descricao,
    required this.avaliacao,
    required this.disponivelAgora,
    this.telefone,
    this.localAtuacao,
    this.aceitaPedidosAmbula = true,
  });

  factory Loja.fromJson(Map<String, dynamic> json) {
    return Loja(
      id: json['id'],
      nome: json['nome'],
      header: json['header'] ?? '',
      descricao: json['descricao'] ?? '',
      avaliacao: (json['avaliacao'] ?? 0).toDouble(),
      disponivelAgora: json['status'] == 'aberta',

      // Esses campos são “a mais” pro futuro:
      telefone: json['telefone'],
      localAtuacao: json['local_atuacao'],
      aceitaPedidosAmbula: json['aceita_pedidos_ambula'] ?? true,
    );
  }

  Loja copyWith({
    int? id,
    String? nome,
    String? header,
    String? descricao,
    double? avaliacao,
    bool? disponivelAgora,
  }) {
    return Loja(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      header: header ?? this.header,
      descricao: descricao ?? this.descricao,
      avaliacao: avaliacao ?? this.avaliacao,
      disponivelAgora: disponivelAgora ?? this.disponivelAgora,
    );
  }
}
