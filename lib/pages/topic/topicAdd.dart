import 'package:ancient_world_history/domain/topic.dart';
import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';

class TopicAdd extends StatefulWidget {
  static const routeName = '/topic/add';

  @override
  _TopicAddState createState() => _TopicAddState();
}

class _TopicAddState extends State<TopicAdd> {
  final _titleController = TextEditingController(text: 'Введите название');
  final htmlController = HtmlEditorController();

  bool typing = false;

  @override
  build(context) {
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
          icon: Icon(typing ? Icons.done : Icons.edit),
          onPressed: () {
            setState(() {
              if (!typing || _titleController.text == 'Введите название') {
                _titleController.text = '';
                typing = !typing;
              } else if (typing && _titleController.text.isNotEmpty)
                typing = !typing;
              else
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Введите название!')));
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Topic topic = Topic(
                  title: _titleController.text,
                  author: Provider.of<AWHUser>(context, listen: false).id,
                  description: await htmlController.getText());
              await FireStoreService().editTopic(topic);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Тема добавлена!')));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: HtmlEditor(
          controller: htmlController,
          htmlEditorOptions: HtmlEditorOptions(
            hint: 'Введите текст...',
          ),
          htmlToolbarOptions: HtmlToolbarOptions(
            defaultToolbarButtons: [
              FontButtons(),
              InsertButtons(),
              ListButtons(listStyles: false),
            ],
            toolbarPosition: ToolbarPosition.belowEditor,
            toolbarType: ToolbarType.nativeGrid,
          ),
          otherOptions: OtherOptions(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewInsets.top),
        ),
      ),
    );
  }
}
