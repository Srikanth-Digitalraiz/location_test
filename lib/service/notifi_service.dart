import 'dart:isolate';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/services.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'test_loca',
        'channelName',
        ongoing: true,
        importance: Importance.max,
        priority: Priority.high,
        autoCancel: false,
      ),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
    );

    // Start a foreground service to keep the app alive
    startForegroundService();
  }

  void startForegroundService() {
    // Acquire a wake lock to keep the CPU running
    Wakelock.enable();

    // Start the foreground service
    const MethodChannel _channel = MethodChannel('backservice');
    _channel.invokeMethod('startService');

    // Start a background isolate to print "Hello" continuously
    // The background isolate will run until the notification is dismissed
    Isolate.spawn(printHello, 'Hello from isolate');
  }

  void printHello(String message) async {
    while (true) {
      print(message);
      await Future.delayed(
          const Duration(seconds: 1)); // Print "Hello" every second
    }
  }
}
