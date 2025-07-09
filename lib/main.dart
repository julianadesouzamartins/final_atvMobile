import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/views/pages/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
// Não precisamos mais desta importação se removemos o WebView na StudyDetailPage
// import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diário de Estudos Bíblicos + IA',
      theme: ThemeData(
        // Define a cor primária e secundária com tonalidades que contrastem com o branco
        // e que você considere suaves.
        colorScheme: ColorScheme.light(
          primary:
              Colors
                  .teal
                  .shade600, // Um teal um pouco mais escuro para contraste
          secondary:
              Colors
                  .orange
                  .shade600, // Um laranja um pouco mais escuro para contraste
          background: Colors.white, // Fundo branco para o aplicativo
          surface: Colors.white, // Superfície branca para Cards, etc.
        ),
        scaffoldBackgroundColor: Colors.white, // Fundo branco para Scaffolds
        primarySwatch:
            Colors
                .blue, // Mantido primarySwatch, mas colorScheme é mais moderno
        // Se quiser que a AppBar tenha uma cor específica (e.g., branco), pode definir aqui
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // Cor dos ícones e texto na AppBar
          elevation: 1, // Uma leve sombra para separar da tela
        ),
      ),
      home: LoginPage(),
    );
  }
}
