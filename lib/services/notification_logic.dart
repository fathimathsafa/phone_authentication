import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_study/presentation/home_screen.dart/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationLogic {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();
  static Future notificationsDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            "Schedule Reminder", "Don't Forget to Drink Water",
            importance: Importance.max, priority: Priority.max));
  }

  static Future init(BuildContext context, String uid) async {
    tz.initializeTimeZones();
    final android = AndroidInitializationSettings("time_workout");
    final Settings = InitializationSettings(android: android);
    await notifications.initialize(Settings,
        onDidReceiveBackgroundNotificationResponse: (payload) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen1()));
      onNotifications.add(payload as String);
    });
  }

  static Future showNotifications(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime dateTime}) async {
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(Duration(days: 1));
    }
    notifications.zonedSchedule(id, title, body,
        tz.TZDateTime.from(dateTime, tz.local),await notificationsDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}
