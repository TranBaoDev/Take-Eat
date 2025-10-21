import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
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
        final currentQty = existing.data()?['quantity'] ?? 1;
        await cartRef.update({'quantity': currentQty + 1});
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
}
