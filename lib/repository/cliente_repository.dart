import 'package:exdb/model/cliente.dart';

import '../model/cliente.dart';
import '../db/db_helper.dart';

// Repositório que abstrai as operações CRUD no banco (camada de dados)
class ClienteRepository {
  // Pega a instância do DatabaseHelper
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Insere um cliente e retorna o id gerado
  Future<int> inserir(Cliente cliente) async {
    final db = await _dbHelper.database;
    // Insert automágico: se cliente.codigo for null, SQLite gera o AUTOINCREMENT
    return await db.insert('clientes', cliente.toMap());
  }

  // Atualiza um cliente existente
  Future<int> atualizar(Cliente cliente) async {
    final db = await _dbHelper.database;
    return await db.update(
      'clientes',
      cliente.toMap(),
      where: 'codigo = ?',
      whereArgs: [cliente.codigo],
    );
  }

  // Exclui um cliente pelo código
  Future<int> excluir(int codigo) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'clientes',
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }

  // Busca clientes, opcionalmente filtrando por nome (LIKE)
  Future<List<Cliente>> buscar({String filtro = ''}) async {
    final db = await _dbHelper.database;

    // Se filtro vazio, traz todos ordenados por nome
    final List<Map<String, dynamic>> maps = filtro.isEmpty
        ? await db.query('clientes', orderBy: 'nome')
        : await db.query(
            'clientes',
            where: 'nome LIKE ?',
            whereArgs: ['%$filtro%'],
            orderBy: 'nome',
          );

    // Converte List<Map> em List<Cliente>
    return maps.map((m) => Cliente.fromMap(m)).toList();
  }
}
