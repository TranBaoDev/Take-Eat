import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

      emit(AuthSuccess(userCredential.user));
    } catch (e) {
      emit(
        AuthError(
          userMessage: 'Đăng nhập thất bại. Vui lòng thử lại.',
          devMessage: e.toString(),
        ),
      );
    }
  }

  /// Sign in with Apple (iOS/macOS). Web or Android flows need separate handling.
  Future<void> signInWithApple() async {
    emit(AuthLoading());
    try {
      // Only allow on Apple platforms for this simple example.
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

      // Request credential from Apple
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuth credential for Firebase
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      emit(AuthSuccess(userCredential.user));
    } catch (e) {
      emit(
        AuthError(
          userMessage: 'Đăng nhập thất bại. Vui lòng thử lại.',
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
}
