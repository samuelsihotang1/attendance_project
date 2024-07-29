<?php

namespace App\Livewire\Announcement;

use App\Models\User;
use Livewire\Component;

class ViewAnnouncement extends Component
{
    public User $user;

    public function mount($nip)
    {
        $this->user = User::whereNip($nip)->firstOrFail();
    }

    public function render()
    {
        return view('announcement.view')->title("Profil - " . $this->user->name);
    }
}