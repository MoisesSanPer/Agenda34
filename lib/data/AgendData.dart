// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:practica32agendasanchezmoises/data/contactos_datos.dart';

class AgendaData extends ChangeNotifier {
  // Campo
  List<Contactos> contacts;

  // Constructor por defecto
  AgendaData({List<Contactos>? contacts}) : contacts = contacts ?? [];

  List<Contactos> get publicContactos => contacts;
  // Constructor factory fromJson()
  factory AgendaData.fromJson(Map<String, dynamic> json) {
    return AgendaData(
      contacts: (json['contacts'] as List<dynamic>?)
              ?.map((contactJson) => Contactos.fromJson(contactJson))
              .toList() ??
          [],
    );
  }

  // Método toString()
  @override
  String toString() {
    return contacts
        .map((e) => e.toString())
        .join('\n'); //recorre la lista y la une mediante salto de lineas
  }

  // Método toJson()
  Map<String, dynamic> toJson() {
    return {
      if (contacts.isNotEmpty)
        "contacts": contacts.map((e) => e
            .toJson()) //Si no esta vacio se pone contacto y si lo esta // recorre la lista y le aplica  lafuncion json
    };
  }

  // Método copyWith()
  AgendaData copyWith({List<Contactos>? contacts}) {
    return AgendaData(
      contacts: contacts ??
          this
              .contacts
              .map((c) => c.copyWith())
              .toList(), //si no esta vacia la crea mediante los elementos que tenga de la lista
    );
  }
}
