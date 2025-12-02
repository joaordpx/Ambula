<?php

namespace App\Http\Controllers;

use App\Models\Estoque;
use App\Models\Loja;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class LojaController extends Controller
{
    /**
     * Lista de lojas (pode filtrar somente abertas com ?apenas_abertas=1).
     */
    public function index(Request $request): JsonResponse
    {
        $query = Loja::query()->with(['user', 'localizacao']);

        if ($request->boolean('apenas_abertas', false)) {
            $query->where('status', true);
        }

        $lojas = $query
            ->orderByDesc('avaliacao')
            ->get();

        $data = $lojas->map(function (Loja $loja) {
            return [
                'id'        => $loja->id,
                'nome'      => $loja->nome,
                'descricao' => $loja->descricao ?? '',
                'avaliacao' => (float) $loja->avaliacao,
                'status'    => (bool) $loja->status,
                'imagem'    => $loja->imagem,
                // campo "header" pro app usar como banner
                'header'    => $loja->imagem,
            ];
        });

        return response()->json($data);
    }

    /**
     * Detalhes de uma loja + cardápio (produtos em estoque).
     * GET /api/lojas/{id}
     */
    public function show(int $id): JsonResponse
    {
        $loja = Loja::query()
            ->with(['user', 'localizacao'])
            ->find($id);

        if (!$loja) {
            return response()->json(['message' => 'Loja não encontrada.'], 404);
        }

        // Produtos disponíveis nessa loja (via estoque)
        $produtosRows = Estoque::query()
            ->where('estoque.loja_id', $id)
            ->where('estoque.quantidade', '>', 0)
            ->join('produto', 'estoque.produto_id', '=', 'produto.id')
            ->select([
                'produto.id as id',
                'estoque.loja_id as loja_id',
                'produto.nome',
                'produto.descricao',
                'produto.valor',
                'produto.imagem',
            ])
            ->orderBy('produto.nome')
            ->get();

        $produtos = $produtosRows->map(function ($row) {
            return [
                'id'        => $row->id,
                'loja_id'   => $row->loja_id,
                'nome'      => $row->nome,
                'descricao' => $row->descricao ?? '',
                'valor'     => (float) $row->valor,
                'imagem'    => $row->imagem ?? '',
            ];
        });

        $lojaData = [
            'id'        => $loja->id,
            'nome'      => $loja->nome,
            'descricao' => $loja->descricao ?? '',
            'avaliacao' => (float) $loja->avaliacao,
            'status'    => (bool) $loja->status,
            'imagem'    => $loja->imagem,
            'header'    => $loja->imagem,
        ];

        return response()->json([
            'loja'     => $lojaData,
            'produtos' => $produtos,
        ]);
    }

    /**
     * Cria loja (para vendedor) – opcional, mas já deixo pronto.
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $data = $request->validate([
                'nome'           => 'required|string|max:255',
                'descricao'      => 'nullable|string',
                'imagem'         => 'nullable|string|max:255',
                'avaliacao'      => 'nullable|numeric|min:0|max:5',
                'status'         => 'boolean',
                'localizacao_id' => 'nullable|exists:localizacao,id',
            ]);

            $userId = Auth::id();

            $loja = Loja::create([
                'nome'           => $data['nome'],
                'descricao'      => $data['descricao'] ?? null,
                'imagem'         => $data['imagem'] ?? null,
                'avaliacao'      => $data['avaliacao'] ?? 0,
                'status'         => $data['status'] ?? false,
                'localizacao_id' => $data['localizacao_id'] ?? null,
                'user_id'        => $userId,
            ]);

            return response()->json($loja, 201);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Erro de validação.',
                'errors'  => $e->errors(),
            ], 422);
        }
    }

    /**
     * Atualiza loja (somente dono ou admin nivel 9).
     */
    public function update(Request $request, int $id): JsonResponse
    {
        $loja = Loja::find($id);

        if (!$loja) {
            return response()->json(['message' => 'Loja não encontrada.'], 404);
        }

        $user = $request->user();
        if ($loja->user_id !== $user->id && $user->nivel < 9) {
            return response()->json(['message' => 'Acesso negado.'], 403);
        }

        try {
            $data = $request->validate([
                'nome'           => 'sometimes|string|max:255',
                'descricao'      => 'sometimes|nullable|string',
                'imagem'         => 'sometimes|nullable|string|max:255',
                'avaliacao'      => 'sometimes|numeric|min:0|max:5',
                'status'         => 'sometimes|boolean',
                'localizacao_id' => 'sometimes|nullable|exists:localizacao,id',
            ]);

            $loja->update($data);

            return response()->json($loja);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Erro de validação.',
                'errors'  => $e->errors(),
            ], 422);
        }
    }

    /**
     * Remove loja (somente dono ou admin).
     */
    public function destroy(Request $request, int $id): JsonResponse
    {
        $loja = Loja::find($id);

        if (!$loja) {
            return response()->json(['message' => 'Loja não encontrada.'], 404);
        }

        $user = $request->user();
        if ($loja->user_id !== $user->id && $user->nivel < 9) {
            return response()->json(['message' => 'Acesso negado.'], 403);
        }

        $loja->delete();

        return response()->json(['message' => 'Loja removida com sucesso.'], 200);
    }
}
