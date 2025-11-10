import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Obtiene la instancia de la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cherry_block.db');
    return _database!;
  }

  /// Inicializa la base de datos local
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Crea las tablas necesarias
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trabajadores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        codigo TEXT,
        cajas INTEGER,
        etiqueta_nfc TEXT UNIQUE,
        fecha_registro TEXT
      )
    ''');
  }

  /// Inserta un nuevo trabajador
  Future<void> insertTrabajador(Map<String, dynamic> trabajador) async {
    final db = await instance.database;
    await db.insert(
      'trabajadores',
      trabajador,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Obtiene todos los trabajadores
  Future<List<Map<String, dynamic>>> getAllTrabajadores() async {
    final db = await instance.database;
    return await db.query('trabajadores', orderBy: 'fecha_registro DESC');
  }

  Future<Map<String, dynamic>?> buscarTrabajadorPorEtiqueta(String etiqueta) async {
    final db = await instance.database;
    final result = await db.query(
      'trabajadores',
      where: 'etiqueta_nfc = ?',
      whereArgs: [etiqueta],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  /// Busca un trabajador por su etiqueta NFC
  Future<Map<String, dynamic>?> getTrabajadorByNfc(String etiquetaNfc) async {
    final db = await instance.database;
    final result = await db.query(
      'trabajadores',
      where: 'etiqueta_nfc = ?',
      whereArgs: [etiquetaNfc],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  /// Actualiza los datos de un trabajador (por ejemplo, cantidad de cajas)
  Future<void> updateTrabajador(Map<String, dynamic> trabajador) async {
    final db = await instance.database;
    await db.update(
      'trabajadores',
      trabajador,
      where: 'id = ?',
      whereArgs: [trabajador['id']],
    );
  }

  /// Elimina un trabajador por ID
  Future<void> deleteTrabajador(int id) async {
    final db = await instance.database;
    await db.delete('trabajadores', where: 'id = ?', whereArgs: [id]);
  }

  /// Elimina todos los registros (por mantenimiento o debug)
  Future<void> clearAllTrabajadores() async {
    final db = await instance.database;
    await db.delete('trabajadores');
  }

  /// Cierra la base de datos
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
