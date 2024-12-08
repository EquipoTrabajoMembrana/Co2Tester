import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterConfigurations();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotification = FlutterLocalNotificationsPlugin();
  final _supabase = Supabase.instance.client;

  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //request permission
    await _requestPermission();

    //setup message handlers
    await _setupMessageHandlers();

    //get FCM token
    final token = await _messaging.getToken();
    print('FMC token: $token');

    if (token != null) {
      await _saveTokenToSupabase(token);
    }

    //suscribe to all devices/broadcast
    suscribeToTopic('all_devices');
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterConfigurations() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    //android
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notification',
      description: 'this channel is used for important notifications',
      importance: Importance.high,
    );

    await _localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotification.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {});

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
       const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notification',
            channelDescription:
                'This channel is used for high importance notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    //background message
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    //opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {}
  }

  Future<void> suscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print('suscribed to $topic');
  }

  Future<void> _saveTokenToSupabase(String token) async {
    final String id = const Uuid().v4();
    try {
      // Intenta insertar o actualizar el token en Supabase
      final response = await _supabase.from('profiles').upsert({
        'fcm_token': token,
        'id': id,
      });

      if (response is Map && response['error'] != null) {
        print('Error al guardar el token en Supabase: ${response['error']}');
      } else {
        print('Token guardado/actualizado correctamente en Supabase');
      }
    } catch (e) {
      print('Error al enviar token a Supabase: $e');
    }
  }
}
