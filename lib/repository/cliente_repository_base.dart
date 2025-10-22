import '../model/cliente.dart';

abstract class ClienteRepositoryBase {
  Future<List<Cliente>> buscar({String filtro = ''});
  Future<void> inserir(Cliente cliente);
  Future<void> atualizar(Cliente cliente);
  Future<void> excluir(int id);
}