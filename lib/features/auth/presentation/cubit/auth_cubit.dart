import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  AuthCubit() : super(AuthInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool isInitialize = false;

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      // 1. Trigger Google Sign-In
      //Todo fix google sign in api
      final googleUser = await _googleSignIn.;
      if (googleUser == null) {
        emit(AuthError("Sign in cancelled"));
        return;
      }

      // 2. Obtain auth details
      final googleAuth = await googleUser.authentication;

      // 3. Create credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      emit(AuthSuccess(userCredential.user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    emit(AuthInitial());
  }
}
