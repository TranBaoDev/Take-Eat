part of 'my_profile_bloc.dart';

sealed class MyProfileEvent extends Equatable {
  const MyProfileEvent();

  @override
  List<Object> get props => [];
}

final class LoadMyProfile extends MyProfileEvent {}

final class BirthInputChanged extends MyProfileEvent {
  final String raw;
  const BirthInputChanged(this.raw);

  @override
  List<Object> get props => [raw];
}

final class UpdateProfileRequested extends MyProfileEvent {
  final String? name;
  final String? phone;
  final String? birthRaw; // raw from UI (may be dd/MM/yyyy)

  const UpdateProfileRequested({this.name, this.phone, this.birthRaw});

  @override
  List<Object> get props => [name ?? '', phone ?? '', birthRaw ?? ''];
}
