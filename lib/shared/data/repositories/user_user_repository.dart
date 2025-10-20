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

  // ✅ Save UserDto vào Firestore
  Future<void> saveUser(UserDto userDto) async {
    try {
      await _usersCollection.doc(userDto.uid).set(userDto);
      print('User saved successfully');
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  // ✅ Read UserDto từ Firestore
  Future<UserDto?> getUser(String uid) async {
    try {
      final docSnapshot = await _usersCollection.doc(uid).get();
      return docSnapshot.data(); // ✅ Trả về UserDto trực tiếp nhờ converter
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // ✅ Update một field (ví dụ: update name)
  Future<void> updateUserName(String uid, String newName) async {
    try {
      await _usersCollection.doc(uid).update({'name': newName});
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}
