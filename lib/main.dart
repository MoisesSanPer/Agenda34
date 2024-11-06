import 'package:flutter/material.dart';
import 'package:practica32agendasanchezmoises/ContactData.dart';
import 'package:practica32agendasanchezmoises/data/AgendData.dart';
import 'package:practica32agendasanchezmoises/data/data.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AgendaData(contacts: contactosFicticios),
      child: const MyApp(),
    ),
  );
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
        home: const ContactData());
  }
}
