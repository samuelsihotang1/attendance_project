<?php

namespace App\Livewire\Employee;

use App\Models\User;
use Livewire\Component;

class ViewEmployee extends Component
{
    public User $user;

    public function mount($nip)
    {
        $this->user = User::whereNip($nip)->firstOrFail();
    }

    public function render()
    {
        return view('employee.view')->title("Profil - " . $this->user->name);
    }

    public function destroy()
    {
        $this->user->delete();
        return redirect()->route('employee');
    }
}