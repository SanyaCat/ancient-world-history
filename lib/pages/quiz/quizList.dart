import 'package:ancient_world_history/pages/quiz/quizCurrent.dart';
import 'package:flutter/material.dart';
import 'package:ancient_world_history/domain/routes.dart';
import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/services/firestore.dart';
import 'package:ancient_world_history/domain/quiz.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// list of topics
class QuizList extends StatefulWidget {
  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  var quizzes = List<Quiz>.empty(growable: true);
  var quizzesFiltered = List<Quiz>.empty(growable: true);
  var users = List<AWHUser>.empty(growable: true);
  Future future;

  var filterTitle = '';
  var filterTitleController = TextEditingController();
  var filterAuthor = '';
  var filterAuthorController = TextEditingController();
  var filterText = 'Все тесты';
  var filterHeight = 0.0;
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
    var stream = db.getQuizzes();

    stream.listen((List<Quiz> data) {
      setState(() {
        quizzes = data;
        quizzesFiltered = new List.from(quizzes, growable: true);
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
      quizzesFiltered = List.from(quizzes);
      if (filterTitle.isNotEmpty && filterAuthor.isNotEmpty) {
        filterText = '$filterTitle/$filterAuthor';
        quizzes.forEach((topic) {
          if (!topic.title.contains(filterTitle) &&
              !findUserById(topic.authorId).name.contains(filterAuthor))
            quizzesFiltered.remove(topic);
        });
      } else if (filterTitle.isNotEmpty) {
        filterText = filterTitle;
        quizzes.forEach((topic) {
          if (!topic.title.contains(filterTitle)) quizzesFiltered.remove(topic);
        });
      } else if (filterAuthor.isNotEmpty) {
        filterText = filterAuthor;
        quizzes.forEach((topic) {
          if (!findUserById(topic.authorId).name.contains(filterAuthor))
            quizzesFiltered.remove(topic);
        });
      } else {
        filterText = 'Все тесты';
      }
    });
  }

  Future<void> clearFilter() async {
    setState(() {
      filterText = 'Все тесты';
      filterTitle = '';
      filterAuthor = '';
      filterTitleController.clear();
      filterAuthorController.clear();
      quizzesFiltered = new List.from(quizzes, growable: true);
    });
  }

  @override
  build(context) {
    var topicList = Expanded(
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: new ListView.builder(
          itemCount: quizzesFiltered.length,
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
                      "${quizzesFiltered[i].title} - ${findUserById(quizzesFiltered[i].authorId).name}",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color,
                        fontWeight: FontWeight.bold,
                      )),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.assignment_turned_in_rounded,
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
                      child: Text('${quizzesFiltered[i].updateDate.day}.'
                          '${quizzesFiltered[i].updateDate.month}.'
                          '${quizzesFiltered[i].updateDate.year}')),
                  // subtitle: Container(
                  //     constraints: BoxConstraints(
                  //       maxHeight: 40,
                  //     ),
                  //     child: Text((Provider.of<AWHUser>(context).results.where((element) => element.quizId == quizzesFiltered[i].id).length == 0) ? '' :
                  //         Provider.of<AWHUser>(context).results.where((element) => element.quizId == quizzesFiltered[i].id).first.correct ,
                  //     ),
                  // ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      QuizCurrent.routeName,
                      arguments: QuizRouteArguments(quizzesFiltered[i],
                          findUserById(quizzesFiltered[i].authorId)),
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
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                controller: filterTitleController,
                decoration: InputDecoration(labelText: 'Название'),
                onChanged: (String val) => setState(() => filterTitle = val),
              ),
              TextFormField(
                controller: filterAuthorController,
                decoration: InputDecoration(labelText: 'Автор'),
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
                        'Фильтр',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColorLight,
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
                        'Очистить',
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