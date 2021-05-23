import 'package:ancient_world_history/domain/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<AWHUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      if (!user.emailVerified) await user.sendEmailVerification();

      return AWHUser.fromFirebase(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<AWHUser> registerWithEmailAndPassword(
      String email, String password, String name, bool admin) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // saving user data
      Map<String, dynamic> userData = {
        'id': user.uid,
        'name': name,
        'admin': admin,
      };
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      if ((await userRef.get()).exists) {
        //await userRef.update(data)
      } else {
        await userRef.set(userData);
      }

      await user.sendEmailVerification();

      return AWHUser.register(user, name, admin);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<AWHUser> get currentUser => _fAuth
      .authStateChanges()
      .map((User user) => user != null ? AWHUser.fromFirebase(user) : null);
}
