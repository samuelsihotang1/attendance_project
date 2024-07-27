<?php

namespace App\Livewire;

use App\Models\Attendance;
use App\Models\Office;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Livewire\Component;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class DashboardCheckIn extends Component
{
    protected $office;
    protected $presentUsers;
    protected $absentUsers;

    public function mount()
    {
        $this->getOffice();
        $this->getUsers();
    }

    public function refresh()
    {
        $this->getOffice();
        $this->getUsers();
    }

    public function render()
    {
        return view('dashboard_check_in')->title("Dashboard");
    }

    protected function getOffice()
    {
        $this->office = Office::find(Auth::user()->office_id);
    }

    protected function getUsers()
    {
        $users = User::where('office_id', $this->office->id)->with('attendancesInToday')->get();

        $this->presentUsers = $users->filter(function ($user) {
            return !$user->attendancesInToday->isEmpty();
        });

        $this->absentUsers = $users->filter(function ($user) {
            return $user->attendancesInToday->isEmpty();
        });
    }

}
