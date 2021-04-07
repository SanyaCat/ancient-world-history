import 'package:ancient_world_history/domain/user.dart';
import 'package:ancient_world_history/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// user authentication
class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super (key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email;
  String _password;
  bool showLogin = true;

  AuthService _authService = AuthService();

  @override
  build(context) {
    Widget _logo() {
      return Padding(
        padding: EdgeInsets.only(top: 70),
        child: Container(
          // title
          child: Align(
            child: Text('История Древнего мира',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ),
        ),
      );
    }

    Widget _inputBox(Icon icon, String hint, TextEditingController controller, bool obscure) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: 20, color: Theme.of(context).textTheme.headline6.color),
          decoration: InputDecoration(
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).textTheme.caption.color,
              ),
              hintText: hint,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).textTheme.headline6.color, width: 3)
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).textTheme.caption.color, width: 1)
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: IconTheme(
                  data: IconThemeData(color: Theme.of(context).textTheme.headline6.color,),
                  child: icon,
                ),
              )
          ),
        ),
      );
    }

    Widget _button(String text, void func()) {
      return RaisedButton(
        splashColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).primaryColorLight,
        color: Theme.of(context).textTheme.headline6.color,
        onPressed: () { func(); },
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 20
          )
        ),
      );
    }

    Widget _form(String label, void func()) {
      return Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 30),
              child: _inputBox(Icon(Icons.email), 'Почта', _emailController, false),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: _inputBox(Icon(Icons.lock), 'Пароль', _passwordController, true),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: _button(label, func),
              ),
            )
          ],
        ),
      );
    }

    void _loginUser() async {
      _email = _emailController.text;
      _password = _passwordController.text;

      if (_email.isEmpty || _password.isEmpty) return;

      AWHUser user = await _authService.signInWithEmailAndPassword(_email.trim(), _password.trim());
      if (user == null) {
        Fluttertoast.showToast(msg: "Ошибка. Пользователя с такой электронной почтой не существует!", fontSize: 16, gravity: ToastGravity.CENTER);
      } else {
        _emailController.clear();
        _passwordController.clear();
      }
    }

    void _registerUser() async {
      _email = _emailController.text;
      _password = _passwordController.text;

      if (_email.isEmpty || _password.isEmpty) return;

      AWHUser user = await _authService.registerWithEmailAndPassword(_email.trim(), _password.trim());
      if (user == null) {
        Fluttertoast.showToast(msg: "Ошибка. Не получилось зарегистрировать пользователя!");
      } else {
        _emailController.clear();
        _passwordController.clear();
      }
    }

    Widget _bottomWave() {
      return Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              color: Theme.of(context).textTheme.headline6.color,
              height: 300,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          _logo(),
          (
              showLogin
              // login
              ? Column(
                children: [
                  _form('Войти', _loginUser),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                          child: Text('Зарегистрироваться', style: TextStyle(fontSize: 20, color: Theme.of(context).textTheme.headline6.color),),
                          onTap: (){
                            setState((){
                              showLogin = false;
                            });
                          }
                      ),
                  )
                ],
              )

              // register
              : Column(
                children: [
                  _form('Регистрация', _registerUser),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                        child: Text('Войти', style: TextStyle(fontSize: 20, color: Theme.of(context).textTheme.headline6.color),),
                        onTap: (){
                          setState(() {
                            showLogin = true;
                          });
                        }
                    ),
                  )
                ],
              )
          ),
          _bottomWave()
        ],
      )
    );
  }
}

// bottom decoration
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(
        secondControlPoint.dx,
        secondControlPoint.dy,
        secondEndPoint.dx,
        secondEndPoint.dy
    );
    return path;
  }

  @override bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}