import 'package:ancient_world_history/domain/topic.dart';
import 'package:ancient_world_history/domain/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _topicCollection =
      FirebaseFirestore.instance.collection('topics');

  Future editUser(AWHUser user) async {
    return await _userCollection.doc(user.id).set(user.toMap());
  }

  Future editTopic(Topic topic) async {
    return await _topicCollection.doc(topic.id).set(topic.toMap());
  }

  // Stream<AWHUser> getUser(String id) {
  //   return _userCollection.snapshots().map((QuerySnapshot data) => data.docs
  //       .map((DocumentSnapshot doc) => AWHUser.fromJson(doc.id, doc.data()))
  //       .firstWhere((element) => element.id == id));
  // }

  Stream<List<AWHUser>> getUsers() {
    return _userCollection.snapshots().map((QuerySnapshot data) => data.docs
        .map((DocumentSnapshot doc) => AWHUser.fromJson(doc.id, doc.data()))
        .toList());
  }

  Stream<List<Topic>> getTopics({Topic topic}) {
    return _topicCollection.snapshots().map((QuerySnapshot data) => data.docs
        .map((DocumentSnapshot doc) => Topic.fromJson(doc.id, doc.data()))
        .toList());
  }
}
