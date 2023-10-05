import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speak_up/data/local/database_services/database_key.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/domain/entities/common_word/common_word.dart';
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
import 'package:speak_up/domain/entities/tense/tense.dart';
import 'package:speak_up/domain/entities/tense_form/tense_form.dart';
import 'package:speak_up/domain/entities/tense_usage/tense_usage.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';
import 'package:speak_up/domain/entities/word/word.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
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
        lessonID: maps[i][LessonTable.LessonID.name] as int,
        name: maps[i][LessonTable.Name.name] as String,
        translation: maps[i][LessonTable.Translation.name] as String,
        description: maps[i][LessonTable.Description.name] as String,
        descriptionTranslation:
            maps[i][LessonTable.DescriptionTranslation.name] as String,
        imageURL: maps[i][LessonTable.ImageURL.name] as String,
      );
    });
  }

  Future<List<Category>> getCategoryList() async {
    final db = await database;
    final maps = await db!.query('category');
    return List.generate(maps.length, (i) {
      return Category(
        categoryID: maps[i][CategoryTable.CategoryID.name] as int,
        name: maps[i][CategoryTable.Name.name] as String,
        translation: maps[i][CategoryTable.Translation.name] as String,
        imageUrl: maps[i][CategoryTable.ImageURL.name] as String,
      );
    });
  }

  Future<List<IdiomType>> getIdiomTypeList() async {
    final db = await database;
    final maps = await db!.query('idiomType');
    return List.generate(maps.length, (i) {
      return IdiomType(
        idiomTypeID: maps[i][IdiomTypeTable.IdiomTypeID.name] as int,
        name: maps[i][IdiomTypeTable.Name.name] as String,
        translation: maps[i][IdiomTypeTable.Translation.name] as String,
      );
    });
  }

  Future<List<ExpressionType>> getExpressionTypeList() async {
    final db = await database;
    final maps = await db!.query('expressionType');
    return List.generate(maps.length, (i) {
      return ExpressionType(
        expressionTypeID:
            maps[i][ExpressionTypeTable.ExpressionTypeID.name] as int,
        name: maps[i][ExpressionTypeTable.Name.name] as String,
        translation: maps[i][ExpressionTypeTable.Translation.name] as String,
        description: maps[i][ExpressionTypeTable.Description.name] as String,
        descriptionTranslation:
            maps[i][ExpressionTypeTable.DescriptionTranslation.name] as String,
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
        topicID: maps[i][TopicTable.TopicID.name] as int,
        topicName: maps[i][TopicTable.TopicName.name] as String,
        translation: maps[i][TopicTable.Translation.name] as String,
        categoryID: maps[i][TopicTable.CategoryID.name] as int,
      );
    });
  }

  Future<List<Phonetic>> getPhoneticList() async {
    final db = await database;
    final maps = await db!.query('phonetic');
    return List.generate(maps.length, (i) {
      final exampleString = maps[i][PhoneticTable.Example.name] as String;
      return Phonetic(
        phoneticID: maps[i][PhoneticTable.PhoneticID.name] as int,
        phonetic: maps[i][PhoneticTable.Phonetic.name] as String,
        phoneticType: maps[i][PhoneticTable.PhoneticType.name] as int,
        youtubeVideoId: maps[i][PhoneticTable.YoutubeVideoID.name] as String,
        description: maps[i][PhoneticTable.Description.name] as String,
        example: convertStringToPhoneticExamplesMap(exampleString),
      );
    });
  }

  Future<List<SentencePattern>> getSentencePatternList() async {
    final db = await database;
    final maps = await db!.query('pattern');
    return List.generate(maps.length, (i) {
      return SentencePattern(
        patternID: maps[i][PatternTable.PatternID.name] as int,
        name: maps[i][PatternTable.Name.name] as String,
        dialogue: maps[i][PatternTable.Dialogue.name] as String,
        description: maps[i][PatternTable.Description.name] as String,
        descriptionTranslation:
            maps[i][PatternTable.DescriptionTranslation.name] as String,
        youtubeVideoID: maps[i][PatternTable.YoutubeVideoID.name] as String?,
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
          maps[i][WordTable.PhoneticComponents.name] as String;
      return Word(
        wordID: maps[i][WordTable.WordID.name] as int,
        word: maps[i][WordTable.Word.name] as String,
        pronunciation: maps[i][WordTable.Pronunciation.name] as String,
        phoneticComponents:
            convertStringToPhoneticComponentsMap(phoneticComponentString),
        translation: maps[i][WordTable.Translation.name] as String,
        phoneticID: maps[i][WordTable.PhoneticID.name] as int,
      );
    });
  }

  Future<List<PhrasalVerbType>> getPhrasalVerbTypeList() async {
    final db = await database;
    final maps = await db!.query('phrasalVerbType');
    return List.generate(maps.length, (i) {
      return PhrasalVerbType(
        phrasalVerbTypeID:
            maps[i][PhrasalVerbTypeTable.PhrasalVerbTypeID.name] as int,
        name: maps[i][PhrasalVerbTypeTable.Name.name] as String,
        translation: maps[i][PhrasalVerbTypeTable.Translation.name] as String,
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
        phrasalVerbID: maps[i][PhrasalVerbTable.PhrasalVerbID.name] as int,
        name: maps[i][PhrasalVerbTable.Name.name] as String,
        description: maps[i][PhrasalVerbTable.Description.name] as String,
        descriptionTranslation:
            maps[i][PhrasalVerbTable.DescriptionTranslation.name] as String,
        phrasalVerbTypeID:
            maps[i][PhrasalVerbTable.PhrasalVerbTypeID.name] as int,
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
        expressionID: maps[i][ExpressionTable.ExpressionID.name] as int,
        name: maps[i][ExpressionTable.Name.name] as String,
        translation: maps[i][ExpressionTable.Translation.name] as String,
        expressionTypeID: maps[i][ExpressionTable.ExpressionTypeID.name] as int,
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
        idiomID: maps[i][IdiomTable.IdiomID.name] as int,
        name: maps[i][IdiomTable.Name.name] as String,
        idiomTypeID: maps[i][IdiomTable.IdiomTypeID.name] as int,
        description: maps[i][IdiomTable.Description.name] as String,
        descriptionTranslation:
            maps[i][IdiomTable.DescriptionTranslation.name] as String,
        audioEndpoint: maps[i][IdiomTable.AudioEndpoint.name] as String,
      );
    });
  }

  Future<List<Sentence>> getSentenceListByParentID(
      int parentID, LessonEnum lessonEnum) async {
    final db = await database;
    final maps = await db!.query(
      'sentence',
      where: 'parentType = ? AND parentID = ?',
      whereArgs: [lessonEnum.index + 1, parentID],
    );
    return List.generate(maps.length, (i) {
      return Sentence(
        sentenceID: maps[i][SentenceTable.SentenceID.name] as int,
        text: maps[i][SentenceTable.Text.name] as String,
        audioEndpoint: maps[i][SentenceTable.AudioEndpoint.name] as String,
        translation: maps[i][SentenceTable.Translation.name] as String,
        parentType: maps[i][SentenceTable.ParentType.name] as int,
        parentID: maps[i][SentenceTable.ParentID.name] as int,
      );
    });
  }

  Future<List<CommonWord>> getCommonWordListByType(int input) async {
    final db = await database;
    final maps = await db!.query(
      'commonWord',
      where: 'type = ?',
      whereArgs: [input],
    );
    return List.generate(maps.length, (i) {
      return CommonWord(
        commonWordID: maps[i][CommonWordTable.CommonWordID.name] as int,
        commonWord: maps[i][CommonWordTable.CommonWord.name] as String,
        translation: maps[i][CommonWordTable.Translation.name] as String,
        partOfSpeech: maps[i][CommonWordTable.PartOfSpeech.name] as String,
        level: maps[i][CommonWordTable.Level.name] as String,
        type: maps[i][CommonWordTable.Type.name] as int,
      );
    });
  }

  Future<List<Tense>> getTenseList() async {
    final db = await database;
    final maps = await db!.query('tense');
    return List.generate(maps.length, (i) {
      return Tense(
        tenseID: maps[i][TenseTable.TenseID.name] as int,
        tense: maps[i][TenseTable.Tense.name] as String,
        translation: maps[i][TenseTable.Translation.name] as String,
        signalWords: maps[i][TenseTable.SignalWords.name] as String,
      );
    });
  }

  Future<List<TenseForm>> getTenseFormListFromTense(int input) async {
    final db = await database;
    final maps = await db!.query(
      'tenseForm',
      where: 'tenseID = ?',
      whereArgs: [input],
    );
    return List.generate(maps.length, (i) {
      return TenseForm(
        tenseFormID: maps[i][TenseFormTable.TenseFormID.name] as int,
        tenseID: maps[i][TenseFormTable.TenseID.name] as int,
        title: maps[i][TenseFormTable.Title.name] as String,
        positive: maps[i][TenseFormTable.Positive.name] as String,
        positiveExample: maps[i][TenseFormTable.PositiveExample.name] as String,
        negative: maps[i][TenseFormTable.Negative.name] as String,
        negativeExample: maps[i][TenseFormTable.NegativeExample.name] as String,
        question: maps[i][TenseFormTable.Question.name] as String,
        questionExample: maps[i][TenseFormTable.QuestionExample.name] as String,
      );
    });
  }

  Future<List<TenseUsage>> getTenseUsageListFromTense(int input) async {
    final db = await database;
    final maps = await db!.query(
      'tenseUsage',
      where: 'tenseID = ?',
      whereArgs: [input],
    );
    return List.generate(maps.length, (i) {
      return TenseUsage(
        tenseUsageID: maps[i][TenseUsageTable.TenseUsageID.name] as int,
        tenseID: maps[i][TenseUsageTable.TenseID.name] as int,
        description: maps[i][TenseUsageTable.Description.name] as String,
        descriptionTranslation:
            maps[i][TenseUsageTable.Description.name] as String,
        example: maps[i][TenseUsageTable.Example.name] as String,
      );
    });
  }
}
