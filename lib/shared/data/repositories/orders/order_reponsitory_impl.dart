import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:take_eat/shared/data/model/order/order.dart';
import 'package:take_eat/shared/data/repositories/orders/order_reponsitory.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore firestore;

  OrderRepositoryImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _orderCollection(String userId) {
    return firestore.collection('users').doc(userId).collection('orders');
  }
  @override
  Future<void> addOrder(Order order) async {
    await _orderCollection(order.userId).doc(order.id).set(order.toJson());
  }

  @override
  Future<List<Order>> getOrders(String userId) async {
    final snapshot = await _orderCollection(userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList();
  }
}
