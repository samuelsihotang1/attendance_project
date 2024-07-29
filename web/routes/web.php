<?php

use App\Livewire\Dashboard\DashboardCheckIn;
use App\Livewire\Dashboard\DashboardCheckOut;
use App\Livewire\Auth\Login;
use App\Livewire\Employee\CreateEmployee;
use App\Livewire\Employee\EditEmployee;
use App\Livewire\Employee\ListEmployee;
use App\Livewire\Employee\ViewEmployee;
use Illuminate\Support\Facades\Route;

Route::middleware('guest')->group(function () {
    // Auth
    Route::get('/login', Login::class)->name('login');
});

Route::middleware('auth:sanctum')->group(function () {
    // Auth
    Route::post('/logout', [Login::class, 'logout'])->name('logout');

    // Dashboard
    Route::get('/', DashboardCheckIn::class)->name('checkin');
    Route::get('/out', DashboardCheckOut::class)->name('checkout');

    // Employee
    Route::get('/employee', ListEmployee::class)->name('employee');
    Route::get('/employee/create', CreateEmployee::class)->name('employee.create');
    Route::get('/employee/view/{nip}', ViewEmployee::class)->name('employee.view');
    Route::get('/employee/edit/{nip}', EditEmployee::class)->name('employee.edit');
});