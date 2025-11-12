import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'likes_event.dart';
import 'likes_state.dart';
import 'package:take_eat/shared/data/repositories/like/like_repository.dart';

@injectable
class LikesBloc extends Bloc<LikesEvent, LikesState> {
  final LikeRepository repository;

  LikesBloc(this.repository) : super(const LikesState.initial()) {
    on<LoadLikes>(_onLoad);
    on<ToggleLike>(_onToggle);
  }

  Future<void> _onLoad(LoadLikes event, Emitter<LikesState> emit) async {
    emit(const LikesState.loading());
    try {
      final ids = await repository.fetchLikedProductIds(event.userId);
      emit(LikesState.loaded(ids.toSet()));
    } catch (e) {
      emit(LikesState.error(e.toString()));
    }
  }

  Future<void> _onToggle(ToggleLike event, Emitter<LikesState> emit) async {
    try {
      final currentIds = state is LikesLoaded
          ? (state as LikesLoaded).likedProductIds
          : <String>{};
      final newLiked = !event.currentLiked;

      final newSet = Set<String>.from(currentIds);
      if (newLiked) {
        newSet.add(event.productId);
      } else {
        newSet.remove(event.productId);
      }

      // optimistic update
      emit(LikesState.loaded(newSet));

      await repository.setLike(event.userId, event.productId, newLiked);
    } catch (e) {
      emit(LikesState.error(e.toString()));
    }
  }
}
