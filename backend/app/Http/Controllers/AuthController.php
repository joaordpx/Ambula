<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        try {

            $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users',
                'password' => 'required|string|min:8|confirmed',
                'telefone' => 'required|string|max:20',
                'cpf' => 'required|string|max:14|unique:users',
                'nivel' => 'sometimes|integer|in:1,2,3,9',
            ]);
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'telefone' => $request->telefone,
                'cpf' => $request->cpf,
                'nivel' => $request->nivel ?? 1,
            ]);


            $token = $user->createToken('auth_token')->plainTextToken;


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


    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email'    => ['required', 'email'],
            'password' => ['required'],
        ]);

        if (! Auth::attempt($credentials)) {
            return response()->json([
                'message' => 'Credenciais inválidas.',
            ], 401);
        }

        /** @var User $user */
        $user = Auth::user();
        $user->load('loja');

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'token' => $token,
            'user'  => $this->formatUserWithLoja($user),
        ]);
    }


    public function logout(Request $request)
    {

        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logout realizado com sucesso. Token revogado.',
        ]);
    }

    public function updateProfile(Request $request)
    {
        try {
            $user = $request->user();

            $validated = $request->validate([
                'name'     => 'required|string|max:255',
                'telefone' => 'required|string|max:20',
                'email'    => [
                    'required',
                    'string',
                    'email',
                    'max:255',
                    // unique na tabela `users`, mas ignorando o próprio usuário
                    Rule::unique('users', 'email')->ignore($user->id),
                ],
            ]);

            $user->name     = $validated['name'];
            $user->telefone = $validated['telefone'];
            $user->email    = $validated['email'];
            $user->save();

            return response()->json([
                'message' => 'Dados atualizados com sucesso.',
                'user'    => $user,
            ]);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Erro de validação.',
                'errors'  => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Erro interno do servidor.',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    public function me(Request $request)
    {
        /** @var User $user */
        $user = $request->user();
        $user->load('loja');

        // /me já devolve direto o usuário (sem wrapper "user")
        return response()->json(
            $this->formatUserWithLoja($user)
        );
    }

    protected function formatUserWithLoja(User $user): array
    {
        $hasLoja = $user->loja()->exists();

        return [
            'id'       => $user->id,
            'name'     => $user->name,
            'email'    => $user->email,
            'telefone' => $user->telefone,
            'cpf'      => $user->cpf,
            'has_loja' => $hasLoja,
            'loja'     => $hasLoja && $user->loja ? [
                'id'             => $user->loja->id,
                'nome'           => $user->loja->nome,
                'descricao'      => $user->loja->descricao,
                'header'         => $user->loja->header,
                'status'         => $user->loja->status,
                'avaliacao'      => $user->loja->avaliacao,
                'localizacao_id' => $user->loja->localizacao_id,
            ] : null,
        ];
    }
}
