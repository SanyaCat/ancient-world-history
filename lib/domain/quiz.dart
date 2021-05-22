class Quiz {
  String id;
  String title;
  String authorId;
  List<QuizQuestion> questions;
  DateTime creationDate;
  DateTime updateDate;

  Quiz({
    this.title,
    this.authorId,
    this.questions,
    this.creationDate,
    this.updateDate,
  });

  Quiz.fromJson(String id, Map<String, dynamic> data) {
    id = id;
    title = data['title'];
    authorId = data['author_id'];
    questions = (data['questions'] as List).map((q) => QuizQuestion.fromJson(q)).toList();
    creationDate = data['creation_date'].toDate();
    updateDate = data['update_date'].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author_id': authorId,
      'questions': questions.map((q) => q.toMap()).toList(),
      'creation_date': creationDate,
      'update_date': updateDate,
    };
  }

  Map<String, dynamic> toMapWithId() {
    return {
      'id': id,
      'title': title,
      'author_id': authorId,
      'questions': questions.map((q) => q.toMap()).toList(),
      'creation_date': creationDate,
      'update_date': updateDate,
    };
  }
}

// one question of the quiz
class QuizQuestion {
  String question;
  String correctAnswer;
  List<String> answers;

  QuizQuestion({
    this.question,
    this.correctAnswer,
    this.answers,
  });

  QuizQuestion.fromJson(Map<String, dynamic> data) {
    question = data['question'];
    correctAnswer = data['correct_answer'];
    answers = List.from(data['answers']);
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'correct_answer': correctAnswer,
      'answers': answers,
    };
  }
}
