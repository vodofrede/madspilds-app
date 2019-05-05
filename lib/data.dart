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
        udloebsdato TEXT
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
        udloebsdato TEXT
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
      MadType fundetMadType = madTyper[madTyper.indexOf(madType)];
      print("Fandt madtype: " + fundetMadType.toString());
      return fundetMadType; 
    } else {
      int madtypeId = await indsaetMadType(madType);
      madType.id = madtypeId;
      print("Indsætter madtype: " + madType.toString());
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

    final List<Map> maps = await db.query("madtyper");
    List<MadType> madTyper = List<MadType>();

    for (Map map in maps) {
      madTyper.add(MadType.fromMap(map));
    }

    return madTyper;
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

    final List<Map> maps = await db.query("madvarer");
    List<MadVare> madVarer = List<MadVare>();

    for (Map map in maps) {
      madVarer.add(MadVare.fromMap(map));
    }

    return madVarer;
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
    return "ID:" + this.id.toString() + " " + this.navn;
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
    udloebsdato = DateTime.parse(map['udloebsdato']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type_id': type_id,
      'antal': antal,
      'udloebsdato': udloebsdato.toIso8601String(),
    };
  }

  int dageTilbage() {
    return udloebsdato.difference(DateTime.now()).inDays;
  }

  Future<MadType> findType() async {
    DatabaseEjer db = DatabaseEjer.instans;

    return db.findMadType(type_id);
  }

  @override
  String toString() {
    return this.antal.toString() + " af ID:" + this.type_id.toString() + ", udløber " + this.udloebsdato.toString();
  }

  bool operator ==(o) => o is MadVare && type_id == o.type_id && antal == o.antal && udloebsdato == o.udloebsdato;
  int get hashCode => hash3(type_id.hashCode, antal.hashCode, udloebsdato.hashCode);
}