<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoriaProdutoController;
use App\Http\Controllers\LocalizacaoController;
use App\Http\Controllers\LojaController;
use App\Http\Controllers\ProdutoController;
use App\Http\Controllers\PedidoController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
// Rotas de Autenticação
Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);

// Rotas de Consulta Pública (Ex: Cardápio e Lojas)
Route::get('localizacoes', [LocalizacaoController::class, 'index']);
Route::get('lojas', [LojaController::class, 'index']);
Route::get('lojas/{loja}', [LojaController::class, 'show']);
Route::get('produtos', [ProdutoController::class, 'index']);
Route::get('produtos/{produto}', [ProdutoController::class, 'show']);



Route::middleware(['auth:sanctum'])->group(function () {
    
    // Rota para obter o usuário autenticado
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Rota de Logout
    Route::post('logout', [AuthController::class, 'logout']);
    //rotas para que assim o usuario atualizar sua localização
    Route::put('user/localizacao', [UserController::class, 'updateLocalizacao']);
    // CRUDs de Administração (Categorias, Produtos, Lojas, Localizações)
    
    // Categorias (Apenas Admin/Vendedor)
    Route::resource('categorias', CategoriaProdutoController::class)->except(['create', 'edit', 'index', 'show']);
    
    // Produtos (Apenas Admin/Vendedor)
    Route::resource('produtos', ProdutoController::class)->except(['create', 'edit', 'index', 'show']);

    // Lojas (Apenas Admin/Vendedor)
    Route::resource('lojas', LojaController::class)->except(['create', 'edit', 'index', 'show']);

    // Localizações (Apenas Admin)
    Route::post('localizacoes', [LocalizacaoController::class, 'store']);
    Route::put('localizacoes/{id}', [LocalizacaoController::class, 'update']);
    
    // Rotas de Pedidos
    Route::post('pedidos', [PedidoController::class, 'store']); // Criar Pedido
    Route::get('pedidos', [PedidoController::class, 'index']); // Listar Meus Pedidos
    Route::get('pedidos/{id}', [PedidoController::class, 'show']); // Ver Pedido Específico

    // Rota para Atualização de Status (Apenas para Vendedores/Admin)
    Route::put('pedidos/{id}/status', [PedidoController::class, 'updateStatus']);
});
