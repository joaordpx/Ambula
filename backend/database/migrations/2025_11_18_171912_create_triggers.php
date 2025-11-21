<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Trigger: ao inserir item no pedido, descontar do estoque
        DB::unprepared('
            CREATE TRIGGER trg_itens_pedidos_after_insert
            AFTER INSERT ON itens_pedidos
            FOR EACH ROW
                UPDATE estoque
                   SET quantidade = quantidade - NEW.quantidade
                 WHERE loja_id = (
                           SELECT loja_id
                             FROM pedido
                            WHERE id = NEW.pedido_id
                       )
                   AND produto_id = NEW.produto_id;
        ');

        // Trigger: ao inserir avaliação, recalcular média da loja
        DB::unprepared('
            CREATE TRIGGER trg_avaliacao_after_insert
            AFTER INSERT ON avaliacao
            FOR EACH ROW
                UPDATE loja
                   SET avaliacao = (
                       SELECT AVG(nota)
                         FROM avaliacao
                        WHERE loja_id = NEW.loja_id
                   )
                 WHERE id = NEW.loja_id;
        ');

        // Trigger: ao atualizar avaliação, recalcular média da loja
        DB::unprepared('
            CREATE TRIGGER trg_avaliacao_after_update
            AFTER UPDATE ON avaliacao
            FOR EACH ROW
                UPDATE loja
                   SET avaliacao = (
                       SELECT AVG(nota)
                         FROM avaliacao
                        WHERE loja_id = NEW.loja_id
                   )
                 WHERE id = NEW.loja_id;
        ');
    }

    public function down(): void
    {
        DB::unprepared('DROP TRIGGER IF EXISTS trg_itens_pedidos_after_insert;');
        DB::unprepared('DROP TRIGGER IF EXISTS trg_avaliacao_after_insert;');
        DB::unprepared('DROP TRIGGER IF EXISTS trg_avaliacao_after_update;');
    }
};
