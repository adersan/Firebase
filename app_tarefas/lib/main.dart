// Importa o pacote Flutter para a interface
import 'package:flutter/material.dart';

// Importa as páginas do app (login, home e cadastro)
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/register_page.dart';

// ✅ Firebase Core — necessário para inicializar o Firebase
import 'package:firebase_core/firebase_core.dart';
// ✅ Arquivo gerado automaticamente com configurações do Firebase (firebase_options.dart)
import 'firebase_options.dart';

void main() async {
  // ✅ Garante que o Flutter esteja pronto para executar código assíncrono antes do runApp
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inicializa o Firebase com as configurações do projeto
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Executa o app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),

      // ✅ Rota inicial: tela de login
      initialRoute: '/',

      // ✅ Definição das rotas do app
      routes: {
        '/': (_) => const LoginPage(), // Tela de login
        '/home': (_) => const HomePage(), // Tela principal após login
        '/register': (_) => const RegisterPage(), // Tela de cadastro
      },
    );
  }
}
