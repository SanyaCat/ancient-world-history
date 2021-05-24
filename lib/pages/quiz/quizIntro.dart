import 'package:ancient_world_history/domain/routes.dart';
import 'package:ancient_world_history/pages/quiz/quizAdd.dart';
import 'package:ancient_world_history/pages/quiz/quizCurrent.dart';
import 'package:ancient_world_history/services/firestore.dart';
import 'package:flutter/material.dart';

class QuizIntro extends StatelessWidget {
  static const routeName = '/quiz/intro';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as QuizRouteArguments;

    var results = args.currentUser.results
        .where((element) => element.quizId == args.quiz.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(args.quiz.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, QuizAdd.routeName,
                  arguments: args.quiz);
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(args.topic.id)));
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content:
                      Text("Вы уверены что хотите удалить выбранный тест?"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        await FireStoreService().deleteQuiz(args.quiz, context);
                      },
                      child: Text(
                        'Да',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Нет',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text.rich(
              TextSpan(
                text: 'Дата создания: ${args.quiz.creationDate.day}.'
                    '${args.quiz.creationDate.month}.'
                    '${args.quiz.creationDate.year}',
                style: TextStyle(
                  fontSize: 24,
                  // color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text.rich(
              TextSpan(
                text: (results.length == 0)
                    ? 'Тест еще не проходился'
                    : '${results.first.correct}/${results.first.total}',
                style: TextStyle(
                  fontSize: 24,
                  // color: Theme.of(context)
                  //     .textTheme
                  //     .caption
                  //     .color,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                QuizCurrent.routeName,
                arguments: args,
              );
            },
            child: Text('Ikuzo!'),
          )
        ],
      ),
    );
  }
}
