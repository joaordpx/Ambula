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
    final dynamic status = json['status'];
    final dynamic statusAberta = json['statusAberta'];

    final bool disponivel =
        (statusAberta is bool && statusAberta) ||
        (status is bool && status) ||
        (status is String && status.toString().toLowerCase() == 'aberta');

    return Loja(
      id: (json['id'] as num).toInt(),
      nome: (json['nome'] ?? '') as String,
      header: (json['header'] ?? json['imagem'] ?? '') as String,
      descricao: (json['descricao'] ?? '') as String,
      avaliacao: json['avaliacao'] is num
          ? (json['avaliacao'] as num).toDouble()
          : double.tryParse(json['avaliacao']?.toString() ?? '0') ?? 0.0,
      disponivelAgora: disponivel,
    );
  }
}
