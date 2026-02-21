import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserProvider with ChangeNotifier {
  UserProfile _profile = const UserProfile();

  UserProfile get profile => _profile;

  /// Populate the local profile from the signed-in Firebase [User].
  /// Call this right after sign-in or when the auth state changes.
  void setFromFirebaseUser(User? user) {
    if (user == null) {
      _profile = const UserProfile(); // reset to guest defaults
    } else {
      // Use displayName if available, otherwise extract name from email.
      String name = user.displayName ?? '';
      if (name.isEmpty && !user.isAnonymous) {
        final email = user.email ?? '';
        name = email.contains('@') ? email.split('@').first : email;
      }
      if (name.isEmpty) name = 'Guest User';

      _profile = UserProfile(
        uid: user.uid,
        name: name,
        email: user.email ?? '',
        phone: user.phoneNumber ?? '',
        avatarUrl: user.photoURL ?? '',
        isGuest: user.isAnonymous,
        // Keep address fields at their defaults; the user can edit later.
        address: _profile.address,
        city: _profile.city,
        country: _profile.country,
        zipCode: _profile.zipCode,
      );
    }
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? zipCode,
  }) {
    _profile = _profile.copyWith(
      name: name,
      email: email,
      phone: phone,
      address: address,
      city: city,
      country: country,
      zipCode: zipCode,
    );
    notifyListeners();
  }
}
