import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

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

        
          
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha fornecida é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('A conta já existe para este e-mail.');
      }

      throw AuthException("Error Desconhecido");
    }
  }

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

  // Clear Navigation History
  

      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Usuário ou senha inválidos.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Usuário ou senha inválidos.');
      } else if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        throw AuthException("Usuário ou senha inválidos.");
      }

      throw AuthException("Error Desconhecido");
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}
