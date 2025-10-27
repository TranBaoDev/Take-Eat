
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:take_eat/features/setting/domain/usecases/delete_account_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.freezed.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final DeleteAccountUseCase deleteAccountUseCase;

  SettingsBloc(this.deleteAccountUseCase)
      : super(const SettingsState.initial()) {
    on<_DeleteAccount>(_onDeleteAccount);
  }

  Future<void> _onDeleteAccount(
      _DeleteAccount event, Emitter<SettingsState> emit) async {
    emit(const SettingsState.loading());
    try {
      await deleteAccountUseCase();
      emit(const SettingsState.success());
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }
}
