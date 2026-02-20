import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserProvider with ChangeNotifier {
  UserProfile _profile = const UserProfile();

  UserProfile get profile => _profile;

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
