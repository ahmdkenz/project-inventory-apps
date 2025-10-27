<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Supplier extends Model
{
    protected $fillable = [
        'nama',
        'kontak_person',
        'telepon',
        'email',
        'alamat'
    ];
}
