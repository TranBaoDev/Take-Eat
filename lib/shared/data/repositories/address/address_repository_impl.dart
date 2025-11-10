import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:take_eat/shared/data/model/address/address.dart';
import 'package:take_eat/shared/data/repositories/address/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> _addressCollection(String userId) {
    return firestore.collection('users').doc(userId).collection('addresses');
  }

  @override
  Future<void> addAddress(Address address) async {
    await _addressCollection(
      address.userId,
    ).doc(address.id).set(address.toJson());
  }

  @override
  Future<Address?> getLatestAddress(String userId) async {
    final snapshot = await _addressCollection(
      userId,
    ).orderBy('createdAt', descending: true).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    final data = snapshot.docs.first.data();
    data['id'] = snapshot.docs.first.id;
    // Ensure boolean fields have sensible defaults to avoid null casts
    if (data['isSelected'] is! bool) {
      data['isSelected'] = false;
    }
    return Address.fromJson(data);
  }

  @override
  Future<List<Address>> getAllAddresses(String userId) async {
    final snapshot = await _addressCollection(
      userId,
    ).orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      // Ensure boolean fields have sensible defaults to avoid null casts
      if (data['isSelected'] is! bool) {
        data['isSelected'] = false;
      }
      return Address.fromJson(data);
    }).toList();
  }
}
