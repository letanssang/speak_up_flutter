import 'package:speak_up/data/local/database_services/database_manager.dart';
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

class LocalDatabaseRepository {
  final DatabaseManager _databaseManager;

  LocalDatabaseRepository(this._databaseManager);

  Future<List<Word>> getWordListByPhoneticID(int phoneticID) async {
    return await _databaseManager.getWordListByPhoneticID(phoneticID);
  }

  Future<List<Lesson>> getLessonList() async {
    return await _databaseManager.getLessonList();
  }

  Future<List<Category>> getCategoryList() async {
    return await _databaseManager.getCategoryList();
  }

  Future<List<IdiomType>> getIdiomTypeList() async {
    return await _databaseManager.getIdiomTypeList();
  }

  Future<List<ExpressionType>> getExpressionTypeList() async {
    return await _databaseManager.getExpressionTypeList();
  }

  Future<List<Topic>> getTopicListByCategoryID(int categoryID) async {
    return await _databaseManager.getTopicListByCategoryID(categoryID);
  }

  Future<List<Phonetic>> getPhoneticList() async {
    return await _databaseManager.getPhoneticList();
  }

  Future<List<PhrasalVerbType>> getPhrasalVerbTypeList() async {
    return await _databaseManager.getPhrasalVerbTypeList();
  }

  Future<List<SentencePattern>> getSentencePatternList() async {
    return await _databaseManager.getSentencePatternList();
  }

  Future<List<PhrasalVerb>> getPhrasalVerbListByType(int input) {
    return _databaseManager.getPhrasalVerbListByType(input);
  }

  Future<List<Expression>> getExpressionListByType(int input) {
    return _databaseManager.getExpressionListByType(input);
  }

  Future<List<Idiom>> getIdiomListByType(int input) {
    return _databaseManager.getIdiomListByType(input);
  }

  Future<List<Sentence>> getSentenceListByParentID(
    int input,
    LessonEnum lessonEnum,
  ) {
    return _databaseManager.getSentenceListByParentID(input, lessonEnum);
  }

  Future<List<CommonWord>> getCommonWordListByType(int input) {
    return _databaseManager.getCommonWordListByType(input);
  }

  Future<List<Tense>> getTenseList() {
    return _databaseManager.getTenseList();
  }

  Future<List<TenseForm>> getTenseFormListFromTense(int input) {
    return _databaseManager.getTenseFormListFromTense(input);
  }

  Future<List<TenseUsage>> getTenseUsageListFromTense(int input) {
    return _databaseManager.getTenseUsageListFromTense(input);
  }
}
