<?php

namespace Database\Seeders;

use App\Models\User;
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
            'photo' => '1.png',
            'rank' => 'Manager',
            'password' => Hash::make('password1'),
        ]);

        User::create([
            'office_id' => 2,
            'name' => 'Jane Smith',
            'nip' => '2345678901',
            'photo' => '1.png',
            'rank' => 'Assistant Manager',
            'password' => Hash::make('password2'),
        ]);

        User::create([
            'office_id' => 3,
            'name' => 'Alice Johnson',
            'nip' => '3456789012',
            'photo' => '1.png',
            'rank' => 'Senior Developer',
            'password' => Hash::make('password3'),
        ]);

        User::create([
            'office_id' => 4,
            'name' => 'Bob Brown',
            'nip' => '4567890123',
            'photo' => '1.png',
            'rank' => 'Developer',
            'password' => Hash::make('password4'),
        ]);

        User::create([
            'office_id' => 5,
            'name' => 'Charlie Davis',
            'nip' => '5678901234',
            'photo' => '1.png',
            'rank' => 'Intern',
            'password' => Hash::make('password5'),
        ]);

        User::create([
            'office_id' => 1,
            'name' => 'Administrator',
            'nip' => 'admin@gmail.com',
            'photo' => '1.png',
            'rank' => 'Manager',
            'password' => Hash::make('admin@gmail.com'),
            'role' => 'admin',
        ]);
    }
}
