<?php

namespace Database\Seeders;

use App\Models\Attendance;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AttendanceSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $datas = [
            [
                'latitude' => '40.712776',
                'longitude' => '74.005974',
                'type' => 'in',
                'status' => 'ontime',
            ],
            [
                'latitude' => '34.052235',
                'longitude' => '118.243683',
                'type' => 'out',
                'status' => 'late',
                'deviation' => 1800,
            ],
            [
                'latitude' => '41.878113',
                'longitude' => '87.629799',
                'type' => 'in',
                'status' => 'ontime',
            ],
            [
                'latitude' => '37.774929',
                'longitude' => '122.419418',
                'type' => 'out',
                'status' => 'early',
                'deviation' => 3600,
            ],
            [
                'latitude' => '51.507351',
                'longitude' => '0.127758',
                'type' => 'in',
                'status' => 'late',
                'deviation' => 300,
            ],
        ];

        foreach ($datas as $data) {
            for ($i = 1; $i <= 5; $i++) {
                Attendance::create([
                    'user_id' => $i,
                    'latitude' => $data['latitude'],
                    'longitude' => $data['longitude'],
                    'type' => $data['type'],
                    'status' => $data['status'],
                    'deviation' => isset($data['deviation']) ? $data['deviation'] : null,
                ]);
            }
        }

    }
}
