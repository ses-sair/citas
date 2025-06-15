// Servicio de notificaciones
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationService {
  static const String _notificationsKey = 'user_notifications';
  static final StreamController<AppNotification> _notificationController =
      StreamController<AppNotification>.broadcast();

  // Stream para escuchar notificaciones
  static Stream<AppNotification> get notificationStream =>
      _notificationController.stream;

  // Obtener todas las notificaciones
  static Future<List<AppNotification>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList(_notificationsKey) ?? [];

      final notifications = notificationsJson.map((json) {
        final data = jsonDecode(json);
        return AppNotification.fromJson(data);
      }).toList();

      // Ordenar por fecha (más recientes primero)
      notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return notifications;
    } catch (e) {
      debugPrint('Error al cargar notificaciones: $e');
      return [];
    }
  }

  // Guardar notificaciones
  static Future<void> _saveNotifications(
      List<AppNotification> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = notifications
          .map((notification) => jsonEncode(notification.toJson()))
          .toList();
      await prefs.setStringList(_notificationsKey, notificationsJson);
    } catch (e) {
      debugPrint('Error al guardar notificaciones: $e');
    }
  }

  // Crear nueva notificación
  static Future<void> createNotification({
    required String title,
    required String message,
    required NotificationType type,
    String? userId,
    String? actionData,
  }) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
      userId: userId,
      actionData: actionData,
    );

    final notifications = await getNotifications();
    notifications.insert(0, notification);

    // Mantener solo las últimas 100 notificaciones
    if (notifications.length > 100) {
      notifications.removeRange(100, notifications.length);
    }

    await _saveNotifications(notifications);

    // Emitir notificación al stream
    _notificationController.add(notification);
  }

  // Marcar notificación como leída
  static Future<void> markAsRead(String notificationId) async {
    final notifications = await getNotifications();
    final index = notifications.indexWhere((n) => n.id == notificationId);

    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      await _saveNotifications(notifications);
    }
  }

  // Marcar todas como leídas
  static Future<void> markAllAsRead() async {
    final notifications = await getNotifications();
    final updatedNotifications =
        notifications.map((n) => n.copyWith(isRead: true)).toList();
    await _saveNotifications(updatedNotifications);
  }

  // Eliminar notificación
  static Future<void> deleteNotification(String notificationId) async {
    final notifications = await getNotifications();
    notifications.removeWhere((n) => n.id == notificationId);
    await _saveNotifications(notifications);
  }

  // Limpiar todas las notificaciones
  static Future<void> clearAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }

  // Contar notificaciones no leídas
  static Future<int> getUnreadCount() async {
    final notifications = await getNotifications();
    return notifications.where((n) => !n.isRead).length;
  }

  // Simular notificaciones de ejemplo para la demo
  static Future<void> generateDemoNotifications() async {
    final now = DateTime.now();

    final demoNotifications = [
      AppNotification(
        id: '1',
        title: '¡Nuevo match!',
        message: 'Ana te ha dado like. ¡Empezad a chatear!',
        type: NotificationType.match,
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: false,
        userId: 'user_1',
      ),
      AppNotification(
        id: '2',
        title: 'Mensaje nuevo',
        message: 'Carlos: Hola, ¿cómo estás?',
        type: NotificationType.message,
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: false,
        userId: 'user_2',
      ),
      AppNotification(
        id: '3',
        title: 'Perfil visitado',
        message: '3 personas han visto tu perfil hoy',
        type: NotificationType.profileView,
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      AppNotification(
        id: '4',
        title: '¡Super Like!',
        message: 'María te ha dado un Super Like ❤️',
        type: NotificationType.superLike,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: false,
        userId: 'user_3',
      ),
      AppNotification(
        id: '5',
        title: 'Actualiza tu perfil',
        message: 'Agrega más fotos para conseguir más matches',
        type: NotificationType.reminder,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];

    await _saveNotifications(demoNotifications);
  }

  // Cerrar el stream
  static void dispose() {
    _notificationController.close();
  }
}

// Tipos de notificaciones
enum NotificationType {
  match,
  message,
  like,
  superLike,
  profileView,
  reminder,
  system,
}

// Modelo de notificación
class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? userId;
  final String? actionData;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.userId,
    this.actionData,
  });

  // Crear copia con modificaciones
  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? userId,
    String? actionData,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      userId: userId ?? this.userId,
      actionData: actionData ?? this.actionData,
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'type': type.name,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
        'userId': userId,
        'actionData': actionData,
      };

  // Crear desde JSON
  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'],
        title: json['title'],
        message: json['message'],
        type: NotificationType.values.firstWhere((e) => e.name == json['type']),
        timestamp: DateTime.parse(json['timestamp']),
        isRead: json['isRead'],
        userId: json['userId'],
        actionData: json['actionData'],
      );

  // Obtener icono según el tipo
  IconData get icon {
    switch (type) {
      case NotificationType.match:
        return Icons.favorite;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.like:
        return Icons.thumb_up;
      case NotificationType.superLike:
        return Icons.star;
      case NotificationType.profileView:
        return Icons.visibility;
      case NotificationType.reminder:
        return Icons.notification_important;
      case NotificationType.system:
        return Icons.info;
    }
  }

  // Obtener color según el tipo
  Color get color {
    switch (type) {
      case NotificationType.match:
        return Colors.pink;
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.like:
        return Colors.green;
      case NotificationType.superLike:
        return Colors.amber;
      case NotificationType.profileView:
        return Colors.purple;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  // Formatear tiempo transcurrido
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return 'Hace ${(difference.inDays / 7).floor()}sem';
    }
  }
}
