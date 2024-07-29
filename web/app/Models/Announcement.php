<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Announcement extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'content',
        'office_id',
        'slug'
    ];

    public function office(): BelongsTo
    {
        return $this->belongsTo(Office::class);
    }
}
