import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/features/myOrder/presentation/widgets/order_status_selector.dart';
import 'package:take_eat/shared/data/converters/order_status_converter.dart';
import 'package:take_eat/shared/data/converters/timestamp_converter.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
abstract class CartItem with _$CartItem {
  const CartItem._();
  const factory CartItem({
    required String id,
    required String name,
    required double price,
    required String image,
    required String userId,
    @TimestampConverter() required DateTime dateTime,
    @Default(1) int quantity,
    @OrderStatusConverter() @Default(OrderStatus.active) OrderStatus orderStatus,
  }) = _CartItem;

  double get total => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
