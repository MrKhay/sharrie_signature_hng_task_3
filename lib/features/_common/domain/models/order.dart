// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../features.dart';

@immutable

/// [Product] order details
class Order {
  /// unique id
  final String id;

  /// [Product]
  final Product product;

  /// quantity of product orderd
  final int quantity;

  /// time order was placed
  final DateTime time;
  const Order({
    required this.id,
    required this.product,
    required this.quantity,
    required this.time,
  });

  Order copyWith({
    String? id,
    Product? product,
    int? quantity,
    DateTime? orderTime,
  }) {
    return Order(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      time: orderTime ?? time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product': product.toMap(),
      'quantity': quantity,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, product: $product, quantity: $quantity, time: $time)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.product == product &&
        other.quantity == quantity &&
        other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^ product.hashCode ^ quantity.hashCode ^ time.hashCode;
  }
}
