// 🔔 Notification Service
// Servicio base para notificaciones

abstract class NotificationService {
  // Inicializar servicio de notificaciones
  Future<void> initialize();

  // Mostrar notificación local
  Future<void> showLocalNotification(String title, String body);

  // Programar notificación
  Future<void> scheduleNotification(
    String title,
    String body,
    DateTime scheduledTime,
  );

  // Cancelar notificación
  Future<void> cancelNotification(int notificationId);

  // Cancelar todas las notificaciones
  Future<void> cancelAllNotifications();

  // Verificar permisos
  Future<bool> hasPermissions();

  // Solicitar permisos
  Future<bool> requestPermissions();
}
