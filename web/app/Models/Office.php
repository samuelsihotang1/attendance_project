<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Facades\Auth;

class Office extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'address',
        'latitude',
        'longitude',
    ];

    public function users(): HasMany
    {
        return $this->hasMany(User::class);
    }
}
