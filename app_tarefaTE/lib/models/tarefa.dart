class Tarefa {
  String titulo;
  DateTime dataInicio;
  String? descricao; // opcional
  DateTime? dataFim; // opcional

  Tarefa({
    required this.titulo,
    required this.dataInicio,
    this.descricao,
    this.dataFim,
  });

  // Útil para futura integração com Firebase ou banco local
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'dataInicio': dataInicio.toIso8601String(),
      'descricao': descricao,
      'dataFim': dataFim?.toIso8601String(),
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      titulo: map['titulo'] ?? '',
      dataInicio: DateTime.parse(map['dataInicio']),
      descricao: map['descricao'],
      dataFim: map['dataFim'] != null ? DateTime.parse(map['dataFim']) : null,
    );
  }
}
