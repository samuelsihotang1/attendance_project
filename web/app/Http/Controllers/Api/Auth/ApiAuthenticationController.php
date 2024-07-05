<?php

namespace App\Http\Controllers\Auth\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class ApiAuthenticationController extends Controller
{
    public function register(RegisterRequest $request)
    {
        // Contoh JSON
        // {
        //     "name": "Jo",
        //     "username": "joshndssosse1232s",
        //     "email": "johnsdoe@sesxasmsplse.co2m",
        //     "password": "0001234567",
        //     "password_confirmation": "0001234567"
        // }

        $request->validated();

        $userData = [
            'name' => $request->name,
            'username' => $request->username,
            'email' => $request->email,
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
        //     "username": "joshndssosse1232s",
        //     "password": "0001234567",
        //     "password_confirmation": "0001234567"
        // }

        $request->validated();

        $user = User::whereUsername($request->username)->first();
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
