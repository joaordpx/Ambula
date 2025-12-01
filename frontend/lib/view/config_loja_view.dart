import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/loja_detalhe.dart';
import 'package:frontend/models/produto.dart';
import 'package:frontend/services/loja_service.dart';
import 'package:frontend/services/categoria_produto_service.dart';
import 'package:frontend/models/categoria_produto.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfigLojaView extends StatefulWidget {
  final int? lojaId;

  const ConfigLojaView({super.key, this.lojaId});

  @override
  State<ConfigLojaView> createState() => _ConfigLojaViewState();
}

class _ConfigLojaViewState extends State<ConfigLojaView> {
  final LojaService _lojaService = LojaService();

  late Future<LojaDetalhe> _futureDetalhe;

  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;

  bool _recebendoPedidos = true;
  bool _salvando = false;
  bool _inicializado = false;

  /// Lista local de produtos (cardápio da loja)
  List<Produto> _produtos = [];

  /// 🔹 Categorias de produto (vêm do CategoriaProdutoService)
  List<CategoriaProduto> _categorias = [];
  bool _categoriasCarregando = true;
  String? _erroCategorias;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController();
    _descricaoController = TextEditingController();

    // escolhe um id de loja pra carregar:
    final int lojaId =
        widget.lojaId ?? LojaService.lojaAtual?.id ?? 1; // mock se nada vier

    _futureDetalhe = _lojaService.getDetalhesLoja(lojaId);

