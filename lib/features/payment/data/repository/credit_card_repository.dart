import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:take_eat/features/payment/data/model/credit_card_model.dart';

class CreditCardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCreditCard(String uid, UserCreditCardModel card) async {
    final col = _firestore
        .collection('users')
        .doc(uid)
        .collection('credit_cards');

    // Delete existing cards for this user first so only the new card remains.
    final snapshot = await col.get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    // Add the new card in the same batch to ensure atomic-ish behavior
    final newDoc = col.doc();
    batch.set(newDoc, card.toJson());

    await batch.commit();
  }

  Stream<List<UserCreditCardModel>> getUserCreditCards(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('credit_cards')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserCreditCardModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Future<void> deleteCreditCard(String uid, String cardId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('credit_cards')
        .doc(cardId)
        .delete();
  }
}
