import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/loja_detalhe.dart';
import 'package:frontend/models/produto.dart';
import 'package:frontend/services/loja_service.dart';
import 'package:frontend/view/product_detail_view.dart';

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
                // about me
                const Text(
                  'Sobre mim',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  detalhe.loja.descricao,
                  style: TextStyle(
                    fontSize: 16,
                    color: TColor.secondarytext,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // todos os produtos
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
                    final loja = detalhe.loja;

                    return _buildProductTile(
                      produto,
                      lojaNome: loja.nome,
                      lojaAberta: loja.disponivelAgora,
                      avaliacaoLoja: loja.avaliacao,
                      lojaHeader: loja.header,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
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
    final Color statusColor = loja.disponivelAgora
        ? TColor.primary
        : TColor.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // faixa verde botao de voltar
        Container(
          color: TColor.primary,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.white,
              ),
            ],
          ),
        ),

        // bloco com avatar, nome, status e avaliação
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // avatar loja
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: loja.header.isNotEmpty
                    ? NetworkImage(loja.header)
                    : null,
                child: loja.header.isEmpty
                    ? const Icon(
                        Icons.storefront,
                        size: 32,
                        color: Colors.black54,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // nome, status e avaliação
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // nome da loja
                    Text(
                      loja.nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // status
                    Row(
                      children: [
                        Text(
                          loja.disponivelAgora
                              ? 'Disponível agora'
                              : 'Fechado no momento',
                          style: TextStyle(
                            fontSize: 14,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: statusColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // avaliacao da loja
                    Row(
                      children: [
                        Text(
                          loja.avaliacao.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
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
        ),
      ],
    );
  }

  Widget _buildProductTile(
    Produto produto, {
    required String lojaNome,
    required bool lojaAberta,
    required double avaliacaoLoja,
    String? lojaHeader,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailView(
              produtoId: produto.id,
              lojaId: produto.lojaId,
              nome: produto.nome,
              descricao: produto.descricao,
              imagemUrl: produto.imagem,
              preco: produto.preco,
              lojaNome: lojaNome,
              lojaAberta: lojaAberta,
              avaliacaoLoja: avaliacaoLoja,
              lojaHeader: lojaHeader,
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // imagem do produto
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child: produto.imagem.isNotEmpty
                  ? Image.network(produto.imagem, fit: BoxFit.cover)
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.fastfood_rounded),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // nome + preço
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        produto.nome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
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
                  style: TextStyle(
                    fontSize: 14,
                    color: TColor.secondarytext,
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
