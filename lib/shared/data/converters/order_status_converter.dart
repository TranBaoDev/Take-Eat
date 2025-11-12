// shared/data/converters/order_status_converter.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/features/myOrder/presentation/widgets/order_status_selector.dart';

class OrderStatusConverter implements JsonConverter<OrderStatus, String> {
  const OrderStatusConverter();

  @override
  OrderStatus fromJson(String json) => OrderStatus.values.byName(json);

  @override
  String toJson(OrderStatus object) => object.name;
}