import 'order_item.dart';

class OrderSummary {
  final List<OrderItem> items;
  final double taxAndFees;
  final double deliveryFee;
  final String address;

  const OrderSummary({
    required this.items,
    required this.taxAndFees,
    required this.deliveryFee,
    this.address = "778 Locust View Drive Oaklanda, CA",
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal + taxAndFees + deliveryFee;

  OrderSummary copyWith({
    List<OrderItem>? items,
    double? taxAndFees,
    double? deliveryFee,
    String? address,
  }) {
    return OrderSummary(
      items: items ?? this.items,
      taxAndFees: taxAndFees ?? this.taxAndFees,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      address: address ?? this.address,
    );
  }
}
