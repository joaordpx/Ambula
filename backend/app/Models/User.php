<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'telefone',
        'cpf',
        'localizacao_id',
        'nivel',
    ];


    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }


    public function localizacao()
    {
        return $this->belongsTo(Localizacao::class);
    }

    public function loja()
    {
        return $this->hasOne(Loja::class);
    }

    public function pedidos()
    {
        return $this->hasMany(Pedido::class);
    }

    public function avaliacoes()
    {
        return $this->hasMany(Avaliacao::class);
    }

    protected $appends = ['is_vendedor'];

    public function getIsVendedorAttribute() : bool {
        return $this->loja()->exists();
    }
}
