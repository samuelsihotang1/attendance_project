<?php

use App\Http\Controllers\AuthenticationController;
use App\Livewire\Login;
use Illuminate\Support\Facades\Route;
use App\Livewire\Counter;

Route::get('/login', Login::class)->name('login');
Route::post('/logout', [Login::class , 'logout'])->name('logout');

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/', function () {
            return view('welcome');
        }
        );
        Route::get('/counter', Counter::class);
    });
