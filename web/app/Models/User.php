<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'office_id',
        'name',
        'nip',
        'photo',
        'rank',
        'password',
        'role',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'password' => 'hashed',
        ];
    }

    public function office(): BelongsTo
    {
        return $this->belongsTo(Office::class);
    }

    public function attendances(): HasMany
    {
        return $this->hasMany(Attendance::class);
    }

    public function attendancesInToday(): HasMany
    {
        return $this->hasMany(Attendance::class)
            ->where('created_at', '>=', Carbon::today()->startOfDay())
            ->where('created_at', '<=', Carbon::today()->endOfDay())
            ->where('type', 'in');
    }

    public function attendancesOutToday(): HasMany
    {
        return $this->hasMany(Attendance::class)
            ->where('created_at', '>=', Carbon::today()->startOfDay())
            ->where('created_at', '<=', Carbon::today()->endOfDay())
            ->where('type', 'out');
    }
}
