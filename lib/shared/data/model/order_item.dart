class OrderItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final DateTime dateTime;

  const OrderItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.dateTime,
  });

  double get total => price * quantity;

  OrderItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    DateTime? dateTime,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
