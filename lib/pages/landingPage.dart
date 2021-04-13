import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/pages/authPage.dart';
import 'package:ancient_world_history/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// decides which page to load first
class LandingPage extends StatelessWidget {
  const LandingPage({Key key}) : super(key: key);

  static const routeName = '/landing';

  @override
  build(context) {
    final AWHUser user = Provider.of<AWHUser>(context);
    final bool isLoggedIn = user != null;

    return isLoggedIn ? HomePage() : AuthPage();
  }
}