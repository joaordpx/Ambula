<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Avaliacao extends Model
{
    use HasFactory;

    protected $table = 'avaliacao';

    protected $fillable = [
        'pedido_id',
        'user_id',
        'loja_id',
        'nota',
    ];

    public function pedido()
    {
        return $this->belongsTo(Pedido::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function loja()
    {
        return $this->belongsTo(Loja::class);
    }
}
