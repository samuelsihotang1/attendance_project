<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Announcement;

class AnnouncementController extends Controller
{
    public function getFewData()
    {
        // untuk 2 data saja
        $data = Announcement::take(2)->latest()->get();

        return response([
            'success' => true,
            'data' => $data,
        ], 200);
    }
    public function getAllData()
    {
        $data = Announcement::latest()->get();

        return response([
            'success' => true,
            'data' => $data,
        ], 200);
    }
}

