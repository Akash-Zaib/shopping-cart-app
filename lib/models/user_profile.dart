class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String address;
  final String city;
  final String country;
  final String zipCode;
  final bool isGuest;

  const UserProfile({
    this.uid = '',
    this.name = 'Guest User',
    this.email = '',
    this.phone = '',
    this.avatarUrl = '',
    this.address = '',
    this.city = '',
    this.country = '',
    this.zipCode = '',
    this.isGuest = true,
  });

  UserProfile copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? address,
    String? city,
    String? country,
    String? zipCode,
    bool? isGuest,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}
