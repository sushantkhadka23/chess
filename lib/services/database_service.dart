import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/game_state.dart';
import '../constants/app_constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.dbName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.dbTableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        board TEXT NOT NULL,
        currentPlayer TEXT NOT NULL,
        moveHistory TEXT NOT NULL,
        halfMoveClock INTEGER NOT NULL,
        positionCount TEXT NOT NULL,
        status TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');
  }

  Future<int> saveGame(GameState gameState) async {
    final db = await database;
    gameState.updatedAt = DateTime.now();

    if (gameState.id == null) {
      final id = await db.insert(AppConstants.dbTableName, gameState.toMap());
      gameState.id = id;
      return id;
    } else {
      await db.update(AppConstants.dbTableName, gameState.toMap(), where: 'id = ?', whereArgs: [gameState.id]);
      return gameState.id!;
    }
  }

  Future<GameState?> loadGame(int id) async {
    final db = await database;
    final result = await db.query(AppConstants.dbTableName, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return GameState.fromMap(result.first);
    }
    return null;
  }

  Future<GameState?> getLastGame() async {
    final db = await database;
    final result = await db.query(AppConstants.dbTableName, orderBy: 'updatedAt DESC', limit: 1);

    if (result.isNotEmpty) {
      return GameState.fromMap(result.first);
    }
    return null;
  }

  Future<List<GameState>> getAllGames() async {
    final db = await database;
    final result = await db.query(AppConstants.dbTableName, orderBy: 'updatedAt DESC');

    return result.map((map) => GameState.fromMap(map)).toList();
  }

  Future<void> deleteGame(int id) async {
    final db = await database;
    await db.delete(AppConstants.dbTableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllGames() async {
    final db = await database;
    await db.delete(AppConstants.dbTableName);
  }
}
