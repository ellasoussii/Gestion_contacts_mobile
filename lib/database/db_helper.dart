import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/contact.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _createDB,
    );
  }

  // Activer les foreign keys (important pour ON DELETE CASCADE)
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    // Table des utilisateurs
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // Table des contacts
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        surname TEXT,
        phone TEXT NOT NULL,
        birthdate TEXT,
        photo TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }

  // ---------- USERS ----------
  Future<int> addUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (res.isNotEmpty) return User.fromMap(res.first);
    return null;
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await instance.database;
    final res = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (res.isNotEmpty) return User.fromMap(res.first);
    return null;
  }

  // ---------- CONTACTS ----------
  Future<int> addContact(Contact contact) async {
    final db = await instance.database;
    // on enlève l'id si null pour que sqlite autogen l'id
    final map = contact.toMap()..remove('id');
    return await db.insert('contacts', map);
  }

  Future<List<Contact>> getContactsByUser(int userId) async {
    final db = await instance.database;
    final res = await db.query(
      'contacts',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return res.map((m) => Contact.fromMap(m)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    final db = await instance.database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
