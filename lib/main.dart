import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newslife/services/firebase.dart';
import 'package:newslife/views/home_view.dart';
import 'package:newslife/views/login_view.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "KaiseiHarunoUmi",
        cardColor: Colors.white,
        textTheme: TextTheme(
            caption: Theme.of(context)
                .textTheme
                .caption
                ?.apply(fontFamily: "Roboto")),
        buttonTheme: ButtonThemeData(buttonColor: Colors.black),
        primarySwatch: Colors.grey,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 1.0,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark)),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        cardColor: Colors.black,
        fontFamily: "KaiseiHarunoUmi",
        textTheme: TextTheme(
            caption: Theme.of(context)
                .textTheme
                .caption
                ?.apply(fontFamily: "Roboto", color: Colors.white)),
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
        buttonTheme: ButtonThemeData(buttonColor: Colors.white),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark)),
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: ThemeMode.system,
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return StreamBuilder(
                  stream: firebaseAuthServices.isSignedIn(),
                  builder: (context, snapshot) {
                    final user = snapshot.data as User?;
                    if (user == null) {
                      return LoginView();
                    } else {
                      return HomeView();
                    }
                  });
            } else {
              return Scaffold(
                body: Column(
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              );
            }
          }),
    );
  }
}
