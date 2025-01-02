// ignore_for_file: prefer_const_constructors


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:practica32agendasanchezmoises/services/auth_service.dart';
import 'package:provider/provider.dart';

class EventsHubSrv {
  Future<UserCredential> onLogin(
      BuildContext context, String email, String password) async {
    print("Iniciando sesión: $email $password");
    AuthSrv auth = Provider.of<AuthSrv>(context, listen: false);
    return auth.iniciarSesion(email, password);
  }

  Future<UserCredential> onCreateAccount(
      BuildContext context, String email, String password) async {
    print("Creando cuenta: $email $password");
    AuthSrv auth = Provider.of<AuthSrv>(context, listen: false);
    return auth.crearCuenta(email, password);
  }
}
