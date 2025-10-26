import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/cliente.dart';
import '../db/db_helper.dart';
import '../db/persistencia_helper.dart';

class ClienteRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> inserir(Cliente cliente) async {
    final usaFirebase = await PersistenciaHelper.getUsaFirebase();

    if (usaFirebase) {
      await _firestore.collection('clientes').add(cliente.toMap());
    } else {
      final db = await DatabaseHelper.instance.database;
      await db.insert('clientes', cliente.toMap());
    }
  }

  Future<List<Cliente>> buscar({String filtro = ''}) async {
    final usaFirebase = await PersistenciaHelper.getUsaFirebase();

    if (usaFirebase) {
      final snapshot = await _firestore.collection('clientes').get();
      return snapshot.docs
          .map((doc) => Cliente.fromMap(doc.data()))
          .toList();
    } else {
      final db = await DatabaseHelper.instance.database;
      final maps = await db.query(
        'clientes',
        where: filtro.isNotEmpty ? 'nome LIKE ?' : null,
        whereArgs: filtro.isNotEmpty ? ['%$filtro%'] : null,
      );
      return maps.map((m) => Cliente.fromMap(m)).toList();
    }
  }

  Future<void> excluir(int codigo) async {
    final usaFirebase = await PersistenciaHelper.getUsaFirebase();

    if (usaFirebase) {
      // Simples: exclui todos com o mesmo código (se existir campo "codigo" no Firebase)
      final snapshot = await _firestore
          .collection('clientes')
          .where('codigo', isEqualTo: codigo)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } else {
      final db = await DatabaseHelper.instance.database;
      await db.delete('clientes', where: 'codigo = ?', whereArgs: [codigo]);
    }
  }
}
