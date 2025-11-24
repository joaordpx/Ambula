class LocalEntrega {
  final int id;
  final String nome;
  final String? descricao;
  final double latitude;
  final double longitude;

  const LocalEntrega({
    required this.id,
    required this.nome,
    this.descricao,
    required this.latitude,
    required this.longitude,
  });
}
