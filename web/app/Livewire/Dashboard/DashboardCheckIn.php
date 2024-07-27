<?php

namespace App\Livewire\Dashboard;

use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Livewire\Component;

class DashboardCheckIn extends Component
{
    protected $presentUsers;
    protected $absentUsers;

    public function mount()
    {
        $this->getUsers();
    }

    public function refresh()
    {
        $this->getUsers();
    }

    public function render()
    {
        return view('dashboard.dashboard_check_in')->title("Absen Masuk");
    }

    protected function getUsers()
    {
        $users = User::where('office_id', Auth::user()->office_id)->with('attendancesInToday')->get();

        $this->presentUsers = $users->filter(function ($user) {
            return !$user->attendancesInToday->isEmpty();
        });

        $this->absentUsers = $users->filter(function ($user) {
            return $user->attendancesInToday->isEmpty();
        });
    }
}
