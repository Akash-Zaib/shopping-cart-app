import 'dart:math';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  int get orderCount => _orders.length;

  Order placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
  }) {
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999).toString().padLeft(3, '0')}',
      items: List.from(items.map((item) => item.copyWith())),
      totalAmount: totalAmount,
      orderDate: DateTime.now(),
      status: OrderStatus.placed,
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, order);
    notifyListeners();
    return order;
  }
}
