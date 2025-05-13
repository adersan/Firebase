import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final tarefasRef = FirebaseFirestore.instance.collection('tarefas');

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  void abrirFormularioTarefa(BuildContext context, {DocumentSnapshot? tarefa}) {
    final controller = TextEditingController(
      text: tarefa != null ? tarefa['titulo'] : '',
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(tarefa != null ? 'Editar Tarefa' : 'Nova Tarefa'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Título da Tarefa'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final titulo = controller.text.trim();
                  if (titulo.isEmpty) return;

                  if (tarefa == null) {
                    // Criar nova
                    tarefasRef.add({
                      'titulo': titulo,
                      'timestamp': FieldValue.serverTimestamp(),
                      'uid': FirebaseAuth.instance.currentUser?.uid,
                    });
                  } else {
                    // Atualizar existente
                    tarefasRef.doc(tarefa.id).update({'titulo': titulo});
                  }

                  Navigator.pop(context); // Fechar o diálogo
                },
                child: Text(tarefa != null ? 'Salvar' : 'Adicionar'),
              ),
            ],
          ),
    );
  }

  void deletarTarefa(String id) {
    tarefasRef.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Tarefas'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            tarefasRef
                //.where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .orderBy('timestamp')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final tarefas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              final tarefa = tarefas[index];
              return ListTile(
                title: Text(tarefa['titulo']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed:
                          () => abrirFormularioTarefa(context, tarefa: tarefa),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deletarTarefa(tarefa.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirFormularioTarefa(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
