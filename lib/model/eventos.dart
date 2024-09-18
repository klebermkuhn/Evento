class Event {
  final int? id;
  final String nome;
  final DateTime dataHora;
  final String local; // Data e horário combinados em um único campo
  final String convidados;
  // Construtor
  Event({
    this.id,
    required this.nome,
    required this.dataHora,
    required this.local,
    required this.convidados,
  });

  // Método toMap para converter o objeto em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'dataHora': dataHora.toIso8601String(),
      'local': local, // Convertendo para string ISO 8601
      'convidados': convidados
    };
  }

  // Método toString para exibir os dados do objeto como string
  @override
  String toString() {
    return 'Event{id: $id, nome: $nome, local: $local, convidados: $convidados, dataHora: ${dataHora.toIso8601String()}}';
  }
}
