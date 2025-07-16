import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'main.dart'; // Assuming Event class is in main.dart

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'events.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE events(id INTEGER PRIMARY KEY, title TEXT, eventTime TEXT, description TEXT)",
        );
      },
    );
  }

  Future<void> insertEvent(Event event) async {
    final db = await database;
    await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Event>> getEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) {
      return Event(
        id: maps[i]['id'],
        title: maps[i]['title'],
        eventTime: DateTime.parse(maps[i]['eventTime']),
        description: maps[i]['description'],
      );
    });
  }

  Future<void> clearEvents() async {
    final db = await database;
    await db.delete('events');
  }
}

extension EventExtension on Event {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'eventTime': eventTime.toIso8601String(),
      'description': description,
    };
  }
}
