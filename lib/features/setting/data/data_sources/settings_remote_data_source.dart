
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class SettingsRemoteDataSource {
  Future<void> deleteUserAccount();
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  SettingsRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> deleteUserAccount() async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final userId = user.uid;

    await firestore.collection('users').doc(userId).delete();

    await user.delete();
  }
}
