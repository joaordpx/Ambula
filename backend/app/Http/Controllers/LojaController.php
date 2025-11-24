<?php

namespace App\Http\Controllers;

use App\Models\Loja;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class LojaController extends Controller
{
    
    public function index()
    {
        return response()->json(Loja::with(['user', 'localizacao'])->get());
    }

    
    public function store(Request $request)
    {
        
        if ($request->user()->nivel < 2) {
            return response()->json(['message' => 'Acesso negado. Você não tem permissão para criar lojas.'], 403);
        }

        try {
            $request->validate([
                'nome' => 'required|string|max:255',
                'descricao' => 'required|string',
                'header' => 'nullable|string',
                'localizacao_id' => 'nullable|exists:localizacao,id',
                
            ]);

            $loja = Loja::create([
                'nome' => $request->nome,
                'descricao' => $request->descricao,
                'header' => $request->header,
                'status' => true,
                'avaliacao' => 0.0,
                'localizacao_id' => $request->localizacao_id,
                'user_id' => $request->user()->id,
            ]);

            return response()->json([
                'message' => 'Loja criada com sucesso.',
                'loja' => $loja
            ], 201);

        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        }
    }

    
    public function show(string $id)
    {
        $loja = Loja::with(['user', 'localizacao'])->find($id);

        if (!$loja) {
            return response()->json(['message' => 'Loja não encontrada.'], 404);
        }

        return response()->json($loja);
    }

    
    public function update(Request $request, string $id)
    {
        $loja = Loja::find($id);

        if (!$loja) {
            return response()->json(['message' => 'Loja não encontrada.'], 404);
        }

        if ($loja->user_id !== $request->user()->id && $request->user()->nivel < 9) {
            return response()->json(['message' => 'Acesso negado. Você não é o dono desta loja.'], 403);
        }

        try {
            $request->validate([
                'nome' => 'required|string|max:255',
                'descricao' => 'required|string',
                'header' => 'nullable|string',
                'status' => 'required|boolean',
                'localizacao_id' => 'nullable|exists:localizacao,id',
            ]);

            $loja->update($request->all());

            return response()->json([
                'message' => 'Loja atualizada com sucesso.',
                'loja' => $loja
            ]);

        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        }
    }

    public function destroy(string $id)
    {
        $loja = Loja::find($id);

        if (!$loja) {
            return response()->json(['message' => 'Loja não encontrada.'], 404);
        }

        if ($loja->user_id !== request()->user()->id && request()->user()->nivel < 9) {
            return response()->json(['message' => 'Acesso negado. Você não é o dono desta loja.'], 403);
        }

    

        $loja->delete();

        return response()->json(['message' => 'Loja removida com sucesso.'], 200);
    }
}
