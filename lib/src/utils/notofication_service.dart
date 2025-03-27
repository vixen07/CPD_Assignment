import 'package:cpdassignment/src/features/home/models/studyspot.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final DarwinInitializationSettings initializationSettingsIOS = 
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );
  }

  void onNotificationTap(NotificationResponse response) {
    // Navigate to the specific study spot when notification is tapped
    if (response.payload != null) {
      Get.toNamed('/spot-details', arguments: response.payload);
    }
  }

  Future<void> showLikeNotification(StudySpot spot) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'spot_likes_channel',
      'Study Spot Likes',
      channelDescription: 'Notifications for liked study spots',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notificationsPlugin.show(
      spot.id.hashCode, // Unique ID based on the spot
      'Spot Liked!',
      'You liked ${spot.name}. It has been added to your favorites.',
      platformDetails,
      payload: spot.id,
    );
  }
}