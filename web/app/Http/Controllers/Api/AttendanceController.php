<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\AttendanceRequest;
use App\Http\Requests\CheckLocationRequest;
use App\Models\Attendance;
use Illuminate\Support\Facades\Auth;

class AttendanceController extends Controller
{
    public function store(AttendanceRequest $request)
    {
        // Contoh JSON
        // {
        //     "latitude": "34.052235",
        //     "longitude": "-118.243683",
        //     "type": "out",
        //     "status": "late",
        //     "deviation": 1800
        // }

        $request->validated();

        $attendance = auth()->user()->attendances()->create([
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
            'type' => $request->type,
            'status' => $request->status,
            'deviation' => $request->deviation,
        ]);

        return response([
            'success' => true,
            'data' => $attendance,
        ], 200);
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


    public function checkLocation(CheckLocationRequest $request)
    {
        // Contoh JSON
        // {
        //     "latitude": "2.383212446907558",
        //     "longitude": "99.14864718342184"
        // }

        $request->validate([
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
        ]);

        // Alamat kantor
        $officeLatitude = 1.748932;
        $officeLongitude = 98.770382;

        $employeeLatitude = $request->latitude;
        $employeeLongitude = $request->longitude;

        $distance = $this->haversineGreatCircleDistance(
            $officeLatitude,
            $officeLongitude,
            $employeeLatitude,
            $employeeLongitude
        );

        // Delete this
        return response()->json(['message' => $distance], 200);
        if ($distance <= 50) {
            return response()->json(['message' => 'Within range'], 200);
        } else {
            return response()->json(['message' => 'Out of range'], 200);
        }
    }

    private function haversineGreatCircleDistance($latitudeFrom, $longitudeFrom, $latitudeTo, $longitudeTo, $earthRadius = 6371000)
    {
        $latFrom = deg2rad($latitudeFrom);
        $lonFrom = deg2rad($longitudeFrom);
        $latTo = deg2rad($latitudeTo);
        $lonTo = deg2rad($longitudeTo);

        $latDelta = $latTo - $latFrom;
        $lonDelta = $lonTo - $lonFrom;

        $a = sin($latDelta / 2) * sin($latDelta / 2) +
            cos($latFrom) * cos($latTo) *
            sin($lonDelta / 2) * sin($lonDelta / 2);
        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earthRadius * $c;
    }
}

