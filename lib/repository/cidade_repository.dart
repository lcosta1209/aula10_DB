import '../model/cidade.dart';
import '../db/db_helper.dart';

abstract class ICidadeRepository {
  Future<int> inserir(Cidade cidade);
  Future<int> atualizar(Cidade cidade);
  Future<int> excluir(int id);
  Future<List<Cidade>> buscar({String filtro = ''});
}

class CidadeRepository implements ICidadeRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<int> inserir(Cidade cidade) async {
    final db = await _dbHelper.database;
    return await db.insert('cidades', cidade.toMap());
  }

  @override
  Future<int> atualizar(Cidade cidade) async {
    final db = await _dbHelper.database;
    return await db.update(
      'cidades',
      cidade.toMap(),
      where: 'id = ?',
      whereArgs: [cidade.id],
    );
  }

  @override
  Future<int> excluir(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'cidades',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Cidade>> buscar({String filtro = ''}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = filtro.isEmpty
        ? await db.query('cidades', orderBy: 'nomeCidade')
        : await db.query(
            'cidades',
            where: 'nomeCidade LIKE ?',
            whereArgs: ['%$filtro%'],
            orderBy: 'nomeCidade',
          );
    return maps.map((m) => Cidade.fromMap(m)).toList();
  }
}