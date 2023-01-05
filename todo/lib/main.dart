import 'package:flutter/material.dart';
import 'package:todo/layout/home_layout.dart';

void main(){
  runApp(todoApp());
}

class todoApp extends StatelessWidget {
  const todoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: home(),
    debugShowCheckedModeBanner: false,);
  }
}
