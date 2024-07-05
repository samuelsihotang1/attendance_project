<?php

use App\Http\Controllers\Api\Auth\ApiAuthenticationController;
use App\Http\Controllers\Api\LocationController;
use App\Http\Controllers\Feed\FeedController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/register', [ApiAuthenticationController::class, 'register']);
Route::post('/login', [ApiAuthenticationController::class, 'login']);

// Agar harus authorize dengan token, gunakan middleware 'auth:sanctum'
Route::post('/feed/store', [FeedController::class, 'store'])->middleware('auth:sanctum');
Route::post('/checklocation', [LocationController::class, 'checkLocation'])->middleware('auth:sanctum');