import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speak_up/domain/entities/lecture_process/lecture_process.dart';

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

  Future<void> updateDisplayName(String name, String uid) async {
    await _firestore.collection('users').doc(uid).update({'name': name});
  }

  Future<void> updateEmail(String email, String uid) async {
    await _firestore.collection('users').doc(uid).update({'email': email});
  }

  Future<List<String>> getYoutubePlaylistIDList() async {
    final youtubePlaylistSnapshot =
        await _firestore.collection('youtube_playlists').get();
    List<String> youtubePlaylistIDs = [];
    for (var docSnapshot in youtubePlaylistSnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      String youtubePlaylistID = data['PlaylistID'];
      youtubePlaylistIDs.add(youtubePlaylistID);
    }
    return youtubePlaylistIDs;
  }

  Future<void> updateIdiomProgress(LectureProcess process) async {
    final snapshot = await _firestore
        .collection('idiom_process')
        .where('IdiomTypeID', isEqualTo: process.lectureID)
        .where('UserID', isEqualTo: process.uid)
        .get();
    //check if idiom process exists
    if (snapshot.docs.isEmpty) {
      //if not exists, create new idiom process
      await _firestore.collection('idiom_process').add({
        'Progress': process.progress,
        'IdiomTypeID': process.lectureID,
        'UserID': process.uid,
      });
    } else {
      //if exists, update process
      await _firestore
          .collection('idiom_process')
          .doc(snapshot.docs.first.id)
          .update({'Progress': process.progress});
    }
  }

  Future<int> getIdiomProgress(int idiomTypeID, String uid) async {
    final snapshot = await _firestore
        .collection('idiom_process')
        .where('IdiomTypeID', isEqualTo: idiomTypeID)
        .where('UserID', isEqualTo: uid)
        .get();
    if (snapshot.docs.isEmpty) {
      return 0;
    } else {
      return snapshot.docs.first['Progress'];
    }
  }
}
