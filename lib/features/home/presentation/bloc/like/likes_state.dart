import 'package:freezed_annotation/freezed_annotation.dart';

part 'likes_state.freezed.dart';

@freezed
class LikesState with _$LikesState {
  const factory LikesState.initial() = LikesInitial;
  const factory LikesState.loading() = LikesLoading;
  const factory LikesState.loaded(Set<String> likedProductIds) = LikesLoaded;
  const factory LikesState.error(String message) = LikesError;
}
