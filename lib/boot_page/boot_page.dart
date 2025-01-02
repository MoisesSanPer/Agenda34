
import 'package:flutter/material.dart';
import 'package:practica32agendasanchezmoises/ContactPage.dart';
import 'package:practica32agendasanchezmoises/data/AgendData.class.dart';
import 'package:provider/provider.dart';

class BootPage extends StatefulWidget {
  const BootPage({super.key});

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  @override
  void initState() {
    NavigatorState navigator = Navigator.of(context);
    AgendaData agenda = Provider.of<AgendaData>(context, listen: false);
    agenda.load().then((value) {
      navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const ContactPage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(), Text("Cargando datos...")],
        ),
      ),
    );
  }
}
