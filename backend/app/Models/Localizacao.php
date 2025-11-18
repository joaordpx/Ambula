<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Localizacao extends Model
{
    use HasFactory;

    protected $table = 'localizacao';

    protected $fillable = [
        'descricao',
    ];

    public function users()
    {
        return $this->hasMany(User::class);
    }

    public function lojas()
    {
        return $this->hasMany(Loja::class);
    }
}
