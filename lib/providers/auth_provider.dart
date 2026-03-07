import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:smart_grocery_tracker/services/auth_service.dart'
    show AuthService, GoogleSignInCancelledException;
import 'package:smart_grocery_tracker/services/firestore_service.dart';

/// Provider managing authentication state.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  User? _user;
  bool _isLoading = false;
  String? _error;
  Timer? _authCheckTimer;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
      
      if (user != null) {
        _startAuthCheck();
      } else {
        _stopAuthCheck();
      }
    });
  }

  void _startAuthCheck() {
    _authCheckTimer?.cancel();
    _authCheckTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      try {
        final currentUser = _authService.currentUser;
        if (currentUser != null) {
          await currentUser.reload();
        } else {
          await signOut();
        }
      } catch (e) {
        final errorString = e.toString().toLowerCase();
        // Ignore network-related issues so we don't accidentally log out users trying to use the app in offline mode.
        if (errorString.contains('network') || 
            errorString.contains('unavailable') || 
            errorString.contains('timeout') ||
            errorString.contains('too-many-requests')) {
          return;
        }
        
        // If reload() fails for any other reason (e.g. user disabled, rejected, deleted, or token expired),
        // we forcefully log the user out to lock down the app's functionality immediately.
        await signOut();
      }
    });
  }

  void _stopAuthCheck() {
    _authCheckTimer?.cancel();
    _authCheckTimer = null;
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
      
      // Force an immediate token refresh to bust any stale auth caches
      // This ensures we get the most up-to-date state from Firebase's servers directly
      if (_authService.currentUser != null) {
        await _authService.currentUser!.getIdToken(true);
        await _analytics.setUserId(id: _authService.currentUser!.uid);
        await _analytics.logLogin(loginMethod: 'email');
      }
      
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
      
      if (_authService.currentUser != null) {
        await _analytics.setUserId(id: _authService.currentUser!.uid);
        await _analytics.logSignUp(signUpMethod: 'email');
      }
      
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
      
      // Force an immediate token refresh to bust any stale auth caches
      // This ensures we get the most up-to-date state from Firebase's servers directly
      if (_authService.currentUser != null) {
        await _authService.currentUser!.getIdToken(true);
        await _analytics.setUserId(id: _authService.currentUser!.uid);
        await _analytics.logLogin(loginMethod: 'google');
      }
      
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
      await _analytics.logEvent(name: 'logout');
      await _analytics.setUserId(id: null);
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

  /// Send password reset email.
  Future<bool> sendPasswordReset(String email) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.sendPasswordReset(email);
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
    String errorString = e.toString().toLowerCase();
    
    if (e is FirebaseAuthException) {
      errorString = '${e.code} ${e.message}'.toLowerCase();
    }

    if (errorString.contains('user-not-found') || errorString.contains('invalid-credential') || errorString.contains('wrong-password')) {
      return 'Incorrect email or password.';
    } else if (errorString.contains('user-disabled')) {
      return 'This account has been disabled by an administrator.';
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
    
    if (e is FirebaseAuthException && e.message != null) {
      return e.message!;
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
