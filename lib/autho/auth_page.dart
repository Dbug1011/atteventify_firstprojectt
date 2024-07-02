import 'package:atteventify/autho/login_or_register.dart';
import 'package:atteventify/presentation/homescreen_page/homescreen_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check if the authentication state is still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If user is logged in, navigate to the home screen
          else if (snapshot.hasData) {
            // Navigate to the home screen
            return HomescreenPage();
          }
          // If there's an error, display an error message
          else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          // If user is not logged in, show the login screen
          else {
            return LoginorRegisterPage();
          }
        },
      ),
    );
  }
}
