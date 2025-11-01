import 'package:flutter/material.dart';
import '../model/cliente.dart';
import '../repository/cliente_repository.dart';

class ClienteDTO {
  final int? codigo;
  final String cpf;
  final String nome;
  final String idade;
  final String dataNascimento;
  final String cidadeNascimento;
  final String subtitulo;

  ClienteDTO({
    required this.codigo,
    required this.cpf,
    required this.nome,
    required this.idade,
    required this.dataNascimento,
    required this.cidadeNascimento,
    required this.subtitulo,
  });

  factory ClienteDTO.fromModel(Cliente cliente) {
    return ClienteDTO(
      codigo: cliente.codigo,
      cpf: cliente.cpf,
      nome: cliente.nome,
      idade: cliente.idade.toString(),
      dataNascimento: cliente.dataNascimento,
      cidadeNascimento: cliente.cidadeNascimento,
      subtitulo: 'CPF: ${cliente.cpf} · ${cliente.cidadeNascimento}',
    );
  }

  Cliente toModel() {
    return Cliente(
      codigo: codigo,
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
    );
  }
}

class ClienteViewModel extends ChangeNotifier {
  final ClienteRepository _repository;
  List<Cliente> _clientes = [];
  String _ultimoFiltro = '';

  List<ClienteDTO> get clientes =>
      _clientes.map((c) => ClienteDTO.fromModel(c)).toList();

  ClienteViewModel(this._repository) {
    loadClientes();
  }

  // Delegate all persistence operations to the repository; the repository
  // itself decides between SQLite and Firebase using PersistenciaHelper.

  Future<void> loadClientes([String filtro = '']) async {
    _ultimoFiltro = filtro;

    _clientes = await _repository.buscar(filtro: filtro);

    notifyListeners();
  }

  Future<void> adicionarCliente({
    required String cpf,
    required String nome,
    required String idade,
    required String dataNascimento,
    required String cidadeNascimento,
  }) async {
    final cliente = Cliente(
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
    );

    await _repository.inserir(cliente);

    await loadClientes(_ultimoFiltro);
  }

  Future<void> editarCliente({
    required int codigo,
    required String cpf,
    required String nome,
    required String idade,
    required String dataNascimento,
    required String cidadeNascimento,
  }) async {
    final cliente = Cliente(
      codigo: codigo,
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
    );
    await _repository.atualizar(cliente);

    await loadClientes(_ultimoFiltro);
  }

  Future<void> removerCliente({int? codigo, String? cpf}) async {
    await _repository.excluir(codigo: codigo, cpf: cpf);

    await loadClientes(_ultimoFiltro);
  }
}
