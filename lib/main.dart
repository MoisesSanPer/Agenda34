import 'package:flutter/material.dart';
import 'package:practica32agendasanchezmoises/agenda_data.dart';
import 'package:practica32agendasanchezmoises/data/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Agenda(contact: contact),
    );
  }
}
