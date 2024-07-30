<?php

use App\Http\Controllers\Api\AnnouncementController;
use App\Http\Controllers\Api\AttendanceController;
use App\Http\Controllers\Api\AuthenticationController;
use Illuminate\Support\Facades\Route;

// Authenticate
Route::post('/register', [AuthenticationController::class, 'register']);
Route::post('/login', [AuthenticationController::class, 'login']);

// Agar harus authorize dengan token, gunakan middleware 'auth:sanctum'
Route::middleware('auth:sanctum')->group(function () {
    // Attendance
    Route::post('/attendance/validate', [AttendanceController::class, 'validateAttendance']);
    Route::post('/attendance/store', [AttendanceController::class, 'store']);
    Route::get('/attendance/all', [AttendanceController::class, 'getAllData']);

    // Announcement
    Route::get('/announcement/all', [AnnouncementController::class, 'getAllData']);

    // Test
    // Route::post('/test', [AttendanceController::class, 'checkTime']);
});