<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Localizacao extends Model
{
    use HasFactory;

    protected $table = 'localizacao';

    protected $fillable = [
        'descricao',
    ];

    public function users(): HasMany
    {
        return $this->hasMany(User::class, 'localizacao_id');
    }
}
