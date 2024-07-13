// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../constants/constants.dart';

@immutable

/// Product details
class Product {
  /// unique id
  final String id;

  /// [Hero] tag
  final String heroTag;

  /// name of product
  final String name;

  /// product description
  final String description;

  /// category of product
  final List<String>? categories;

  /// product image url
  final List<String>? photos;

  /// price of product
  final double currentPrice;

  ///
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.heroTag,
    this.categories,
    this.photos,
    required this.currentPrice,
  });

  Product copyWith({
    String? id,
    String? name,
    String? heroTag,
    String? description,
    List<String>? categories,
    List<String>? photos,
    double? currentPrice,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      heroTag: heroTag ?? this.heroTag,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      photos: photos ?? this.photos,
      currentPrice: currentPrice ?? this.currentPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'heroTag': heroTag,
      'description': description,
      'categories': categories,
      'photos': photos,
      'currentPrice': currentPrice,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      heroTag: "${Random().nextInt(1000)} Tag",
      description: map['description'] as String,
      categories: (map['categories'] as List<dynamic>).isNotEmpty
          ? List<dynamic>.from(map['categories'] as List<dynamic>)
              .map((dynamic category) => category['name'] as String)
              .toList()
          : null,
      photos: (map['photos'] as List<dynamic>).isNotEmpty
          ? List<dynamic>.from(map['photos'] as List<dynamic>)
              .map((dynamic category) =>
                  kTimuImageBaseUrl + category['url'].toString())
              .toList()
          : null,
      currentPrice: (map['current_price'] as List<dynamic>).isNotEmpty
          ? List<dynamic>.from(map['current_price'] as List<dynamic>)
              .map((dynamic prices) =>
                  (prices['NGN'] as List<dynamic>).first as double)
              .toList()
              .first
          : 0.00,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, categories: $categories, photos: $photos, currentPrice: $currentPrice)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        listEquals(other.categories, categories) &&
        listEquals(other.photos, photos) &&
        other.currentPrice == currentPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        categories.hashCode ^
        photos.hashCode ^
        currentPrice.hashCode;
  }
}
