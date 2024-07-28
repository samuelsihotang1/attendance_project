<?php

use App\Livewire\Dashboard\DashboardCheckIn;
use App\Livewire\Dashboard\DashboardCheckOut;
use App\Livewire\Auth\Login;
use App\Livewire\Employee\Employee;
use Illuminate\Support\Facades\Route;

Route::middleware('guest')->group(function () {
    Route::get('/login', Login::class)->name('login');
});

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [Login::class, 'logout'])->name('logout');
    Route::get('/', DashboardCheckIn::class);
    Route::get('/out', DashboardCheckOut::class);
    Route::get('/employee', Employee::class);
});

// Route::get('/test', [DashboardCheckIn::class, 'getUsers']);