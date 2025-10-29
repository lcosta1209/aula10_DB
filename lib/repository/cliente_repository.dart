import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/db_helper.dart';
import '../db/persistencia_helper.dart';
import '../model/cliente.dart';

class ClienteRepository {
  final _firestore = FirebaseFirestore.instance;
  final _table = 'clientes';

  Future<List<Cliente>> buscar({String filtro = ''}) async {
    final usaFirebase = await PersistenciaHelper.getUsaFirebase();

    if (usaFirebase) {
      final query = await _firestore
          .collection(_table)
          .where('nome', isGreaterThanOrEqualTo: filtro)
          .get();
      return query.docs.map((d) => Cliente.fromMap(d.data())).toList();
    } else {
      final db = await DatabaseHelper.instance.database;
      final maps = await db.query(
        _table,
        where: filtro.isNotEmpty ? 'nome LIKE ?' : null,
        whereArgs: filtro.isNotEmpty ? ['%$filtro%'] : null,
      );
      return maps.map((m) => Cliente.fromMap(m)).toList();
    }
  }

  Future<void> inserir(Cliente cliente) async {
    final usaFirebase = await PersistenciaHelper.getUsaFirebase();

    if (usaFirebase) {
      await _firestore.collection(_table).add(cliente.toMap());
    } else {
      final db = await DatabaseHelper.instance.database;
      await db.insert(_table, cliente.toMap());
    }
  }

  Future<void> atualizar(Cliente cliente) async {
    final usaFirebase = await PersistenciaHelper.getUsaFirebase();

    if (usaFirebase) {
      final query = await _firestore
          .collection(_table)
          .where('cpf', isEqualTo: cliente.cpf)
          .get();

      if (query.docs.isNotEmpty) {
        await _firestore
            .collection(_table)
            .doc(query.docs.first.id)
            .update(cliente.toMap());
      }
    } else {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        _table,
        cliente.toMap(),
        where: 'codigo = ?',
        whereArgs: [cliente.codigo],
      );
    }
  }

  Future<void> excluir(int codigo) async {
    final usaFirebase = await PersistenciaHelper.getUsaFirebase();

    if (usaFirebase) {
      final query = await _firestore
          .collection(_table)
          .where('codigo', isEqualTo: codigo)
          .get();

      if (query.docs.isNotEmpty) {
        await _firestore.collection(_table).doc(query.docs.first.id).delete();
      }
    } else {
      final db = await DatabaseHelper.instance.database;
      await db.delete(
        _table,
        where: 'codigo = ?',
        whereArgs: [codigo],
      );
    }
  }
}
