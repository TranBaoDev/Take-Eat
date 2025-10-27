import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:take_eat/shared/data/model/user/user_dto.dart';

class UserRepository {
  final CollectionReference<UserDto> _usersCollection;

  UserRepository()
    : _usersCollection = FirebaseFirestore.instance
          .collection('users')
          .withConverter<UserDto>(
            // ✅ Type-safe converter
            fromFirestore: (snapshot, _) {
              final data = snapshot.data()!;
              return UserDto.fromJson(data); // ✅ Deserialize từ Map
            },
            toFirestore: (userDto, _) =>
                userDto.toJson(), // ✅ Serialize thành Map
          );

  Future<void> saveUser(UserDto userDto) async {
    try {
      await _usersCollection.doc(userDto.uid).set(userDto);
      print('User saved successfully');
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  Future<UserDto?> getUser(String uid) async {
    try {
      final docSnapshot = await _usersCollection.doc(uid).get();
      return docSnapshot.data();
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> updateUserInfo(
    String uid, {
    String? name,
    String? phone,
    String? birthDate,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (birthDate != null) updates['birthDate'] = birthDate;

      if (updates.isNotEmpty) {
        await _usersCollection.doc(uid).update(updates);
        print('User info updated successfully');
      }
    } catch (e) {
      print('Error updating user info: $e');
    }
  }
}
