import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/produto.dart';

class ProductDetailView extends StatefulWidget {
  final Produto produto;
  final String lojaNome;
  final bool lojaAberta;
  final double avaliacaoLoja;
  final String? lojaHeader; // avatar opcional da loja

  const ProductDetailView({
    super.key,
    required this.produto,
    required this.lojaNome,
    required this.lojaAberta,
    required this.avaliacaoLoja,
    this.lojaHeader,
  });

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _quantidade = 1;

  @override
  Widget build(BuildContext context) {
    final produto = widget.produto;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // IMAGEM + BOTÃO VOLTAR
            Stack(
              children: [
                // imagem do produto
                SizedBox(
                  width: double.infinity,
                  height: 260,
                  child: produto.imagem.isNotEmpty
                      ? Image.network(produto.imagem, fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.fastfood_rounded, size: 56),
                        ),
                ),
                // botão voltar
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.25),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),

            // CONTEÚDO SCROLLÁVEL
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // nome do produto
                    Text(
                      produto.nome,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // preço
                    Text(
                      'R\$ ${produto.preco.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: TColor.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // descrição
                    Text(
                      produto.descricao,
                      style: TextStyle(
                        fontSize: 14,
                        color: TColor.secondarytext,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // BLOCO DA LOJA
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // avatar da loja
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              (widget.lojaHeader != null &&
                                  widget.lojaHeader!.isNotEmpty)
                              ? NetworkImage(widget.lojaHeader!)
                              : null,
                          child:
                              (widget.lojaHeader == null ||
                                  widget.lojaHeader!.isEmpty)
                              ? const Icon(
                                  Icons.storefront,
                                  size: 22,
                                  color: Colors.black54,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),

                        // nome + status
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.lojaNome,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.lojaAberta
                                    ? 'Disponível agora'
                                    : 'Fechada no momento',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: widget.lojaAberta
                                      ? TColor.primary
                                      : TColor.accent,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // avaliação
                        Row(
                          children: [
                            Text(
                              widget.avaliacaoLoja.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 13,
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

                    const SizedBox(height: 80), // respiro pro botão de baixo
                  ],
                ),
              ),
            ),

            // BARRA INFERIOR: QUANTIDADE + ADICIONAR AO CARRINHO
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                color: TColor.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // STEPPER DE QUANTIDADE
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _quantidade > 1
                              ? () {
                                  setState(() {
                                    _quantidade--;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.remove_rounded),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          splashRadius: 18,
                        ),
                        Text(
                          _quantidade.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _quantidade++;
                            });
                          },
                          icon: const Icon(Icons.add_rounded),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          splashRadius: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // BOTÃO ADICIONAR AO CARRINHO
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: TColor.primary,
                          shape: const StadiumBorder(),
                          elevation: 0,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          // aqui no futuro vamos integrar com o carrinho
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$_quantidade x ${produto.nome} adicionado(s) ao carrinho (mock).',
                              ),
                            ),
                          );
                        },
                        child: const Text('Adicionar ao carrinho'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
