<?php

namespace Database\Seeders;

use App\Models\Office;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class OfficeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Office::create([
            'name' => 'Office One',
            'address' => '123 Main Street',
            'latitude' => '40.712776',
            'longitude' => '-74.005974',
        ]);

        Office::create([
            'name' => 'Office Two',
            'address' => '456 Elm Street',
            'latitude' => '34.052235',
            'longitude' => '-118.243683',
        ]);

        Office::create([
            'name' => 'Office Three',
            'address' => '789 Oak Street',
            'latitude' => '41.878113',
            'longitude' => '-87.629799',
        ]);

        Office::create([
            'name' => 'Office Four',
            'address' => '101 Maple Avenue',
            'latitude' => '37.774929',
            'longitude' => '-122.419418',
        ]);

        Office::create([
            'name' => 'Office Five',
            'address' => '202 Pine Street',
            'latitude' => '51.507351',
            'longitude' => '-0.127758',
        ]);
    }
}
