// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practica32agendasanchezmoises/data/ContactData.class.dart';

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

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: onSubmitForm,
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
    );
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
    }
  }

  void onSubmitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Esta correcto')),
      );

      widget.contact.name = _nameController.text;
      widget.contact.surname = _surnameController.text;
      widget.contact.email = _emailController.text;
      widget.contact.phone = _phoneController.text;
      widget.contact.birthdate =
          DateFormat('MM dd, yyyy').parse(_birthdateController.text);

      Navigator.of(context).pop(true);
    }
    {
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
