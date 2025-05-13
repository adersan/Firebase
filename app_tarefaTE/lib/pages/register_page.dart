import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            TextField(
              controller: confirmarSenhaController,
              decoration: const InputDecoration(labelText: "Confirmar Senha"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              //aqui irei integrar com Firebase
              onPressed: () {
                // Aqui você pode adicionar a lógica de cadastr
                if (senhaController.text == confirmarSenhaController.text) {
                  // Aqui futuramente você integrará com Firebase

                  // Retornar para a tela de login após cadastro
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Cadastro realizado com sucesso"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("As senhas não coincidem")),
                  );
                }
              },
              child: const Text("Cadastrar"),
            ),
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