    // carrega categorias uma vez (mock -> futuro: GET /categorias-produto)
    _carregarCategorias();
  }

  Future<void> _carregarCategorias() async {
    try {
      final lista = await CategoriaProdutoService.fetchCategorias();
      if (!mounted) return;
      setState(() {
        _categorias = lista;
        _categoriasCarregando = false;
        _erroCategorias = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _categoriasCarregando = false;
        _erroCategorias = 'Erro ao carregar categorias.';
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _initControllersFromLoja(LojaDetalhe detalhe) {
    if (_inicializado) return;
    _inicializado = true;

    _nomeController.text = detalhe.loja.nome;
    _descricaoController.text = detalhe.loja.descricao;
    _recebendoPedidos = detalhe.loja.disponivelAgora;

    // copia produtos do detalhe para a lista local
    _produtos = List<Produto>.from(detalhe.produtos);
  }

  Future<void> _salvar() async {
    final nome = _nomeController.text.trim();
    final desc = _descricaoController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe o nome da loja.')));
      return;
    }

    setState(() => _salvando = true);

    // aqui, no futuro, entra o PUT/POST no backend.
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _salvando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados da loja salvos (mock).')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Minha loja',
          style: GoogleFonts.inter(
            color: TColor.primarytext,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<LojaDetalhe>(
        future: _futureDetalhe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Não foi possível carregar os dados da loja.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: TColor.secondarytext),
                ),
              ),
            );
          }

          final detalhe = snapshot.data!;
          _initControllersFromLoja(detalhe);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome
                Text(
                  'Nome da loja',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: TColor.primarytext,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF6F7FB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Descrição
                Text(
                  'Descrição',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: TColor.primarytext,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _descricaoController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF6F7FB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Switch "recebendo pedidos"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recebendo pedidos pelo Ambula',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: TColor.primarytext,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Quando desativado, sua loja não aparecerá para os compradores.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: TColor.secondarytext,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _recebendoPedidos,
                      activeColor: TColor.primary,
                      onChanged: (value) {
                        setState(() => _recebendoPedidos = value);
                        // LojaService.atualizarDisponibilidade(...); // no futuro
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ======== CARDÁPIO ========
                Text(
                  'Cardápio',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: TColor.primarytext,
                  ),
                ),
                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton.icon(
                    onPressed: () => _abrirFormProduto(),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(
                      'Adicionar produto',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                if (_produtos.isEmpty)
                  Text(
                    'Nenhum produto cadastrado ainda.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: TColor.secondarytext,
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _produtos.length,
                    itemBuilder: (context, index) {
                      final produto = _produtos[index];
                      return _buildProdutoTile(produto);
                    },
                  ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _salvando ? null : _salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: _salvando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar alterações'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ======== Bottom-sheet de adicionar/editar produto ========

  void _abrirFormProduto({Produto? produtoExistente}) {
    if (_categoriasCarregando) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categorias ainda estão carregando...')),
      );
      return;
    }

    if (_erroCategorias != null || _categorias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível carregar categorias de produto.'),
        ),
      );
      return;
    }

    final isEdicao = produtoExistente != null;

    final nomeCtrl = TextEditingController(text: produtoExistente?.nome ?? '');
    final descCtrl = TextEditingController(
      text: produtoExistente?.descricao ?? '',
    );
    final precoCtrl = TextEditingController(
      text: produtoExistente != null ? produtoExistente.preco.toString() : '',
    );

    // tenta descobrir categoria selecionada (edição) a partir do texto
    CategoriaProduto? categoriaInicial;
    if (produtoExistente?.categoria != null &&
        produtoExistente!.categoria!.trim().isNotEmpty) {
      categoriaInicial = _categorias.firstWhere(
        (c) => c.descricao == produtoExistente.categoria,
        orElse: () => _categorias.first,
      );
    }

    CategoriaProduto? categoriaSelecionada = categoriaInicial;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdicao ? 'Editar produto' : 'Novo produto',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nome do produto',
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: descCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: precoCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Preço (R\$)'),
                  ),
                  const SizedBox(height: 8),

                  // 🔹 SELECT de categoria baseado em CategoriaProdutoService
                  DropdownButtonFormField<CategoriaProduto>(
                    value: categoriaSelecionada,
                    items: _categorias
                        .map(
                          (c) => DropdownMenuItem<CategoriaProduto>(
                            value: c,
                            child: Text(c.descricao),
                          ),
                        )
                        .toList(),
                    onChanged: (novo) {
                      setModalState(() {
                        categoriaSelecionada = novo;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Categoria'),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        final nome = nomeCtrl.text.trim();
                        final desc = descCtrl.text.trim();
                        final precoStr = precoCtrl.text
                            .replaceAll(',', '.')
                            .trim();

                        if (nome.isEmpty || precoStr.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Informe pelo menos nome e preço do produto.',
                              ),
                            ),
                          );
                          return;
                        }

                        if (categoriaSelecionada == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Selecione uma categoria para o produto.',
                              ),
                            ),
                          );
                          return;
                        }

                        final preco = double.tryParse(precoStr);
                        if (preco == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Preço inválido.')),
                          );
                          return;
                        }

                        final catDescricao =
                            categoriaSelecionada!.descricao; // texto exibido

                        setState(() {
                          if (isEdicao) {
                            final idx = _produtos.indexOf(produtoExistente!);
                            if (idx != -1) {
                              _produtos[idx] = Produto(
                                id: produtoExistente.id,
                                lojaId: produtoExistente.lojaId,
                                nome: nome,
                                descricao: desc,
                                preco: preco,
                                imagem: produtoExistente.imagem,
                                categoria: catDescricao,
                              );
                            }
                          } else {
                            _produtos.add(
                              Produto(
                                id: DateTime.now().millisecondsSinceEpoch,
                                lojaId: widget.lojaId ?? 1,
                                nome: nome,
                                descricao: desc,
                                preco: preco,
                                imagem: null,
                                categoria: catDescricao,
                              ),
                            );
                          }
                        });

                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isEdicao
                            ? 'Salvar alterações'
                            : 'Adicionar ao cardápio',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ======== Tile visual de cada produto ========

  Widget _buildProdutoTile(Produto produto) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // placeholder de imagem
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.fastfood, size: 22, color: Colors.black54),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TColor.primarytext,
                  ),
                ),
                if (produto.categoria != null &&
                    produto.categoria!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      produto.categoria!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: TColor.secondarytext,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                if (produto.descricao.isNotEmpty)
                  Text(
                    produto.descricao,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: TColor.secondarytext,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  'R\$ ${produto.preco.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: TColor.primarytext,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => _abrirFormProduto(produtoExistente: produto),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: () {
                  setState(() {
                    _produtos.remove(produto);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
