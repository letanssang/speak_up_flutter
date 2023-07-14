import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore;
  FirestoreRepository(this._firestore);
  Future<List<Topic>> getTopicsFromCategory(int categoryId) async {
    final topicsSnapshot = await _firestore
        .collection('topics')
        .where('Category ID', isEqualTo: categoryId)
        .get();

    List<Topic> topics = [];

    for (var docSnapshot in topicsSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      Topic topic = Topic.fromJson(data);
      topics.add(topic);
    }

    return topics;
  }
}
