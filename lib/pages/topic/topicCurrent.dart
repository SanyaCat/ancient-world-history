import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicCurrent extends StatelessWidget {
  static const routeName = '/topic/current';

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выбранная тема'),
      ),
      body: Text("Current topic"),
    );
  }
}