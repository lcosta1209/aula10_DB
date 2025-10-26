import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/prefs_service.dart';
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

  // 🔹 Helper para saber se usa Firebase
  Future<bool> _useFirebase() async => await PrefsService.getUseFirebase();

  // 🔹 Carregar clientes (Firebase ou SQLite)
  Future<void> loadClientes([String filtro = '']) async {
    _ultimoFiltro = filtro;

    if (await _useFirebase()) {
      final snap = await FirebaseFirestore.instance.collection('clientes').get();
      _clientes = snap.docs.map((d) {
        final data = d.data();
        return Cliente(
          codigo: null, // Firestore usa ID string
          cpf: data['cpf'] ?? '',
          nome: data['nome'] ?? '',
          idade: data['idade'] ?? 0,
          dataNascimento: data['dataNascimento'] ?? '',
          cidadeNascimento: data['cidadeNascimento'] ?? '',
        );
      }).toList();
    } else {
      _clientes = await _repository.buscar(filtro: filtro);
    }

    notifyListeners();
  }

  // 🔹 Inserir cliente
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

    if (await _useFirebase()) {
      await FirebaseFirestore.instance.collection('clientes').add({
        'cpf': cpf,
        'nome': nome,
        'idade': int.tryParse(idade) ?? 0,
        'dataNascimento': dataNascimento,
        'cidadeNascimento': cidadeNascimento,
      });
    } else {
      await _repository.inserir(cliente);
    }

    await loadClientes(_ultimoFiltro);
  }

  // 🔹 Editar cliente
  Future<void> editarCliente({
    required int codigo,
    required String cpf,
    required String nome,
    required String idade,
    required String dataNascimento,
    required String cidadeNascimento,
  }) async {
    if (await _useFirebase()) {
      // No Firebase não temos "codigo", então você pode usar o CPF como identificador
      final snap = await FirebaseFirestore.instance
          .collection('clientes')
          .where('cpf', isEqualTo: cpf)
          .get();

      for (var doc in snap.docs) {
        await doc.reference.update({
          'nome': nome,
          'idade': int.tryParse(idade) ?? 0,
          'dataNascimento': dataNascimento,
          'cidadeNascimento': cidadeNascimento,
        });
      }
    } else {
      final cliente = Cliente(
        codigo: codigo,
        cpf: cpf,
        nome: nome,
        idade: int.tryParse(idade) ?? 0,
        dataNascimento: dataNascimento,
        cidadeNascimento: cidadeNascimento,
      );
      await _repository.atualizar(cliente);
    }

    await loadClientes(_ultimoFiltro);
  }

  // 🔹 Remover cliente
  Future<void> removerCliente(int codigo, [String? cpf]) async {
    if (await _useFirebase()) {
      final snap = await FirebaseFirestore.instance
          .collection('clientes')
          .where('cpf', isEqualTo: cpf)
          .get();

      for (var doc in snap.docs) {
        await doc.reference.delete();
      }
    } else {
      await _repository.excluir(codigo);
    }

    await loadClientes(_ultimoFiltro);
  }
}
