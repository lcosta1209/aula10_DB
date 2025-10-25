// Classe que representa o modelo de dados 'Cliente'.
class Cliente {
  int? codigo; // SQLite
  String cpf;
  String nome;
  int idade;
  String dataNascimento;
  String cidadeNascimento;
  String? firebaseId; // Firebase

  Cliente({
    this.codigo,
    required this.cpf,
    required this.nome,
    required this.idade,
    required this.dataNascimento,
    required this.cidadeNascimento,
    this.firebaseId,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'codigo': codigo,
      'cpf': cpf,
      'nome': nome,
      'idade': idade,
      'dataNascimento': dataNascimento,
      'cidadeNascimento': cidadeNascimento,
    };
    if (firebaseId != null) {
      map['firebaseId'] = firebaseId;
    }
    return map;
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      codigo: map['codigo'],
      cpf: map['cpf'],
      nome: map['nome'],
      idade: map['idade'],
      dataNascimento: map['dataNascimento'],
      cidadeNascimento: map['cidadeNascimento'],
      firebaseId: map['firebaseId'],
    );
  }
}
