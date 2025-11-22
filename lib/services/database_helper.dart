// services/database_helper.dart
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cosecheros.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trabajadores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        codigo TEXT UNIQUE,
        cajas INTEGER DEFAULT 0,
        identificador TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cajas_registro (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trabajador_id INTEGER,
        cantidad INTEGER,
        hora TEXT,
        FOREIGN KEY(trabajador_id) REFERENCES trabajadores(id)
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS cajas_registro (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          trabajador_id INTEGER,
          cantidad INTEGER,
          hora TEXT,
          FOREIGN KEY(trabajador_id) REFERENCES trabajadores(id)
        )
      ''');
    }
  }

  Future<int> insertTrabajador(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('trabajadores', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getTrabajadorByCodigo(String codigo) async {
    final db = await instance.database;
    final result = await db.query(
      'trabajadores',
      where: 'codigo = ?',
      whereArgs: [codigo],
      limit: 1,
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<List<Map<String, dynamic>>> buscarTrabajadores(String query) async {
    final db = await instance.database;
    final q = '%${query.trim().toLowerCase()}%';
    return await db.rawQuery(
      'SELECT * FROM trabajadores WHERE LOWER(nombre) LIKE ? OR LOWER(codigo) LIKE ? ORDER BY nombre ASC',
      [q, q],
    );
  }

  Future<List<Map<String, dynamic>>> getAllTrabajadores() async {
    final db = await instance.database;
    return await db.query('trabajadores', orderBy: 'nombre ASC');
  }

  Future<int> updateTrabajador(Map<String, dynamic> trabajador) async {
    final db = await instance.database;
    return await db.update(
      'trabajadores',
      trabajador,
      where: 'id = ?',
      whereArgs: [trabajador['id']],
    );
  }

  Future<int> updateCajasById(int trabajadorId, int nuevasCajas) async {
    final db = await instance.database;
    return await db.update(
      'trabajadores',
      {'cajas': nuevasCajas},
      where: 'id = ?',
      whereArgs: [trabajadorId],
    );
  }

  Future<int> desvincularQR(int id) async {
    final db = await instance.database;
    return await db.update('trabajadores', {'codigo': null}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTrabajador(int id) async {
    final db = await instance.database;

    await db.delete('cajas_registro', where: 'trabajador_id = ?', whereArgs: [id]);

    return await db.delete('trabajadores', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertCajaRegistro(int trabajadorId, int cantidad) async {
    final db = await instance.database;
    final ahora = DateTime.now().toIso8601String();
    return await db.insert('cajas_registro', {
      'trabajador_id': trabajadorId,
      'cantidad': cantidad,
      'hora': ahora,
    });
  }

  Future<List<Map<String, dynamic>>> getRegistrosByTrabajador(int trabajadorId) async {
    final db = await instance.database;
    return await db.query(
      'cajas_registro',
      where: 'trabajador_id = ?',
      whereArgs: [trabajadorId],
      orderBy: 'hora DESC',
    );
  }

  Future<int> deleteCajaRegistro(int registroId) async {
    final db = await instance.database;

    final regs = await db.query(
      'cajas_registro',
      where: 'id = ?',
      whereArgs: [registroId],
      limit: 1,
    );

    if (regs.isEmpty) return 0;
    final reg = regs.first;
    final trabajadorId = reg['trabajador_id'] as int;
    final cantidad = reg['cantidad'] as int;

    final deleted = await db.delete(
      'cajas_registro',
      where: 'id = ?',
      whereArgs: [registroId],
    );

    final t = await db.query(
      'trabajadores',
      where: 'id = ?',
      whereArgs: [trabajadorId],
      limit: 1,
    );

    if (t.isNotEmpty) {
      final current = t.first;
      final currentBoxes = (current['cajas'] ?? 0) as int;
      int updatedBoxes = currentBoxes - cantidad;
      if (updatedBoxes < 0) updatedBoxes = 0;
      await updateCajasById(trabajadorId, updatedBoxes);
    }

    return deleted;
  }

  Future<int> getTotalBoxes() async {
    final db = await instance.database;
    final res = await db.rawQuery('SELECT SUM(cantidad) as total FROM cajas_registro');
    if (res.isNotEmpty) {
      final t = res.first['total'];
      if (t == null) return 0;
      return (t as int);
    }
    return 0;
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('cajas_registro');
    await db.delete('trabajadores');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) await db.close();
  }


  Future<Map<String, dynamic>?> buscarTrabajadorPorEtiqueta(String tagData) async {
    final db = await instance.database;
    final result = await db.query(
      'trabajadores',
      where: 'identificador = ?',
      whereArgs: [tagData],
      limit: 1,
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<void> agregarIdentificador(int id, String idf) async {
    final db = await instance.database;
    await db.update(
      'trabajadores',
      {'identificador': idf},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> sumarCajas(int trabajadorId, int cantidad) async { 
    final db = await instance.database; 
    await db.rawUpdate(""" UPDATE trabajadores SET cajas = cajas + ? WHERE id = ? """, 
    [cantidad, trabajadorId]); 
    await db.insert('registros', { 'trabajador_id': trabajadorId, 'cantidad': cantidad, 'hora': 
    DateTime.now().toString() }); }
}
