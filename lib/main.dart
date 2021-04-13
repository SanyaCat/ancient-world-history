import 'package:ancient_world_history/domain/routes.dart';
import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/pages/landingPage.dart';
import 'package:ancient_world_history/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// initializes app
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AWHApp());
}

class AWHApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  build(context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // check for errors
        if (snapshot.hasError) {
          Fluttertoast.showToast(msg: "Ошибка!!!");
        }

        // shows application
        return StreamProvider<AWHUser>.value(
          value: AuthService().currentUser,
          child: MaterialApp(
            title: 'История Древнего мира',
            theme: ThemeData(
              primaryColor: Colors.amber,
              primaryColorLight: Colors.amberAccent,
              primaryColorDark: Color.fromARGB(100, 255, 200, 0),
              textTheme: TextTheme(
                headline6: TextStyle(color: Colors.black54),
                caption: TextStyle(color: Colors.black38),
              ),
              accentColor: Colors.black54,
            ),
            initialRoute: LandingPage.routeName,
            routes: allRoutes,
          ),
        );
      },
    );
  }
}
