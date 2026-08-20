import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'contacts.db',
    );

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        address TEXT NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        imagePath TEXT
      )
    ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE contacts ADD COLUMN imagePath TEXT');
    }
  }

  // CREATE
  Future<int> insertContact(Contact contact) async {
    final db = await database;

    return await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ ALL
  Future<List<Contact>> getContacts() async {
    final db = await database;

    final result = await db.query(
      'contacts',
      orderBy: 'name COLLATE NOCASE ASC',
    );

    return result.map((map) {
      return Contact.fromMap(map);
    }).toList();
  }

  // READ BY ID
  Future<Contact?> getContactById(int id) async {
    final db = await database;

    final result = await db.query(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Contact.fromMap(result.first);
  }

  // SEARCH
  Future<List<Contact>> searchContacts(String query) async {
    final db = await database;

    final result = await db.query(
      'contacts',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name COLLATE NOCASE ASC',
    );

    return result.map((map) {
      return Contact.fromMap(map);
    }).toList();
  }

  // FAVORITES
  Future<List<Contact>> getFavoriteContacts() async {
    final db = await database;

    final result = await db.query(
      'contacts',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'name COLLATE NOCASE ASC',
    );

    return result.map((map) {
      return Contact.fromMap(map);
    }).toList();
  }

  // UPDATE
  Future<int> updateContact(Contact contact) async {
    final db = await database;

    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // DELETE
  Future<int> deleteContact(int id) async {
    final db = await database;

    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // TOGGLE FAVORITE
  Future<int> toggleFavorite(
      int id,
      bool isFavorite,
      ) async {
    final db = await database;

    return await db.update(
      'contacts',
      {
        'isFavorite': isFavorite ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
