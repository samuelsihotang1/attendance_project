<?php

namespace App\Livewire\Office;

use App\Models\Announcement;
use Livewire\Component;

class ViewOffice extends Component
{
    public Announcement $announcement;

    public function mount($slug)
    {
        $this->announcement = Announcement::whereSlug($slug)->firstOrFail();
    }

    public function render()
    {
        return view('office.view')->title("Berita - " . $this->announcement->title);
    }

    public function destroy()
    {
        $this->announcement->delete();
        return redirect()->route('announcement');
    }
}