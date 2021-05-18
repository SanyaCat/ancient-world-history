import 'dart:io';
import 'package:ancient_world_history/domain/topic.dart';
import 'package:ancient_world_history/domain/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class FireStoreService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _topicCollection =
      FirebaseFirestore.instance.collection('topics');
  // final DocumentReference _imageCollection =
  //     FirebaseFirestore.instance.collection('images').doc();

  Future editUser(AWHUser user, context) async {
    ProgressDialog progress = ProgressDialog(context);
    progress.style(message: 'Сохранение...');
    await progress.show();
    return await _userCollection
        .doc(user.id)
        .set(user.toMap())
        .whenComplete(() => progress.hide());
  }

  Future editTopic(Topic topic, context) async {
    ProgressDialog progress = ProgressDialog(context);
    progress.style(message: 'Сохранение...');
    await progress.show();
    return await _topicCollection
        .doc(topic.id)
        .set(topic.toMap())
        .whenComplete(() => progress.hide());
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

  Future<String> uploadFile(File _image, context) async {
    var storageReference = FirebaseStorage.instance.ref().child('images/'
        '${Provider.of<AWHUser>(context, listen: false).id}/'
        '${_image.path.replaceAll('/', '')}');
    await storageReference.putFile(_image);
    String returnURL;
    await storageReference
        .getDownloadURL()
        .then((fileURL) => returnURL = fileURL)
        .onError((error, stackTrace) => returnURL = null);
    return returnURL;
  }
}
