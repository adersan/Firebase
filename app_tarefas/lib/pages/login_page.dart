// Importa os pacotes essenciais para interface Flutter
import 'package:flutter/material.dart';
// ✅ Importa o Firebase Auth para autenticação de usuários
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores para capturar o texto digitado nos campos
    final emailController = TextEditingController();
    final senhaController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo de email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            // Campo de senha (com ocultação de texto)
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // 🔐 Quando o botão "Entrar" é pressionado...

                final email = emailController.text.trim();
                final senha = senhaController.text.trim();

                try {
                  // ✅ FirebaseAuth: tenta logar com email e senha
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: senha,
                  );

                  // ✅ Se o login funcionar, vai para a tela principal (home)
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  // ❌ Se ocorrer erro de login (email/senha errados, usuário não encontrado, etc.)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erro ao fazer login: $e")),
                  );
                }
              },
              child: const Text("Entrar"),
            ),
            // Botão para navegar até a página de cadastro
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Ainda não tem conta? Cadastre-se"),
            ),
          ],
        ),
      ),
    );
  }
}
// A classe LoginPage é um widget Stateless que representa a tela de login do aplicativo.
// Ela contém campos para o usuário inserir seu email e senha, além de botões para fazer login e navegar para a página de cadastro. 