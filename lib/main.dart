import 'package:flutter/material.dart';
import 'screens/MessageBoardScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '留言板',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MessageBoardScreen(),
    );
  }
}
