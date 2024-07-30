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
        $offices = [
            ['name' => 'Office 1', 'address' => '123 Main St', 'latitude' => '3.591903', 'longitude' => '98.676726', 'start_open' => '06:00:00', 'end_open' => '08:00:00', 'start_close' => '17:00:00', 'end_close' => '20:00:00'],
            ['name' => 'Office 2', 'address' => '456 Elm St', 'latitude' => '3.591903', 'longitude' => '98.676726', 'start_open' => '09:00:00', 'end_open' => '08:00:00', 'start_close' => '17:00:00', 'end_close' => '20:00:00'],
            ['name' => 'Office 3', 'address' => '789 Oak St', 'latitude' => '3.591903', 'longitude' => '98.676726', 'start_open' => '08:30:00', 'end_open' => '08:00:00', 'start_close' => '17:00:00', 'end_close' => '20:00:00'],
            ['name' => 'Office 4', 'address' => '101 Pine St', 'latitude' => '3.591903', 'longitude' => '98.676726', 'start_open' => '08:00:00', 'end_open' => '08:00:00', 'start_close' => '17:00:00', 'end_close' => '20:00:00'],
            ['name' => 'Office 5', 'address' => '202 Maple St', 'latitude' => '3.591903', 'longitude' => '98.676726', 'start_open' => '09:00:00', 'end_open' => '08:00:00', 'start_close' => '17:00:00', 'end_close' => '20:00:00'],
            ['name' => 'Office 6', 'address' => '303 Cedar St', 'latitude' => '3.591903', 'longitude' => '98.676726', 'start_open' => '08:00:00', 'end_open' => '08:00:00', 'start_close' => '17:00:00', 'end_close' => '20:00:00'],
            ['name' => 'Office 7', 'address' => '404 Birch St', 'latitude' => '3.591903', 'longitude' => '98.676726', 'start_open' => '08:30:00', 'end_open' => '08:00:00', 'start_close' => '17:00:00', 'end_close' => '20:00:00'],
            ['name' => 'Office 8', 'address' => '505 Willow St', 'latitude' => '3.591903', 'longitude' => '98.676726', 'start_open' => '09:00:00', 'end_open' => '08:00:00', 'start_close' => '17:00:00', 'end_close' => '20:00:00'],
            ['name' => 'Office 9', 'address' => '606 Chestnut St', 'latitude' => '3.591903', 'longitude' => '98.676726', 'start_open' => '08:00:00', 'end_open' => '08:00:00', 'start_close' => '17:00:00', 'end_close' => '20:00:00'],
            ['name' => 'Office 10', 'address' => '707 Fir St', 'latitude' => '3.591903', 'longitude' => '98.676726', 'start_open' => '09:00:00', 'end_open' => '08:00:00', 'start_close' => '17:00:00', 'end_close' => '20:00:00'],
        ];

        foreach ($offices as $office) {
            Office::create($office);
        }
    }
}
