<?php

use App\Http\Controllers\Api\AuthenticationController;
use App\Http\Controllers\Api\FeedController;
use App\Http\Controllers\Api\LocationController;
use Illuminate\Support\Facades\Route;

// Authenticate
Route::post('/register', [AuthenticationController::class, 'register']);
Route::post('/login', [AuthenticationController::class, 'login']);

// Agar harus authorize dengan token, gunakan middleware 'auth:sanctum'
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/feed/store', [FeedController::class, 'store']);
    Route::post('/checklocation', [LocationController::class, 'checkLocation']);
});