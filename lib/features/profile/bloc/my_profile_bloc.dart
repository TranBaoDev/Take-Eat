import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:take_eat/core/router/router.dart';

import 'package:take_eat/shared/data/repositories/user_repository.dart';
import 'package:intl/intl.dart';

part 'my_profile_event.dart';
part 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  MyProfileBloc({UserRepository? userRepository})
    : _userRepository = userRepository ?? UserRepository(),
      super(MyProfileInitial()) {
    on<LoadMyProfile>(_onLoadMyProfile);
    on<BirthInputChanged>(_onBirthInputChanged);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }
  final UserRepository _userRepository;

  Future<void> _onLoadMyProfile(
    LoadMyProfile event,
    Emitter<MyProfileState> emit,
  ) async {
    emit(MyProfileLoading());
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        emit(const MyProfileError('User not signed in'));
        return;
      }

      final uid = firebaseUser.uid;
      final userDto = await _userRepository.getUser(uid);

      final name = userDto?.name ?? firebaseUser.displayName ?? 'Unknown User';
      final email = userDto?.email ?? firebaseUser.email;
      final photo = userDto?.photoUrl ?? firebaseUser.photoURL;
      final phone = userDto?.phone ?? '';
      final birthRaw = userDto?.birthDate ?? '';

      final birthFormatted = _formatToDisplay(birthRaw);

      emit(
        MyProfileLoaded(
          uid: uid,
          name: name,
          email: email,
          photoUrl: photo,
          phone: phone,
          birthRaw: birthRaw,
          birthFormatted: birthFormatted,
        ),
      );
    } catch (e) {
      emit(MyProfileError('Failed to load profile: $e'));
    }
  }

  void _onBirthInputChanged(
    BirthInputChanged event,
    Emitter<MyProfileState> emit,
  ) {
    final s = state;
    if (s is MyProfileLoaded) {
      final formatted = _formatInputToDisplay(event.raw);
      emit(
        MyProfileLoaded(
          uid: s.uid,
          name: s.name,
          email: s.email,
          photoUrl: s.photoUrl,
          phone: s.phone,
          birthRaw: event.raw,
          birthFormatted: formatted,
        ),
      );
    }
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<MyProfileState> emit,
  ) async {
    final s = state;
    if (s is! MyProfileLoaded) return;
    // Emit updating state carrying the current profile data so UI can remain
    // populated while the update is in progress.
    emit(
      MyProfileUpdating(
        uid: s.uid,
        name: s.name,
        email: s.email,
        photoUrl: s.photoUrl,
        phone: s.phone,
        birthRaw: s.birthRaw,
        birthFormatted: s.birthFormatted,
      ),
    );
    try {
      final uid = s.uid;

      // Normalize birth date to yyyy-MM-dd for storage when possible
      String? birthToStore;
      final raw = event.birthRaw ?? s.birthRaw;
      if (raw.trim().isEmpty) {
        birthToStore = null;
      } else {
        birthToStore = _normalizeToStorage(raw);
      }

      await _userRepository.updateUserProfile(
        uid: uid,
        name: event.name ?? s.name,
        phone: event.phone ?? s.phone,
        birthDate: birthToStore,
      );

      // Reload to reflect stored value
      final userDto = await _userRepository.getUser(uid);
      final updatedBirthRaw = userDto?.birthDate ?? '';
      final updatedBirthFormatted = _formatToDisplay(updatedBirthRaw);

      emit(
        MyProfileLoaded(
          uid: uid,
          name: userDto?.name ?? event.name ?? s.name,
          email: userDto?.email ?? s.email,
          photoUrl: userDto?.photoUrl ?? s.photoUrl,
          phone: userDto?.phone ?? event.phone ?? s.phone,
          birthRaw: updatedBirthRaw,
          birthFormatted: updatedBirthFormatted,
        ),
      );
    } catch (e) {
      emit(MyProfileError('Failed to update profile: $e'));
    }
  }

  // Helpers
  String _formatToDisplay(String raw) {
    if (raw.isEmpty) return '';
    // If it's already dd/MM/yyyy, return as-is
    final dmy = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$');
    if (dmy.hasMatch(raw)) return raw;

    // If it's numeric-only 8 digits (ddMMyyyy), parse as that
    final digitsOnly = RegExp(r'^(\d{8})$');
    if (digitsOnly.hasMatch(raw)) {
      final d = int.parse(raw.substring(0, 2));
      final mo = int.parse(raw.substring(2, 4));
      final y = int.parse(raw.substring(4, 8));
      try {
        final p = DateTime(y, mo, d);
        return DateFormat('dd/MM/yyyy').format(p);
      } catch (_) {
        return raw;
      }
    }

    // Try ISO-like yyyy-MM-dd
    final ymd = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
    final m = ymd.firstMatch(raw);
    if (m != null) {
      final y = int.parse(m.group(1)!);
      final mo = int.parse(m.group(2)!);
      final d = int.parse(m.group(3)!);
      try {
        final p = DateTime(y, mo, d);
        return DateFormat('dd/MM/yyyy').format(p);
      } catch (_) {
        return raw;
      }
    }

    // Lastly try general parse, but avoid parsing numeric-only strings (they can be ambiguous)
    try {
      final p = DateTime.parse(raw);
      return DateFormat('dd/MM/yyyy').format(p);
    } catch (_) {
      return raw;
    }
  }

  String _formatInputToDisplay(String input) {
    // remove non-digits
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '';
    final dLen = digits.length.clamp(0, 8);
    final parts = <String>[];
    if (dLen <= 2) return digits;
    parts.add(digits.substring(0, 2));
    if (dLen <= 4) {
      parts.add(digits.substring(2, dLen));
      return parts.join('/');
    }
    parts.add(digits.substring(2, 4));
    parts.add(digits.substring(4, dLen));
    return parts.join('/');
  }

  String? _normalizeToStorage(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    // if dd/MM/yyyy
    final dmy = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$');
    final m = dmy.firstMatch(trimmed);
    if (m != null) {
      final d = int.parse(m.group(1)!);
      final mo = int.parse(m.group(2)!);
      final y = int.parse(m.group(3)!);
      try {
        final dt = DateTime(y, mo, d);
        return DateFormat('yyyy-MM-dd').format(dt);
      } catch (_) {
        return trimmed;
      }
    }

    // if numeric-only and length 8, assume ddMMyyyy
    final digitsOnly = RegExp(r'^(\d{8})$');
    if (digitsOnly.hasMatch(trimmed)) {
      final d = int.parse(trimmed.substring(0, 2));
      final mo = int.parse(trimmed.substring(2, 4));
      final y = int.parse(trimmed.substring(4, 8));
      try {
        final dt = DateTime(y, mo, d);
        return DateFormat('yyyy-MM-dd').format(dt);
      } catch (_) {
        return trimmed;
      }
    }

    // try parse ISO or other parseable formats
    try {
      final p = DateTime.parse(trimmed);
      return DateFormat('yyyy-MM-dd').format(p);
    } catch (_) {}

    // otherwise return raw
    return trimmed;
  }
}
