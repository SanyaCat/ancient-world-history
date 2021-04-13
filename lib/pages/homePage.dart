import 'package:ancient_world_history/pages/topic/topicAdd.dart';
import 'package:ancient_world_history/pages/topic/topicList.dart';
import 'package:ancient_world_history/pages/quiz/quizList.dart';
import 'package:ancient_world_history/services/auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// topic page
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  static const routeName = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int sectionIndex = 0;

  @override
  build(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(sectionIndex == 0 ? 'Теория' : 'Тесты'),
        leading: Icon(Icons.article_outlined),
        actions: <Widget>[
          // log out button
          TextButton.icon(
            onPressed: () {
              AuthService().logOut();
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).textTheme.headline6.color,
            ),
            label: SizedBox.shrink(),
          )
        ],
      ),
      body: sectionIndex == 0 ? TopicList() : QuizList(),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.article_outlined),
          Icon(Icons.edit),
        ],
        index: sectionIndex,
        height: 50,
        backgroundColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
        buttonBackgroundColor: Theme.of(context).primaryColorLight,
        color: Theme.of(context).textTheme.headline6.color,
        animationCurve: Curves.elasticInOut,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() => sectionIndex = index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (sectionIndex == 0) {
            Navigator.pushNamed(context, TopicAdd.routeName);
          }
        },
        child: Icon(Icons.add),
        //backgroundColor: Theme.of(context).textTheme.headline6.color,
        foregroundColor: Theme.of(context).primaryColor,
        tooltip: sectionIndex == 0 ? 'Добавить тему' : 'Добавить тест',
      ),
    );
  }
}
