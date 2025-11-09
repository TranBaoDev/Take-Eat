import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:take_eat/features/myOrder/presentation/widgets/order_status_selector.dart';
import 'package:take_eat/shared/data/model/cart/cart_item.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(CartItem item) async {
    try {
      final cartRef = _firestore
          .collection('users')
          .doc(item.userId)
          .collection('cart')
          .doc(item.id);

      final existing = await cartRef.get();

      if (existing.exists) {
        await cartRef.update({
          'quantity': item.quantity,
          'dateTime': item.dateTime.toIso8601String(),
        });
      } else {
        await cartRef.set(item.toJson());
      }
    } catch (e, stack) {
      debugPrint(stack.toString());
      rethrow;
    }
  }


  Future<void> removeFromCart(String userId, String itemId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(itemId)
        .delete();
  }

  Future<List<CartItem>> getCartByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      return snapshot.docs
          .map((doc) => CartItem.fromJson(doc.data()))
          .toList();
    } catch (e, stack) {
      debugPrint(stack.toString());
      rethrow;
    }
  }


  Future<void> clearCart(String userId) async {
    final ref = _firestore.collection('users').doc(userId).collection('cart');
    final snapshot = await ref.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
  Future<void> updateOrderStatus(String userId, String orderId, OrderStatus status) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .update({'orderStatus': status.name});
    } catch (e, stack) {
      debugPrint(stack.toString());
      rethrow;
    }
  }
}
