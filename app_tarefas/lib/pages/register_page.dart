// Importação dos pacotes essenciais
import 'package:flutter/material.dart';
// ✅ Importação do Firebase Auth (obrigatória para autenticação)
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores dos campos do formulário
    final nomeController = TextEditingController();
    final emailController = TextEditingController();
    final senhaController = TextEditingController();
    final confirmarSenhaController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo Nome (opcional nesse caso)
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            // Campo Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            // Campo Senha (com obscureText para segurança)
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            // Campo Confirmar Senha
            TextField(
              controller: confirmarSenhaController,
              decoration: const InputDecoration(labelText: "Confirmar Senha"),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // BOTÃO "Cadastrar"
            ElevatedButton(
              onPressed: () async {
                final nome = nomeController.text.trim();
                final email = emailController.text.trim();
                final senha = senhaController.text.trim();
                final confirmarSenha = confirmarSenhaController.text.trim();

                // Validação: senha deve coincidir
                if (senha != confirmarSenha) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("As senhas não coincidem")),
                  );
                  return;
                }

                try {
                  // ✅ CRIA CONTA NO FIREBASE com email e senha
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: senha,
                  );

                  // ✅ Após criar o usuário, volta para tela de login
                  Navigator.pop(context);

                  // Mensagem de sucesso
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Cadastro realizado com sucesso"),
                    ),
                  );
                } catch (e) {
                  // ❌ Tratamento de erro (ex: email já usado, senha fraca)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erro ao cadastrar: $e")),
                  );
                }
              },
              child: const Text("Cadastrar"),
            ),

            // Botão para voltar para a tela de login
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Voltar para login
              },
              child: const Text("Já tem conta? Faça login"),
            ),
          ],
        ),
      ),
    );
  }
}
