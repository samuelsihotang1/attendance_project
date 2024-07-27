<?php

use App\Livewire\DashboardCheckIn;
use App\Livewire\DashboardCheckOut;
use App\Livewire\Login;
use Illuminate\Support\Facades\Route;

Route::middleware('guest')->group(function () {
    Route::get('/login', Login::class)->name('login');
});

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [Login::class, 'logout'])->name('logout');
    Route::get(
        '/welcome',
        function () {
            return view('welcome');
        }
    );
    Route::get('/', DashboardCheckIn::class);
    Route::get('/out', DashboardCheckOut::class);
});

Route::get('/test', [DashboardCheckIn::class, 'getUsers']);