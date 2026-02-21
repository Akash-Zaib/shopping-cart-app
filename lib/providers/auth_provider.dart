import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  /// The currently signed-in Firebase user (null = not signed in).
  User? get user => _user;

  /// Whether the user is signed in at all.
  bool get isSignedIn => _user != null;

  /// Whether the current user is an anonymous / guest user.
  bool get isGuest => _user?.isAnonymous ?? false;

  /// True while an auth operation is in progress.
  bool get isLoading => _isLoading;

  /// The last error message (null when there is no error).
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    // Seed with the current user (may be non-null on hot restart).
    _user = _authService.currentUser;

    // Listen for future auth state changes.
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // ── helpers ────────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _friendlyError(dynamic e) {
    if (e is AuthCancelledException) {
      return 'Sign-in was cancelled.';
    }
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'weak-password':
          return 'The password is too weak. Use at least 6 characters.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-not-found':
          return 'No account found with this email.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'invalid-credential':
          return 'Invalid email or password. Please try again.';
        default:
          return e.message ?? 'An unknown error occurred.';
      }
    }
    return e.toString();
  }

  // ── public methods ─────────────────────────────────────────────────

  Future<bool> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signUpWithEmail(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _friendlyError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signInWithEmail(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _friendlyError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signInWithGoogle();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _friendlyError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInAsGuest() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signInAsGuest();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _friendlyError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signOut();
    } catch (e) {
      _errorMessage = _friendlyError(e);
    }
    _setLoading(false);
  }
}
