<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pedido extends Model
{
    use HasFactory;

    protected $table = 'pedido';

    protected $fillable = [
        'user_id',
        'status_pedido_id',
        'loja_id',
        'pagamento',
    ];

    protected $casts = [
        'pagamento' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function loja()
    {
        return $this->belongsTo(Loja::class);
    }

    public function status()
    {
        return $this->belongsTo(StatusPedido::class, 'status_pedido_id');
    }

    public function itens()
    {
        return $this->hasMany(ItensPedido::class);
    }

    public function avaliacao()
    {
        // normalmente um pedido tem no máximo 1 avaliação
        return $this->hasOne(Avaliacao::class);
    }
}