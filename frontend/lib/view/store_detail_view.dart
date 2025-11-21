import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/loja_detalhe.dart';
import 'package:frontend/models/produto.dart';
import 'package:frontend/services/loja_service.dart';

class StoreDetailView extends StatefulWidget {
  final int lojaId;

  const StoreDetailView({super.key, required this.lojaId});

  @override
  State<StoreDetailView> createState() => _StoreDetailViewState();
}

class _StoreDetailViewState extends State<StoreDetailView> {
  late Future<LojaDetalhe> _futureDetalhe;
  final LojaService _lojaService = LojaService();

  @override
  void initState() {
    super.initState();
    _futureDetalhe = _lojaService.getDetalhesLoja(widget.lojaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A navbar inferior fica no widget de nível acima (MainTabView)
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<LojaDetalhe>(
          future: _futureDetalhe,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Não foi possível carregar esta loja.'),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureDetalhe = _lojaService.getDetalhesLoja(
                            widget.lojaId,
                          );
                        });
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            final detalhe = snapshot.data!;
            return _buildContent(context, detalhe);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LojaDetalhe detalhe) {
    return Column(
      children: [
        _buildHeader(context, detalhe),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sobre mim
                const Text(
                  'Sobre mim',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  detalhe.loja.descricao,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Todos os produtos
                const Text(
                  'Todos os produtos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: detalhe.produtos.length,
                  itemBuilder: (context, index) {
                    final produto = detalhe.produtos[index];
                    return _buildProductTile(produto);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, LojaDetalhe detalhe) {
    final loja = detalhe.loja;

    return Container(
      color: TColor.primary,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha do botão de voltar
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.white,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar da loja
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  backgroundImage: loja.header.isNotEmpty
                      ? NetworkImage(loja.header)
                      : null,
                  child: loja.header.isEmpty
                      ? const Icon(Icons.storefront, size: 32)
                      : null,
                ),
                const SizedBox(width: 12),

                // Nome, status, avaliação
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loja.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            loja.disponivelAgora
                                ? 'Disponível agora'
                                : 'Fechado no momento',
                            style: TextStyle(
                              fontSize: 13,
                              color: loja.disponivelAgora
                                  ? Colors.white
                                  : Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            loja.avaliacao.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTile(Produto produto) {
    return InkWell(
      onTap: () {
        // futuro: abrir detalhes do produto / bottom sheet
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem do produto
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 72,
              height: 72,
              child: produto.imagem.isNotEmpty
                  ? Image.network(produto.imagem, fit: BoxFit.cover)
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.fastfood_rounded),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome + preço na mesma linha
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        produto.nome,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'R\$ ${produto.preco.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  produto.descricao,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
