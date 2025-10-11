import 'package:flutter/material.dart';
import '../model/cliente.dart';
import '../repository/cliente_repository.dart';

// ViewModel que expõe dados e ações para as Views (usa ChangeNotifier para MVVM reativo)
class ClienteViewModel extends ChangeNotifier {
  // Repositório de dados (injeção simples via construtor)
  final ClienteRepository _repository;

  // Lista pública de clientes que a View irá observar
  List<Cliente> clientes = [];

  // Último filtro usado (para manter a lista consistente ao voltar da tela de edição)
  String _ultimoFiltro = '';

  // Construtor recebe o repositório
  ClienteViewModel(this._repository) {
    // Ao construir o ViewModel, carregamos a lista inicial
    loadClientes();
  }

  // Carrega clientes do repositório com filtro opcional
  Future<void> loadClientes([String filtro = '']) async {
    // Guarda o filtro atual
    _ultimoFiltro = filtro;
    // Busca no repositório
    clientes = await _repository.buscar(filtro: filtro);
    // Notifica listeners (Views que usam Provider/Consumer serão atualizadas)
    notifyListeners();
  }

  // Adiciona um cliente
  Future<void> adicionarCliente(Cliente cliente) async {
    await _repository.inserir(cliente);
    // Recarrega a lista com o último filtro aplicado
    await loadClientes(_ultimoFiltro);
  }

  // Atualiza um cliente
  Future<void> editarCliente(Cliente cliente) async {
    await _repository.atualizar(cliente);
    await loadClientes(_ultimoFiltro);
  }

  // Remove um cliente pelo código
  Future<void> removerCliente(int codigo) async {
    await _repository.excluir(codigo);
    await loadClientes(_ultimoFiltro);
  }
}
