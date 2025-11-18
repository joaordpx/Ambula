<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

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

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function localizacao()
    {
        return $this->belongsTo(Localizacao::class);
    }

    public function pedidos()
    {
        return $this->hasMany(Pedido::class);
    }

    public function estoques()
    {
        return $this->hasMany(Estoque::class);
    }

    public function avaliacoes()
    {
        return $this->hasMany(Avaliacao::class);
    }
}
