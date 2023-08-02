import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
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

  Future<List<Sentence>> getSentencesFromTopic(int topicId) async {
    final sentencesSnapshot = await _firestore
        .collection('sentences')
        .where('TopicId', isEqualTo: topicId)
        .where('Status', isEqualTo: 1)
        .get();

    List<Sentence> sentences = [];
    for (var docSnapshot in sentencesSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      Sentence sentence = Sentence.fromJson(data);
      sentences.add(sentence);
    }
    sentences.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return sentences;
  }

  Future<void> updateDisplayName(String name, String uid) async {
    await _firestore.collection('users').doc(uid).update({'name': name});
  }

  Future<void> updateEmail(String email, String uid) async {
    await _firestore.collection('users').doc(uid).update({'email': email});
  }
}
