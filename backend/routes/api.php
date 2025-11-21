<?php

use App\Http\Controllers\AuthController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\ProdutoController; 
use App\Http\Controllers\LojaController; 
use App\Http\Controllers\PedidoController;



Route::middleware(['auth:sanctum'])->group(function () {
    

    Route::resource('produtos', ProdutoController::class)->except(['create', 'edit']);
    
    
    Route::resource('lojas', LojaController::class)->except(['create', 'edit', 'index', 'show']);
    
    
    Route::post('pedidos', [PedidoController::class, 'store']);

    Route::get('pedidos', [PedidoController::class, 'index']);
    
    Route::get('pedidos/{id}', [PedidoController::class, 'show']);

    
    Route::put('pedidos/{id}/status', [PedidoController::class, 'updateStatus']);
    

    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    
    Route::get('/me', function (Request $request) {
        return response()->json([
            'user' => $request->user(),
        ]);
    });
    
    Route::post('logout', [AuthController::class, 'logout']);

});



Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);


Route::get('lojas', [LojaController::class, 'index']);
Route::get('lojas/{loja}', [LojaController::class, 'show']);



Route::get('/debug-path', function () {
    return base_path();
});