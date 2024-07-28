<?php

namespace App\Livewire\Employee;

use App\Models\Office;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Employee extends Component
{
    use WithPagination;

    protected $users;
    protected $offices;
    protected $my_office;
    protected $office_id;

    public function mount()
    {
        $this->office_id = Auth::user()->office_id;
        $this->getData();
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
        return view('employee.employee')->title("Pegawai");
    }

    protected function getMyOffice()
    {
        $this->my_office = Office::where('id', $this->office_id)->first();
    }

    protected function getUsers()
    {
        $this->users = User::where('office_id', $this->office_id)->paginate(1);
    }

    protected function getOffices()
    {
        $this->offices = Office::all();
    }

    public function setOffice($id)
    {
        $this->office_id = $id;
    }
}
