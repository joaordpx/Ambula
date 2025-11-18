<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Estoque extends Model
{
    use HasFactory;

    protected $table = 'estoque';

    protected $fillable = [
        'loja_id',
        'produto_id',
        'quantidade',
    ];

    public function loja()
    {
        return $this->belongsTo(Loja::class);
    }

    public function produto()
    {
        return $this->belongsTo(Produto::class);
    }
}
