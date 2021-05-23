import 'package:ancient_world_history/domain/routes.dart';
import 'package:ancient_world_history/pages/topic/topicAdd.dart';
import 'package:ancient_world_history/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TopicCurrent extends StatelessWidget {
  static const routeName = '/topic/current';

  @override
  build(context) {
    final args =
        ModalRoute.of(context).settings.arguments as TopicRouteArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.topic.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, TopicAdd.routeName,
                  arguments: args.topic);
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
                      Text("Вы уверены что хотите удалить выбранную тему?"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        await FireStoreService()
                            .deleteTopic(args.topic, context);
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
      body: Container(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Padding(
                //   padding: EdgeInsets.all(8),
                //   child: Text(
                //     'Автор: ${args.user.name}',
                //     style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Html(
                      data: '<div style="font-size: 20">' +
                          args.topic.text +
                          '<//div>'),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    height: 600,
                    child: ListView.builder(
                      itemCount: args.topic.images.length,
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: SizedBox(
                          width: 300,
                          child: Image.network(
                            args.topic.images[index],
                            loadingBuilder: (context, child, progress) =>
                                progress == null
                                    ? child
                                    : Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Theme.of(context).accentColor,
                                                ),
                                              ),
                                              Text('   Загрузка изображения...')
                                            ],
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // saveImage(String url, context) {
  //   HapticFeedback.vibrate();
  //   GallerySaver.saveImage(url.substring(0, url.indexOf('?alt=media&token'))).then((bool success) {
  //     if (success) {
  //       HapticFeedback.vibrate();
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('Изображение сохранено!')));
  //     }
  //   });
  // }
}
