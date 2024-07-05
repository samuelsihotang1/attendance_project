<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthenticationController extends Controller
{
    public function register(RegisterRequest $request)
    {
        // Contoh JSON
        // {
        //     "office_id": "1",
        //     "name": "Administrator",
        //     "nip": "12345",
        //     "photo": "photo1.jpg",
        //     "rank": "Administrator",
        //     "password": "inipassword",
        //     "password_confirmation": "inipassword"
        // }

        $request->validated();

        $userData = [
            'office_id' => $request->office_id,
            'name' => $request->name,
            'nip' => $request->nip,
            'photo' => $request->photo,
            'rank' => $request->rank,
            'password' => Hash::make($request->password)
        ];

        $user = User::create($userData);
        $token = $user->createToken('auth_token')->plainTextToken;

        return response([
            'success' => true,
            'message' => 'Register successfully.',
            'data' => $user,
            'token' => $token,
        ], 201);
    }

    public function login(LoginRequest $request)
    {
        // Contoh JSON
        // {
        //     "nip": "12345",
        //     "password": "inipassword",
        //     "password_confirmation": "inipassword"
        // }

        $request->validated();

        $user = User::whereNip($request->nip)->first();
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response([
                'message' => 'The provided credentials are incorrect.'
            ], 422);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response([
            'success' => true,
            'message' => 'Login successfully.',
            'data' => $user,
            'token' => $token,
        ], 200);
    }
}
