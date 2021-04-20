import 'package:ancient_world_history/domain/topic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final CollectionReference _topicCollection =
      FirebaseFirestore.instance.collection('topics');

  Future editTopic(Topic topic) async {
    return await _topicCollection.doc(topic.id).set(topic.toMap());
  }

  Stream<List<Topic>> getTopics({Topic topic}) {
    // Query query;
    // if (topic.author.isNotEmpty)
    //   query = _topicCollection.where('author', isEqualTo: topic.author);
    // else
    //   query = _topicCollection.where('author', isEqualTo: true);
    //
    // if (topic.title.isNotEmpty)
    //   query = query.where('title', isEqualTo: topic.title);
    // else
    //   query = query.where('title', isEqualTo: true);

    return _topicCollection.snapshots().map((QuerySnapshot data) => data.docs
        .map((DocumentSnapshot doc) => Topic.fromJson(doc.id, doc.data())).toList());
  }
}
