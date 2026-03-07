import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_grocery_tracker/services/auth_service.dart'
    show AuthService, GoogleSignInCancelledException;
import 'package:smart_grocery_tracker/services/firestore_service.dart';

/// Provider managing authentication state.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Sign in with email/password.
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.signInWithEmail(email, password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(e.message ?? 'Authentication error');
      return false;
    } catch (e) {
      _setLoading(false);
      _setError(_parseFirebaseError(e));
      return false;
    }
  }

  /// Sign up with email/password.
  Future<bool> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.signUpWithEmail(email, password, displayName);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(e.message ?? 'Authentication error');
      return false;
    } catch (e) {
      _setLoading(false);
      _setError(_parseFirebaseError(e));
      return false;
    }
  }

  /// Sign in with Google.
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.signInWithGoogle();
      _setLoading(false);
      return true;
    } on GoogleSignInCancelledException {
      _setLoading(false);
      _setError('Google sign-in was cancelled.');
      return false;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(e.message ?? 'Authentication error');
      return false;
    } catch (e) {
      _setLoading(false);
      _setError(_parseFirebaseError(e));
      return false;
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      _setError(_parseFirebaseError(e));
    }
  }

  /// Update email.
  Future<bool> updateEmail(String newEmail, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.updateEmail(newEmail, password);
      
      // Update the user's email document stored in Firestore
      if (_user != null) {
        await _firestoreService.updateUserEmail(_user!.uid, newEmail);
        // Refresh the local user state
        _user = _authService.currentUser;
      }
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_parseFirebaseError(e));
      return false;
    }
  }

  /// Update password.
  Future<bool> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.updatePassword(currentPassword, newPassword);
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_parseFirebaseError(e));
      return false;
    }
  }

  /// Update display name.
  Future<bool> updateDisplayName(String name) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.updateDisplayName(name);
      // Reload user to get updated name
      _user = _authService.currentUser;
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_parseFirebaseError(e));
      return false;
    }
  }

  /// Parse Firebase errors into user-friendly messages.
  String _parseFirebaseError(dynamic e) {
    if (e is FirebaseAuthException) {
      return e.message ?? 'Authentication error';
    }
    final errorString = e.toString();
    if (errorString.contains('user-not-found')) {
      return 'No account found with this email.';
    } else if (errorString.contains('wrong-password')) {
      return 'Incorrect password.';
    } else if (errorString.contains('email-already-in-use')) {
      return 'An account already exists with this email.';
    } else if (errorString.contains('weak-password')) {
      return 'Password is too weak. Use at least 6 characters.';
    } else if (errorString.contains('invalid-email')) {
      return 'Invalid email address.';
    } else if (errorString.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    } else if (errorString.contains('network-request-failed')) {
      return 'Network error. Check your connection.';
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
