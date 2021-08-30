import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newslife/views/home_view.dart';

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
      home: HomeView(),
    );
  }
}
