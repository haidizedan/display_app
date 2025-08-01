import 'package:flutter/material.dart';

class Category {
  final String id;
  final String nameAr;
  final String nameEn;
  final int iconCodePoint; // Flutter icon code
  final String? imagePath; // optional custom image
  final int order;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.iconCodePoint,
    this.imagePath,
    this.order = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      iconCodePoint: json['iconCodePoint'] ?? Icons.category.codePoint,
      imagePath: json['imagePath'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'iconCodePoint': iconCodePoint,
      'imagePath': imagePath,
      'order': order,
    };
  }

  Category copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    int? iconCodePoint,
    String? imagePath,
    int? order,
  }) {
    return Category(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      imagePath: imagePath ?? this.imagePath,
      order: order ?? this.order,
    );
  }
} 