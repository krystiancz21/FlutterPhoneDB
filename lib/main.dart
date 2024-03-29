import 'package:flutter/material.dart';
import 'package:phonedb/screens/phonesScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Database App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PhonesScreen(),
    );
  }
}
