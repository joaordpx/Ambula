import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/services/carrinho_service.dart';
import 'package:frontend/view/carrinho_view.dart';

class ProductDetailView extends StatefulWidget {
  final int produtoId;
  final int lojaId;

  final String nome;
  final String descricao; // pode vir vazia em alguns fluxos
  final String? imagemUrl; // pode ser null
  final double preco;

  final String lojaNome;
  final bool lojaAberta;
  final double avaliacaoLoja;
  final String? lojaHeader; // avatar opcional da loja

  const ProductDetailView({
    super.key,
    required this.produtoId,
    required this.lojaId,
    required this.nome,
    required this.descricao,
    this.imagemUrl,
    required this.preco,
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // imagem + botao de voltar
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 260,
                  child:
                      (widget.imagemUrl != null && widget.imagemUrl!.isNotEmpty)
                      ? Image.network(widget.imagemUrl!, fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.fastfood_rounded, size: 56),
                        ),
                ),
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

            // conteudo
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // nome
                    Text(
                      widget.nome,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // preco
                    Text(
                      'R\$ ${widget.preco.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: TColor.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // desc
                    Text(
                      widget.descricao.isNotEmpty
                          ? widget.descricao
                          : 'Descrição não informada.',
                      style: TextStyle(
                        fontSize: 14,
                        color: TColor.secondarytext,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // bloco loja
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // barra inferior
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
                  // quantidade
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
                                  setState(() => _quantidade--);
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
                            setState(() => _quantidade++);
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

                  // add to cart
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
                        onPressed: () async {
                          await CarrinhoService.addItemWithSingleStoreRule(
                            context,
                            lojaId: widget.lojaId,
                            lojaNome: widget.lojaNome,
                            produtoId: widget.produtoId,
                            imageUrl: widget.imagemUrl,
                            nome: widget.nome,
                            preco: widget.preco,
                            quantidade: _quantidade,
                          );

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Item adicionado ao carrinho',
                              ),
                              action: SnackBarAction(
                                label: 'Ver carrinho',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const CartView(),
                                    ),
                                  );
                                },
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
