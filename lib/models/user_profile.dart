class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String address;
  final String city;
  final String country;
  final String zipCode;

  const UserProfile({
    this.name = 'Alex Johnson',
    this.email = 'alex.johnson@email.com',
    this.phone = '+1 (555) 123-4567',
    this.avatarUrl = 'https://i.pravatar.cc/300?img=11',
    this.address = '123 Flutter Lane',
    this.city = 'San Francisco',
    this.country = 'United States',
    this.zipCode = '94102',
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? address,
    String? city,
    String? country,
    String? zipCode,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
    );
  }
}
