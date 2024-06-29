<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;

class LocationController extends Controller
{
    public function checkLocation(Request $request)
    {
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

