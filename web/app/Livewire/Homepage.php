<?php

namespace App\Livewire;

use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Livewire\Component;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class Homepage extends Component
{
    public function render()
    {
        return view('homepage')->title("Homepage");
    }
}
