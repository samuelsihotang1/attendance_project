<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::create([
            'office_id' => 1,
            'name' => 'John Doe',
            'nip' => '1234567890',
            'photo' => 'photo1.jpg',
            'rank' => 'Manager',
            'password' => Hash::make('password1'),
        ]);

        User::create([
            'office_id' => 2,
            'name' => 'Jane Smith',
            'nip' => '2345678901',
            'photo' => 'photo2.jpg',
            'rank' => 'Assistant Manager',
            'password' => Hash::make('password2'),
        ]);

        User::create([
            'office_id' => 3,
            'name' => 'Alice Johnson',
            'nip' => '3456789012',
            'photo' => 'photo3.jpg',
            'rank' => 'Senior Developer',
            'password' => Hash::make('password3'),
        ]);

        User::create([
            'office_id' => 4,
            'name' => 'Bob Brown',
            'nip' => '4567890123',
            'photo' => 'photo4.jpg',
            'rank' => 'Developer',
            'password' => Hash::make('password4'),
        ]);

        User::create([
            'office_id' => 5,
            'name' => 'Charlie Davis',
            'nip' => '5678901234',
            'photo' => 'photo5.jpg',
            'rank' => 'Intern',
            'password' => Hash::make('password5'),
        ]);
    }
}
