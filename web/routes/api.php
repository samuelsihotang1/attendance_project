<?php

use App\Http\Controllers\Api\Auth\ApiAuthenticationController;
use App\Http\Controllers\Api\LocationController;
use App\Http\Controllers\Feed\FeedController;
use Illuminate\Support\Facades\Route;

// Authenticate
Route::post('/register', [ApiAuthenticationController::class, 'register']);
Route::post('/login', [ApiAuthenticationController::class, 'login']);

// Agar harus authorize dengan token, gunakan middleware 'auth:sanctum'
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/feed/store', [FeedController::class, 'store']);
    Route::post('/checklocation', [LocationController::class, 'checkLocation']);
});