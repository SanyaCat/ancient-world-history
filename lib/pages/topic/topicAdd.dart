import 'package:ancient_world_history/domain/topic.dart';
import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor/html_editor.dart';
import 'package:provider/provider.dart';

class TopicAdd extends StatefulWidget {
  static const routeName = '/topic/add';

  @override
  _TopicAddState createState() => _TopicAddState();
}

class _TopicAddState extends State<TopicAdd> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  var err = false;

  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление темы'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                Topic topic = Topic(
                  title: _titleController.text,
                  author: Provider.of<AWHUser>(context, listen: false).id,
                  description: await keyEditor.currentState.getText()
                );
                await FireStoreService().editTopic(topic);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Тема добавлена!')));
                // await keyEditor.currentState.getText()
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Название',
                    labelStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      err = true;
                      return 'Введите название';
                    } else {
                      err = false;
                    }
                    return null;
                  },
                ),
              ),
              HtmlEditor(
                hint: 'Введите текст...',
                key: keyEditor,
                height: MediaQuery.of(context).size.height -
                    (err ? 198.5 : 178) -
                    MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
