import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => !isLogin
      ? LoginScreen(changePage: toggle)
      : RegisterScreen(
          changePage: toggle,
        );

  void toggle() => setState(() => isLogin = !isLogin);
}
