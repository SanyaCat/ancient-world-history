import 'package:ancient_world_history/components/topicCurrent.dart';
import 'package:ancient_world_history/components/topicList.dart';
import 'package:ancient_world_history/services/auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// topic page
class TopicPage extends StatefulWidget {
  TopicPage({Key key}) : super(key: key);

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  int sectionIndex = 0;

  @override
  build(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(sectionIndex == 0 ? 'Тема' : 'Теория'),
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
      body: sectionIndex == 0 ? TopicCurrent() : TopicList(),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.article_outlined),
          Icon(Icons.search),
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
    );
  }
}
