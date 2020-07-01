import 'package:flutter/material.dart';
import 'package:groceylistapp/Screens/EditingScreen.dart';
import 'package:groceylistapp/Screens/HomeScreen.dart';
import 'package:groceylistapp/Screens/ListScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => HomeScreen(),
        '/list': (context) => ListScreen(),
        '/edit': (context) => EditingScreen(),
      },
    );
  }
}
