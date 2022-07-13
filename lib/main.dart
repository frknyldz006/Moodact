import 'package:flutter/material.dart';
import 'package:moodact/screens/main_screen.dart';

void main() {
  runApp(MoodAct());
}

class MoodAct extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MoodAct',
        theme: ThemeData(fontFamily: 'Dunkin'),
        debugShowCheckedModeBanner: false,
        home: MainScreen());
  }
}
