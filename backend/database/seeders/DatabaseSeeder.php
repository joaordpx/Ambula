<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Localizacao;
use App\Models\CategoriaProduto;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // -----------------------------------------
        // LOCALIZAÇÕES (Prédio 1, 2 e 3)
        // -----------------------------------------
        $locais = [
            [
                'nome' => 'Prédio 1 - CCSA',
                'descricao' => 'Centro de Ciências Sociais Aplicadas.',
                'latitude' => -16.726300,
                'longitude' => -43.861900,
            ],
            [
                'nome' => 'Prédio 2 - CCH',
                'descricao' => 'Centro de Ciências Humanas.',
                'latitude' => -16.726900,
                'longitude' => -43.861200,
            ],
            [
                'nome' => 'Prédio 3 - CCET',
                'descricao' => 'Centro de Ciências Exatas e Tecnológicas.',
                'latitude' => -16.727400,
                'longitude' => -43.860800,
            ],
        ];

        foreach ($locais as $local) {
            Localizacao::create($local);
        }

        // -----------------------------------------
        // CATEGORIAS DE PRODUTO
        // -----------------------------------------
        $categorias = [
            'Salgados',
            'Doces',
            'Bebidas',
            'Lanches',
            'Refeições',
            'Açaí',
            'Café',
            'Snacks',
            'Saudável',
            'Massas',
        ];

        foreach ($categorias as $descricao) {
            CategoriaProduto::create(['descricao' => $descricao]);
        }

        $status = [
            'emAndamento',
            'entregue',
            'cancelado',
            'pronto',
            'emPreparo',
            'novo',

        ];

        foreach ($categorias as $descricao) {
            CategoriaProduto::create(['descricao' => $descricao]);
        }
    }
}
