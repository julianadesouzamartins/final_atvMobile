import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Registra ou recupera o AuthController
    final AuthController authController = Get.put(AuthController());

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // Cores padrão para o layout
    const Color azulBebe = Color(0xFFADD8E6);
    const Color azulPrincipal = Color(0xFF4A90E2);
    const Color textoCor = Colors.black87;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: azulBebe,
        elevation: 0,
        title: const Text(
          'Diário de Estudos Bíblicos + IA',
          style: TextStyle(color: textoCor, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: textoCor),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Icon(Icons.menu_book, size: 72, color: azulPrincipal),
                    const SizedBox(height: 20),

                    // Campo de Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: azulPrincipal,
                        ),
                        labelStyle: const TextStyle(color: textoCor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: azulPrincipal),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Por favor, insira um email válido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Campo de Senha
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: azulPrincipal,
                        ),
                        labelStyle: const TextStyle(color: textoCor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: azulPrincipal),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    Obx(() {
                      if (authController.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: azulPrincipal,
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            // Botão Entrar
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: azulPrincipal,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                icon: const Icon(Icons.login),
                                label: const Text('Entrar'),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    authController.login(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                  }
                                },
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Botão Cadastrar
                            TextButton.icon(
                              icon: const Icon(
                                Icons.person_add_alt_1,
                                color: azulPrincipal,
                              ),
                              label: const Text(
                                'Cadastrar',
                                style: TextStyle(color: azulPrincipal),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  authController.register(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                }
                              },
                            ),

                            // Botão Esqueci minha senha
                            TextButton.icon(
                              icon: const Icon(
                                Icons.lock_reset,
                                color: azulPrincipal,
                              ),
                              label: const Text(
                                'Esqueci minha senha',
                                style: TextStyle(color: azulPrincipal),
                              ),
                              onPressed: () {
                                if (emailController.text.isNotEmpty &&
                                    RegExp(
                                      r'\S+@\S+\.\S+',
                                    ).hasMatch(emailController.text)) {
                                  authController.sendPasswordResetEmail(
                                    emailController.text.trim(),
                                  );
                                } else {
                                  Get.snackbar(
                                    'Erro',
                                    'Insira um email válido para redefinir sua senha.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.redAccent,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }
                    }),
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
