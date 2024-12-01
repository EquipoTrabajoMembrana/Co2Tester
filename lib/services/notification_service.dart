import 'dart:html' as html;

class WebNotification {
  static Future<bool> requestPermission() async {
    final permission = await html.Notification.requestPermission();
    return permission == 'granted';
  }

  static void showNotification(String title, String body) {
    if (html.Notification.permission == 'granted') {
      html.Notification(title, body: body);
    } else {
      print('Permiso no concedido para notificaciones.');
    }
  }
}
