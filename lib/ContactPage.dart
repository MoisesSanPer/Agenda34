// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practica32agendasanchezmoises/ContactDetailPage.dart';
import 'package:practica32agendasanchezmoises/data/AgendData.class.dart';
import 'package:practica32agendasanchezmoises/data/ContactData.class.dart';
import 'package:practica32agendasanchezmoises/events_hub.dart';
import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool isAscending = true;
 @override
  void initState() {
    super.initState();
    
    final agendaData = Provider.of<AgendaData>(context, listen: false);
    agendaData.load();  
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(221, 24, 24, 23),
        appBar: _appbar,
        body: _body,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final eventsHub = Provider.of<EventsHub>(context, listen: false);

            eventsHub.onCreateContact(context);
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: _tabBar,
      ),
    );
  }

  AppBar get _appbar => AppBar(
        backgroundColor: const Color.fromARGB(221, 24, 24, 23),
        title: const Text("Agenda", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(isAscending
                ? FontAwesomeIcons.arrowUpAZ
                : FontAwesomeIcons.arrowDownZA),
            onPressed: () {
              setState(() 
              {
                isAscending = !isAscending;
              final eventsHub =
                          Provider.of<EventsHub>(context, listen: false);
                      eventsHub.onSort(context,context.read<AgendaData>().publicContactos);              
                      });
            },
          ),
          IconButton(icon: Icon(FontAwesomeIcons.filter), onPressed: onFiltrar),
        ],
      );

  void onFiltrar() {}

  TabBar get _tabBar => TabBar(
        tabs: [
          Tab(text: "Contactos", icon: Icon(Icons.contacts_sharp)),
          Tab(text: "Favoritos", icon: Icon(Icons.star)),
        ],
      );

  Widget get _body => TabBarView(
        children: [
          _buildContactList(),
          _buildContactFavouriteList(),
        ],
      );

  Widget _buildContactList() {
    return Consumer<AgendaData>(
      builder: (context, agendaData, child) {
        final contacts = agendaData.publicContactos;
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final iconData =
                agenda_data.getIconoPorEtiqueta(contacts[index].labels);
            return ListTile(
              onTap: () => verContacto(context, contacts[index]),
              leading: Icon(iconData),
              title: Row(
                children: [
                  Text(
                    '${contacts[index].name ?? 'Sin nombre'} ${contacts[index].surname ?? 'Sin apellido'}',
                    style: TextStyle(color: Colors.white),
                  ),
                  if (contacts[index].isFavorite)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.star,
                      ),
                    ),
                ],
              ),
              subtitle: Text(
                '${contacts[index].email ?? "Sin email"}, ${contacts[index].phone ?? "Sin telefono"}',
                style: TextStyle(color: Colors.white),
              ),
              trailing: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: "ver",
                    child: Text('Ver'),
                  ),
                  PopupMenuItem(value: "editar", child: Text('Editar')),
                  PopupMenuItem(value: "eliminar",child: Text('Eliminar'),),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'ver':
                      verContacto(context, contacts[index]);
                      break;
                    case 'editar':
                      final eventsHub =
                          Provider.of<EventsHub>(context, listen: false);
                      eventsHub.onEditContact(context, contacts[index]);
                      break;
                      case 'eliminar':
                      final eventsHub =
                          Provider.of<EventsHub>(context, listen: false);
                      eventsHub.onDeleteContact(context, contacts[index]);
                      break;
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContactFavouriteList() {
    return Consumer<AgendaData>(
      builder: (context, agendaData, child) {
        final favoriteContacts = agendaData.publicContactos
            .where((contact) => contact.isFavorite)
            .toList();
        return ListView.builder(
          itemCount: favoriteContacts.length,
          itemBuilder: (context, index) {
            final contact = favoriteContacts[index];
            final iconData = agenda_data.getIconoPorEtiqueta(contact.labels);
            return ListTile(
              onTap: () => verContacto(context, contact),
              leading: Icon(iconData),
              title: Row(
                children: [
                  Text(
                    '${contact.name ?? 'Sin nombre'} ${contact.surname ?? 'Sin apellido'}',
                    style: TextStyle(color: Colors.white),
                  ),
                  if (favoriteContacts[index].isFavorite)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.star,
                      ),
                    ),
                ],
              ),
              subtitle: Text(
                '${contact.email ?? "Sin email"}, ${contact.phone ?? "Sin telefono"}',
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                onPressed: () => verContacto(context, contact),
                icon: Icon(Icons.more_vert),
              ),
            );
          },
        );
      },
    );
  }

  static verContacto(BuildContext context, Contactos contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailPage(contact: contact),
      ),
    );
  }

  void onOrdenar(List<Contactos> contacts) {
    if (isAscending) {
      contacts.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    } else {
      contacts.sort((a, b) => (b.name ?? '').compareTo(a.name ?? ''));
    }
    isAscending = !isAscending;
  }
}
