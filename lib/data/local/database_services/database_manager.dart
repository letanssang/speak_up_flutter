import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speak_up/data/local/database_services/database_key.dart';
import 'package:speak_up/domain/entities/word/word.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();

  factory DatabaseManager() => _instance;

  DatabaseManager._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}speak_up.db";
    ByteData data = await rootBundle.load("assets/database/speak_up.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
    return await openDatabase(path);
  }

  Future<List<Word>> getWordListByPhoneticID(int phoneticID) async {
    final db = await database;
    final maps = await db!.query(
      'word',
      where: 'phoneticID = ?',
      whereArgs: [phoneticID],
    );
    return List.generate(maps.length, (i) {
      final phoneticComponentString =
          maps[i][WordTable.phoneticComponents.field] as String;
      return Word(
        wordID: maps[i][WordTable.wordID.field] as int,
        word: maps[i][WordTable.word.field] as String,
        pronunciation: maps[i][WordTable.pronunciation.field] as String,
        phoneticComponents:
            convertStringToPhoneticComponentsMap(phoneticComponentString),
        translation: maps[i][WordTable.translation.field] as String,
        phoneticID: maps[i][WordTable.phoneticID.field] as int,
      );
    });
  }

  Map<String, int> convertStringToPhoneticComponentsMap(String string) {
    //convert String phoneticComponents to Map<String, int> .
    // example: string {"s": 25, "i": 1, "t": 24}
    // to map {'s': 25, 'i': 1, 't': 24}
    final Map<String, int> phoneticComponents = {};
    final List<String> phoneticComponentsList = string.split(',');
    for (var element in phoneticComponentsList) {
      final List<String> phoneticComponentsElementList = element.split(':');
      phoneticComponents[phoneticComponentsElementList[0]] =
          int.parse(phoneticComponentsElementList[1]);
    }
    return phoneticComponents;
  }
}
