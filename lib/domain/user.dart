import 'package:firebase_auth/firebase_auth.dart';

class AWHUser {
  String id;
  String name;
  bool admin;
  List<UserResult> results;

  AWHUser.register(User user, String name, bool admin) {
    id = user.uid;
    this.name = name;
    this.admin = admin;
    results = List.empty();
  }

  AWHUser.fromFirebase(User user) {
    id = user.uid;
  }

  AWHUser.fromJson(String id, Map<String, dynamic> data) {
    this.id = id;
    name = data['name'];
    admin = data['admin'];
    results =
        (data['results'] as List).map((r) => UserResult.fromJson(r)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'admin': admin,
      'results': results.map((r) => r.toMap()).toList(),
    };
  }
}

class UserResult {
  String quizId;
  int correct;
  int total;

  UserResult(quizId, correct, total) {
    this.quizId = quizId;
    this.correct = correct;
    this.total = total;
  }

  UserResult.fromJson(Map<String, dynamic> data) {
    quizId = data['quiz_id'];
    correct = data['correct'];
    total = data['total'];
  }

  Map<String, dynamic> toMap() {
    return {
      'quiz_id': quizId,
      'correct': correct,
      'total': total,
    };
  }
}
