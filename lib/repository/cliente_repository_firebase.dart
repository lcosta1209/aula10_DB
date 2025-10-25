import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/cliente.dart';
import 'cliente_repository.dart';

class ClienteRepositoryFirebase implements IClienteRepository {
  final _collection = FirebaseFirestore.instance.collection('clientes');

  @override
  Future<List<Cliente>> buscar({String filtro = ''}) async {
    final snapshot = await _collection.get();
    var clientes = snapshot.docs.map((doc) {
      var data = doc.data();
      // Adiciona o id do documento como firebaseId
      data['firebaseId'] = doc.id;
      return Cliente.fromMap(data);
    }).toList();
    if (filtro.isNotEmpty) {
      clientes = clientes.where((c) => c.nome.contains(filtro)).toList();
    }
    return clientes;
  }

  @override
  Future<int> inserir(Cliente cliente) async {
    final docRef = await _collection.add(cliente.toMap());
    // Retorna 1 para sucesso (Firebase não retorna int id)
    return docRef.id.isNotEmpty ? 1 : 0;
  }

  @override
  Future<int> atualizar(Cliente cliente) async {
    if (cliente.firebaseId == null) return 0;
    await _collection.doc(cliente.firebaseId).set(cliente.toMap());
    return 1;
  }

  @override
  Future<int> excluir(int codigo) async {
    // No Firebase, o código é o id do documento (firebaseId)
    // Aqui, você pode adaptar para buscar pelo id ou passar o firebaseId diretamente
    // Exemplo: excluir por firebaseId
    await _collection.doc(codigo.toString()).delete();
    return 1;
  }
}