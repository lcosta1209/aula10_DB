class ClienteDTO {
  int? codigo;
  String nome;
  String email;

  ClienteDTO({
    this.codigo,
    required this.nome,
    required this.email,
  });

  String get subtitulo => 'Email: $email';
}
