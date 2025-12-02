<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasManyThrough;

class Loja extends Model
{
    use HasFactory;

    protected $table = 'loja';

    protected $fillable = [
        'nome',
        'descricao',
        'header',
        'avaliacao',
        'status',
        'localizacao_id',
        'user_id',
    ];

    protected $casts = [
        'status'    => 'boolean',
        'avaliacao' => 'decimal:2',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function localizacao(): BelongsTo
    {
        return $this->belongsTo(Localizacao::class);
    }

    public function estoques(): HasMany
    {
        return $this->hasMany(Estoque::class);
    }

    /**
     * Acesso aos produtos por meio da tabela estoque.
     */
    public function produtos(): HasManyThrough
    {
        return $this->hasManyThrough(
            Produto::class,
            Estoque::class,
            'loja_id',   // FK em estoque
            'id',        // PK em produto
            'id',        // PK em loja
            'produto_id' // FK em estoque
        );
    }
}
