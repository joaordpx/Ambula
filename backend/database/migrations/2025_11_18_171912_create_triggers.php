<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Trigger: ao inserir item no pedido, descontar do estoque
        DB::unprepared('
            CREATE TRIGGER trg_itens_pedidos_after_insert
            AFTER INSERT ON itens_pedidos
            BEGIN
                UPDATE estoque
                   SET quantidade = quantidade - NEW.quantidade
                 WHERE loja_id = (
                           SELECT loja_id
                             FROM pedido
                            WHERE id = NEW.pedido_id
                       )
                   AND produto_id = NEW.produto_id;
            END;
        ');

        // Trigger: ao inserir avaliação, recalcular média da loja
        DB::unprepared('
            CREATE TRIGGER trg_avaliacao_after_insert
            AFTER INSERT ON avaliacao
            BEGIN
                UPDATE loja
                   SET avaliacao = (
                       SELECT AVG(nota)
                         FROM avaliacao
                        WHERE loja_id = NEW.loja_id
                   )
                 WHERE id = NEW.loja_id;
            END;
        ');

        // Trigger: ao atualizar avaliação, recalcular média da loja
        DB::unprepared('
            CREATE TRIGGER trg_avaliacao_after_update
            AFTER UPDATE ON avaliacao
            BEGIN
                UPDATE loja
                   SET avaliacao = (
                       SELECT AVG(nota)
                         FROM avaliacao
                        WHERE loja_id = NEW.loja_id
                   )
                 WHERE id = NEW.loja_id;
            END;
        ');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::unprepared('DROP TRIGGER IF EXISTS trg_itens_pedidos_after_insert;');
        DB::unprepared('DROP TRIGGER IF EXISTS trg_avaliacao_after_insert;');
        DB::unprepared('DROP TRIGGER IF EXISTS trg_avaliacao_after_update;');
    }
};
