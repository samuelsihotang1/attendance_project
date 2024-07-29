<?php

namespace App\Http\Controllers;

class Utils extends Controller
{
    public static function upload($photo)
    {
        $path = 'assets/images/avatar/';
        $extension = $photo->extension();
        $name = uniqid();

        while (file_exists($path . $name . '.' . $extension)) {
            $name = $name . uniqid();
        }

        $photo->storeAs($path, $name . '.' . $extension);
        return $name . '.' . $extension;
    }
}

