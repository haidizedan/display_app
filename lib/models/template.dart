class Template {
  final String id;
  final String name;
  final String description;
  final String thumbnail;
  final String type; // video, image, price_tag
  final int maxProducts;
  final bool hasPriceTag;
  final bool isFullScreen;

  Template({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.type,
    this.maxProducts = 1,
    this.hasPriceTag = false,
    this.isFullScreen = false,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      type: json['type'] ?? '',
      maxProducts: json['maxProducts'] ?? 1,
      hasPriceTag: json['hasPriceTag'] ?? false,
      isFullScreen: json['isFullScreen'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnail': thumbnail,
      'type': type,
      'maxProducts': maxProducts,
      'hasPriceTag': hasPriceTag,
      'isFullScreen': isFullScreen,
    };
  }
} 