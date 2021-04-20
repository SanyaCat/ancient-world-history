import 'package:ancient_world_history/domain/topic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicCurrent extends StatelessWidget {
  static const routeName = '/topic/current';

  @override
  build(context) {
    final Topic topic = ModalRoute.of(context).settings.arguments as Topic;

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Автор: ${topic.author}',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              topic.description,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
