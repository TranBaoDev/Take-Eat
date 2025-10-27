import 'package:take_eat/features/setting/data/data_sources/settings_remote_data_source.dart';
import 'package:take_eat/features/setting/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> deleteAccount() async {
    await remoteDataSource.deleteUserAccount();
  }
}