import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/pages/home_page.dart';
import '../views/pages/login_page.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Indicador de carregamento
  final RxBool isLoading = false.obs;

  // Observador do usuário autenticado
  final Rxn<User> _firebaseUser = Rxn<User>();

  // Getter do usuário atual
  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    print('AuthController onInit iniciado');

    // Escuta mudanças na autenticação
    _firebaseUser.bindStream(_auth.authStateChanges());

    // Redirecionamento com base na autenticação
    ever(_firebaseUser, (User? user) {
      print(
        'Auth state mudou: user is ${user == null ? "null (deslogado)" : "logado"}',
      );
      if (user == null) {
        print('Navegando para LoginPage');
        Get.offAll(() => LoginPage());
      } else {
        print('Navegando para HomePage');
        Get.offAll(() => HomePage());
      }
    });

    print('AuthController onInit finalizado');
  }

  // Cadastro de novo usuário
  Future<void> register(String email, String password) async {
    print('register() iniciado');
    isLoading.value = true;
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('register() sucesso');
      Get.snackbar(
        "Sucesso",
        "Conta criada com sucesso!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade300,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      print('register() erro: ${e.message}');
      Get.snackbar(
        "Erro ao cadastrar",
        e.message ?? "Erro desconhecido",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade300,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      print('register() finalizado');
    }
  }

  // Login do usuário
  Future<void> login(String email, String password) async {
    print('login() iniciado');
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('login() sucesso');
      Get.snackbar(
        "Bem-vindo",
        "Login realizado com sucesso!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.shade300,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      print('login() erro: ${e.message}');
      Get.snackbar(
        "Erro ao logar",
        e.message ?? "Erro desconhecido",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade300,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      print('login() finalizado');
    }
  }

  // Logout do usuário
  Future<void> logout() async {
    print('logout() iniciado');
    await _auth.signOut();
    print('logout() finalizado');
    Get.snackbar(
      "Logout",
      "Você saiu da sua conta.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade700,
      colorText: Colors.white,
    );
  }

  // Envia e-mail de redefinição de senha
  Future<void> sendPasswordResetEmail(String email) async {
    print('sendPasswordResetEmail() iniciado');
    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('sendPasswordResetEmail() sucesso');
      Get.snackbar(
        "E-mail enviado",
        "Um link para redefinir sua senha foi enviado para $email.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade300,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      print('sendPasswordResetEmail() erro: ${e.message}');
      Get.snackbar(
        "Erro ao enviar e-mail",
        e.message ?? "Erro desconhecido",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade300,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      print('sendPasswordResetEmail() finalizado');
    }
  }

  // Verifica se o usuário está logado
  bool get isLoggedIn => user != null;
}
