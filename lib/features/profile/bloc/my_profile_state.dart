part of 'my_profile_bloc.dart';

sealed class MyProfileState extends Equatable {
  const MyProfileState();

  @override
  List<Object> get props => [];
}

final class MyProfileInitial extends MyProfileState {}

final class MyProfileLoading extends MyProfileState {}

final class MyProfileLoaded extends MyProfileState {
  // dd/MM/yyyy for display

  const MyProfileLoaded({
    required this.uid,
    required this.name,
    this.email,
    this.photoUrl,
    required this.phone,
    required this.birthRaw,
    required this.birthFormatted,
  });
  final String uid;
  final String name;
  final String? email;
  final String? photoUrl;
  final String phone;
  final String birthRaw; // raw stored value
  final String birthFormatted;

  @override
  List<Object> get props => [
    uid,
    name,
    email ?? '',
    photoUrl ?? '',
    phone,
    birthRaw,
    birthFormatted,
  ];
}

final class MyProfileUpdating extends MyProfileState {
  const MyProfileUpdating({
    required this.uid,
    required this.name,
    this.email,
    this.photoUrl,
    required this.phone,
    required this.birthRaw,
    required this.birthFormatted,
  });

  final String uid;
  final String name;
  final String? email;
  final String? photoUrl;
  final String phone;
  final String birthRaw;
  final String birthFormatted;

  @override
  List<Object> get props => [
    uid,
    name,
    email ?? '',
    photoUrl ?? '',
    phone,
    birthRaw,
    birthFormatted,
  ];
}

final class MyProfileUpdated extends MyProfileState {}

final class MyProfileError extends MyProfileState {
  const MyProfileError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
