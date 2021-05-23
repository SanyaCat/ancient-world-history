import 'package:ancient_world_history/domain/quiz.dart';
import 'package:flutter/material.dart';

class QuestionAdd extends StatefulWidget {
  static const routeName = '/quiz/question_add';

  @override
  _QuestionAddState createState() => _QuestionAddState();
}

class _QuestionAddState extends State<QuestionAdd> {
  final _titleController = TextEditingController(text: 'Введите вопрос');
  bool typing = false;
  // List<String> _answers = List.of(['ответ 1', 'ответ 2'], growable: true);
  List<TextEditingController> _answerControllers = List.of([
    TextEditingController(text: 'ответ 1'),
    TextEditingController(text: 'ответ 2'),
  ], growable: true);
  var correct = 0;
  bool edit = false;

  @override
  build(context) {
    final args = ModalRoute.of(context).settings.arguments as QuizQuestion;
    edit = args != null;

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
                if (_titleController.text == 'Введите вопрос')
                  _titleController.text = '';
                typing = !typing;
              } else if (typing && _titleController.text.isNotEmpty)
                typing = !typing;
              else
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Вопрос должен быть заполнен!')));
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () async {
              if (_titleController.text != 'Введите вопрос') {
                List<String> list = List.empty(growable: true);
                _answerControllers.forEach((element) {
                  list.add(element.text);
                });

                // TODO: CHECK ANSWERS

                Navigator.pop(context, QuizQuestion(
                  question: _titleController.text,
                  correctAnswer: _answerControllers[correct].text,
                  answers: list,
                ));
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Введите вопрос!')));
              }
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: new ListView.builder(
        itemCount: _answerControllers.length,
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
                // title: Text("${_answers[i]}",
                //     style: TextStyle(
                //       color: Theme.of(context).textTheme.headline6.color,
                //       fontWeight: FontWeight.bold,
                //     )),
                title: TextField(
                  controller: _answerControllers[i],
                ),
                leading: Container(
                  padding: EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    child: Icon(
                      (i == correct) ? Icons.done : Icons.remove,
                      color: Theme.of(context).accentColor,
                    ),
                    onTap: () {
                      setState(() {
                        correct = i;
                      });
                    },
                  ),
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
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: Theme.of(context).textTheme.headline6.color),
                  onPressed: () {
                    setState(() {
                      _answerControllers.removeAt(i);
                    });
                  },
                )
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _answerControllers.add(TextEditingController(text: 'ответ X'));
          });
        },
        child: Icon(Icons.add),
        foregroundColor: Theme.of(context).primaryColor,
        tooltip: 'Добавить ответ',
      ),
    );
  }
}
