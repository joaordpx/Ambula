<?php

namespace App\Http\Controllers;

use App\Models\Produto;
use App\Models\Estoque;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;

class ProdutoController extends Controller
{
    /**
     * GET /api/produtos
     * Lista produtos.
     * Filtros opcionais:
     *  - ?categoria_id=ID
     *  - ?q=termo
     */
    public function index(Request $request)
    {
        $query = Produto::query()->with('categoria');

        if ($request->filled('categoria_id')) {
            $query->where('categoria_produto_id', $request->get('categoria_id'));
        }

        if ($request->filled('q')) {
            $term = $request->get('q');
            $query->where(function ($q) use ($term) {
                $q->where('nome', 'LIKE', "%{$term}%")
                    ->orWhere('descricao', 'LIKE', "%{$term}%");
            });
        }

        $produtos = $query->orderBy('nome')->get();

        // JSON alinhado com o model Produto do Flutter
        $data = $produtos->map(function (Produto $p) {
            return [
                'id'        => $p->id,
                // lojaId não é direto aqui — vem do estoque/loja.
                // Para listagem genérica, deixamos 0 e a tela de loja usa /lojas/{id}.
                'loja_id'   => 0,
                'nome'      => $p->nome,
                'descricao' => $p->descricao ?? '',
                'valor'     => (float) $p->valor,
                'imagem'    => $p->imagem,
                'categoria' => $p->categoria?->descricao,
            ];
        });

        return response()->json($data);
    }

    /**
     * GET /api/produtos/{id}
     * Detalhes de um produto. Opcionalmente, recebe ?loja_id=ID
     * pra retornar a loja/estoque associado.
     */
    public function show(Request $request, int $id)
    {
        $produto = Produto::with('categoria')->find($id);

        if (!$produto) {
            return response()->json(['message' => 'Produto não encontrado.'], 404);
        }

        $lojaId = $request->get('loja_id');

        $lojaInfo = null;

        if ($lojaId) {
            $estoque = Estoque::where('produto_id', $produto->id)
                ->where('loja_id', $lojaId)
                ->first();

            if ($estoque) {
                $lojaInfo = [
                    'loja_id'  => $estoque->loja_id,
                    'estoque'  => $estoque->quantidade,
                ];
            }
        }

        return response()->json([
            'id'        => $produto->id,
            'nome'      => $produto->nome,
            'descricao' => $produto->descricao ?? '',
            'valor'     => (float) $produto->valor,
            'imagem'    => $produto->imagem,
            'categoria' => $produto->categoria?->descricao,
            'lojaInfo'  => $lojaInfo,
        ]);
    }

    /**
     * POST /api/produtos
     * Criação (vendedor/admin).
     */
    public function store(Request $request)
    {
        try {
            $data = $request->validate([
                'nome'               => 'required|string|max:255',
                'valor'              => 'required|numeric|min:0.01',
                'descricao'          => 'required|string',
                'categoria_produto_id' => 'nullable|exists:categoria_produto,id',
                'imagem'             => 'nullable|string|max:255',
            ]);

            $produto = Produto::create($data);

            return response()->json($produto, 201);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Erro de validação.',
                'errors'  => $e->errors(),
            ], 422);
        }
    }

    /**
     * PUT /api/produtos/{id}
     * Atualização (vendedor/admin).
     */
    public function update(Request $request, int $id)
    {
        $produto = Produto::find($id);

        if (!$produto) {
            return response()->json(['message' => 'Produto não encontrado.'], 404);
        }

        try {
            $data = $request->validate([
                'nome'               => 'sometimes|required|string|max:255',
                'valor'              => 'sometimes|required|numeric|min:0.01',
                'descricao'          => 'sometimes|required|string',
                'categoria_produto_id' => 'sometimes|nullable|exists:categoria_produto,id',
                'imagem'             => 'sometimes|nullable|string|max:255',
            ]);

            $produto->update($data);

            return response()->json($produto);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Erro de validação.',
                'errors'  => $e->errors(),
            ], 422);
        }
    }

    /**
     * DELETE /api/produtos/{id}
     */
    public function destroy(int $id)
    {
        $produto = Produto::find($id);

        if (!$produto) {
            return response()->json(['message' => 'Produto não encontrado.'], 404);
        }

        // remove imagem se estiver salva no disco public (se você estiver usando isso)
        if ($produto->imagem) {
            Storage::disk('public')->delete($produto->imagem);
        }

        $produto->delete();

        return response()->json(['message' => 'Produto removido com sucesso.'], 200);
    }
}
