<?php

namespace App\Http\Controllers;

use App\Models\Pedido;
use App\Models\Produto;
use App\Models\Estoque;
use App\Models\ItensPedido;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class PedidoController extends Controller
{
    
    public function store(Request $request)
    {
        try {
           
            $request->validate([
                'loja_id' => 'required|exists:loja,id',
                'itens' => 'required|array|min:1',
                'itens.*.produto_id' => 'required|exists:produto,id',
                'itens.*.quantidade' => 'required|integer|min:1',
                'pagamento' => 'required|boolean',
            ]);


            DB::beginTransaction();

            $pedido = Pedido::create([
                'user_id' => $request->user()->id,
                'loja_id' => $request->loja_id,
                'status_pedido_id' => 1,
                'pagamento' => $request->pagamento,
            ]);

            $totalPedido = 0;
            $itensParaInserir = [];

            
            foreach ($request->itens as $itemRequest) {
                $produto = Produto::find($itemRequest['produto_id']);
                $quantidade = $itemRequest['quantidade'];

               
                $estoque = Estoque::where('loja_id', $request->loja_id)
                                  ->where('produto_id', $produto->id)
                                  ->first();

                if (!$estoque || $estoque->quantidade < $quantidade) {
                    DB::rollBack();
                    return response()->json([
                        'message' => 'Estoque insuficiente para o produto: ' . $produto->nome,
                    ], 409);
                }

                
                $precoUnitario = $produto->valor;
                $subtotal = $precoUnitario * $quantidade;
                $totalPedido += $subtotal;

                $itensParaInserir[] = new ItensPedido([
                    'produto_id' => $produto->id,
                    'quantidade' => $quantidade,
                    'preco_unitario' => $precoUnitario,
                    'subtotal' => $subtotal,
                ]);

                $estoque->decrement('quantidade', $quantidade);
            }

            
            $pedido->itens()->saveMany($itensParaInserir);

          
            DB::commit();

            return response()->json([
                'message' => 'Pedido criado com sucesso.',
                'pedido' => $pedido->load('itens.produto', 'loja', 'status'),
                'total' => $totalPedido,
            ], 201);

        } catch (ValidationException $e) {
            DB::rollBack();
            return response()->json(['errors' => $e->errors()], 422);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Erro ao criar pedido.', 'error' => $e->getMessage()], 500);
        }
    }

   
    public function index(Request $request)
    {
        $pedidos = Pedido::where('user_id', $request->user()->id)
                         ->with(['itens.produto', 'loja', 'status'])
                         ->orderBy('created_at', 'desc')
                         ->get();

        return response()->json($pedidos);
    }

   
    public function show(string $id, Request $request)
    {
        $pedido = Pedido::where('id', $id)
                        ->where('user_id', $request->user()->id) // Apenas pedidos do usuário
                        ->with(['itens.produto', 'loja', 'status'])
                        ->first();

        if (!$pedido) {
            return response()->json(['message' => 'Pedido não encontrado.'], 404);
        }

        return response()->json($pedido);
    }

    
    public function updateStatus(string $id, Request $request)
    {

        if ($request->user()->nivel < 2) {
            return response()->json(['message' => 'Acesso negado. Você não tem permissão para alterar status.'], 403);
        }

        $pedido = Pedido::find($id);

        if (!$pedido) {
            return response()->json(['message' => 'Pedido não encontrado.'], 404);
        }

        try {
            $request->validate([
                'status_pedido_id' => 'required|exists:status_pedido,id',
            ]);

            $pedido->update(['status_pedido_id' => $request->status_pedido_id]);

            return response()->json([
                'message' => 'Status do pedido atualizado com sucesso.',
                'pedido' => $pedido->load('status')
            ]);

        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        }
    }
}
