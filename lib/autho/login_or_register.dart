import 'package:atteventify/presentation/loginscreen_screen/loginscreen_screen.dart';
import 'package:atteventify/presentation/signupscreen_screen/signupscreen_screen.dart';
import 'package:flutter/material.dart';

class LoginorRegisterPage extends StatefulWidget {
  const LoginorRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginorRegisterPage> createState() => _LoginorRegisterPageState();
}

class _LoginorRegisterPageState extends State<LoginorRegisterPage> {
  // initially show login page at the beginning
  bool showLoginscreenScreen = true;

//togglebetween login and register page
  void togglePages() {
    setState(() {
      showLoginscreenScreen = !showLoginscreenScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginscreenScreen) {
      return LoginscreenScreen(
        onTap: togglePages,
      );
    } else {
      return SignupscreenScreen(
        onTap: togglePages,
      );
    }
  }
}
