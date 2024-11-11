import 'package:flutter/material.dart';
import 'package:practica32agendasanchezmoises/ContactFormPage.dart';
import 'package:practica32agendasanchezmoises/data/AgendData.class.dart';
import 'package:practica32agendasanchezmoises/data/ContactData.class.dart';
import 'package:provider/provider.dart';

Future<void> onCreateContact(BuildContext context) async {
  // Paso 1: Crear un contacto vacío
  Contactos newContact = Contactos(
    id: 0, // El id puede ser 0 porque es un nuevo contacto
    name: '',
    surname: '',
    email: '',
    phone: '',
    birthdate: null,
    isFavorite: false,
    labels: [],
  );
  bool? resultado = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ContactFormPage(contact: newContact),
    ),
  );
  if (resultado == true) {
    newContact.creation = DateTime.now();
    Provider.of<AgendaData>(context, listen: false).addContact(newContact);
  }
}

Future<void> onEditContact(
    BuildContext context, Contactos contacto, int index) async {
  // Paso 1: Crear un contacto vacío
  Contactos newContact = contacto.copyWith();
  bool? resultado = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ContactFormPage(contact: newContact),
    ),
  );
  if (resultado == true) {
    newContact.creation = DateTime.now();
    Provider.of<AgendaData>(context, listen: false)
        .updateContact(contacto, newContact, index);
  }
}
