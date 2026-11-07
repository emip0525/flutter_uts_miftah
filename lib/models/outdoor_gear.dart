class OutdoorGear {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double pricePerDay;
  final double securityDeposit;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final String description;
  final Map<String, String> specifications;
  final List<String> features;
  final bool inStock;
  final int stockCount;

  OutdoorGear({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.pricePerDay,
    required this.securityDeposit,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.description,
    required this.specifications,
    required this.features,
    this.inStock = true,
    this.stockCount = 5,
  });

  factory OutdoorGear.fromJson(Map<String, dynamic> json) {
    return OutdoorGear(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? 'Alat Outdoor',
      brand: json['brand'] as String? ?? 'Generic',
      category: json['category'] as String? ?? 'Peralatan',
      pricePerDay: (json['price_per_day'] ?? json['pricePerDay'] ?? 0).toDouble(),
      securityDeposit: (json['security_deposit'] ?? json['securityDeposit'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 4.5).toDouble(),
      reviewsCount: (json['reviews_count'] ?? json['reviewsCount'] ?? 10).toInt(),
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      description: json['description'] as String? ?? '',
      specifications: (json['specifications'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
          ) ??
          {},
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      inStock: json['in_stock'] ?? json['inStock'] ?? true,
      stockCount: (json['stock_count'] ?? json['stockCount'] ?? 5).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'price_per_day': pricePerDay,
      'security_deposit': securityDeposit,
      'rating': rating,
      'reviews_count': reviewsCount,
      'image_url': imageUrl,
      'description': description,
      'specifications': specifications,
      'features': features,
      'in_stock': inStock,
      'stock_count': stockCount,
    };
  }

  OutdoorGear copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    double? pricePerDay,
    double? securityDeposit,
    double? rating,
    int? reviewsCount,
    String? imageUrl,
    String? description,
    Map<String, String>? specifications,
    List<String>? features,
    bool? inStock,
    int? stockCount,
  }) {
    return OutdoorGear(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      specifications: specifications ?? this.specifications,
      features: features ?? this.features,
      inStock: inStock ?? this.inStock,
      stockCount: stockCount ?? this.stockCount,
    );
  }
}
