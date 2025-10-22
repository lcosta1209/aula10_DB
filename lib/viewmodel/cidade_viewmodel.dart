import 'package:flutter/material.dart';
import '../model/cidade.dart';
import '../repository/cidade_repository.dart';

// DTO (Data Transfer Object) para expor dados formatados à View
// A View NÃO deve acessar o Model diretamente
class CidadeDTO {
  final int? id;
  final String nomeCidade;

  CidadeDTO({
    required this.id,
    required this.nomeCidade,
  });

  // Converte Model para DTO
  factory CidadeDTO.fromModel(Cidade cidade) {
    return CidadeDTO(
      id: cidade.id,
      nomeCidade: cidade.nomeCidade,
    );
  }

  // Converte DTO para Model
  Cidade toModel() {
    return Cidade(
      id: id,
      nomeCidade: nomeCidade,
    );
  }
}

// ViewModel que expõe dados e ações para as Views (usa ChangeNotifier para MVVM reativo)
class CidadeViewModel extends ChangeNotifier {
  // Repositório de dados (injeção simples via construtor)
  final CidadeRepository _repository;

  // Lista interna de cidades (Model) - privada
  List<Cidade> _cidades = [];

  // Lista pública de DTOs que a View irá observar
  List<CidadeDTO> get cidades =>
      _cidades.map((c) => CidadeDTO.fromModel(c)).toList();

  // Último filtro usado (para manter a lista consistente)
  String _ultimoFiltro = '';

  // Construtor recebe o repositório
  CidadeViewModel(this._repository) {
    // Ao construir o ViewModel, carregamos a lista inicial
    loadCidades();
  }

  // Carrega cidades do repositório com filtro opcional
  Future<void> loadCidades([String filtro = '']) async {
    // Guarda o filtro atual
    _ultimoFiltro = filtro;
    // Busca no repositório
    _cidades = await _repository.buscar(filtro: filtro);
    // Notifica listeners (Views que usam Provider/Consumer serão atualizadas)
    notifyListeners();
  }

  // Adiciona uma cidade (recebe dados primitivos da View)
  Future<void> adicionarCidade({
    required String nomeCidade,
  }) async {
    final cidade = Cidade(
      nomeCidade: nomeCidade,
    );
    await _repository.inserir(cidade);
    // Recarrega a lista com o último filtro aplicado
    await loadCidades(_ultimoFiltro);
  }

  // Atualiza uma cidade (recebe dados primitivos da View)
  Future<void> editarCidade({
    required int id,
    required String nomeCidade,
  }) async {
    final cidade = Cidade(
      id: id,
      nomeCidade: nomeCidade,
    );
    await _repository.atualizar(cidade);
    await loadCidades(_ultimoFiltro);
  }

  // Remove uma cidade pelo id
  Future<void> removerCidade(int id) async {
    await _repository.excluir(id);
    await loadCidades(_ultimoFiltro);
  }

  // Busca cidade por ID
  Future<CidadeDTO?> buscarCidadePorId(int id) async {
    final cidade = _cidades.firstWhere(
      (c) => c.id == id,
      orElse: () => Cidade(nomeCidade: ''),
    );
    return cidade.id != null ? CidadeDTO.fromModel(cidade) : null;
  }
}