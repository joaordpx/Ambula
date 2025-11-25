<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Routing\Controller;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{

    public function register(Request $request) {
        try {
            $validated = $request->validate([
                'name'     => ['required', 'string', 'max:255'],
                'email'    => ['required', 'string', 'email', 'max:255', 'unique:users,email'],
                'password' => ['required', 'string', 'min:6'],
                'telefone' => ['required', 'string', 'max:20'],
                'cpf'      => ['required', 'string', 'max:14', 'unique:users,cpf'],
                'nivel'    => ['nullable', 'integer', 'in:1,2,9'],
                'localizacao_id' => ['nullable', 'exists:localizacao,id'],
            ]);

            $user = User::create([
                'name'     => $validated['name'],
                'email'    => $validated['email'],
                'password' => Hash::make($validated['password']),
                'telefone' => $validated['telefone'],
                'cpf'      => $validated['cpf'],
                'nivel'    => $validated['nivel'] ?? 1, 
                'localizacao_id' => $validated['localizacao_id'] ?? null,
            ]);

            $token = $user->createToken('api-token')->plainTextToken;

            return response()->json([
                'user'  => $user,
                'token' => $token,
            ], 201);
        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        }
    }

    
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'string', 'email'],
            'password' => ['required', 'string'],
        ]);

        if (!Auth::attempt($credentials)) {
            return response()->json([
                'message' => 'Credenciais invalidas.',
            ], 401);
        }

        $user = Auth::user();

        $user->load('loja');

        $user->tokens()->delete();
        $token = $user->createToken('api-token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ], 200);
    }

    public function logout(Request $request)
    {
        $user = $request->user();

        $user->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logout realizado com sucesso.',
        ], 200);
    }
}
