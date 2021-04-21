import 'package:firebase_auth/firebase_auth.dart';

class AWHUser {
  String id;
  String name;
  bool admin;

  AWHUser.register(User user, String name, bool admin) {
    id = user.uid;
    this.name = name;
    this.admin = admin;
  }

  AWHUser.fromFirebase(User user) {
    id = user.uid;
  }

  AWHUser.fromJson(String id, Map<String, dynamic> data) {
    this.id = id;
    name = data['name'];
    admin = data['admin'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'admin': admin,
    };
  }
}