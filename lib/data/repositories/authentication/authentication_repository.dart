import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthenticationRepository(this._firebaseAuth, this._googleSignIn);

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return Future.error('Google sign in failed');
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> updateDisplayName(String name) async {
    await _firebaseAuth.currentUser!.updateDisplayName(name);
  }

  Future<void> updateEmail(String email) async {
    await _firebaseAuth.currentUser!.updateEmail(email);
  }

  Future<void> updatePassword(String password) async {
    await _firebaseAuth.currentUser!.updatePassword(password);
  }

  Future<void> reAuthenticateWithCredential(String password) async {
    final AuthCredential credential = EmailAuthProvider.credential(
      email: _firebaseAuth.currentUser!.email!,
      password: password,
    );
    await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  User getCurrentUser() {
    return _firebaseAuth.currentUser!;
  }
}
