import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:smart_grocery_tracker/services/auth_service.dart'
    show AuthService, GoogleSignInCancelledException;
import 'package:smart_grocery_tracker/services/firestore_service.dart';

/// Central auth state for the app: sign-in, sign-up, and profile updates.
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

  /// Listen to Firebase auth changes and start/stop periodic checks.
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

  // Periodically verify the auth session and sign out on non-network failures.
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
        final isNetworkIssue = errorString.contains('network') ||
            errorString.contains('unavailable') ||
            errorString.contains('timeout') ||
            errorString.contains('too-many-requests');

        if (!isNetworkIssue) {
          await signOut();
        }
      }
    });
  }

  void _stopAuthCheck() {
    _authCheckTimer?.cancel();
    _authCheckTimer = null;
  }


  /// Toggle the global auth loading flag and notify listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Store a user-facing error message and notify listeners.
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Clear any visible auth error.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Email/password sign-in used by the login form.
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.signInWithEmail(email, password);
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

  /// Email/password sign-up used by the registration form.
  Future<bool> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.signUpWithEmail(email, password, displayName);
      _user = _authService.currentUser;
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

  /// Google OAuth sign-in flow.
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.signInWithGoogle();
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

  /// Sign out the current user and clear analytics identity.
  Future<void> signOut() async {
    try {
      await _analytics.logEvent(name: 'logout');
      await _analytics.setUserId(id: null);
      await _authService.signOut();
    } catch (e) {
      _setError(_parseFirebaseError(e));
    }
  }

  /// Change the user's email in Firebase Auth and Firestore.
  Future<bool> updateEmail(String newEmail, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.updateEmail(newEmail, password);
      if (_user != null) {
        await _firestoreService.updateUserEmail(_user!.uid, newEmail);
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

  /// Trigger a password reset email for the given address.
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

  /// Change the user's password after re-authenticating.
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

  /// Update the user's display name used across the UI.
  Future<bool> updateDisplayName(String name) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.updateDisplayName(name);
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
