import 'package:cite_quizgame/home.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

void main() {
  // Set up a timer to clear local storage after 30 seconds
  // Timer(Duration(seconds: 30), () async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('name');
  //   await prefs.remove('no');
  //   await prefs.remove('score');
  //   await prefs.remove('lastSavedTime');
  //   print('Local storage cleared after 30 seconds.');
  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
