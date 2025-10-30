part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  AuthSuccess(this.user);
  final UserDto? user;

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

class AuthLoaded extends AuthState {
  AuthLoaded({
    required this.name,
    this.photoUrl,
    this.email,
    this.phone,
    this.birthDate,
  });

  final String name;
  final String? photoUrl;
  final String? email;
  final String? phone;
  final String? birthDate;

  @override
  List<Object?> get props => [name, photoUrl, email, phone, birthDate];

  AuthLoaded copyWith({
    String? name,
    String? photoUrl,
    String? email,
    String? phone,
    String? birthDate,
  }) {
    return AuthLoaded(
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
