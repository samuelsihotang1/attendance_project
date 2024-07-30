<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Utils;
use App\Models\Attendance;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AttendanceController extends Controller
{
    public function validateAttendance(Request $request)
    {
        // Contoh JSON
        // {
        //     "latitude": "2.383212446907558",
        //     "longitude": "99.14864718342184",
        //     "type": "in"
        // }
        try {
            $request->validate([
                'latitude' => ['required', 'string', 'max:24'],
                'longitude' => ['required', 'string', 'max:24'],
                'type' => ['required', 'string', 'in:in,out'],
            ]);

            if ($this->checkLocation($request->latitude, $request->longitude) > 50.0) {
                return response([
                    'success' => false,
                    'message' => 'Anda jauh dari lokasi kantor',
                ]);
            }

            $timeDeviation = $this->checkTime($request->type);
            if ($timeDeviation != 0) {
                return response([
                    'success' => false,
                    'message' => $timeDeviation > 0 ? 'Anda telah terlambat' : 'Anda terlalu cepat datang',
                ]);
            }

            return response([
                'success' => 'true',
                'message' => 'Success',
            ])->setStatusCode(200);
        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Exception: ' . $e->getMessage(),
            ], 422);
        }
    }

    public function store(Request $request)
    {
        // Contoh JSON
        // {
        //      "latitude": "3.591903",
        //      "longitude": "98.676726",
        //      "type": "out",
        //      "image": "image.png"
        // }

        try {
            $request->validate([
                'latitude' => ['required', 'string', 'max:24'],
                'longitude' => ['required', 'string', 'max:24'],
                'type' => ['required', 'string', 'in:in,out'],
                'image' => ['required', 'image', 'max:2048'],
            ]);

            if ($this->checkLocation($request->latitude, $request->longitude) > 50.0) {
                return response([
                    'success' => false,
                    'message' => 'Anda jauh dari lokasi kantor',
                ]);
            }

            $timeDeviation = $this->checkTime($request->type);
            if ($timeDeviation != 0) {
                return response([
                    'success' => false,
                    'message' => $timeDeviation > 0 ? 'Anda telah terlambat' : 'Anda terlalu cepat datang',
                ]);
            }

            $image = Utils::upload($request->image, 'attendance');

            $attendance = Auth::user()->attendances()->create([
                'type' => $request->type,
                'image' => $image,
                'time_deviation' => $timeDeviation,
                'latitude' => $request->latitude,
                'longitude' => $request->longitude,
            ]);

            return response([
                'success' => true,
                'data' => $attendance,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Exception: ' . $e->getMessage(),
            ], 422);
        }
    }

    public function getTodayData()
    {
        $userId = auth()->user()->id;

        $data = Attendance::where('user_id', $userId)->whereDate('created_at', today())->latest()->get();

        return response([
            'success' => true,
            'data' => $data,
        ], 200);
    }

    public function getFewData()
    {
        $userId = auth()->user()->id;

        // untuk 2 hari terakhir
        $data = Attendance::where('user_id', $userId)->take(4)->latest()->get();

        return response([
            'success' => true,
            'data' => $data,
        ], 200);
    }

    public function getAllData()
    {
        $userId = auth()->user()->id;

        $data = Attendance::where('user_id', $userId)->latest()->get();

        return response([
            'success' => true,
            'data' => $data,
        ], 200);
    }

    protected function checkLocation($employeeLatitude, $employeeLongitude)
    {
        $latFrom = deg2rad(Auth::user()->office->latitude);
        $lonFrom = deg2rad(Auth::user()->office->longitude);
        $latTo = deg2rad($employeeLatitude);
        $lonTo = deg2rad($employeeLongitude);

        $earthRadius = 6371000;
        $latDelta = $latTo - $latFrom;
        $lonDelta = $lonTo - $lonFrom;

        $a = sin($latDelta / 2) * sin($latDelta / 2) +
            cos($latFrom) * cos($latTo) *
            sin($lonDelta / 2) * sin($lonDelta / 2);
        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earthRadius * $c;
    }

    protected function checkTime($type)
    {
        date_default_timezone_set('Asia/Jakarta');

        $office = Auth::user()->office;
        $start = $office->start_open;
        $end = $office->end_open;

        if ($type == 'out') {
            $start = $office->start_close;
            $end = $office->end_close;
        }

        $now = date('H:i:s');

        $startTime = strtotime($start);
        $endTime = strtotime($end);
        $nowTime = strtotime($now);

        if ($nowTime <= $startTime) {
            return $nowTime - $startTime;
        } elseif ($nowTime >= $endTime) {
            return $nowTime - $endTime;
        } else {
            return 0;
        }
    }
}

