import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseEjer {
  static final _databaseNavn = "madvare_database.db";
  static final _databaseVersion = 1;
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String databaseMappe = await getDatabasesPath();
    String sti = join(databaseMappe, _databaseNavn);
    return await openDatabase(
      sti,
      version: _databaseVersion,
      onCreate: _onCreate,
    
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE madtyper (
        id INTEGER PRIMARY KEY,
        navn TEXT NOT NULL,
        kategori TEXT
      );
      CREATE TABLE madvarer (
        id INTEGER PRIMARY KEY,
        type TEXT NOT NULL,
        antal INTEGER NOT NULL,
        udloebsdato TEXT,
      );
    ''');
  }

  Future<int> indsaetMadType(MadType madType) async {
    Database db = await database;
    int id = await db.insert(
      'madtyper', 
      madType.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    return id;
  }

  Future<MadType> findMadType(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(
      'madtyper',
      columns: ['id', 'navn', 'kategori'],
      where: 'id = ?',
      whereArgs: [id]
    );

    if (maps.length > 0) {
      return MadType.fromMap(maps.first); 
    }

    return null;
  }

  Future<void> sletMadType(int id) async {
    Database db = await database;

    await db.delete(
      'madtyper',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<MadType>> alleMadTyper() async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('madtyper');

    return List.generate(maps.length, (i) {
      return MadType(
        id: maps[i]['id'],
        navn: maps[i]['navn'],
        kategori: maps[i]['kategori'],
      );
    });
  }

  Future<void> opdaterMadType(MadType madType) async {
    Database db = await database;

    await db.update(
      'madtyper', 
      madType.toMap(),
      where: "id = ?",
      whereArgs: [madType.id],
    );
  }
}

class MadType {
  int id;
  String navn;
  String kategori;

  MadType({this.id, this.navn, this.kategori});

  MadType.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    navn = map['navn'];
    kategori = map['kategori'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'navn': navn,
      'kategori': kategori,
    };
  }
}

class MadVare {
  MadType type;
  int antal;
  DateTime udloebsdato;

  MadVare({this.type, this.antal, this.udloebsdato});
}