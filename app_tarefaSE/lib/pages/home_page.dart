// IMPORTAÇÃO DOS PACOTES
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar datas no app
// ✅ Firebase Authentication: gerencia login e logout do usuário
import 'package:firebase_auth/firebase_auth.dart';
// ✅ Cloud Firestore: banco de dados em tempo real do Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // ✅ Referência à coleção 'tarefas' do Firestore
  CollectionReference get tarefasRef =>
      FirebaseFirestore.instance.collection('tarefas');

  // ✅ Função que abre um formulário para adicionar ou editar uma tarefa
  // Todos os dados são salvos/atualizados no Firestore
  void adicionarOuEditarTarefa(BuildContext context, {DocumentSnapshot? doc}) {
    final isEditing = doc != null;

    final tituloController = TextEditingController(text: doc?['titulo'] ?? '');
    final descricaoController = TextEditingController(
      text: doc?['descricao'] ?? '',
    );

    // ✅ Converte os campos de data do Firestore (Timestamp) para DateTime
    DateTime dataInicio =
        (doc?['dataInicio'] as Timestamp?)?.toDate() ?? DateTime.now();
    DateTime dataFim =
        (doc?['dataFim'] as Timestamp?)?.toDate() ?? DateTime.now();

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setModalState) => AlertDialog(
                  title: Text(isEditing ? 'Editar Tarefa' : 'Nova Tarefa'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: tituloController,
                          decoration: const InputDecoration(
                            labelText: 'Título da tarefa',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Início: ${DateFormat('dd/MM/yyyy').format(dataInicio)}',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                final data = await showDatePicker(
                                  context: context,
                                  initialDate: dataInicio,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (data != null)
                                  setModalState(() => dataInicio = data);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: descricaoController,
                          decoration: const InputDecoration(
                            labelText: 'Descrição (opcional)',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Término: ${DateFormat('dd/MM/yyyy').format(dataFim)}',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_month),
                              onPressed: () async {
                                final data = await showDatePicker(
                                  context: context,
                                  initialDate: dataFim,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (data != null)
                                  setModalState(() => dataFim = data);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        // ✅ Obtém o usuário atualmente logado com Firebase Auth
                        final user = FirebaseAuth.instance.currentUser;
                        final uid =
                            user?.uid; // UID usado para filtrar tarefas por usuário

                        if (uid != null && tituloController.text.isNotEmpty) {
                          // ✅ Dados a serem salvos no Firestore
                          final dados = {
                            'titulo': tituloController.text,
                            'descricao': descricaoController.text,
                            'dataInicio': Timestamp.fromDate(
                              dataInicio,
                            ), // 🔁 Converte para Timestamp
                            'dataFim': Timestamp.fromDate(dataFim),
                            'uid':
                                uid, // 🔐 Relaciona a tarefa com o usuário logado
                          };

                          if (isEditing) {
                            // ✅ Atualiza tarefa existente no Firestore
                            await tarefasRef.doc(doc!.id).update(dados);
                          } else {
                            // ✅ Cria nova tarefa no Firestore
                            await tarefasRef.add(dados);
                          }

                          Navigator.pop(context); // Fecha o modal
                        }
                      },
                      child: Text(isEditing ? 'Atualizar' : 'Salvar'),
                    ),
                  ],
                ),
          ),
    );
  }

  // ✅ Função para excluir uma tarefa do Firestore
  void deletarTarefa(BuildContext context, String id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja realmente excluir esta tarefa?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  // ✅ Remove o documento (tarefa) da coleção no Firestore
                  await tarefasRef.doc(id).delete();
                  Navigator.pop(context);
                },
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Firebase Auth: obtém usuário autenticado
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            // ✅ Faz logout do Firebase Auth
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(
              context,
              '/',
            ); // Volta à tela inicial
          },
        ),
      ),

      // ✅ Verifica se há usuário logado
      body:
          uid == null
              ? const Center(child: Text("Usuário não autenticado."))
              : StreamBuilder<QuerySnapshot>(
                // ✅ Escuta mudanças em tempo real da coleção 'tarefas'
                stream:
                    tarefasRef
                        .where(
                          'uid',
                          isEqualTo: uid,
                        ) // 🔐 Filtra tarefas do usuário atual
                        .orderBy('dataInicio') // 📅 Ordena pela data de início
                        .snapshots(), // 🔄 Escuta atualizações automáticas
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Erro ao carregar tarefas."),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text("Nenhum dado encontrado."));
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma tarefa cadastrada.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final titulo = data['titulo'] ?? '';
                      final descricao = data['descricao'] ?? '';

                      // ✅ Converte os campos Timestamp do Firestore para DateTime
                      final dataInicio =
                          data['dataInicio'] != null
                              ? (data['dataInicio'] as Timestamp).toDate()
                              : DateTime.now();

                      final dataFim =
                          data['dataFim'] != null
                              ? (data['dataFim'] as Timestamp).toDate()
                              : DateTime.now();

                      return ListTile(
                        title: Text(titulo),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Início: ${dateFormat.format(dataInicio)}'),
                            if (descricao.isNotEmpty)
                              Text('Descrição: $descricao'),
                            Text('Término: ${dateFormat.format(dataFim)}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed:
                                  () => adicionarOuEditarTarefa(
                                    context,
                                    doc: doc,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deletarTarefa(context, doc.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => adicionarOuEditarTarefa(context),
        child: const Icon(Icons.add_task), // ✅ Ícone para nova tarefa
      ),
    );
  }
}
