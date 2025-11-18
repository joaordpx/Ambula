<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Produto extends Model
{
    use HasFactory;

    protected $table = 'produto';

    protected $fillable = [
        'nome',
        'valor',
        'descricao',
        'imagem',
        'categoria_produto_id',
    ];

    public function categoria()
    {
        return $this->belongsTo(CategoriaProduto::class, 'categoria_produto_id');
    }

    public function estoques()
    {
        return $this->hasMany(Estoque::class);
    }

    public function itens()
    {
        return $this->hasMany(ItensPedido::class, 'produto_id');
    }
}
