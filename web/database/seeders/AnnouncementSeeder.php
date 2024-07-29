<?php

namespace Database\Seeders;

use App\Models\Announcement;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AnnouncementSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Announcement::create([
            'title' => 'Office Closure',
            'slug' => 'office-closure',
            'content' => 'The office will be closed on July 4th for Independence Day.',
        ]);

        Announcement::create([
            'title' => 'New Policy Update',
            'slug' => 'new-policy-update',
            'content' => 'Please review the new company policies updated on the HR portal.',
        ]);

        Announcement::create([
            'title' => 'Team Meeting',
            'slug' => 'team-meeting',
            'content' => 'There will be a team meeting on Friday at 10 AM in the conference room.',
        ]);

        Announcement::create([
            'title' => 'Holiday Schedule',
            'slug' => 'holiday-schedule',
            'content' => 'The holiday schedule for the upcoming year has been posted on the intranet.',
        ]);

        Announcement::create([
            'title' => 'Office Maintenance',
            'slug' => 'office-maintenance',
            'content' => 'Office maintenance will occur this weekend. Please ensure your desks are cleared.',
        ]);
    }
}
