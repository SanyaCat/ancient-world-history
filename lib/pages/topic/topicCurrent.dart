import 'package:ancient_world_history/domain/routes.dart';
import 'package:ancient_world_history/domain/topic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TopicCurrent extends StatelessWidget {
  static const routeName = '/topic/current';

  @override
  build(context) {
    final RouteArguments args = ModalRoute.of(context).settings.arguments as RouteArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.topic.title),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Автор: ${args.user.name}',
                    style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Html(
                      data: '<div style="font-size: 20">' +
                          args.topic.description +
                          '<//div>'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
