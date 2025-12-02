<?php

namespace App\Http\Controllers;

use App\Models\Localizacao;
use Illuminate\Http\JsonResponse;

class LocalizacaoController extends Controller
{
    /**
     * Lista todos os locais de entrega (tabela localizacao).
     */
    public function index(): JsonResponse
    {
        $locais = Localizacao::orderBy('descricao')->get();

        // Retorna algo simples: [ { id, descricao }, ... ]
        return response()->json($locais);
    }
}
