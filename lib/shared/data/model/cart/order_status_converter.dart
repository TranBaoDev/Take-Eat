import 'package:json_annotation/json_annotation.dart';
import 'package:take_eat/features/myOrder/presentation/widgets/order_status_selector.dart';

class OrderStatusConverter implements JsonConverter<OrderStatus, String> {
  const OrderStatusConverter();

  @override
  OrderStatus fromJson(String json) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == json,
      orElse: () => OrderStatus.active,
    );
  }

  @override
  String toJson(OrderStatus object) => object.name;
}
