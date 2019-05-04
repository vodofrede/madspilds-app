import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:quiver/core.dart';

import 'dart:async';

class DatabaseEjer {
  static final _databaseNavn = "madvare_database.db";
  static final _databaseVersion = 1;
  static Database _database;

  DatabaseEjer._privateConstructor();
  static final DatabaseEjer instans =  DatabaseEjer._privateConstructor();

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
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    print("Creating database");
    await db.execute('''
      CREATE TABLE madtyper (
        id INTEGER PRIMARY KEY,
        navn TEXT NOT NULL,
        kategori TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE madvarer (
        id INTEGER PRIMARY KEY,
        type_id INTEGER,
        antal INTEGER NOT NULL,
        udloebsdato DATETIME
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('''
      CREATE TABLE madtyper (
        id INTEGER PRIMARY KEY,
        navn TEXT NOT NULL,
        kategori TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE madvarer (
        id INTEGER PRIMARY KEY,
        type_id INTEGER,
        antal INTEGER NOT NULL,
        udloebsdato DATETIME
      )
    ''');
  }

  //
  // Funktioner for madtyper 
  //
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

  Future<MadType> findEllerIndsaetMadType(MadType madType) async {
    List<MadType> madTyper = await alleMadTyper();

    if (madTyper.contains(madType)) {
      print("Fandt madtype: " + madType.toString());
      return madType; 
    } else {
      print("Indsætter madtype: " + madType.toString());
      indsaetMadType(madType);
      return madType;
    }
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

  //
  // Funktioner for madvarer (varer, du tjekker ind)
  //
  Future<int> indsaetMadVare(MadVare madVare) async {
    Database db = await database;
    int id = await db.insert(
      'madvarer', 
      madVare.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    return id;
  }

  Future<MadVare> findMadVare(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(
      'madvarer',
      columns: ['id', 'type_id', 'antal', 'udloebsdato'],
      where: 'id = ?',
      whereArgs: [id]
    );

    if (maps.length > 0) {
      return MadVare.fromMap(maps.first); 
    }

    return null;
  }

  Future<void> sletMadVare(int id) async {
    Database db = await database;

    await db.delete(
      'madvarer',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<MadVare>> alleMadVarer() async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('madvarer');

    return List.generate(maps.length, (i) {
      return MadVare(
        id: maps[i]['id'],
        type_id: maps[i]['type_id'],
        antal: maps[i]['antal'],
        udloebsdato: maps[i]['udloebsdato'],
      );
    });
  }

  Future<void> opdaterMadVare(MadVare madVare) async {
    Database db = await database;

    await db.update(
      'madvarer', 
      madVare.toMap(),
      where: "id = ?",
      whereArgs: [madVare.id],
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

  @override
  String toString() {
    return "(" + this.navn + ", " + this.kategori + ")";
  }

  bool operator ==(o) => o is MadType && navn.toLowerCase() == o.navn.toLowerCase() && kategori.toLowerCase() == o.kategori.toLowerCase();
  int get hashCode => hash2(navn.toLowerCase().hashCode, kategori.toLowerCase().hashCode);
}

class MadVare {
  int id;
  int type_id;
  int antal;
  DateTime udloebsdato;

  MadVare({this.id, this.type_id, this.antal, this.udloebsdato});

  MadVare.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    type_id = map['type_id'];
    antal = map['antal'];
    udloebsdato = map['udloebsdato'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type_id': type_id,
      'antal': antal,
      'udloebsdato': udloebsdato,
    };
  }

  @override
  String toString() {
    return this.antal.toString() + " af ID:" + this.type_id.toString() + ", udløber " + udloebsdato.weekday.toString();
  }

  bool operator ==(o) => o is MadVare && type_id == o.type_id && antal == o.antal && udloebsdato == o.udloebsdato;
  int get hashCode => hash3(type_id.hashCode, antal.hashCode, udloebsdato.hashCode);
}