// ignore_for_file: unnecessary_this, use_build_context_synchronously, constant_identifier_names, avoid_print, unused_element

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:practica32agendasanchezmoises/data/ContactData.class.dart';
import 'package:practica32agendasanchezmoises/model/enumeraciones.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enumeración para el estado de la agenda
enum Status {
  Initial,
  Loading,
  Ready,
  Error,
}

// Clase AgendaData
class AgendaData extends ChangeNotifier {
  Status _status = Status.Initial;
  List<Contactos> contacts;

  AgendaData({List<Contactos>? contacts}) : contacts = contacts ?? [], _state = AgendaState.initial;

  // Getters
  Status get status => _status;
  List<Contactos> get publicContactos => contacts;

    AgendaState _state;
  AgendaState get state => _state;
 

  int generateUniqueId() {
  if (contacts.isEmpty) {
    return 1; // Si la lista está vacía, empieza desde 1
  }
  
  return contacts.map((contact) => contact.id).reduce((a, b) => a > b ? a : b) + 1;
}
  // Método para añadir un contacto
  void addContact(Contactos newContact) {
    print("Añadiendo contacto: ${newContact.name}");
    contacts.add(newContact);
    save();  
    _setStatus(Status.Ready);
    notifyListeners();
  }

  // Método para actualizar un contacto
  void updateContact(Contactos oldContact, Contactos newContact, int index) {
    contacts[index] = newContact;
    _setStatus(Status.Ready);
    save();  
    notifyListeners();  
  }

  // Método para eliminar un contacto
  void removeContact(int contactId) {
    contacts.removeWhere((contact) => contact.id == contactId);
    _setStatus(Status.Ready); 
    save(); 
    notifyListeners();  
  }

  // Cambio de estado
  void _setStatus(Status status) {
    _status = status;
    notifyListeners();
  }

  // Método para guardar la agenda en SharedPreferences
 Future<void> save() async {
 final prefs = await SharedPreferences.getInstance();
    String? jsonStrign = jsonEncode(toJson());
    await prefs.setString("agendaData", jsonStrign);
}


 Future<void> load() async {
 await Future.delayed(const Duration(seconds: 2));

    String? jsonString;
    final prefs = await SharedPreferences.getInstance();
    jsonString = prefs.getString("agendaData");

    if (jsonString != null) {
      _state = AgendaState.loaded;
      Map<String, dynamic> data = jsonDecode(jsonString);
      AgendaData agenda = AgendaData.fromJson(Map.from(data));
      contacts = List.from(agenda.contacts);
    } else {
      _state = AgendaState.initial;
    }
    notifyListeners();
    _state = AgendaState.ready;
 }
  // Método para convertir la clase AgendaData a JSON
  Map<String, dynamic> toJson() {
    return {
      'contacts': contacts.map((contact) => contact.toJson()).toList(),
    };
  }

  // Factory para crear AgendaData desde JSON
  factory AgendaData.fromJson(Map<String, dynamic> json) {
    return AgendaData(
      contacts: (json['contacts'] as List<dynamic>? ?? [])
          .map((contactJson) => Contactos.fromJson(contactJson))
          .toList(),
    );
  }
}


