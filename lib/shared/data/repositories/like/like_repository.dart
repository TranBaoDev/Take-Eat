import 'package:injectable/injectable.dart';
import 'package:take_eat/shared/data/service/like_service.dart';

@lazySingleton
class LikeRepository {
  final LikeService _service;

  LikeRepository(this._service);

  Future<void> setLike(String userId, String productId, bool liked) =>
      _service.setLike(userId, productId, liked);

  Future<List<String>> fetchLikedProductIds(String userId) =>
      _service.getLikedProductIds(userId);

  Future<bool> isLiked(String userId, String productId) =>
      _service.isProductLiked(userId, productId);
}
