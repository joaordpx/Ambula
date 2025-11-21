<?php

namespace App\Http\Controllers;

use App\Models\CategoriaProduto;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class CategoriaProdutoController extends Controller
{
    
    public function index()
    {
        return response()->json(CategoriaProduto::all());
    }

    public function store(Request $request)
    {
        try {
            $request->validate([
                'descricao' => 'required|string|max:255|unique:categoria_produto,descricao',
            ]);

            $categoria = CategoriaProduto::create($request->all());

            return response()->json([
                'message' => 'Categoria criada com sucesso.',
                'categoria' => $categoria
            ], 201);

        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        }
    }

    public function show(string $id)
    {
        $categoria = CategoriaProduto::find($id);

        if (!$categoria) {
            return response()->json(['message' => 'Categoria não encontrada.'], 404);
        }

        return response()->json($categoria);
    }

    /**
     * PUT/PATCH /api/categorias/{id} - Atualiza uma categoria.
     */
    public function update(Request $request, string $id)
    {
        $categoria = CategoriaProduto::find($id);

        if (!$categoria) {
            return response()->json(['message' => 'Categoria não encontrada.'], 404);
        }

        try {
            $request->validate([
                'descricao' => 'required|string|max:255|unique:categoria_produto,descricao,' . $id,
            ]);

            $categoria->update($request->all());

            return response()->json([
                'message' => 'Categoria atualizada com sucesso.',
                'categoria' => $categoria
            ]);

        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        }
    }

    
    public function destroy(string $id)
    {
        $categoria = CategoriaProduto::find($id);

        if (!$categoria) {
            return response()->json(['message' => 'Categoria não encontrada.'], 404);
        }

        if ($categoria->produtos()->count() > 0) {
            return response()->json(['message' => 'Não é possível deletar. Existem produtos associados a esta categoria.'], 409);
        }

        $categoria->delete();

        return response()->json(['message' => 'Categoria removida com sucesso.'], 200);
    }
}
