<?php

namespace App\Livewire\Dashboard;

use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Livewire\Component;

class DashboardCheckOut extends Component
{
    protected $presentUsers;
    protected $absentUsers;

    public function render()
    {
        $this->getUsers();
        return view('dashboard.dashboard_check_out')->title("Absen Pulang");
    }

    protected function getUsers()
    {
        $users = User::where('office_id', Auth::user()->office_id)->with('attendancesOutToday')->get();

        $this->presentUsers = $users->filter(function ($user) {
            return !$user->attendancesOutToday->isEmpty();
        });

        $this->absentUsers = $users->filter(function ($user) {
            return $user->attendancesOutToday->isEmpty();
        });
    }

    public function hydrate()
    {
        $this->dispatch('contentChanged');
    }
}
