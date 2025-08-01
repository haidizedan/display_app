class Product {
  final String id;
  final String name;
  final String? nameEn;
  final String categoryId;
  final String? imagePath;
  final String? videoPath;
  final double? price;
  final String? currency;
  final String? unit;
  final String? template;
  final String? description;

  Product({
    required this.id,
    required this.name,
    this.nameEn,
    required this.categoryId,
    this.imagePath,
    this.videoPath,
    this.price,
    this.currency,
    this.unit,
    this.template,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['nameEn'],
      categoryId: json['categoryId'] ?? '',
      imagePath: json['imagePath'],
      videoPath: json['videoPath'],
      price: json['price']?.toDouble(),
      currency: json['currency'],
      unit: json['unit'],
      template: json['template'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameEn': nameEn,
      'categoryId': categoryId,
      'imagePath': imagePath,
      'videoPath': videoPath,
      'price': price,
      'currency': currency,
      'unit': unit,
      'description': description,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? categoryId,
    String? imagePath,
    String? videoPath,
    double? price,
    String? currency,
    String? unit,
    String? template,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      categoryId: categoryId ?? this.categoryId,
      imagePath: imagePath ?? this.imagePath,
      videoPath: videoPath ?? this.videoPath,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      unit: unit ?? this.unit,
      template: template ?? this.template,
      description: description ?? this.description,
    );
  }
} 