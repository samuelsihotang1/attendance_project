<?php

namespace App\Livewire\Employee;

use App\Models\Office;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Livewire\Attributes\Validate;
use Livewire\WithFileUploads;
use Livewire\Component;

class CreateEmployee extends Component
{
    use WithFileUploads;

    public $photo;
    public $name;
    public $nip;
    public $role;
    public $rank;
    public $password;
    public $offices;
    public $office_id;
    public $my_office_id;

    public function mount()
    {
        $this->my_office_id = Auth::user()->office_id;
        $this->office_id = $this->my_office_id;
        $this->role = 'user';
    }

    public function render()
    {
        $this->getOffices();
        return view('employee.create')->title("Daftar Pegawai");
    }

    protected function upload($nip)
    {
        $this->photo->storeAs(path: 'assets/images/avatar', name: $nip . '.' . $this->photo->extension());
    }

    protected function getOffices()
    {
        $this->offices = Office::all();
    }

    protected function encryptPassword()
    {
        $this->password = bcrypt($this->password);
    }

    public function store()
    {
        $this->validate();
        $this->encryptPassword();
        $this->upload($this->nip);

        User::create([
            'name' => $this->name,
            'nip' => $this->nip,
            'role' => $this->role,
            'rank' => $this->rank,
            'password' => $this->password,
            'office_id' => $this->office_id,
            'photo' => $this->nip . '.' . $this->photo->extension()
        ]);

        return redirect()->route('employee');
    }

    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'nip' => ['required', 'string', 'max:255', 'unique:users,nip'],
            'role' => ['required', 'string', 'max:255'],
            'rank' => ['required', 'string', 'max:255'],
            'password' => ['required', 'string', 'max:255'],
            'office_id' => ['required', 'exists:offices,id'],
            'photo' => ['image', 'max:2048'],
        ];
    }
}