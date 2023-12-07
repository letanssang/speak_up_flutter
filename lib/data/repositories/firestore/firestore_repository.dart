import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speak_up/domain/entities/flash_card/flash_card.dart';
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

  Future<void> updatePhrasalVerbProgress(LectureProcess input) async {
    final snapshot = await _firestore
        .collection('phrasal_verb_process')
        .where('PhrasalVerbTypeID', isEqualTo: input.lectureID)
        .where('UserID', isEqualTo: input.uid)
        .get();
    //check if phrasal verb process exists
    if (snapshot.docs.isEmpty) {
      //if not exists, create new phrasal verb process
      await _firestore.collection('phrasal_verb_process').add({
        'Progress': input.progress,
        'PhrasalVerbTypeID': input.lectureID,
        'UserID': input.uid,
      });
    } else {
      //if exists, update process
      await _firestore
          .collection('phrasal_verb_process')
          .doc(snapshot.docs.first.id)
          .update({'Progress': input.progress});
    }
  }

  Future<void> updatePatternProgress(LectureProcess input) async {
    final snapshot = await _firestore
        .collection('pattern_process')
        .where('PatternID', isEqualTo: input.lectureID)
        .where('UserID', isEqualTo: input.uid)
        .get();
    //check if pattern process exists
    if (snapshot.docs.isEmpty) {
      //if not exists, create new pattern process
      await _firestore.collection('pattern_process').add({
        'PatternID': input.lectureID,
        'UserID': input.uid,
      });
    }
  }

  Future<void> updatePhoneticProgress(LectureProcess input) async {
    final snapshot = await _firestore
        .collection('phonetic_process')
        .where('UserID', isEqualTo: input.uid)
        .where('PhoneticID', isEqualTo: input.lectureID)
        .get();
    //check if phonetic process exists
    if (snapshot.docs.isEmpty) {
      //if not exists, create new phonetic process
      await _firestore.collection('phonetic_process').add({
        'PhoneticID': input.lectureID,
        'UserID': input.uid,
      });
    }
  }

  Future<List<int>> getPhoneticDoneList(String uid) async {
    final snapshot = await _firestore
        .collection('phonetic_process')
        .where('UserID', isEqualTo: uid)
        .get();
    List<int> phoneticDoneList = [];
    for (var docSnapshot in snapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      int phoneticID = data['PhoneticID'];
      phoneticDoneList.add(phoneticID);
    }
    return phoneticDoneList;
  }

  Future<void> updateExpressionProgress(LectureProcess input) async {
    final snapshot = await _firestore
        .collection('expression_process')
        .where('ExpressionID', isEqualTo: input.lectureID)
        .where('UserID', isEqualTo: input.uid)
        .get();
    //check if expression process exists
    if (snapshot.docs.isEmpty) {
      //if not exists, create new expression process
      await _firestore.collection('expression_process').add({
        'ExpressionID': input.lectureID,
        'UserID': input.uid,
      });
    }
  }

  Future<List<int>> getExpressionDoneList() async {
    final snapshot = await _firestore.collection('expression_process').get();
    List<int> expressionDoneList = [];
    for (var docSnapshot in snapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      int expressionID = data['ExpressionID'];
      expressionDoneList.add(expressionID);
    }
    return expressionDoneList;
  }

  Future<List<int>> getPatternDoneList(String uid) async {
    final snapshot = await _firestore
        .collection('pattern_process')
        .where('UserID', isEqualTo: uid)
        .get();
    List<int> patternDoneList = [];
    for (var docSnapshot in snapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      int patternID = data['PatternID'];
      patternDoneList.add(patternID);
    }
    return patternDoneList;
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

  Future<int> getPhrasalVerbProgress(int phrasalVerbTypeID, String uid) async {
    final snapshot = await _firestore
        .collection('phrasal_verb_process')
        .where('PhrasalVerbTypeID', isEqualTo: phrasalVerbTypeID)
        .where('UserID', isEqualTo: uid)
        .get();
    if (snapshot.docs.isEmpty) {
      return 0;
    } else {
      return snapshot.docs.first['Progress'];
    }
  }

  Future<void> addFlashCard(FlashCard flashCard, String uid) async {
    //check contains
    final snapshot = await _firestore
        .collection('flash_cards')
        .where('FlashCardID', isEqualTo: flashCard.flashcardID)
        .where('FrontText', isEqualTo: flashCard.frontText)
        .where('UserID', isEqualTo: uid)
        .get();
    if (snapshot.docs.isEmpty) {
      //if not exists, add new flash card
      await _firestore.collection('flash_cards').add({
        'FlashCardID': flashCard.flashcardID,
        'FrontText': flashCard.frontText,
        'BackText': flashCard.backText,
        'BackTranslation': flashCard.backTranslation,
        'UserID': uid,
      });
    }
  }

  Future<List<FlashCard>> getFlashCardList(String uid) async {
    final snapshot = await _firestore
        .collection('flash_cards')
        .where('UserID', isEqualTo: uid)
        .get();
    List<FlashCard> flashCardList = [];
    for (var docSnapshot in snapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data();
      FlashCard flashCard = FlashCard.fromJson(data);
      flashCardList.add(flashCard);
    }
    return flashCardList;
  }

  Future<void> updateMessages(
      List<Map<String, dynamic>> messagesMap, String uid) {
    return _firestore
        .collection('messages')
        .doc(uid)
        .set({'messages': messagesMap});
  }

  Future<List<Map<String, dynamic>>> getMessages(String uid) async {
    final snapshot = await _firestore.collection('messages').doc(uid).get();
    if (snapshot.exists) {
      List<Map<String, dynamic>> messagesMap = [];
      for (var message in snapshot.data()!['messages']) {
        messagesMap.add(message);
      }

      // if length > 50, then just get last 50 messages
      return messagesMap.length > 50
          ? messagesMap.sublist(messagesMap.length - 50)
          : messagesMap;
    } else {
      return [];
    }
  }
}
