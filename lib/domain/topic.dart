class Topic {
  String id;
  String title;
  String authorId;
  String text;
  String topicDate;
  DateTime creationDate;
  DateTime updateDate;
  List<String> images;

  Topic({
    this.title,
    this.authorId,
    this.text,
    this.topicDate,
    this.creationDate,
    this.updateDate,
    this.images,
  });

  Topic.fromJson(String id, Map<String, dynamic> data) {
    this.id = id;
    title = data['title'];
    authorId = data['author_id'];
    text = data['text'];
    topicDate = data['topic_date'];
    creationDate = data['creation_date'].toDate();
    updateDate = data['update_date'].toDate();
    images = List.from(data['images']);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author_id': authorId,
      'text': text,
      'topic_date': topicDate,
      'creation_date': creationDate,
      'update_date': updateDate,
      'images': images
    };
  }

  Map<String, dynamic> toMapWithId() {
    return {
      'id': id,
      'title': title,
      'author_id': authorId,
      'text': text,
      'topic_date': topicDate,
      'creation_date': creationDate,
      'update_date': updateDate,
      'images': images
    };
  }
}
