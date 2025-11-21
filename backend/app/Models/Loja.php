<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Loja extends Model
{
    use HasFactory;

    protected $table = 'loja';

    protected $fillable = [
        'nome',
        'descricao',
        'header',
        'status',
        'avaliacao',
        'localizacao_id',
        'user_id',
    ];

    protected $casts = [
        'status' => 'boolean',
        'avaliacao' => 'float',
    ];

    
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function localizacao(): BelongsTo
    {
        return $this->belongsTo(Localizacao::class);
    }
    

}
