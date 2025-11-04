import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    print('🔄 Inicializando NotificationService...');
    
    // 🔧 SOLICITAR PERMISOS PRIMERO (Android 13+)
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted = await androidImplementation.requestNotificationsPermission();
      print('✅ Permiso de notificaciones: ${granted == true ? "CONCEDIDO" : "DENEGADO"}');
    }

    // Configuración Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Inicializar plugin
    final bool? initialized = await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('📱 Notificación tocada: ${response.payload}');
      },
    );
    
    print('✅ NotificationService inicializado: $initialized');
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'cherry_block_channel',
        'Cherry Block Notifications',
        channelDescription: 'Canal de notificaciones para Cherry Block',
        importance: Importance.max, 
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await _notificationsPlugin.show(
        id, 
        title, 
        body, 
        notificationDetails,
      );
      
      print('✅ Notificación enviada: $title');
    } catch (e) {
      print('❌ Error al enviar notificación: $e');
    }
  }
}