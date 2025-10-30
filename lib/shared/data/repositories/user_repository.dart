import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:take_eat/shared/data/model/user/user_dto.dart';

class UserRepository {
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
  final CollectionReference<UserDto> _usersCollection;

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

  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phone,
    String? birthDate,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      // store using the json key expected by UserDto (birth_date)
      if (birthDate != null) updates['birth_date'] = birthDate;

      if (updates.isNotEmpty) {
        // Use untyped collection for partial updates to avoid converter casting issues
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(updates, SetOptions(merge: true));
        print('User profile updated successfully');
      }
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }
}
