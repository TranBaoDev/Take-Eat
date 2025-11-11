import 'package:get_it/get_it.dart';
import 'package:take_eat/features/address/blocs/address_bloc.dart';
import 'package:take_eat/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:take_eat/features/home/presentation/bloc/filter/search_filter_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:take_eat/features/home/presentation/bloc/like/likes_bloc.dart';
import 'package:take_eat/features/payment/data/repository/credit_card_repository.dart';
import 'package:take_eat/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:take_eat/shared/data/repositories/address/address_repository.dart';
import 'package:take_eat/shared/data/repositories/address/address_repository_impl.dart';
import 'package:take_eat/shared/data/repositories/like/like_repository.dart';
import 'package:take_eat/shared/data/service/like_service.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt
    ..registerLazySingleton<AuthCubit>(AuthCubit.new)
    // Payment: repository + bloc
    ..registerLazySingleton<CreditCardRepository>(CreditCardRepository.new)
    ..registerFactory(() => PaymentBloc(getIt<CreditCardRepository>()))
    // Register other cubits/services here, e.g.:
    // Likes
    ..registerLazySingleton<LikeService>(LikeService.new)
    ..registerLazySingleton<LikeRepository>(
      () => LikeRepository(getIt<LikeService>()),
    )
    ..registerFactory(() => LikesBloc(getIt<LikeRepository>()))
    // Search Filter Bloc
    ..registerFactory<SearchFilterBloc>(SearchFilterBloc.new)
    // Address
    ..registerLazySingleton<AddressRepository>(() => AddressRepositoryImpl())
    ..registerFactory(() => AddressBloc(getIt<AddressRepository>()))
    ..registerFactory(() => HomeBloc());
    
}
