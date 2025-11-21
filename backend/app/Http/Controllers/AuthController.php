<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Endpoint para registro de novos usuários.
     */
    public function register(Request $request)
    {
        try {
            // 1. Validação dos dados de entrada
            $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users',
                'password' => 'required|string|min:8|confirmed',
                'telefone' => 'required|string|max:20',
                'cpf' => 'required|string|max:14|unique:users',
                // localizacao_id é opcional na sua migração, mas vamos validar se for enviado
                'localizacao_id' => 'nullable|exists:localizacao,id',
                // Definimos um nível padrão para novos registros (ex: 1 para cliente)
                'nivel' => 'sometimes|integer|in:1,2,3,9', 
            ]);

            // 2. Criação do usuário
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'telefone' => $request->telefone,
                'cpf' => $request->cpf,
                'localizacao_id' => $request->localizacao_id,
                // Se 'nivel' não for enviado, assume 1 (Cliente Padrão)
                'nivel' => $request->nivel ?? 1, 
            ]);

            // 3. Criação do token Sanctum
            $token = $user->createToken('auth_token')->plainTextToken;

            // 4. Retorno da resposta
            return response()->json([
                'message' => 'Usuário registrado com sucesso.',
                'user' => $user,
                'token' => $token,
                'token_type' => 'Bearer',
            ], 201);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Erro de validação.',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Erro interno do servidor.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Endpoint para login de usuários.
     */
    public function login(Request $request)
    {
        try {
            // 1. Validação dos dados de entrada
            $request->validate([
                'email' => 'required|string|email',
                'password' => 'required|string',
            ]);

            // 2. Tentativa de autenticação
            if (!Auth::attempt($request->only('email', 'password'))) {
                return response()->json([
                    'message' => 'Credenciais inválidas.',
                ], 401);
            }

            // 3. Recupera o usuário autenticado
            $user = User::where('email', $request->email)->firstOrFail();

            // 4. Criação do token Sanctum (remove tokens antigos para segurança)
            $user->tokens()->delete(); // Opcional: revoga tokens anteriores
            $token = $user->createToken('auth_token')->plainTextToken;

            // 5. Retorno da resposta
            return response()->json([
                'message' => 'Login realizado com sucesso.',
                'user' => $user,
                'token' => $token,
                'token_type' => 'Bearer',
            ]);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Erro de validação.',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Erro interno do servidor.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Endpoint para logout de usuários.
     * Requer autenticação (middleware 'auth:sanctum').
     */
    public function logout(Request $request)
    {
        // Revoga o token atual que foi usado para a requisição
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logout realizado com sucesso. Token revogado.',
        ]);
    }
}
