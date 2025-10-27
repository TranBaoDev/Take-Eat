import 'package:freezed_annotation/freezed_annotation.dart';

part 'likes_event.freezed.dart';

@freezed
abstract class LikesEvent with _$LikesEvent {
  const factory LikesEvent.loadLikes(String userId) = LoadLikes;
  const factory LikesEvent.toggleLike({
    required String userId,
    required String productId,
    required bool currentLiked,
  }) = ToggleLike;
}

