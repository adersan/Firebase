// Importa o pacote do Cloud Firestore para usar Timestamp
import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo de dados para representar uma tarefa salva no Firestore
class Tarefa {
  final String id; // ID do documento no Firestore
  final String titulo; // Título da tarefa
  final String? descricao; // Descrição (opcional)
  final DateTime dataInicio; // Data de início (obrigatória)
  final DateTime? dataFim; // Data de término (opcional)
  final String uid; // UID do usuário dono da tarefa (vinculado ao FirebaseAuth)

  // Construtor do modelo Tarefa
  Tarefa({
    required this.id,
    required this.titulo,
    required this.dataInicio,
    required this.uid,
    this.descricao,
    this.dataFim,
  });

  // 🔁 Converte um documento Firestore em um objeto Tarefa
  factory Tarefa.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Tarefa(
      id: doc.id, // Pega o ID automático gerado pelo Firestore
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'],
      // Converte Timestamp do Firestore em DateTime do Flutter
      dataInicio: (data['dataInicio'] as Timestamp).toDate(),
      dataFim:
          data['dataFim'] != null
              ? (data['dataFim'] as Timestamp).toDate()
              : null,
      uid: data['uid'] ?? '', // UID do usuário que criou essa tarefa
    );
  }

  // 🔁 Converte objeto Tarefa em Mapa para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      // Converte DateTime do Flutter para Timestamp do Firestore
      'dataInicio': Timestamp.fromDate(dataInicio),
      'dataFim': dataFim != null ? Timestamp.fromDate(dataFim!) : null,
      'uid': uid, // UID necessário para filtrar tarefas por usuário
    };
  }
}
