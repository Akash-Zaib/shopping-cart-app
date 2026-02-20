class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final List<String> colors;
  final List<String> sizes;
  final bool isFeatured;
  final double discount; // percentage 0-100

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.colors = const [],
    this.sizes = const [],
    this.isFeatured = false,
    this.discount = 0,
  });

  double get discountedPrice => price * (1 - discount / 100);

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
    List<String>? colors,
    List<String>? sizes,
    bool? isFeatured,
    double? discount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      isFeatured: isFeatured ?? this.isFeatured,
      discount: discount ?? this.discount,
    );
  }
}
