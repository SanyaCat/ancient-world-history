import 'package:firebase_auth/firebase_auth.dart';

class AWHUser {
  String id;

  AWHUser.fromFirebase(User user) {
    id = user.uid;
  }
}