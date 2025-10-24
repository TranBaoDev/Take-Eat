import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/shared/data/converters/timestamp_converter.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  @JsonSerializable(explicitToJson: true)
  const factory Order({
    required String id,
    required String userId,
    required String status,
    required List<OrderItem> items,
    required double total,
    @TimestampConverter() required DateTime createdAt, required String address,
  }) = _Order;

  const Order._();

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String name,
    required int quantity,
    required double price,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}
