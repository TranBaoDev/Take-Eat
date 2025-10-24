import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:take_eat/shared/data/model/address/address.dart';
import 'package:take_eat/shared/data/repositories/address/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final FirebaseFirestore firestore;

  AddressRepositoryImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _addressCollection(String userId) {
    return firestore.collection('users').doc(userId).collection('addresses');
  }

  @override
  Future<void> addAddress(Address address) async {
    await _addressCollection(address.userId)
        .doc(address.id)
        .set(address.toJson());
  }

  @override
  Future<Address?> getLatestAddress(String userId) async {
    final snapshot = await _addressCollection(userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Address.fromJson(snapshot.docs.first.data());
  }
}
