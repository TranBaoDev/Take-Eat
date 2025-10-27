import 'package:take_eat/features/setting/domain/repositories/settings_repository.dart';

class DeleteAccountUseCase {
  final SettingsRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<void> call() async {
    return await repository.deleteAccount();
  }
}