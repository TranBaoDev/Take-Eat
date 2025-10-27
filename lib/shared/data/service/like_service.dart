import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LikeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Set or remove a like for a product under the user's document.
  ///
  /// We store likes as a subcollection `users/{userId}/likes/{productId}`.
  /// - if [liked] == true -> create or update the doc
  /// - if [liked] == false -> delete the doc
  Future<void> setLike(String userId, String productId, bool liked) {
    final docRef = _db.collection('users').doc(userId).collection('likes').doc(productId);
    if (liked) {
      return docRef.set({
        'productId': productId,
        'liked': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      return docRef.delete();
    }
  }

  /// Returns a list of productIds the user has liked
  Future<List<String>> getLikedProductIds(String userId) async {
    final snapshot = await _db.collection('users').doc(userId).collection('likes').get();
    return snapshot.docs.map((d) => d.id).toList();
  }

  /// Returns whether the product is liked by the user
  Future<bool> isProductLiked(String userId, String productId) async {
    final doc = await _db.collection('users').doc(userId).collection('likes').doc(productId).get();
    // If the doc exists and the 'liked' field is true -> liked.
    // Use explicit comparison to avoid dynamic type issues.
    final data = doc.data();
    final likedField = data != null ? data['liked'] : null;
    return doc.exists && (likedField == true);
  }
}
