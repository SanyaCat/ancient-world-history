import 'package:ancient_world_history/domain/routes.dart';
import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/pages/topic/topicCurrent.dart';
import 'package:ancient_world_history/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:ancient_world_history/domain/topic.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// list of topics
class TopicList extends StatefulWidget {
  @override
  _TopicListState createState() => _TopicListState();
}

class _TopicListState extends State<TopicList> {
  var topics = List<Topic>.empty(growable: true);
  var topicsFiltered = List<Topic>.empty(growable: true);
  var users = List<AWHUser>.empty(growable: true);
  Future future;

  var filterTitle = '';
  var filterTitleController = TextEditingController();
  var filterAuthor = '';
  var filterAuthorController = TextEditingController();
  var filterText = 'Все темы';
  var filterHeight = 190.0;
  FireStoreService db = FireStoreService();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await loadData();
    clearFilter();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();

    future = loadData();
  }

  AWHUser findUserById(id) => users.firstWhere((element) => element.id == id);

  Future<void> loadData() async {
    var stream = db.getTopics();

    stream.listen((List<Topic> data) {
      setState(() {
        topics = data;
        topicsFiltered = new List.from(topics, growable: true);
      });
    });

    var streamUsers = db.getUsers();
    streamUsers.listen((List<AWHUser> data) {
      setState(() {
        users = data;
      });
    });
  }

  Future<void> refreshPage() async {
    await _refreshController.requestRefresh();
  }

  void filter() async {
    setState(() {
      topicsFiltered = List.from(topics);
      if (filterTitle.isNotEmpty && filterAuthor.isNotEmpty) {
        filterText = '$filterTitle/$filterAuthor';
        topics.forEach((topic) {
          if (!topic.title.contains(filterTitle) &&
              !findUserById(topic.authorId).name.contains(filterAuthor))
            topicsFiltered.remove(topic);
        });
      } else if (filterTitle.isNotEmpty) {
        filterText = filterTitle;
        topics.forEach((topic) {
          if (!topic.title.contains(filterTitle)) topicsFiltered.remove(topic);
        });
      } else if (filterAuthor.isNotEmpty) {
        filterText = filterAuthor;
        topics.forEach((topic) {
          if (!findUserById(topic.authorId).name.contains(filterAuthor))
            topicsFiltered.remove(topic);
        });
      } else {
        filterText = 'Все темы';
      }
    });
  }

  Future<void> clearFilter() async {
    setState(() {
      filterText = 'Все темы';
      filterTitle = '';
      filterAuthor = '';
      filterTitleController.clear();
      filterAuthorController.clear();
      topicsFiltered = new List.from(topics, growable: true);
    });
  }

  @override
  build(context) {
    var topicList = Expanded(
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: new ListView.builder(
          itemCount: topicsFiltered.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return Card(
              key: UniqueKey(),
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColorLight),
                child: ListTile(
                  title: Text(
                      "${topicsFiltered[i].title} - ${findUserById(topicsFiltered[i].authorId).name}",
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
                        maxHeight: 40,
                      ),
                      child: Text('${topicsFiltered[i].updateDate.day}.'
                          '${topicsFiltered[i].updateDate.month}.'
                          '${topicsFiltered[i].updateDate.year}')),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      TopicCurrent.routeName,
                      arguments: RouteArguments(topicsFiltered[i],
                          findUserById(topicsFiltered[i].authorId)),
                    );
                  },
                ),
              ),
            );
          },
        ),
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
              filterHeight = (filterHeight == 0 ? 190 : 0);
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).textTheme.headline6.color.withAlpha(50),
          ),
        ));

    var filterForm = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
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
                  // Apply Filter button
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

                  // Clear Filter button
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

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            filterInfo,
            filterForm,
            topicList,
          ],
        );
      },
    );
  }
}
