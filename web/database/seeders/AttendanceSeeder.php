<?php

namespace Database\Seeders;

use App\Models\Attendance;
use Illuminate\Database\Seeder;
use Carbon\Carbon;

class AttendanceSeeder extends Seeder
{
    public function run()
    {
        $users = range(1, 5);
        $types = ['in', 'out'];
        $startDate = Carbon::now()->subDays(10);

        foreach ($users as $user_id) {
            foreach ($types as $type) {
                for ($i = 0; $i < 10; $i++) {
                    Attendance::create([
                        'user_id' => $user_id,
                        'type' => $type,
                        'image' => 'default_image.png',
                        'time_deviation' => rand(-500, 500),
                        'latitude' => '0.123456',
                        'longitude' => '0.123456',
                        'created_at' => $startDate->copy()->addDays($i)->toDateTimeString(),
                        'updated_at' => $startDate->copy()->addDays($i)->toDateTimeString(),
                    ]);
                }
            }
        }
    }
}
