import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  
  AuthProvider() {
    // Escuchar cambios en el estado de autenticación
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }
  
  // Método para iniciar sesión con email y contraseña
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      _isLoading = false;
      notifyListeners();
      _logger.i('Usuario autenticado: ${_user?.email}');
      return true;
      
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      _logger.e('Error de autenticación: ${e.code}');
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error desconocido. Intenta nuevamente.';
      notifyListeners();
      _logger.e('Error desconocido: $e');
      return false;
    }
  }
  
  // Método para registrarse con email y contraseña
  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      _isLoading = false;
      notifyListeners();
      _logger.i('Usuario registrado: ${_user?.email}');
      return true;
      
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      _logger.e('Error de registro: ${e.code}');
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error desconocido. Intenta nuevamente.';
      notifyListeners();
      _logger.e('Error desconocido: $e');
      return false;
    }
  }
  
  // Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
    _logger.i('Usuario cerró sesión');
  }
  
  // Método para resetear contraseña
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      await _auth.sendPasswordResetEmail(email: email.trim());
      
      _isLoading = false;
      notifyListeners();
      _logger.i('Email de recuperación enviado a: $email');
      return true;
      
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      _logger.e('Error al enviar email: ${e.code}');
      return false;
    }
  }
  
  // Traducir códigos de error de Firebase
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe una cuenta con este correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu internet.';
      default:
        return 'Error: $code';
    }
  }
  
  // Limpiar mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}