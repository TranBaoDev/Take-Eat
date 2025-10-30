import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:take_eat/shared/data/model/user/user_dto.dart';
import 'package:take_eat/shared/data/repositories/user_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool isInitialize = false;

  /// Sign in with Google using the google_sign_in package and Firebase Auth.
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      // 1. Initialize (once) and trigger Google Sign-In (authenticate)
      if (!isInitialize) {
        await _googleSignIn.initialize();
        isInitialize = true;
      }

      final googleUser = await _googleSignIn.authenticate();

      // 2. Obtain auth details (synchronous getter)
      final googleAuth = googleUser.authentication;

      // 3. Create credential for Firebase (idToken is available)
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // 4. Sign in Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      final firebaseUser = userCredential.user!;
      final userDto = UserDto(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName,
        email: firebaseUser.email,
        photoUrl: firebaseUser.photoURL,
      );

      // Save vào Firestore
      final userRepo = UserRepository();
      final existingUser = await userRepo.getUser(firebaseUser.uid);

      if (existingUser == null) {
        // 🆕 User mới → tạo mới
        await userRepo.saveUser(userDto);
      } else {
        // ✅ User đã có → chỉ cập nhật thông tin cơ bản
        await userRepo.updateUserProfile(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName,
          birthDate: existingUser.birthDate, // giữ nguyên nếu có
        );
      }

      emit(AuthSuccess(userDto));
    } catch (e) {
      emit(
        AuthError(
          userMessage: 'Login failed. Please try again.',
          devMessage: e.toString(),
        ),
      );
    }
  }

  /// Sign in with Apple (iOS/macOS). Web or Android flows need separate handling.
  Future<void> signInWithApple() async {
    emit(AuthLoading());
    try {
      if (kIsWeb ||
          !(defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)) {
        emit(
          AuthError(
            userMessage:
                'Sign in with Apple is only supported on iOS/macOS in this example.',
            devMessage: null,
          ),
        );
        return;
      }

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      final firebaseUser = userCredential.user!;

      final userDto = UserDto(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName ?? appleCredential.givenName,
        email: firebaseUser.email,
        photoUrl: firebaseUser.photoURL,
      );

      final userRepo = UserRepository();
      await userRepo.saveUser(userDto);

      emit(AuthSuccess(userDto));
    } catch (e) {
      emit(
        AuthError(
          userMessage: 'Login failed. Please try again.',
          devMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    try {
      await _auth.signOut();
    } catch (_) {}
    emit(AuthInitial());
  }

  Future<void> loadCurrentUser() async {
    emit(AuthLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      await user.reload();
      final refreshedUser = _auth.currentUser!;
      final userRepo = UserRepository();
      final userDto = await userRepo.getUser(refreshedUser.uid);

      if (userDto != null) {
        emit(
          AuthLoaded(
            name: userDto.name ?? refreshedUser.displayName ?? 'Unknown User',
            photoUrl: userDto.photoUrl ?? refreshedUser.photoURL,
            email: userDto.email ?? refreshedUser.email,
          ),
        );
      } else {
        emit(
          AuthLoaded(
            name: refreshedUser.displayName ?? 'Unknown User',
            photoUrl: refreshedUser.photoURL,
            email: refreshedUser.email,
          ),
        );
      }
    } catch (e) {
      emit(
        AuthError(
          devMessage: e.toString(),
          userMessage: "Failed to load profile",
        ),
      );
    }
  }

  /// Update the current user's profile fields (name, phone, birthDate).
  /// Keeps business logic inside the cubit and reloads the stored user after update.
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? birthDate,
  }) async {
    emit(AuthLoading());
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) throw Exception('User not logged in');

      final userRepo = UserRepository();
      await userRepo.updateUserProfile(
        uid: firebaseUser.uid,
        name: name,
        phone: phone,
        birthDate: birthDate,
      );

      // reload saved user data from repository
      final userDto = await userRepo.getUser(firebaseUser.uid);
      if (userDto != null) {
        emit(
          AuthLoaded(
            name: userDto.name ?? firebaseUser.displayName ?? 'Unknown User',
            photoUrl: userDto.photoUrl ?? firebaseUser.photoURL,
            email: userDto.email ?? firebaseUser.email,
            phone: userDto.phone,
            birthDate: userDto.birthDate,
          ),
        );
      } else {
        emit(
          AuthLoaded(
            name: firebaseUser.displayName ?? 'Unknown User',
            photoUrl: firebaseUser.photoURL,
            email: firebaseUser.email,
          ),
        );
      }
    } catch (e) {
      emit(
        AuthError(
          userMessage: 'Failed to update profile',
          devMessage: e.toString(),
        ),
      );
    }
  }
}
