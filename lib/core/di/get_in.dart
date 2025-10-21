import 'package:get_it/get_it.dart';
import 'package:take_eat/features/auth/presentation/cubit/auth_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<AuthCubit>(AuthCubit.new);
  // Register other cubits/services here, e.g.:
}
