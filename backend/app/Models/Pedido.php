<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Pedido extends Model
{
    use HasFactory;

    protected $table = 'pedido';

    protected $fillable = [
        'user_id',
        'status_pedido_id',
        'localizacao_id',
        'loja_id',
        'pagamento',
    ];

    protected $casts = [
        'pagamento' => 'boolean',
    ];

    public function toArrayResponse()
    {
        return [
            'id' => $this->id,
            'loja_id' => $this->loja_id,
            'loja_nome' => $this->loja->nome ?? null,
            'status' => $this->status,
            'total' => $this->valor_total,
            'created_at' => $this->created_at,
            'cliente_nome' => $this->user->name ?? null,
            'cliente_telefone' => $this->user->telefone ?? null,
            'local_entrega' => $this->localEntrega->nome ?? null,
            'itens' => $this->itens->map(function ($i) {
                return [
                    'nome' => $i->produto->nome,
                    'quantidade' => $i->quantidade
                ];
            })
        ];
    }



    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function status(): BelongsTo
    {
        return $this->belongsTo(StatusPedido::class, 'status_pedido_id');
    }

    public function loja(): BelongsTo
    {
        return $this->belongsTo(Loja::class);
    }

    public function itens(): HasMany
    {
        return $this->hasMany(ItensPedido::class);
    }

    public function localizacao(): BelongsTo
    {
        return $this->belongsTo(Localizacao::class);
    }
}
