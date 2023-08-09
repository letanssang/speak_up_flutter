import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speak_up/domain/entities/expression/expression.dart';
import 'package:speak_up/domain/entities/expression_type/expression_type.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/entities/idiom_type/idiom_type.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/domain/entities/pattern/sentence_pattern.dart';
import 'package:speak_up/domain/entities/phrasal_verb/phrasal_verb.dart';
import 'package:speak_up/domain/entities/phrasal_verb_type/phrasal_verb_type.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore;

  FirestoreRepository(this._firestore);

  Future<void> saveUserData(User user) async {
    _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'name': user.displayName,
      'photoUrl': user.photoURL,
    });
  }

  Future<List<Lesson>> getLessonList() async {
    final lessonSnapshot = await _firestore
        .collection('lessons')
        .where('Status', isEqualTo: 1)
        .get();

    List<Lesson> lessons = [];

    for (var docSnapshot in lessonSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      Lesson lesson = Lesson.fromJson(data);
      lessons.add(lesson);
    }
    lessons.sort((a, b) => a.lessonID.compareTo(b.lessonID));
    return lessons;
  }

  Future<List<Topic>> getTopicsFromCategory(int categoryId) async {
    final topicsSnapshot = await _firestore
        .collection('topics')
        .where('CategoryID', isEqualTo: categoryId)
        .where('Status', isEqualTo: 1)
        .get();

    List<Topic> topics = [];

    for (var docSnapshot in topicsSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      Topic topic = Topic.fromJson(data);
      topics.add(topic);
    }

    return topics;
  }

  Future<List<ExpressionType>> getExpressionTypeList() async {
    final expressionTypeSnapshot = await _firestore
        .collection('expression_types')
        .where('Status', isEqualTo: 1)
        .get();

    List<ExpressionType> expressionTypes = [];

    for (var docSnapshot in expressionTypeSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      ExpressionType expressionType = ExpressionType.fromJson(data);
      expressionTypes.add(expressionType);
    }
    expressionTypes
        .sort((a, b) => a.expressionTypeID.compareTo(b.expressionTypeID));
    return expressionTypes;
  }

  Future<List<SentencePattern>> getSentencePatternList() async {
    final sentencePatternSnapshot = await _firestore
        .collection('patterns')
        .where('Status', isEqualTo: 1)
        .get();
    List<SentencePattern> sentencePatterns = [];
    for (var docSnapshot in sentencePatternSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      SentencePattern sentencePattern = SentencePattern.fromJson(data);
      sentencePatterns.add(sentencePattern);
    }
    sentencePatterns.sort((a, b) => a.patternID.compareTo(b.patternID));
    return sentencePatterns;
  }

  Future<List<PhrasalVerbType>> getPhrasalVerbTypeList() async {
    final phrasalVerbTypeSnapshot = await _firestore
        .collection('phrasal_verb_types')
        .where('Status', isEqualTo: 1)
        .get();
    List<PhrasalVerbType> phrasalVerbTypes = [];
    for (var docSnapshot in phrasalVerbTypeSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      PhrasalVerbType phrasalVerbType = PhrasalVerbType.fromJson(data);
      phrasalVerbTypes.add(phrasalVerbType);
    }
    phrasalVerbTypes
        .sort((a, b) => a.phrasalVerbTypeID.compareTo(b.phrasalVerbTypeID));
    return phrasalVerbTypes;
  }

  Future<List<IdiomType>> getIdiomTypeList() async {
    final idiomTypeSnapshot = await _firestore
        .collection('idiom_types')
        .where('Status', isEqualTo: 1)
        .get();
    List<IdiomType> idiomTypes = [];
    for (var docSnapshot in idiomTypeSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      IdiomType idiomType = IdiomType.fromJson(data);
      idiomTypes.add(idiomType);
    }
    idiomTypes.sort((a, b) => a.idiomTypeID.compareTo(b.idiomTypeID));
    return idiomTypes;
  }

  Future<List<Expression>> getExpressionListByType(int expressionTypeID) async {
    final expressionSnapshot = await _firestore
        .collection('expressions')
        .where('ExpressionTypeID', isEqualTo: expressionTypeID)
        .where('Status', isEqualTo: 1)
        .get();

    List<Expression> expressions = [];
    for (var docSnapshot in expressionSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      Expression expression = Expression.fromJson(data);
      expressions.add(expression);
    }
    expressions.sort((a, b) => a.expressionID.compareTo(b.expressionID));
    return expressions;
  }

  Future<List<PhrasalVerb>> getPhrasalVerbListByType(
      int phrasalVerbTypeID) async {
    final phrasalVerbSnapshot = await _firestore
        .collection('phrasal_verbs')
        .where('PhrasalVerbTypeID', isEqualTo: phrasalVerbTypeID)
        .where('Status', isEqualTo: 1)
        .get();

    List<PhrasalVerb> phrasalVerbs = [];
    for (var docSnapshot in phrasalVerbSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      PhrasalVerb phrasalVerb = PhrasalVerb.fromJson(data);
      phrasalVerbs.add(phrasalVerb);
    }
    phrasalVerbs.sort((a, b) => a.phrasalVerbID.compareTo(b.phrasalVerbID));
    return phrasalVerbs;
  }

  Future<List<Idiom>> getIdiomListByType(int idiomTypeId) async {
    final idiomSnapshot = await _firestore
        .collection('idioms')
        .where('IdiomTypeID', isEqualTo: idiomTypeId)
        .where('Status', isEqualTo: 1)
        .get();

    List<Idiom> idioms = [];
    for (var docSnapshot in idiomSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      Idiom idiom = Idiom.fromJson(data);
      idioms.add(idiom);
    }
    idioms.sort((a, b) => a.idiomID.compareTo(b.idiomID));
    return idioms;
  }

  Future<List<Sentence>> getSentenceListFromTopic(int topicId) async {
    final sentencesSnapshot = await _firestore
        .collection('sentencesA')
        .where('ParentType', isEqualTo: 1)
        .where('ParentID', isEqualTo: topicId)
        .where('Status', isEqualTo: 1)
        .get();

    List<Sentence> sentences = [];
    for (var docSnapshot in sentencesSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      Sentence sentence = Sentence.fromJson(data);
      sentences.add(sentence);
    }
    sentences.sort((a, b) => a.sentenceID.compareTo(b.sentenceID));
    return sentences;
  }

  Future<List<Sentence>> getSentenceListFromPattern(int patternID) async {
    final sentencesSnapshot = await _firestore
        .collection('sentencesA')
        .where('ParentType', isEqualTo: 2)
        .where('ParentID', isEqualTo: patternID)
        .where('Status', isEqualTo: 1)
        .get();

    List<Sentence> sentences = [];
    for (var docSnapshot in sentencesSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      Sentence sentence = Sentence.fromJson(data);
      sentences.add(sentence);
    }
    sentences.sort((a, b) => a.sentenceID.compareTo(b.sentenceID));
    return sentences;
  }

  Future<void> updateDisplayName(String name, String uid) async {
    await _firestore.collection('users').doc(uid).update({'name': name});
  }

  Future<void> updateEmail(String email, String uid) async {
    await _firestore.collection('users').doc(uid).update({'email': email});
  }
}
