<?php

namespace App\Http\Controllers;

use App\Models\Loja;
use App\Models\Produto;
use App\Models\CategoriaProduto;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SearchController extends Controller
{
    /**
     * Busca por produtos e lojas.
     * GET /api/search?q=...
     */
    public function search(Request $request): JsonResponse
    {
        $term = trim(
            $request->get('q', $request->get('query', ''))
        );

        if ($term === '') {
            return response()->json([
                'produtos' => [],
                'lojas'    => [],
            ]);
        }

        /**
         * 1) Descobrir categorias cujo nome bate com o termo
         *    Ex: termo "Lanches" -> todas as categorias "Lanches"
         */
        $categoriaIds = CategoriaProduto::query()
            ->where('descricao', 'LIKE', "%{$term}%")
            ->pluck('id')
            ->all();

        /**
         * 2) PRODUTOS
         *    - Nome do produto
         *    - Descrição do produto
         *    - Nome da loja
         *    - OU categoria_produto_id IN categorias encontradas
         */
        $produtosRows = Produto::query()
            ->join('estoque', 'estoque.produto_id', '=', 'produto.id')
            ->join('loja', 'estoque.loja_id', '=', 'loja.id')
            ->where(function ($q) use ($term, $categoriaIds) {
                $q->where('produto.nome', 'LIKE', "%{$term}%")
                    ->orWhere('produto.descricao', 'LIKE', "%{$term}%")
                    ->orWhere('loja.nome', 'LIKE', "%{$term}%");

                // se tiver categoria compatível com o termo, traz todos os produtos dessa(s) categoria(s)
                if (!empty($categoriaIds)) {
                    $q->orWhereIn('produto.categoria_produto_id', $categoriaIds);
                }
            })
            ->selectRaw('
                produto.id       as produto_id,
                produto.nome     as produto_nome,
                produto.valor    as valor,
                loja.id          as loja_id,
                loja.nome        as loja_nome,
                loja.avaliacao   as loja_avaliacao
            ')
            ->groupBy(
                'produto.id',
                'produto.nome',
                'produto.valor',
                'loja.id',
                'loja.nome',
                'loja.avaliacao'
            )
            // pode aumentar/diminuir esse limite se quiser
            ->orderByDesc('loja_avaliacao')
            ->take(60)
            ->get();

        $produtos = $produtosRows->map(function ($row) {
            return [
                'id'            => $row->produto_id,
                'lojaId'        => $row->loja_id,
                'nome'          => $row->produto_nome,
                'valor'         => (float) $row->valor,
                'lojaNome'      => $row->loja_nome,
                'lojaAvaliacao' => (float) $row->loja_avaliacao,
            ];
        });

        /**
         * 3) LOJAS
         *    Continua igual: busca pelo nome e descrição da loja
         */
        $lojasRows = Loja::query()
            ->where(function ($q) use ($term) {
                $q->where('nome', 'LIKE', "%{$term}%")
                    ->orWhere('descricao', 'LIKE', "%{$term}%");
            })
            ->orderByDesc('avaliacao')
            ->take(40)
            ->get([
                'id',
                'nome',
                'descricao',
                'avaliacao',
                'status',
                'imagem',
            ]);

        $lojas = $lojasRows->map(function (Loja $loja) {
            return [
                'id'           => $loja->id,
                'nome'         => $loja->nome,
                'categoria'    => '', // se depois você tiver isso em loja, só preencher
                'statusAberta' => (bool) $loja->status,
                'descricao'    => $loja->descricao ?? '',
                'avaliacao'    => (float) $loja->avaliacao,
                'imagem'       => $loja->imagem,
            ];
        });

        return response()->json([
            'produtos' => $produtos,
            'lojas'    => $lojas,
        ]);
    }
}
