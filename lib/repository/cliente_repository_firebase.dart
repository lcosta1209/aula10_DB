import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/cliente.dart';

class ClienteRepositoryFirebase {
  final _collection = FirebaseFirestore.instance.collection('clientes');

  Future<List<Cliente>> buscar() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => Cliente.fromMap(doc.data())).toList();
  }

  Future<void> inserir(Cliente cliente) async {
    await _collection.add(cliente.toMap());
  }

  Future<void> atualizar(Cliente cliente) async {
    await _collection.doc(cliente.firebaseId).set(cliente.toMap());
  }

  Future<void> excluir(String firebaseId) async {
    await _collection.doc(firebaseId).delete();
  }
}