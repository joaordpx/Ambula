<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoriaProdutoController;
use App\Http\Controllers\HomeController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\LocalizacaoController;
use App\Http\Controllers\ProdutoController;
use App\Http\Controllers\LojaController;
use App\Http\Controllers\PedidoController;
use App\Http\Controllers\SearchController;


Route::middleware(['auth:sanctum'])->group(function () {


    Route::resource('produtos', ProdutoController::class)->except(['create', 'edit']);


    Route::post('lojas', [LojaController::class, 'store']);
    Route::put('lojas/{loja}', [LojaController::class, 'update']);
    Route::delete('lojas/{loja}', [LojaController::class, 'destroy']);

    Route::post('produtos', [ProdutoController::class, 'store']);
    Route::put('produtos/{produto}', [ProdutoController::class, 'update']);
    Route::delete('produtos/{produto}', [ProdutoController::class, 'destroy']);


    Route::get('/pedidos', [PedidoController::class, 'index']);
    Route::get('/pedidos/{id}', [PedidoController::class, 'show']);
    Route::post('/pedidos', [PedidoController::class, 'store']);


    Route::put('pedidos/{id}/status', [PedidoController::class, 'updateStatus']);


    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    Route::get('/me', function (Request $request) {
        return response()->json([
            'user' => $request->user(),
        ]);
    });

    Route::put('/me', [AuthController::class, 'updateProfile']);

    Route::post('logout', [AuthController::class, 'logout']);
});


// Auth público
Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);

// Lojas públicas
Route::get('lojas', [LojaController::class, 'index']);
Route::get('lojas/{loja}', [LojaController::class, 'show']);

// Categorias de produto
Route::get('categorias-produto', [CategoriaProdutoController::class, 'index']);

// Endpoints da Home
Route::get('home/lojas-populares', [HomeController::class, 'lojasPopulares']);
Route::get('home/mais-amados', [HomeController::class, 'maisAmados']);
Route::get('home/disponiveis-agora', [HomeController::class, 'disponiveisAgora']);

Route::get('/localizacoes', [LocalizacaoController::class, 'index']);


Route::get('search', [SearchController::class, 'search']);

Route::get('lojas', [LojaController::class, 'index']);
Route::get('lojas/{loja}', [LojaController::class, 'show']);

Route::get('produtos', [ProdutoController::class, 'index']);
Route::get('produtos/{produto}', [ProdutoController::class, 'show']);

// Debug opcional
Route::get('/debug-path', function () {
    return base_path();
});
