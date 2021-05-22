import 'dart:io';
import 'package:ancient_world_history/domain/topic.dart';
import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
  List<File> topicImages = List.empty(growable: true);

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
          icon: Icon(typing ? Icons.download_done_sharp : Icons.edit),
          onPressed: () {
            setState(() {
              if (!typing) {
                if (_titleController.text == 'Введите название')
                  _titleController.text = '';
                typing = !typing;
              } else if (typing && _titleController.text.isNotEmpty)
                typing = !typing;
              else
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Название должно быть заполнено!')));
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return imageDialog();
                  });
            },
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () async {
              if (_titleController.text != 'Введите название') {
                List<String> imagesUrls = List.empty(growable: true);

                for (int i = 0; i < topicImages.length; i++) {
                  imagesUrls.add(await FireStoreService().uploadFile(topicImages[i], context));
                }

                // topicImages.forEach((image) async {
                //   imagesUrls.add(await FireStoreService().uploadFile(image, context));
                // });

                Topic topic = Topic(
                  title: _titleController.text,
                  authorId: Provider.of<AWHUser>(context, listen: false).id,
                  text: await htmlController.getText(),
                  topicDate: '',
                  creationDate: DateTime.now(),
                  updateDate: DateTime.now(),
                  images: imagesUrls,
                );
                await FireStoreService().editTopic(topic, context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Тема добавлена!')));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Введите название!')));
              }
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
            initialText: '',
          ),
          htmlToolbarOptions: HtmlToolbarOptions(
            defaultToolbarButtons: [
              FontButtons(clearAll: false),
              ListButtons(listStyles: false),
              InsertButtons(
                picture: false,
                video: false,
                audio: false,
                link: false,
                table: false,
              ),
            ],
            toolbarPosition: ToolbarPosition.belowEditor,
            toolbarType: ToolbarType.nativeScrollable,
          ),
          otherOptions: OtherOptions(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewInsets.top),
        ),
      ),
    );
  }

  StatefulBuilder imageDialog() {
    PickedFile file;
    List<File> images = topicImages;
    return StatefulBuilder(builder: (context, setState) {
      chooseImage() async {
        if (images.length <= 10) {
          file = await ImagePicker().getImage(source: ImageSource.gallery);

          setState(() {
            images.add(File(file.path));
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Максимум 10 изображений")));
        }
      }

      Widget showImage() {
        //tmpFile = snapshot.data;
        //base64Image = snapshot.data.readAsString();
        return (images.isNotEmpty)
            ? Container(
                height: 500,
                child: ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (_, index) => Image.file(images[index]),
                ),
              )
            : Text(
                'No Image Selected',
                textAlign: TextAlign.center,
              );
      }

      return AlertDialog(
        content: Column(
          children: [
            OutlinedButton(
              onPressed: chooseImage,
              child: Text('Choose Image'),
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      );
    });
  }
}
