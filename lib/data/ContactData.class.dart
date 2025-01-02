// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

class Contactos extends ChangeNotifier {
  final int id;
  String? name, surname, email, phone;
  DateTime? birthdate;
  DateTime? creation, modification;
  bool isFavorite;
  List<String> labels;

  Contactos({
    required this.id,
    this.name,
    this.surname,
    this.email,
    this.phone,
    this.birthdate,
    DateTime? creation,
    DateTime? modification,
    this.isFavorite = false,
    List<String>? labels,
  })  : labels = labels ?? [],
        creation = creation ?? DateTime.now();

  factory Contactos.fromJson(Map<String, dynamic> json) {
  return Contactos(
    id: json['id'],
    name: json['name'],
    surname: json['surname'],
    email: json['email'],
    phone: json['phone'],
    birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
    creation: json['creation'] != null ? DateTime.parse(json['creation']) : null,
    isFavorite: json['isFavorite'] ?? false,
  );
}

  @override
  String toString() {
    return [
      "id: $id",
      if (name != null) "Name: $name",
      if (surname != null) "Surname: $surname",
      if (email != null) "Email: $email",
      if (phone != null) "Phone: $phone",
      if (birthdate != null) "Birthdate: $birthdate",
      if (creation != null) "Creation: $creation",
      if (modification != null) "modification: $modification",
      if (isFavorite) "Is favorite",
      if (labels.isEmpty) "labels: ${labels.join(", ")}",
    ]
        .map(
          (e) => "\te",
        )
        .join(",\n");
  }

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'name': name,
    'surname': surname,
    'email': email,
    'phone': phone,
    'birthdate': birthdate?.toIso8601String(),
    'creation': creation?.toIso8601String(),
    'isFavorite': isFavorite,
  };
}

  Contactos copyWith({
    int? id,
    String? name,
    String? surname,
    String? email,
    String? phone,
    DateTime? birthdate,
    DateTime? creation,
    DateTime? modification,
    bool? isFavorite,
    List<String>? labels,
  }) {
    return Contactos(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthdate: birthdate ?? this.birthdate,
      creation: creation ?? this.creation,
      modification: modification ?? this.modification,
      isFavorite: isFavorite ?? this.isFavorite,
      labels: labels ?? List.from(this.labels),
    );
  }

  void copyValuesFrom(Contactos other) {
    name = other.name ?? name;
    surname = other.surname ?? surname;
    email = other.email ?? email;
    phone = other.phone ?? phone;
    birthdate = other.birthdate ?? birthdate;
    creation = other.creation;
    modification = other.modification;
    isFavorite = other.isFavorite;
    labels = other.labels;
  }
}
