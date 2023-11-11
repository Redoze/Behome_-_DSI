import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() async {
    _auth.authStateChanges().listen((User? newUser) {
      user = newUser;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    user = _auth.currentUser;
    notifyListeners();
  }

  register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'A senha fornecida é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        throw 'A conta já existe para este e-mail.';
      }
    }
  }

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Nenhum usuário encontrado para este e-mail.';
      } else if (e.code == 'wrong-password') {
        throw 'Usuário ou senha inválidos.';
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}
