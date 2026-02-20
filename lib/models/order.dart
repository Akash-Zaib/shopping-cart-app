import 'cart_item.dart';

enum OrderStatus { placed, confirmed, shipped, delivered }

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final OrderStatus status;
  final String paymentMethod;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.status = OrderStatus.placed,
    this.paymentMethod = 'Credit Card',
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
