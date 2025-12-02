<?php

namespace App\Http\Controllers;

use App\Models\Loja;
use App\Models\ItensPedido;
use Illuminate\Http\JsonResponse;

class HomeController extends Controller
{
    /**
     * ~15 lojas com maior avaliação.
     */
    public function lojasPopulares(): JsonResponse
    {
        $lojas = Loja::query()
            ->orderByDesc('avaliacao')
            ->take(15)
            ->get([
                'id',
                'nome',
                'avaliacao',
                'status',
            ]);

        return response()->json($lojas);
    }

    /**
     * ~15 produtos mais pedidos (agrupando por produto + loja).
     */
    public function maisAmados(): JsonResponse
    {
        $rows = ItensPedido::query()
            ->join('pedido', 'itens_pedidos.pedido_id', '=', 'pedido.id')
            ->join('loja', 'pedido.loja_id', '=', 'loja.id')
            ->join('produto', 'itens_pedidos.produto_id', '=', 'produto.id')
            ->selectRaw('
                produto.id   as produto_id,
                produto.nome as produto_nome,
                loja.id      as loja_id,
                loja.nome    as loja_nome,
                loja.status  as loja_status,
                SUM(itens_pedidos.quantidade) as total_pedida
            ')
            ->groupBy(
                'produto.id',
                'produto.nome',
                'loja.id',
                'loja.nome',
                'loja.status'
            )
            ->orderByDesc('total_pedida')
            ->take(15)
            ->get();

        $response = $rows->map(function ($row) {
            return [
                // id direto para o front
                'id'            => $row->produto_id,
                'produtoId'     => $row->produto_id,
                'lojaId'        => $row->loja_id,
                'nomeProduto'   => $row->produto_nome,
                'nomeAmbulante' => $row->loja_nome,
                'lojaAberta'    => (bool) $row->loja_status,
                'totalPedidos'  => (int) $row->total_pedida,
            ];
        });

        return response()->json($response);
    }

    /**
     * ~15 lojas abertas agora (status = true).
     */
    public function disponiveisAgora(): JsonResponse
    {
        $lojas = Loja::query()
            ->where('status', true)
            ->orderByDesc('avaliacao')
            ->take(15)
            ->get([
                'id',
                'nome',
                'avaliacao',
                'status',
            ]);

        return response()->json($lojas->map(function (Loja $loja) {
            return [
                'id'        => $loja->id,
                'nome'      => $loja->nome,
                'avaliacao' => $loja->avaliacao,
                'status'    => (bool) $loja->status,
            ];
        }));
    }
}
