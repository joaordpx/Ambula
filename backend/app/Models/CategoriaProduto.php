<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class CategoriaProduto extends Model
{
    use HasFactory;

    protected $table = 'categoria_produto';

    protected $fillable = [
        'descricao',
    ];

    
    public function produtos(): HasMany
    {
        return $this->hasMany(Produto::class, 'categoria_produto_id');
    }
}