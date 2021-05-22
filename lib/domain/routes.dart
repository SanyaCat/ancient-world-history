import 'package:ancient_world_history/domain/quiz.dart';
import 'package:ancient_world_history/domain/topic.dart';
import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/pages/landingPage.dart';
import 'package:ancient_world_history/pages/quiz/QuestionAdd.dart';
import 'package:ancient_world_history/pages/quiz/quizAdd.dart';
import 'package:ancient_world_history/pages/quiz/quizCurrent.dart';
import 'package:ancient_world_history/pages/topic/topicAdd.dart';
import 'package:ancient_world_history/pages/topic/topicCurrent.dart';
import 'package:ancient_world_history/pages/homePage.dart';
import 'package:flutter/material.dart';

class TopicRouteArguments {
  final Topic topic;
  final AWHUser user;

  TopicRouteArguments(this.topic, this.user);
}

class QuizRouteArguments {
  final Quiz quiz;
  final AWHUser user;

  QuizRouteArguments(this.quiz, this.user);
}

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
  Route(
      name: 'Current Quiz',
      route: QuizCurrent.routeName,
      builder: (context) => QuizCurrent()),
  Route(
      name: 'Add Quiz',
      route: QuizAdd.routeName,
      builder: (context) => QuizAdd()),
  Route(
      name: 'Add Question',
      route: QuestionAdd.routeName,
      builder: (context) => QuestionAdd()),
];

final routesMap =
    Map.fromEntries(routes.map((e) => MapEntry(e.route, e.builder)));

final allRoutes = <String, WidgetBuilder> {
  ...routesMap
};