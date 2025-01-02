// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practica32agendasanchezmoises/data/AgendData.class.dart';
import 'package:practica32agendasanchezmoises/data/ContactData.class.dart';
import 'package:provider/provider.dart';

class ContactFormPage extends StatefulWidget {
  final Contactos contact;
  const ContactFormPage({super.key, required this.contact});

  @override
  State<ContactFormPage> createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controladores de los campos de texto
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _birthdateController;

  //Lo que es e contacti al principio
  late Contactos initialContact;
  //Para saber si el boton tiene que guardar o no
  bool isSaveButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    initialContact = Contactos(
      id: widget.contact.id,
      name: widget.contact.name,
      surname: widget.contact.surname,
      phone: widget.contact.phone,
      email: widget.contact.email,
      birthdate: widget.contact.birthdate,
    );

    // Inicializar los controladores con los valores del contacto
    _nameController = TextEditingController(text: widget.contact.name);
    _surnameController = TextEditingController(text: widget.contact.surname);
    _phoneController = TextEditingController(text: widget.contact.phone);
    _emailController = TextEditingController(text: widget.contact.email);

    _birthdateController = TextEditingController(
      text: widget.contact.birthdate != null
          ? DateFormat('MM dd, yyyy').format(widget.contact.birthdate!)
          : '',
    );

    _nameController.addListener(onDataChange);
    _surnameController.addListener(onDataChange);
    _phoneController.addListener(onDataChange);
    _emailController.addListener(onDataChange);
    _birthdateController.addListener(onDataChange);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  void onDataChange() {
    widget.contact.name = _nameController.text;
    widget.contact.surname = _surnameController.text;
    widget.contact.phone = _phoneController.text;
    widget.contact.email = _emailController.text;

    bool hasChanged = widget.contact.name != initialContact.name ||
        widget.contact.surname != initialContact.surname ||
        widget.contact.phone != initialContact.phone ||
        widget.contact.email != initialContact.email ||
        widget.contact.birthdate != initialContact.birthdate;

    setState(() {
      isSaveButtonEnabled = hasChanged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(221, 24, 24, 23),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(221, 24, 24, 23),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.contact.id == 0 ? 'Nuevo contacto' : "Edicion de contacto",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: isSaveButtonEnabled ? onSubmitForm : null,
              icon: Icon(Icons.check),
              color: Colors.white,
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: 'Nombre',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Nombre',
                        hintStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white)),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _surnameController,
                    decoration: InputDecoration(
                        labelText: 'Apellidos',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Apellidos',
                        hintStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white)),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                        labelText: 'Telefono',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Telefono',
                        hintStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white)),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),
                  validator: validarEmail,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _birthdateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha De Nacimiento',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  readOnly: true,
                  onTap: _selectDate,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // Actualiza los datos del contacto con los valores actuales del formulario.
    widget.contact.name = _nameController.text;
    widget.contact.surname = _surnameController.text;
    widget.contact.phone = _phoneController.text;
    widget.contact.email = _emailController.text;
    if (_birthdateController.text.isNotEmpty) {
      widget.contact.birthdate =
          DateFormat('MM dd, yyyy').parse(_birthdateController.text);
    }

    // Comprueba si algún dato ha cambiado comparando con `initialContact`.
    bool hasChanged = widget.contact.name != initialContact.name ||
        widget.contact.surname != initialContact.surname ||
        widget.contact.phone != initialContact.phone ||
        widget.contact.email != initialContact.email ||
        widget.contact.birthdate != initialContact.birthdate;

    if (hasChanged) {
      // Mostrar un AlertDialog simple de confirmación si hay cambios
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Salir sin guardar'),
              content: Text(
                  'Tienes cambios sin guardar. ¿Deseas salir sin guardar?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Sí'),
                ),
              ],
            ),
          ) ??
          false;
    } else {
      return true;
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.contact.birthdate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('MM dd, yyyy').format(pickedDate);
      setState(() {
        _birthdateController.text = formattedDate;
      });
      widget.contact.birthdate = pickedDate;
      onDataChange();
    }
  }

void onSubmitForm() {
  if (_formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Esta correcto')),
    );

    // Actualiza los valores del contacto con los valores del formulario
    widget.contact.name = _nameController.text;
    widget.contact.surname = _surnameController.text;
    widget.contact.email = _emailController.text;
    widget.contact.phone = _phoneController.text;
    widget.contact.birthdate =
        DateFormat('MM dd, yyyy').parse(_birthdateController.text);

    final agendaData = Provider.of<AgendaData>(context, listen: false);
    agendaData.addContact(widget.contact);

    // Volver a la pantalla anterior después de agregar el contacto
    Navigator.of(context).pop(true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Validación no superada.')),
    );
  }
}

  String? validarEmail(value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, introduce un correo electrónico';
    }

    // Definir la expresión regular para un correo electrónico válido
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Por favor introduce un correo electrónico válido';
    }

    return null;
  }
}
