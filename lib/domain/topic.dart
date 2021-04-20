class Topic{
  String id;
  String title;
  String author;
  String description;
  //creation date
  //date
  //id of author, not name!
  //img...

  Topic({this.title, this.author, this.description});

  Topic.fromJson(String id, Map<String, dynamic> data) {
    id = id;
    title = data['title'];
    author = data['author'];
    description = data['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description
    };
  }
}

