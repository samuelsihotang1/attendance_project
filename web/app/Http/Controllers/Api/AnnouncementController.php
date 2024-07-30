<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Announcement;

class AnnouncementController extends Controller
{
    public function getAllData()
    {
        try {
            $data = Announcement::latest()->get();

            return response([
                'success' => true,
                'data' => $data,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Exception: ' . $e->getMessage(),
            ], 422);
        }
    }
}

