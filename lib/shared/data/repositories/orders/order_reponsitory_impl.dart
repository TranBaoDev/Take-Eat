import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:take_eat/shared/data/model/order/order.dart';
import 'package:take_eat/core/di/get_in.dart';
import 'package:take_eat/features/notification/bloc/notifi_bloc.dart';
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
      final previous = doc.data();
      final previousStatus = previous != null
          ? (previous['status'] as String?)
          : null;
      await docRef.update(order.toJson());

      if (previousStatus != null && previousStatus != order.status) {
        // Dispatch notification for status change
        try {
          getIt<NotifiBloc>().add(
            NotifiEvent.orderStatusChanged(
              order.id,
              order.userId,
              order.status,
            ),
          );
        } catch (_) {
          // ignore if NotifiBloc not registered or dispatch fails
        }
      }
    } else {
      await docRef.set(order.toJson());
    }
  }

  @override
  Future<List<Order>> getOrders(String userId) async {
    final snapshot = await _orderCollection(
      userId,
    ).orderBy('createdAt', descending: true).get();

    return snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList();
  }

  @override
  Future<void> deleteOrder(String userId) async {
    final query = await _orderCollection(
      userId,
    ).orderBy('createdAt', descending: true).limit(1).get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.delete();
    }
  }
}
