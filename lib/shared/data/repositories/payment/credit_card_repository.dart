import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:take_eat/shared/data/model/credit_card/credit_card_model.dart';

class CreditCardRepository {
  CreditCardRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  /// Collection: 'credit_cards'
  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('credit_cards');

  /// 🟢 Create or update a credit card
  Future<void> saveCard(CreditCardModel card) async {
    await _collection.doc(card.uid).set(card.toJson(), SetOptions(merge: true));
  }

  /// 🟡 Get a credit card by uid
  Future<CreditCardModel?> getCard(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (doc.exists) {
      return CreditCardModel.fromJson(doc.data()!);
    }
    return null;
  }

  /// 🔴 Delete a card
  Future<void> deleteCard(String uid) async {
    await _collection.doc(uid).delete();
  }

  /// 🔵 Get all cards (if needed for admin or list view)
  Stream<List<CreditCardModel>> getAllCards() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => CreditCardModel.fromJson(doc.data()))
          .toList(),
    );
  }
}
