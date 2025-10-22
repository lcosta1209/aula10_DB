// Classe que representa o modelo de dados 'Cidade'.
class Cidade {
  // A propriedade 'id' é a chave primária (autoincrement)
  int? id; // pode ser null ao criar uma nova cidade

  // Nome da cidade
  String nomeCidade;

  // Construtor com campos obrigatórios (exceto id)
  Cidade({
    this.id,
    required this.nomeCidade,
  });

  // Converte o objeto Cidade em Map<String, dynamic> para inserir/atualizar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id, // pode ser null (SQLite atribuirá autoincrement)
      'nomeCidade': nomeCidade,
    };
  }

  // Cria um objeto Cidade a partir de um Map (resultado de uma query no SQLite)
  factory Cidade.fromMap(Map<String, dynamic> map) {
    return Cidade(
      id: map['id'],
      nomeCidade: map['nomeCidade'],
    );
  }

  @override
  String toString() {
    return 'Cidade{id: $id, nomeCidade: $nomeCidade}';
  }
}