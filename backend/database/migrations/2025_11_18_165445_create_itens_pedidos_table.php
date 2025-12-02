<?php

use App\Models\Pedido;
use App\Models\Produto;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{

    public function up(): void
    {
        Schema::create('itens_pedidos', function (Blueprint $table) {
            $table->id();
            $table->foreignIdFor(Pedido::class)->constrained()->onDelete('cascade');
            $table->foreignIdFor(Produto::class)->constrained();
            $table->integer('quantidade');
            $table->timestamps();
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('itens_pedidos');
    }
};
