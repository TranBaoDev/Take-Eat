import 'package:get_it/get_it.dart';
import 'package:take_eat/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:take_eat/shared/data/service/like_service.dart';
import 'package:take_eat/shared/data/repositories/like/like_repository.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_bloc.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<AuthCubit>(AuthCubit.new);
  // Register other cubits/services here, e.g.:
  // Likes
  getIt.registerLazySingleton<LikeService>(() => LikeService());
  getIt.registerLazySingleton<LikeRepository>(() => LikeRepository(getIt<LikeService>()));
  getIt.registerFactory(() => LikesBloc(getIt<LikeRepository>()));
}
