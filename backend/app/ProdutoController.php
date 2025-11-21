<?php

namespace App\Http\Controllers;

use App\Models\Produto;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;

class ProdutoController extends Controller
{
    /**
     * GET /api/produtos - Lista todos os produtos.
     */
    public function index()
    {
        return response()->json(Produto::with('categoria')->get());
    }

    /**
     * POST /api/produtos - Cria um novo produto.
     */
    public function store(Request $request)
    {
        try {
            
            $request->validate([
                'nome' => 'required|string|max:255',
                'valor' => 'required|numeric|min:0.01',
                'descricao' => 'required|string',
                'categoria_produto_id' => 'required|exists:categoria_produto,id',
                'imagem' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048', // Regra para upload de imagem
            ]);

            $data = $request->except('imagem');
            $data['imagem'] = null;

            
            if ($request->hasFile('imagem')) {
                
                $path = $request->file('imagem')->store('produtos', 'public');
                $data['imagem'] = $path;
            }

            $produto = Produto::create($data);

            return response()->json([
                'message' => 'Produto criado com sucesso.',
                'produto' => $produto
            ], 201);

        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erro ao criar produto.', 'error' => $e->getMessage()], 500);
        }
    }

    /**
     * GET /api/produtos/{id} - Mostra um produto específico.
     */
    public function show(string $id)
    {
        $produto = Produto::with('categoria')->find($id);

        if (!$produto) {
            return response()->json(['message' => 'Produto não encontrado.'], 404);
        }

        return response()->json($produto);
    }

    /**
     * PUT/PATCH /api/produtos/{id} - Atualiza um produto.
     */
    public function update(Request $request, string $id)
    {
        $produto = Produto::find($id);

        if (!$produto) {
            return response()->json(['message' => 'Produto não encontrado.'], 404);
        }

        try {
            $request->validate([
                'nome' => 'required|string|max:255',
                'valor' => 'required|numeric|min:0.01',
                'descricao' => 'required|string',
                'categoria_produto_id' => 'required|exists:categoria_produto,id',
                'imagem' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            ]);

            $data = $request->except('imagem');

            if ($request->hasFile('imagem')) {
                
                if ($produto->imagem) {
                    Storage::disk('public')->delete($produto->imagem);
                }
                
                $path = $request->file('imagem')->store('produtos', 'public');
                $data['imagem'] = $path;
            }

            
            $produto->update($data);

            return response()->json([
                'message' => 'Produto atualizado com sucesso.',
                'produto' => $produto
            ]);

        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Erro ao atualizar produto.', 'error' => $e->getMessage()], 500);
        }
    }

    public function destroy(string $id)
    {
        $produto = Produto::find($id);

        if (!$produto) {
            return response()->json(['message' => 'Produto não encontrado.'], 404);
        }

        
        if ($produto->imagem) {
            Storage::disk('public')->delete($produto->imagem);
        }

        $produto->delete();

        return response()->json(['message' => 'Produto removido com sucesso.'], 200);
    }
}
