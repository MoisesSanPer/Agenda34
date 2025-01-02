

  import 'package:firebase_auth/firebase_auth.dart';

class AuthSrv {
  User? get user => FirebaseAuth.instance.currentUser;

  Future<UserCredential> iniciarSesion(String email, String password) async {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> crearCuenta(String email, String password) async {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> desconectar() async {
    await FirebaseAuth.instance.signOut();
  }
}
