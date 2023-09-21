import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speak_up/data/local/database_services/database_key.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/domain/entities/expression/expression.dart';
import 'package:speak_up/domain/entities/expression_type/expression_type.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/entities/idiom_type/idiom_type.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/domain/entities/pattern/sentence_pattern.dart';
import 'package:speak_up/domain/entities/phonetic/phonetic.dart';
import 'package:speak_up/domain/entities/phrasal_verb/phrasal_verb.dart';
import 'package:speak_up/domain/entities/phrasal_verb_type/phrasal_verb_type.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';
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

  Future<List<Lesson>> getLessonList() async {
    final db = await database;
    final maps = await db!.query('lesson');
    return List.generate(maps.length, (i) {
      return Lesson(
        lessonID: maps[i][LessonTable.lessonID.field] as int,
        name: maps[i][LessonTable.name.field] as String,
        translation: maps[i][LessonTable.translation.field] as String,
        description: maps[i][LessonTable.description.field] as String,
        descriptionTranslation:
            maps[i][LessonTable.descriptionTranslation.field] as String,
        imageURL: maps[i][LessonTable.imageURL.field] as String,
      );
    });
  }

  Future<List<Category>> getCategoryList() async {
    final db = await database;
    final maps = await db!.query('category');
    return List.generate(maps.length, (i) {
      return Category(
        categoryID: maps[i][CategoryTable.categoryID.field] as int,
        name: maps[i][CategoryTable.name.field] as String,
        translation: maps[i][CategoryTable.translation.field] as String,
        imageUrl: maps[i][CategoryTable.imageURL.field] as String,
      );
    });
  }

  Future<List<IdiomType>> getIdiomTypeList() async {
    final db = await database;
    final maps = await db!.query('idiomType');
    return List.generate(maps.length, (i) {
      return IdiomType(
        idiomTypeID: maps[i][IdiomTypeTable.idiomTypeID.field] as int,
        name: maps[i][IdiomTypeTable.name.field] as String,
        translation: maps[i][IdiomTypeTable.translation.field] as String,
      );
    });
  }

  Future<List<ExpressionType>> getExpressionTypeList() async {
    final db = await database;
    final maps = await db!.query('expressionType');
    return List.generate(maps.length, (i) {
      return ExpressionType(
        expressionTypeID:
            maps[i][ExpressionTypeTable.expressionTypeID.field] as int,
        name: maps[i][ExpressionTypeTable.name.field] as String,
        translation: maps[i][ExpressionTypeTable.translation.field] as String,
        description: maps[i][ExpressionTypeTable.description.field] as String,
        descriptionTranslation:
            maps[i][ExpressionTypeTable.descriptionTranslation.field] as String,
      );
    });
  }

  Future<List<Topic>> getTopicListByCategoryID(int categoryID) async {
    final db = await database;
    final maps = await db!.query(
      'topic',
      where: 'categoryID = ?',
      whereArgs: [categoryID],
    );
    return List.generate(maps.length, (i) {
      return Topic(
        topicID: maps[i][TopicTable.topicID.field] as int,
        topicName: maps[i][TopicTable.topicName.field] as String,
        translation: maps[i][TopicTable.translation.field] as String,
        categoryID: maps[i][TopicTable.categoryID.field] as int,
      );
    });
  }

  Future<List<Phonetic>> getPhoneticList() async {
    final db = await database;
    final maps = await db!.query('phonetic');
    return List.generate(maps.length, (i) {
      final exampleString = maps[i][PhoneticTable.example.field] as String;
      return Phonetic(
        phoneticID: maps[i][PhoneticTable.phoneticID.field] as int,
        phonetic: maps[i][PhoneticTable.phonetic.field] as String,
        phoneticType: maps[i][PhoneticTable.phoneticType.field] as int,
        youtubeVideoId: maps[i][PhoneticTable.youtubeVideoID.field] as String,
        description: maps[i][PhoneticTable.description.field] as String,
        example: convertStringToPhoneticExamplesMap(exampleString),
      );
    });
  }

  Future<List<SentencePattern>> getSentencePatternList() async {
    final db = await database;
    final maps = await db!.query('pattern');
    return List.generate(maps.length, (i) {
      return SentencePattern(
        patternID: maps[i][PatternTable.patternID.field] as int,
        name: maps[i][PatternTable.name.field] as String,
        dialogue: maps[i][PatternTable.dialogue.field] as String,
        description: maps[i][PatternTable.description.field] as String,
        descriptionTranslation:
            maps[i][PatternTable.descriptionTranslation.field] as String,
        youtubeVideoID: maps[i][PatternTable.youtubeVideoID.field] as String?,
      );
    });
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

  Future<List<PhrasalVerbType>> getPhrasalVerbTypeList() async {
    final db = await database;
    final maps = await db!.query('phrasalVerbType');
    return List.generate(maps.length, (i) {
      return PhrasalVerbType(
        phrasalVerbTypeID:
            maps[i][PhrasalVerbTypeTable.phrasalVerbTypeID.field] as int,
        name: maps[i][PhrasalVerbTypeTable.name.field] as String,
        translation: maps[i][PhrasalVerbTypeTable.translation.field] as String,
      );
    });
  }

  Map<String, int> convertStringToPhoneticComponentsMap(String string) {
    //convert String phoneticComponents to Map<String, int> .
    // example: string {"s": 25, "i": 1, "t": 24}
    // to map {'s': 25, 'i': 1, 't': 24}
    string = string.substring(1, string.length - 1);
    final Map<String, int> phoneticComponents = {};
    final List<String> phoneticComponentsList = string.split(',');
    for (var element in phoneticComponentsList) {
      final List<String> phoneticComponentsElementList = element.split(':');
      phoneticComponents[phoneticComponentsElementList[0]] =
          int.parse(phoneticComponentsElementList[1]);
    }
    return phoneticComponents;
  }

  Map<String, String> convertStringToPhoneticExamplesMap(String string) {
    //example: {"it": "/ɪt/", "sit": "/sɪt/", "ship": "/ʃɪp/"}
    // to map {'it': '/ɪt/', 'sit': '/sɪt/', 'ship': '/ʃɪp/'}
    string = string.substring(1, string.length - 1);
    final Map<String, String> phoneticExamples = {};
    final List<String> phoneticExamplesList = string.split(',');
    for (var element in phoneticExamplesList) {
      final List<String> phoneticExamplesElementList = element.split(':');
      phoneticExamples[phoneticExamplesElementList[0]] =
          phoneticExamplesElementList[1];
    }
    return phoneticExamples;
  }

  Future<List<PhrasalVerb>> getPhrasalVerbListByType(int input) async {
    final db = await database;
    final maps = await db!.query(
      'phrasalVerb',
      where: 'phrasalVerbTypeID = ?',
      whereArgs: [input],
    );
    return List.generate(maps.length, (i) {
      return PhrasalVerb(
        phrasalVerbID: maps[i][PhrasalVerbTable.phrasalVerbID.field] as int,
        name: maps[i][PhrasalVerbTable.name.field] as String,
        description: maps[i][PhrasalVerbTable.description.field] as String,
        descriptionTranslation:
            maps[i][PhrasalVerbTable.descriptionTranslation.field] as String,
        phrasalVerbTypeID:
            maps[i][PhrasalVerbTable.phrasalVerbTypeID.field] as int,
      );
    });
  }

  Future<List<Expression>> getExpressionListByType(int input) async {
    final db = await database;
    final maps = await db!.query(
      'expression',
      where: 'expressionTypeID = ?',
      whereArgs: [input],
    );
    return List.generate(maps.length, (i) {
      return Expression(
        expressionID: maps[i][ExpressionTable.expressionID.field] as int,
        name: maps[i][ExpressionTable.name.field] as String,
        translation: maps[i][ExpressionTable.translation.field] as String,
        expressionTypeID:
            maps[i][ExpressionTable.expressionTypeID.field] as int,
      );
    });
  }

  Future<List<Idiom>> getIdiomListByType(int input) async {
    final db = await database;
    final maps = await db!.query(
      'idiom',
      where: 'idiomTypeID = ?',
      whereArgs: [input],
    );
    return List.generate(maps.length, (i) {
      return Idiom(
        idiomID: maps[i][IdiomTable.idiomID.field] as int,
        name: maps[i][IdiomTable.name.field] as String,
        idiomTypeID: maps[i][IdiomTable.idiomTypeID.field] as int,
        description: maps[i][IdiomTable.description.field] as String,
        descriptionTranslation:
            maps[i][IdiomTable.descriptionTranslation.field] as String,
        audioEndpoint: maps[i][IdiomTable.audioEndpoint.field] as String,
      );
    });
  }

  Future<List<Sentence>> getSentenceListFromIdiom(int input) async {
    final db = await database;
    final maps = await db!.query(
      'sentence',
      where: 'parentType = ? AND parentID = ?',
      whereArgs: [SentenceParentType.idiom.typeNumber, input],
    );
    return List.generate(maps.length, (i) {
      return Sentence(
        sentenceID: maps[i][SentenceTable.sentenceID.field] as int,
        text: maps[i][SentenceTable.text.field] as String,
        audioEndpoint: maps[i][SentenceTable.audioEndpoint.field] as String,
        translation: maps[i][SentenceTable.translation.field] as String,
        parentType: maps[i][SentenceTable.parentType.field] as int,
        parentID: maps[i][SentenceTable.parentID.field] as int,
      );
    });
  }

  Future<List<Sentence>> getSentenceListFromTopic(int input) async {
    final db = await database;
    final maps = await db!.query(
      'sentence',
      where: 'parentType = ? AND parentID = ?',
      whereArgs: [SentenceParentType.topic.typeNumber, input],
    );
    return List.generate(maps.length, (i) {
      return Sentence(
        sentenceID: maps[i][SentenceTable.sentenceID.field] as int,
        text: maps[i][SentenceTable.text.field] as String,
        audioEndpoint: maps[i][SentenceTable.audioEndpoint.field] as String,
        translation: maps[i][SentenceTable.translation.field] as String,
        parentType: maps[i][SentenceTable.parentType.field] as int,
        parentID: maps[i][SentenceTable.parentID.field] as int,
      );
    });
  }

  Future<List<Sentence>> getSentenceListFromPattern(int input) async {
    final db = await database;
    final maps = await db!.query(
      'sentence',
      where: 'parentType = ? AND parentID = ?',
      whereArgs: [SentenceParentType.pattern.typeNumber, input],
    );
    return List.generate(maps.length, (i) {
      return Sentence(
        sentenceID: maps[i][SentenceTable.sentenceID.field] as int,
        text: maps[i][SentenceTable.text.field] as String,
        audioEndpoint: maps[i][SentenceTable.audioEndpoint.field] as String,
        translation: maps[i][SentenceTable.translation.field] as String,
        parentType: maps[i][SentenceTable.parentType.field] as int,
        parentID: maps[i][SentenceTable.parentID.field] as int,
      );
    });
  }
}
