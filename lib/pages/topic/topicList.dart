import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/pages/topic/topicCurrent.dart';
import 'package:ancient_world_history/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:ancient_world_history/domain/topic.dart';

// list of topics
class TopicList extends StatefulWidget {
  @override
  _TopicListState createState() => _TopicListState();
}

class _TopicListState extends State<TopicList> {
  @override
  void initState() {
    clearFilter();
    super.initState();
  }

  var topics = List<Topic>.empty();
  var users = List<AWHUser>.empty();

  var filterTitle = '';
  var filterTitleController = TextEditingController();
  var filterAuthor = '';
  var filterAuthorController = TextEditingController();
  var filterText = '';
  var filterHeight = 0.0;
  FireStoreService db = FireStoreService();

  loadData() async {
    filterTitle = filterTitleController.text;
    filterAuthor = filterAuthorController.text;

    var stream = db.getTopics(
        topic: Topic(
      title: filterTitle.isNotEmpty ? filterTitle : null,
      authorId: filterAuthor.isNotEmpty ? filterAuthor : null,
    ));

    stream.listen((List<Topic> data) {
      setState(() {
        topics = data;
      });
    });

    var streamUsers = db.getUsers();
    streamUsers.listen((List<AWHUser> data) {
      setState(() {
        users = data;
      });
    });

    topics.forEach((topic) {
      topic.author =
          users.firstWhere((element) => element.id == topic.authorId);
    });
  }

  List<Topic> filter() {
    setState(() {
      if (filterTitle.isNotEmpty)
        filterText = filterTitle;
      else
        filterText = 'All';
      if (filterAuthor.isNotEmpty) filterText += '/' + filterAuthor;
      filterHeight = 0.0;
    });

    var list = topics;
    return list;
  }

  List<Topic> clearFilter() {
    setState(() {
      filterText = 'All topics';
      filterTitle = '';
      filterAuthor = '';
      filterTitleController.clear();
      filterAuthorController.clear();
      filterHeight = 0.0;
    });

    var list = topics;
    return list;
  }

  @override
  build(context) {
    var topicList = Expanded(
      child: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, i) {
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorLight),
              child: ListTile(
                title: Text("${topics[i].title} - ${topics[i].author.name}",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontWeight: FontWeight.bold,
                    )),
                leading: Container(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.description,
                      color: Theme.of(context).accentColor),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 1,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                trailing: Icon(Icons.arrow_right,
                    color: Theme.of(context).textTheme.headline6.color),
                subtitle: Container(
                    constraints: BoxConstraints(
                      maxHeight: 40.0,
                    ),
                    child: Text('${topics[i].updateDate.day}.'
                        '${topics[i].updateDate.month}.'
                        '${topics[i].updateDate.year}')),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    TopicCurrent.routeName,
                    arguments: topics[i],
                  );
                },
              ),
            ),
          );
        },
      ),
    );

    var filterInfo = Container(
        margin: EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 5),
        decoration: BoxDecoration(
            color:
                Theme.of(context).textTheme.headline6.color.withOpacity(0.5)),
        height: 40,
        child: ElevatedButton(
          child: Row(
            children: [
              Icon(
                Icons.filter_list,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                filterText,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontStyle: FontStyle.italic,
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          onPressed: () {
            setState(() {
              filterHeight = (filterHeight == 0.0 ? 280 : 0.0);
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).textTheme.headline6.color.withAlpha(50),
          ),
        ));

    var filterForm = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: filterTitleController,
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (String val) => setState(() => filterTitle = val),
              ),
              TextFormField(
                controller: filterAuthorController,
                decoration: InputDecoration(labelText: 'Author'),
                onChanged: (String val) => setState(() => filterAuthor = val),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        filter();
                      },
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        clearFilter();
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: filterHeight,
    );

    loadData();

    return Column(
      children: <Widget>[
        filterInfo,
        filterForm,
        topicList,
      ],
    );
  }
}
