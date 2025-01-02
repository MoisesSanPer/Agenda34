// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, annotate_overrides, camel_case_types, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:practica32agendasanchezmoises/data/AgendData.class.dart';
import 'package:practica32agendasanchezmoises/data/ContactData.class.dart';
import 'package:intl/intl.dart';
import 'package:practica32agendasanchezmoises/events_hub.dart';
import 'package:provider/provider.dart';

class ContactDetailPage extends StatefulWidget {
  final Contactos contact;
  const ContactDetailPage({super.key, required this.contact});

  @override
  State<ContactDetailPage> createState() => agenda_data();
}

class agenda_data extends State<ContactDetailPage> {
  bool isFavorite = false;
  Icon iconolabel = Icon(
    Icons.question_mark,
    size: 50,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromARGB(221, 24, 24, 23),
        appBar: _appbar,
        body: SingleChildScrollView(
          child: _body(widget.contact, context),
        ),
      ),
    );
  }

  AppBar get _appbar => AppBar(
        backgroundColor: Color.fromARGB(221, 24, 24, 23),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: onFavorito,
              icon: Icon(isFavorite ? Icons.star : Icons.star_border)),
          IconButton(
              onPressed: () {
                final eventsHub =
                    Provider.of<EventsHub>(context, listen: false);
                eventsHub.onEditContact(context, widget.contact);
              },
              icon: Icon(Icons.edit)),
        ],
      );

  void onFavorito() {
    setState(() {
      isFavorite = !isFavorite;
      widget.contact.isFavorite = isFavorite;
    });
  }

  void onlapiz() {}

  Widget _body(Contactos contacto, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(13),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: iconolabel,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (contacto.name != null && contacto.surname != null)
                    ? "${contacto.name} ${contacto.surname}"
                    : "",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Divider(color: Colors.white),
            TextButton(
              onPressed: () => onEmailPress(context, contacto),
              child: ListTile(
                title: Text(
                  "Correo electrónico",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  contacto.email ?? "",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                trailing: Icon(
                  Icons.email,
                  size: 30,
                ),
              ),
            ),
            Divider(color: Colors.white),
            TextButton(
              onPressed: () => onBotonTelefono(context, contacto),
              child: ListTile(
                title: Text(
                  "Teléfono",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  contacto.phone ?? "",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                trailing: Icon(
                  Icons.phone,
                  size: 30,
                ),
              ),
            ),
            Divider(color: Colors.white),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "Nacimiento",
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          (contacto.birthdate != null)
                              ? DateFormat('MM dd, yyyy')
                                  .format(contacto.birthdate!)
                              : "Fecha no disponible",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Edad",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        (contacto.birthdate != null)
                            ? (DateTime.now().year - contacto.birthdate!.year)
                                .toString()
                            : "Edad no disponible",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.white),
            TextButton(
              onPressed: () => onBotonEtiqueta(context, contacto),
              child: ListTile(
                title: Text(
                  "Etiqueta",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  (contacto.labels.isNotEmpty)
                      ? contacto.labels[0]
                      : " No hay nada en la lista",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Divider(color: Colors.white),
            Text(
              "Agregado el ${contacto.birthdate != null ? DateFormat('yyyy-MM-dd').format(contacto.birthdate!) : 'Fecha no disponible'}",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Modificado el ${contacto.creation != null ? DateFormat('yyyy-MM-dd').format(contacto.creation!) : 'Fecha no disponible'}",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void onEmailPress(BuildContext context, Contactos contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Enviando email a ${contact.email}"),
      ),
    );
  }

  void onBotonTelefono(BuildContext context, Contactos contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Llamando a ${contact.phone}"),
      ),
    );
  }

 void onBotonEtiqueta(BuildContext context, Contactos contacto) {
  TextEditingController controller = TextEditingController(
    text: contacto.labels
        .map((label) => label[0].toUpperCase() + label.substring(1).toLowerCase())
        .join(', '),
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Ingresa la etiqueta',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Obtener las etiquetas actualizadas
                  List<String> labels = controller.text
                      .split(',')
                      .map((label) => label.trim().toLowerCase())
                      .toList();

                  setState(() {
                    contacto.labels = labels;
                    iconolabel = Icon(getIconoPorEtiqueta(labels),
                        color: Colors.black);
                  });

                  // Buscar el índice del contacto
                  final agendaData =
                      Provider.of<AgendaData>(context, listen: false);
                  int index = agendaData.publicContactos.indexWhere(
                      (c) => c.id == contacto.id);

                  if (index != -1) {
                    agendaData.updateContact(widget.contact, contacto, index);
                  }

                  Navigator.pop(context);
                },
                child: Text('Aplicar'),
              ),
            ],
          ),
        ),
      );
    },
  );
}



  static IconData getIconoPorEtiqueta(List<String> labels) {
    if (labels.isNotEmpty) {
      switch (labels[0].toLowerCase()) {
        case "trabajo":
          return Icons.business;
        case "amistad":
          return Icons.emoji_emotions;
        case "gym":
          return Icons.fitness_center;
        case "familia":
          return Icons.family_restroom;
        default:
          return Icons.question_mark;
      }
    }
    return Icons.question_mark;
  }
}
