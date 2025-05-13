import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Tarefa> tarefas = [];

  void adicionarOuEditarTarefa({int? index}) {
    final isEditing = index != null;
    final tarefa = isEditing ? tarefas[index] : null;

    final tituloController = TextEditingController(text: tarefa?.titulo ?? '');
    final descricaoController = TextEditingController(
      text: tarefa?.descricao ?? '',
    );
    DateTime dataInicio = tarefa?.dataInicio ?? DateTime.now();
    DateTime? dataFim = tarefa?.dataFim;

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setModalState) => AlertDialog(
                  title: Text(isEditing ? "Editar Tarefa" : "Nova Tarefa"),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: tituloController,
                          decoration: const InputDecoration(
                            labelText: "Título da tarefa",
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Início: ${DateFormat('dd/MM/yyyy').format(dataInicio)}",
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
                                if (data != null) {
                                  setModalState(() => dataInicio = data);
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: descricaoController,
                          decoration: const InputDecoration(
                            labelText: "Descrição (opcional)",
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                dataFim != null
                                    ? "Término: ${DateFormat('dd/MM/yyyy').format(dataFim!)}"
                                    : "Selecionar data de término (opcional)",
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_month),
                              onPressed: () async {
                                final data = await showDatePicker(
                                  context: context,
                                  initialDate: dataFim ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (data != null) {
                                  setModalState(() => dataFim = data);
                                }
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
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () {
                        if (tituloController.text.isNotEmpty) {
                          final novaTarefa = Tarefa(
                            titulo: tituloController.text,
                            dataInicio: dataInicio,
                            descricao:
                                descricaoController.text.isNotEmpty
                                    ? descricaoController.text
                                    : null,
                            dataFim: dataFim,
                          );
                          setState(() {
                            if (isEditing) {
                              tarefas[index] = novaTarefa;
                            } else {
                              tarefas.add(novaTarefa);
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text(isEditing ? "Atualizar" : "Salvar"),
                    ),
                  ],
                ),
          ),
    );
  }

  void deletarTarefa(int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Confirmar exclusão"),
            content: const Text("Deseja realmente excluir esta tarefa?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    tarefas.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text("Excluir"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Tarefas"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          return ListTile(
            title: Text(tarefa.titulo),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Início: ${dateFormat.format(tarefa.dataInicio)}"),
                if (tarefa.descricao != null && tarefa.descricao!.isNotEmpty)
                  Text("Descrição: ${tarefa.descricao}"),
                if (tarefa.dataFim != null)
                  Text("Término: ${dateFormat.format(tarefa.dataFim!)}"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => adicionarOuEditarTarefa(index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deletarTarefa(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => adicionarOuEditarTarefa(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
