<?php

use App\Livewire\Dashboard\DashboardCheckIn;
use App\Livewire\Dashboard\DashboardCheckOut;
use App\Livewire\Auth\Login;
use App\Livewire\Employee\CreateEmployee;
use App\Livewire\Employee\EditEmployee;
use App\Livewire\Employee\Employee;
use App\Livewire\Employee\ViewEmployee;
use Illuminate\Support\Facades\Route;

Route::middleware('guest')->group(function () {
    Route::get('/login', Login::class)->name('login');
});

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [Login::class, 'logout'])->name('logout');
    Route::get('/', DashboardCheckIn::class)->name('checkin');
    Route::get('/out', DashboardCheckOut::class)->name('checkout');
    Route::get('/employee', Employee::class)->name('employee');
    Route::get('/employee/create', CreateEmployee::class)->name('employee.create');
    Route::get('/employee/view/{nip}', ViewEmployee::class)->name('employee.view');
    Route::get('/employee/edit/{nip}', EditEmployee::class)->name('employee.edit');
});

// Route::get('/test', [DashboardCheckIn::class, 'getUsers']);