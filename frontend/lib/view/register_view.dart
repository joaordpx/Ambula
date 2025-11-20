import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    cpfController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final telefone = telefoneController.text.trim();
    final cpf = cpfController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        telefone.isEmpty ||
        cpf.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('As senhas não coincidem')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.register(
        name: name,
        email: email,
        password: password,
        telefone: telefone,
        cpf: cpf,
        nivel: 0, // todo mundo começa como comprador
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );

      if (mounted) {
        Navigator.pop(context); // volta para a tela de login
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

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // botão volta
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.black,
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(height: 8),

              // logo + slogan
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

              // Nome
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nome",
                  style: GoogleFonts.inter(
                    color: TColor.primarytext,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Digite seu nome",
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

              // Email
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

              // Telefone
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Telefone",
                  style: GoogleFonts.inter(
                    color: TColor.primarytext,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: telefoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Digite seu telefone",
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

              // CPF
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "CPF",
                  style: GoogleFonts.inter(
                    color: TColor.primarytext,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: cpfController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Digite seu CPF",
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

              // Senha
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
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Confirmar Senha
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Confirme a Senha",
                  style: GoogleFonts.inter(
                    color: TColor.primarytext,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: "Digite sua senha novamente",
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
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Botão criar conta
              Center(
                child: SizedBox(
                  width: 180,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
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
                        : const Text("Criar Conta"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
