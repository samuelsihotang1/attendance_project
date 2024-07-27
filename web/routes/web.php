<?php

use App\Http\Controllers\AuthenticationController;
use App\Livewire\Homepage;
use App\Livewire\Login;
use Illuminate\Support\Facades\Route;
use App\Livewire\Counter;

Route::get('/login', Login::class)->name('login');
Route::post('/logout', [Login::class, 'logout'])->name('logout');

Route::middleware('auth:sanctum')->group(function () {
    Route::get(
        '/welcome',
        function () {
            return view('welcome');
        }
    );
    Route::get('/', Homepage::class);
});
