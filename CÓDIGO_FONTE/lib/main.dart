import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_auth/ui/home.dart';
import 'package:flutter_fire_auth/ui/login.dart';

void main() {
  runApp(MaterialApp(
      home: MainScreen(),
      title: 'O POVO Filmes',
      color: Colors.white,
      theme: ThemeData(
          hintColor: Colors.white,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)))
      )
  ));
}

// =================================

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return LoginPage();
        if (!snapshot.hasData || snapshot.data == null)
          return LoginPage();
        return HomePage();
      },
    );
  }
}

