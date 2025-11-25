<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\Relations\HasMany;


use App\Models\Localizacao;
use App\Models\Loja;
use App\Models\Pedido;
use App\Models\Avaliacao;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'telefone',
        'cpf',
        'localizacao_id',
        'nivel',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }


    public function localizacao(): BelongsTo
    {
        return $this->belongsTo(Localizacao::class);
    }

    public function loja(): HasOne
    {
        return $this->hasOne(Loja::class);
    }

    public function pedidos(): HasMany
    {
        return $this->hasMany(Pedido::class);
    }

    public function avaliacoes(): HasMany
    {
        return $this->hasMany(Avaliacao::class);
    }

    
    protected $appends = ['is_vendedor'];

    public function getIsVendedorAttribute(): bool
    {
        return $this->loja()->exists();
    }
}
