<?php

namespace App\Livewire\Employee;

use App\Models\Office;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Livewire\Component;

class View extends Component
{
    public User $user;

    public function mount($nip)
    {
        $this->user = User::whereNip($nip)->firstOrFail();
    }

    public function render()
    {
        return view('employee.view')->title($this->user->name);
    }
}