import 'package:ancient_world_history/domain/routes.dart';
import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/pages/quiz/quizAdd.dart';
import 'package:ancient_world_history/services/firestore.dart';
import 'package:flutter/material.dart';

class QuizCurrent extends StatefulWidget {
  static const routeName = '/quiz/current';

  @override
  _QuizCurrentState createState() => _QuizCurrentState();
}

class _QuizCurrentState extends State<QuizCurrent>
    with SingleTickerProviderStateMixin {
  var initSeconds = 100;
  AnimationController _progressController;
  Animation _animation;
  var currentQuestion = 0;
  List<int> chosenAnswers = List.filled(50, 0);
  var score = 0;
  var timeText = "";
  UserResult result;
  List<bool> answered = List.filled(8, false);

  @override
  void initState() {
    _progressController = AnimationController(
        duration: Duration(seconds: initSeconds), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_progressController);
    _animation.addListener(() {
      setState(() {
        var seconds = initSeconds - (_progressController.value * initSeconds).floor();
        if (seconds >= 60)
          timeText = '${seconds ~/ 60} мин. ${seconds % 60} сек.';
        else
        timeText = '${seconds % 60} сек.';
      });
    });

    _progressController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  build(context) {
    final args =
        ModalRoute.of(context).settings.arguments as QuizRouteArguments;

    final questions = args.quiz.questions;
    result = UserResult(args.quiz.id);

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
                        await FireStoreService()
                            .deleteQuiz(args.quiz, context);
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
          // Time
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              width: double.infinity,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) => Container(
                      width: constraints.maxWidth * _progressController.value,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Theme.of(context).primaryColorDark,
                            Theme.of(context).primaryColorLight,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(timeText),
                          Icon(Icons.access_time),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text.rich(
              TextSpan(
                text:
                    '[${currentQuestion + 1}/${questions.length}] ${args.quiz.questions[currentQuestion].question}',
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context)
                      .textTheme
                      .caption
                      .color
                      .withOpacity(0.7),
                ),
              ),
            ),
          ),
          Divider(),
          SizedBox(height: 8),
          Container(
            // height: 34 +
            //   68.0 *
            //       args.quiz.questions.((a, b) => a.answers.length > b.answers.length ? a : b),
            // height: 400,
            // child: PageView.builder(
            //   itemCount: args.quiz.questions.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(25),
              ),
              height: 34 + 68.0 * questions[currentQuestion].answers.length,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: questions[currentQuestion].answers.length,
                itemBuilder: (context, i) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                          "  ${i + 1}. ${questions[currentQuestion].answers[i]}",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline6.color,
                            fontWeight: FontWeight.bold,
                          )),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      // trailing: Container(
                      //   height: 26,
                      //   width: 26,
                      //   decoration: BoxD,
                      // ),
                      trailing: (answered[currentQuestion])
                          ? (questions[currentQuestion].answers[i] ==
                                  questions[currentQuestion].correctAnswer)
                              ? Icon(Icons.done)
                              : (chosenAnswers[currentQuestion] == i)
                                  ? Icon(Icons.remove_circle_outlined)
                                  : Icon(Icons.blur_circular)
                          : Icon((chosenAnswers[currentQuestion] == i)
                              ? Icons.circle
                              : Icons.blur_circular),
                      onTap: () {
                        setState(() {
                          chosenAnswers[currentQuestion] = i;
                        });
                      },
                    ),
                  );
                },
              ),
              // );
              // },
            ),
          ),
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      if (currentQuestion > 0) {
                        currentQuestion--;
                      } else {
                        Navigator.pop(context);
                      }
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      answered[currentQuestion] = true;
                    });
                  },
                  child: Text(
                    'Подтвердить',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      if (currentQuestion < questions.length - 1) {
                        currentQuestion++;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Тест пройден!')));
                        Navigator.pop(context);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
