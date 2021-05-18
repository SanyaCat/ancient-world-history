import 'package:ancient_world_history/pages/landingPage.dart';
import 'package:ancient_world_history/pages/topic/topicAdd.dart';
import 'package:ancient_world_history/pages/topic/topicCurrent.dart';
import 'package:ancient_world_history/pages/homePage.dart';
import 'package:flutter/material.dart';

// class RouteArguments {
//   final Topic topic;
//   final AWHUser user;
//
//   RouteArguments(this.topic, this.user);
// }

class Route {
  final String name;
  final String route;
  final WidgetBuilder builder;

  const Route({
    @required this.name,
    @required this.route,
    @required this.builder,
  });
}

final routes = [
  Route(
      name: 'Home',
      route: HomePage.routeName,
      builder: (context) => HomePage()),
  Route(
      name: 'Landing',
      route: LandingPage.routeName,
      builder: (context) => LandingPage()),
  Route(
      name: 'Current Topic',
      route: TopicCurrent.routeName,
      builder: (context) => TopicCurrent()),
  Route(
      name: 'Add Topic',
      route: TopicAdd.routeName,
      builder: (context) => TopicAdd()),
];

final routesMap =
    Map.fromEntries(routes.map((e) => MapEntry(e.route, e.builder)));

final allRoutes = <String, WidgetBuilder> {
  ...routesMap
};