part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  AuthSuccess(this.user);
  final User? user;

  /// True when a user object is present
  bool get isAuthenticated => user != null;
}

class AuthError extends AuthState {
  /// userMessage: shown to end users (friendly)
  /// devMessage: internal/debug details (stacktrace, exception) shown only to devs (debug mode)
  AuthError({required this.userMessage, this.devMessage});

  final String userMessage;
  final String? devMessage;

  @override
  String toString() =>
      'AuthError(userMessage: $userMessage, devMessage: $devMessage)';
}

// default implementation on base state
extension AuthStateX on AuthState {
  bool get isAuthenticated => false;
}
