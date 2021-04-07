import 'package:ancient_world_history/domain/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<AWHUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return AWHUser.fromFirebase(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<AWHUser> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return AWHUser.fromFirebase(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<AWHUser> get currentUser {
    return _fAuth
        .authStateChanges()
        .map((User user) => user != null ? AWHUser.fromFirebase(user) : null);
  }
}
