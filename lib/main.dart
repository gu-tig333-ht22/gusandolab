// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';
import 'firstview.dart';

void main() {
  var state = MyState();

  runApp(
    ChangeNotifierProvider(
      create: (context) => state,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Att-Göra Lista',
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.yellow,
          unselectedWidgetColor: Colors.yellow,
          fontFamily: 'Roboto'),
      home: const Homepage(),
    );
  }
}
