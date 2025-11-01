import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/db_helper.dart';
import '../db/persistencia_helper.dart';
import '../model/cliente.dart';

class ClienteRepository {
  final _table = 'clientes';

  Future<List<Cliente>> buscar({String filtro = ''}) async {
    final usaFirebase = await PersistenciaHelper.getUsaFirebase();

    if (usaFirebase) {
      // Obtain the Firestore instance lazily only when needed (after Firebase.initializeApp())
      final firestore = FirebaseFirestore.instance;
      final query = await firestore
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
      final firestore = FirebaseFirestore.instance;
      await firestore.collection(_table).add(cliente.toMap());
    } else {
      final db = await DatabaseHelper.instance.database;
      await db.insert(_table, cliente.toMap());
    }
  }

  Future<void> atualizar(Cliente cliente) async {
    final usaFirebase = await PersistenciaHelper.getUsaFirebase();

    if (usaFirebase) {
      final firestore = FirebaseFirestore.instance;
      final query = await firestore
          .collection(_table)
          .where('cpf', isEqualTo: cliente.cpf)
          .get();

      if (query.docs.isNotEmpty) {
        await firestore
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

  /// Exclui um cliente. Para Firebase, prefira passar [cpf] (string) —
  /// se [cpf] for fornecido, a remoção será feita por CPF. Para SQLite,
  /// [codigo] é usado como chave primária.
  Future<void> excluir({int? codigo, String? cpf}) async {
    final usaFirebase = await PersistenciaHelper.getUsaFirebase();

    if (usaFirebase) {
      final firestore = FirebaseFirestore.instance;

      if (cpf != null && cpf.isNotEmpty) {
        final query = await firestore
            .collection(_table)
            .where('cpf', isEqualTo: cpf)
            .get();

        for (var doc in query.docs) {
          await firestore.collection(_table).doc(doc.id).delete();
        }
      } else if (codigo != null) {
        final query = await firestore
            .collection(_table)
            .where('codigo', isEqualTo: codigo)
            .get();

        for (var doc in query.docs) {
          await firestore.collection(_table).doc(doc.id).delete();
        }
      }
    } else {
      final db = await DatabaseHelper.instance.database;
      if (codigo != null) {
        await db.delete(
          _table,
          where: 'codigo = ?',
          whereArgs: [codigo],
        );
      }
    }
  }
}
