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

  final topics = <Topic>[
    Topic(
        title: '2,5 млн лет назад',
        author: 'Александр',
        description: 'Появление представителей первого человека'),
    Topic(
        title: '1,6 млн лет назад',
        author: 'Александр',
        description: 'Появление человека прямоходщего'),
    Topic(
        title: '250 тыс. лет назад',
        author: 'Наталья',
        description: 'Появление неандертальцев'),
    Topic(
        title: '40 тыс. лет назад',
        author: 'Александр',
        description: 'Появление Кроманьонцев в Европе'),
    Topic(
        title: 'Около 2600 года до н.э.',
        author: 'Наталья',
        description: 'Постройка пирамиды Хеопса в Египте'),
  ];

  var filterTitle = '';
  var filterTitleController = TextEditingController();
  var filterAuthor = '';
  var filterAuthorController = TextEditingController();
  var filterText = '';
  var filterHeight = 0.0;

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
                title: Text("${topics[i].title} - ${topics[i].author}",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontWeight: FontWeight.bold,
                    )),
                leading: Container(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.description,
                      color: Theme.of(context).textTheme.headline6.color),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              width: 1,
                              color: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .color))),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                trailing: Icon(Icons.arrow_right,
                    color: Theme.of(context).textTheme.headline6.color),
                subtitle: Text(topics[i].description, maxLines: 3),
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
              Icon(Icons.filter_list),
              Text(
                filterText,
                style: TextStyle(),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          onPressed: () {
            setState(() {
              filterHeight = (filterHeight == 0.0 ? 280 : 0.0);
            });
          },
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

    return Column(
      children: <Widget>[
        filterInfo,
        filterForm,
        topicList,
      ],
    );
  }
}
