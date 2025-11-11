import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:take_eat/features/notification/model/notification_item.dart';

class NotifyRepository {
  NotifyRepository({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> _notifications(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('notifications');
  }

  Future<List<NotificationItem>> getNotifications(String userId) async {
    final snapshot = await _notifications(
      userId,
    ).orderBy('createdAt', descending: true).get();
    return snapshot.docs
        .map((d) => NotificationItem.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  Future<void> addNotification(NotificationItem item) async {
    final ref = _notifications(item.userId).doc(item.id);
    await ref.set(item.toJson());
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    final ref = _notifications(userId).doc(notificationId);
    await ref.update({'read': true});
  }

  Future<void> deleteNotification(String userId, String notificationId) async {
    final ref = _notifications(userId).doc(notificationId);
    await ref.delete();
  }
}
