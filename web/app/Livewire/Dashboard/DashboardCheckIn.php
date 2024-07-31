<?php

namespace App\Livewire\Dashboard;

use App\Models\Office;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Livewire\Component;

class DashboardCheckIn extends Component
{
    protected $presentUsers;
    protected $absentUsers;
    protected $offices;
    protected $my_office;
    protected $office_id;

    public function mount()
    {
        $this->office_id = Auth::user()->office_id;
    }

    public function getData()
    {
        $this->getMyOffice();
        $this->getUsers();
        $this->getOffices();
    }

    public function render()
    {
        $this->getData();
        return view('dashboard.dashboard_check_in')->title("Absen Masuk");
    }

    protected function getUsers()
    {
        $users = User::where('office_id', $this->office_id)->with('attendancesInToday')->get();

        $this->presentUsers = $users->filter(function ($user) {
            return !$user->attendancesInToday->isEmpty();
        });

        $this->absentUsers = $users->filter(function ($user) {
            return $user->attendancesInToday->isEmpty();
        });
    }

    protected function getMyOffice()
    {
        $this->my_office = Office::where('id', $this->office_id)->first();
    }

    protected function getOffices()
    {
        $this->offices = Office::all();
    }

    public function setOffice($id)
    {
        $this->office_id = $id;
    }

    public function hydrate()
    {
        $this->dispatch('contentChanged');
    }
}
