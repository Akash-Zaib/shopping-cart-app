import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Current Firebase user (null if not signed in).
  User? get currentUser => _auth.currentUser;

  /// Stream that emits whenever the auth state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── Email / Password ─────────────────────────────────────────────

  /// Create a new account with email & password.
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Sign in with an existing email & password.
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ─── Google Sign-In ───────────────────────────────────────────────

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the native Google Sign-In flow.
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw AuthCancelledException('Google sign-in was cancelled by the user.');
    }

    // Obtain the auth details from the request.
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential.
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential.
    return await _auth.signInWithCredential(credential);
  }

  // ─── Anonymous / Guest ────────────────────────────────────────────

  Future<UserCredential> signInAsGuest() async {
    return await _auth.signInAnonymously();
  }

  // ─── Sign Out ─────────────────────────────────────────────────────

  Future<void> signOut() async {
    // Sign out from Google as well so the account picker shows next time.
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }
}

/// Thrown when the user cancels a sign-in flow (e.g. Google account picker).
class AuthCancelledException implements Exception {
  final String message;
  const AuthCancelledException(this.message);

  @override
  String toString() => 'AuthCancelledException: $message';
}
