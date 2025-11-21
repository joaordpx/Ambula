import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/view/register_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/view/home_vendedor_view.dart';
import 'package:frontend/view/main_tab_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha e-mail e senha')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(email: email, password: password);

      final token = result['token'];
      final user = result['user'] as Map<String, dynamic>;
      final loja = user['loja'];

      AuthService.setToken(token); // grava o token em memória

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bem-vindo, ${user['name']}!')));

      if (loja == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainTabView()),
        );
      } else {
        // Tem loja -> perguntar se quer entrar como comprador ou vendedor
        await _showRoleChoiceDialog(user);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showRoleChoiceDialog(Map<String, dynamic> user) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Como você quer entrar?',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Você possui uma loja cadastrada. '
            'Escolha se deseja usar o app como comprador ou vendedor.',
            style: GoogleFonts.inter(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainTabView()),
                );
              },
              child: Text(
                'Comprador',
                style: GoogleFonts.inter(color: TColor.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeVendedorView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Vendedor',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/imgs/logo.png",
                      width: media.width * 0.3,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Conectando você aos sabores do\ncampus!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sora(
                        color: TColor.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // email
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: GoogleFonts.inter(
                      color: TColor.primarytext,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Digite seu e-mail",
                    filled: true,
                    fillColor: const Color(0xFFF6F7FB),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // senha
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Senha",
                    style: GoogleFonts.inter(
                      color: TColor.primarytext,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Digite sua senha",
                    filled: true,
                    fillColor: const Color(0xFFF6F7FB),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // esqueci a senha
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: implementar fluxo de recuperação de senha (quando existir)
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Esqueci a senha",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // entrar btn
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: const StadiumBorder(),
                        elevation: 0,
                        textStyle: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text("Entrar"),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Não possui uma conta? ",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterView(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Registre-se agora",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
