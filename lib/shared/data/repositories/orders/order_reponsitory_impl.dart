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
    final docRef = _orderCollection(order.userId).doc(order.id);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.update(order.toJson());
    } else {
      await docRef.set(order.toJson());
    }
  }


  @override
  Future<List<Order>> getOrders(String userId) async {
    final snapshot = await _orderCollection(userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList();
  }
  
  @override
  Future<void> deleteOrder(String userId) async {
    final query = await _orderCollection(userId)
      .orderBy('createdAt', descending: true)
      .limit(1)
      .get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.delete();
    }
  }
}
