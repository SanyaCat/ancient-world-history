import 'package:flutter/material.dart';

class TopicAdd extends StatelessWidget {
  static const routeName = '/topic/add';

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление темы'),
      ),
      body: Text("Topic Add"),
    );
  }
}
