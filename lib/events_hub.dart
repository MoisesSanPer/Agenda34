// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:practica32agendasanchezmoises/ContactFormPage.dart';
import 'package:practica32agendasanchezmoises/data/AgendData.class.dart';
import 'package:practica32agendasanchezmoises/data/ContactData.class.dart';
import 'package:provider/provider.dart';

class EventsHub {
  bool isAscending = true;
  Future<void> onEditContact(BuildContext context, Contactos contact,
      {bool isNew = false}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContactFormPage(contact: contact)),
    );
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isNew
                ? 'Contacto creado con éxito'
                : 'Contacto editado con éxito')),
      );
    } else if (result == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error al guardar los cambios')),
      );
    }
  }

  void onCreateContact(BuildContext context) {
    final agendaData = Provider.of<AgendaData>(context, listen: false);
    final newId = agendaData.generateUniqueId();
    print('Generando ID: $newId');
    final newContact = Contactos(
      id: newId,
      name: "",
      surname: "",
      email: "",
      phone: "",
      labels: [],
      isFavorite: false,
    );

    final eventsHub = Provider.of<EventsHub>(context, listen: false);
    eventsHub.onEditContact(context, newContact, isNew: true);
    agendaData.save();
  }

  void onDeleteContact(BuildContext context, Contactos contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content:
              Text('¿Realmente deseas borrar el contacto ${contact.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final agendaData =
                    Provider.of<AgendaData>(context, listen: false);
                agendaData.removeContact(contact.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Contacto eliminado')),
                );
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
    final agendaData = Provider.of<AgendaData>(context, listen: false);
    agendaData.save();
  }

  void onEditLabels(BuildContext context, List<String> labels,
      {bool saveChanges = false}) {
    TextEditingController controller =
        TextEditingController(text: labels.join(', '));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Etiquetas'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Etiquetas (separadas por coma)',
            ),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (saveChanges) {
                  // Si se deben guardar los cambios, actualizamos las etiquetas
                  labels.clear();
                  labels.addAll(controller.text
                      .split(',')
                      .map((label) => label.trim())
                      .toList());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Etiquetas actualizadas')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
    final agendaData = Provider.of<AgendaData>(context, listen: false);
    agendaData.save();
  }

  void onSort(BuildContext context, List<Contactos> contactos) {
    isAscending = !isAscending;
    contactos.sort((a, b) {
      int compare = a.name!.compareTo(b.name!);
      return isAscending ? compare : -compare;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(isAscending ? 'Orden Ascendente' : 'Orden Descendente')),
    );
    final agendaData = Provider.of<AgendaData>(context, listen: false);
    agendaData.save();
  }
}
