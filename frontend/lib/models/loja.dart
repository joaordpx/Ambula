class Loja {
  final int id;
  final String nome;
  final String header;
  final String descricao;
  final double avaliacao;
  final bool disponivelAgora;

  Loja({
    required this.id,
    required this.nome,
    required this.header,
    required this.descricao,
    required this.avaliacao,
    required this.disponivelAgora,
  });

  factory Loja.fromJson(Map<String, dynamic> json) {
    return Loja(
      id: json['id'],
      nome: json['nome'],
      header: json['header'] ?? '',
      descricao: json['descricao'] ?? '',
      avaliacao: (json['avaliacao'] ?? 0).toDouble(),
      disponivelAgora: json['status'] == 'aberta',
    );
  }
}
