<?php

namespace App\Http\Controllers;

use App\Models\Pedido;
use App\Models\ItensPedido;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class PedidoController extends Controller
{
    /**
     * GET /api/pedidos
     * Lista pedidos do usuário logado.
     */
    public function index()
    {
        $user = Auth::user();

        $pedidos = Pedido::where('user_id', $user->id)
            ->with([
                'loja',
                'itens.produto',
                'status',
                'localizacao',
            ])
            ->orderByDesc('created_at')
            ->get();

        return response()->json($pedidos);
    }

    /**
     * GET /api/pedidos/{id}
     * Detalhes de um pedido do usuário logado.
     */
    public function show(int $id)
    {
        $user = Auth::user();

        $pedido = Pedido::where('id', $id)
            ->where('user_id', $user->id)
            ->with([
                'loja',
                'itens.produto',
                'status',
                'localizacao',
            ])
            ->first();

        if (!$pedido) {
            return response()->json(['message' => 'Pedido não encontrado.'], 404);
        }

        return response()->json($pedido);
    }

    /**
     * POST /api/pedidos
     * Cria pedido + itens.
     *
     * Espera:
     * {
     *   "loja_id": 1,
     *   "localizacao_id": 2,
     *   "itens": [
     *      { "produto_id": 10, "quantidade": 2 },
     *      ...
     *   ]
     * }
     */
    public function store(Request $request)
    {
        try {
            $data = $request->validate([
                'loja_id' => 'required|exists:loja,id',
                'localizacao_id' => 'required|exists:localizacao,id',
                'itens' => 'required|array|min:1',
                'itens.*.produto_id' => 'required|exists:produto,id',
                'itens.*.quantidade' => 'required|integer|min:1',
            ]);

            $user = Auth::user();

            DB::beginTransaction();

            $pedido = Pedido::create([
                'user_id' => $user->id,
                'loja_id' => $data['loja_id'],
                'localizacao_id' => $data['localizacao_id'],
                'status_pedido_id' => 1, // por ex.: 1 = "PENDENTE"
                'valor_total' => 0,
                'pagamento' => false, // se existir col. pagamento
            ]);

            $valorTotal = 0;

            foreach ($data['itens'] as $item) {
                $itemPedido = ItensPedido::create([
                    'pedido_id' => $pedido->id,
                    'produto_id' => $item['produto_id'],
                    'quantidade' => $item['quantidade'],
                ]);

                // Preço do produto
                $produto = $itemPedido->produto;
                $valorTotal += ($produto->valor * $itemPedido->quantidade);
            }

            $pedido->update([
                'valor_total' => $valorTotal,
            ]);

            DB::commit();

            return response()->json([
                'message' => 'Pedido criado com sucesso.',
                'pedido' => $pedido->load([
                    'loja',
                    'itens.produto',
                    'status',
                    'localizacao',
                ]),
                'total' => $valorTotal,
            ], 201);
        } catch (ValidationException $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Erro de validação.',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Erro interno do servidor.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
