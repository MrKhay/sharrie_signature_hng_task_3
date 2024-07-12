import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../features.dart';

part 'orders_data_notifier.g.dart';

/// Manages [Product]
@Riverpod(keepAlive: true)
class OrdersDataNotifier extends _$OrdersDataNotifier {
  @override
  Future<List<Order>?> build() async {
    return <Order>[];
  }

  /// add new order
  void addNewOrder(Order order) {
    List<Order> orders = state.value ?? <Order>[];

    // when product already exits
    if (orders.any((Order o) => o.product.id == order.product.id)) {
      orders = orders.map((Order o) {
        // update list
        if (o.product.id == order.product.id) {
          return o.copyWith(quantity: order.quantity + o.quantity);
        }
        return o;
      }).toList();

      state = AsyncValue<List<Order>>.data(<Order>[...orders]);
      return;
    }

    // update state
    state = AsyncValue<List<Order>>.data(<Order>[order, ...orders]);
  }

  /// remove  order
  void removeNewOrder(Order order) {
    List<Order> orders = state.value ?? <Order>[];
    orders = orders.where((Order o) => o != order).toList();

    // update state
    state = AsyncValue<List<Order>>.data(<Order>[...orders]);
  }

  /// modify order quantity
  void modifyOrderQuantity(int quantity, String id) {
    List<Order> orders = state.value ?? <Order>[];

    // update order
    orders = orders.map((Order order) {
      if (order.id == id) {
        return Order(
          id: id,
          product: order.product,
          quantity: quantity,
          time: order.time,
        );
      }
      return order;
    }).toList();

    // update state
    state = AsyncValue<List<Order>>.data(orders);
  }

  /// clear orders
  void clearOrders() {
    // update state
    state = const AsyncValue<List<Order>>.data(<Order>[]);
  }
}
