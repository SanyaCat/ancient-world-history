class Quiz {
  String id;
  String title;
  String authorId;
  String question;
  String correctAnswer;
  List<String> answers;
  DateTime creationDate;
  DateTime updateDate;

  Quiz({
    this.title,
    this.authorId,
    this.question,
    this.correctAnswer,
    this.answers,
    this.creationDate,
    this.updateDate,
  });

  Quiz.fromJson(String id, Map<String, dynamic> data) {
    id = id;
    title = data['title'];
    authorId = data['author_id'];
    question = data['question'];
    correctAnswer = data['correct_answer'];
    answers = List.from(data['answers']);
    creationDate = data['creation_date'].toDate();
    updateDate = data['update_date'].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author_id': authorId,
      'question': question,
      'correct_answer': correctAnswer,
      'answers': answers,
      'creation_date': creationDate,
      'update_date': updateDate,
    };
  }

  Map<String, dynamic> toMapWithId() {
    return {
      'id': id,
      'title': title,
      'author_id': authorId,
      'question': question,
      'correct_answer': correctAnswer,
      'answers': answers,
      'creation_date': creationDate,
      'update_date': updateDate,
    };
  }
}