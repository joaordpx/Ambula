<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Só cria se as tabelas existirem
        if (
            Schema::hasTable('itens_pedidos') &&
            Schema::hasTable('estoque') &&
            Schema::hasTable('pedidos')
        ) {
            // Trigger: descontar do estoque ao inserir item
            DB::unprepared('
                CREATE TRIGGER trg_itens_pedidos_after_insert
                AFTER INSERT ON itens_pedidos
                FOR EACH ROW
                BEGIN
                    UPDATE estoque
                    SET quantidade = quantidade - NEW.quantidade
                    WHERE loja_id = (
                        SELECT loja_id
                        FROM pedidos
                        WHERE id = NEW.pedido_id
                    )
                    AND produto_id = NEW.produto_id;
                END;
            ');
        }

        if (Schema::hasTable('avaliacao') && Schema::hasTable('loja')) {

            // Trigger: recalcular média ao inserir avaliação
            DB::unprepared('
                CREATE TRIGGER trg_avaliacao_after_insert
                AFTER INSERT ON avaliacao
                FOR EACH ROW
                BEGIN
                    UPDATE loja
                    SET avaliacao = (
                        SELECT AVG(nota) FROM avaliacao WHERE loja_id = NEW.loja_id
                    )
                    WHERE id = NEW.loja_id;
                END;
            ');

            // Trigger: recalcular média ao atualizar avaliação
            DB::unprepared('
                CREATE TRIGGER trg_avaliacao_after_update
                AFTER UPDATE ON avaliacao
                FOR EACH ROW
                BEGIN
                    UPDATE loja
                    SET avaliacao = (
                        SELECT AVG(nota) FROM avaliacao WHERE loja_id = NEW.loja_id
                    )
                    WHERE id = NEW.loja_id;
                END;
            ');
        }
    }

    public function down(): void
    {
        DB::unprepared('DROP TRIGGER IF EXISTS trg_itens_pedidos_after_insert;');
        DB::unprepared('DROP TRIGGER IF EXISTS trg_avaliacao_after_insert;');
        DB::unprepared('DROP TRIGGER IF EXISTS trg_avaliacao_after_update;');
    }
};
