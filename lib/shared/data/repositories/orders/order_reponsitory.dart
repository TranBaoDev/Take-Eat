import 'package:take_eat/shared/data/model/order/order.dart';

abstract class OrderRepository {
  Future<void> addOrder(Order order);
  Future<List<Order>> getOrders(String userId);
  Future<void> deleteOrder(String userId);
}
