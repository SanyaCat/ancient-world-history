import 'package:ancient_world_history/domain/quiz.dart';
import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/pages/quiz/questionAdd.dart';
import 'package:ancient_world_history/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizAdd extends StatefulWidget {
  static const routeName = '/quiz/add';

  @override
  _QuizAddState createState() => _QuizAddState();
}

class _QuizAddState extends State<QuizAdd> {
  final _titleController = TextEditingController(text: 'Введите название');
  bool typing = false;
  List<QuizQuestion> _questions = List.empty(growable: true);
  bool edit = false;

  @override
  build(context) {
    final args = ModalRoute.of(context).settings.arguments as Quiz;
    edit = args != null;
    if (edit) _questions = args.questions;

    return Scaffold(
      appBar: AppBar(
        title: typing
            ? TextField(
                autofocus: true,
                controller: _titleController,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(_titleController.text),
        leading: IconButton(
          icon: Icon(typing ? Icons.download_done_sharp : Icons.edit),
          onPressed: () {
            setState(() {
              if (!typing) {
                if (_titleController.text == 'Введите название')
                  _titleController.text = '';
                typing = !typing;
              } else if (typing && _titleController.text.isNotEmpty)
                typing = !typing;
              else
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Название должно быть заполнено!')));
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () async {
              if (_titleController.text != 'Введите название') {
                Quiz quiz = Quiz(
                  title: _titleController.text,
                  authorId: Provider.of<AWHUser>(context, listen: false).id,
                  questions: _questions,
                  creationDate: (edit) ? args.creationDate : DateTime.now(),
                  updateDate: DateTime.now(),
                );
                if (edit) {
                  quiz.id = args.id;
                  await FireStoreService().editQuiz(quiz, context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Тест изменен!')));
                  Navigator.pop(context);
                } else {
                  await FireStoreService().addQuiz(quiz, context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Тест добавлен!')));
                }
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Введите название!')));
              }
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: new ListView.builder(
        itemCount: _questions.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return Card(
            key: UniqueKey(),
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorLight),
              child: ListTile(
                title: Text("${_questions[i].question}",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontWeight: FontWeight.bold,
                    )),
                leading: Container(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.question_answer_outlined,
                      color: Theme.of(context).accentColor),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 1,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                trailing: Icon(Icons.arrow_right,
                    color: Theme.of(context).textTheme.headline6.color),
                subtitle: Container(
                  constraints: BoxConstraints(
                    maxHeight: 40,
                  ),
                  child: Text('${_questions[i].correctAnswer}'),
                ),
                // onTap: () async {
                //   // setState(() {
                //     await Navigator.pushNamed(
                //       context,
                //       QuestionAdd.routeName,
                //       arguments: _questions[i],
                //     );
                //   // });
                // },
                onLongPress: () {
                  setState(() {
                    _questions.removeAt(i);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final question = await Navigator.pushNamed(
            context,
            QuestionAdd.routeName,
          );
          setState(() {
            _questions.add(question);
          });
        },
        child: Icon(Icons.add),
        foregroundColor: Theme.of(context).primaryColor,
        tooltip: 'Добавить вопрос',
      ),
    );
  }
}
