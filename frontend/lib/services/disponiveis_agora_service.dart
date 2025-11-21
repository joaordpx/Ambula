import 'dart:convert';

class DisponiveisAgoraService {
  static Future<List<Map<String, dynamic>>> fetchDisponiveisAgora() async {
    await Future.delayed(const Duration(milliseconds: 400));

    const mockJson = '''
    [
      {
        "id": 1,
        "nome": "Cookie Caseiro",
        "imagem": "https://picsum.photos/300",
        "ambulante": {
          "nome": "Maria doces",
          "foto": "https://i.pravatar.cc/150?img=12"
        },
        "status_loja": "aberto"
      },
      {
        "id": 2,
        "nome": "Brownie Tradicional",
        "imagem": "https://picsum.photos/301",
        "ambulante": {
          "nome": "Doces do João",
          "foto": "https://i.pravatar.cc/150?img=24"
        },
        "status_loja": "aberto"
      },
      {
        "id": 3,
        "nome": "Café Gelado",
        "imagem": "https://picsum.photos/302",
        "ambulante": {
          "nome": "Café da Lu",
          "foto": "https://i.pravatar.cc/150?img=35"
        },
        "status_loja": "aberto"
      }
    ]
    ''';

    return List<Map<String, dynamic>>.from(jsonDecode(mockJson));
  }
}
