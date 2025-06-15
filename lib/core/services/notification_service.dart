import 'package:flutter/material.dart';

// Tipos de notificación
enum NotificationType {
  message,
  match,
  like,
  visit,
  system
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Lista de notificaciones
  static final List<AppNotification> _notifications = [];
  static final List<VoidCallback> _listeners = [];

  // Crear notificación
  static void createNotification({
    required String title,
    required String message,
    required NotificationType type,
    String? userId,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      userId: userId,
      imageUrl: imageUrl,
      data: data ?? {},
      timestamp: DateTime.now(),
      isRead: false,
    );

    _notifications.insert(0, notification);
    _notifyListeners();

    // Mostrar notificación del sistema en web
    _showBrowserNotification(notification);
  }

  // Mostrar notificación del navegador (solo web)
  static void _showBrowserNotification(AppNotification notification) {
    // En un entorno real, aquí se usaría la API de notificaciones del navegador
    debugPrint('Nueva notificación: ${notification.title} - ${notification.message}');
  }

  // Obtener todas las notificaciones
  static List<AppNotification> getAllNotifications() {
    return List.from(_notifications);
  }

  // Obtener notificaciones no leídas
  static List<AppNotification> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  // Marcar como leída
  static void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _notifyListeners();
    }
  }

  // Marcar todas como leídas
  static void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    _notifyListeners();
  }

  // Eliminar notificación
  static void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _notifyListeners();
  }

  // Limpiar todas las notificaciones
  static void clearAll() {
    _notifications.clear();
    _notifyListeners();
  }

  // Suscribirse a cambios
  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  // Desuscribirse
  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  // Notificar cambios
  static void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  // Obtener conteo de no leídas
  static int getUnreadCount() {
    return _notifications.where((n) => !n.isRead).length;
  }

  // Crear notificaciones demo
  static void createDemoNotifications() {
    final demoNotifications = [
      {
        'title': '¡Nuevo match!',
        'message': 'Ana te ha dado like. ¡Ahora pueden chatear!',
        'type': NotificationType.match,
        'userId': 'user_2',
      },
      {
        'title': 'Nuevo mensaje',
        'message': 'Carlos: ¡Hola! ¿Cómo estás?',
        'type': NotificationType.message,
        'userId': 'user_3',
      },
      {
        'title': 'Le gustas a alguien',
        'message': 'Alguien te ha dado like. ¡Desliza para descubrir quién!',
        'type': NotificationType.like,
      },
      {
        'title': 'Perfil visitado',
        'message': 'María ha visitado tu perfil',
        'type': NotificationType.visit,
        'userId': 'user_4',
      },
      {
        'title': 'Actualización disponible',
        'message': 'Nueva versión de la app disponible con mejoras',
        'type': NotificationType.system,
      },
    ];

    for (final notification in demoNotifications) {
      createNotification(
        title: notification['title'] as String,
        message: notification['message'] as String,
        type: notification['type'] as NotificationType,
        userId: notification['userId'] as String?,
      );
    }
  }
}

// Modelo de notificación
class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final String? userId;
  final String? imageUrl;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.userId,
    this.imageUrl,
    required this.data,
    required this.timestamp,
    required this.isRead,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    String? userId,
    String? imageUrl,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  // Obtener icono según el tipo
  IconData get icon {
    switch (type) {
      case NotificationType.message:
        return Icons.message;
      case NotificationType.match:
        return Icons.favorite;
      case NotificationType.like:
        return Icons.thumb_up;
      case NotificationType.visit:
        return Icons.visibility;
      case NotificationType.system:
        return Icons.info;
    }
  }

  // Obtener color según el tipo
  Color get color {
    switch (type) {
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.match:
        return Colors.pink;
      case NotificationType.like:
        return Colors.orange;
      case NotificationType.visit:
        return Colors.purple;
      case NotificationType.system:
        return Colors.grey;
    }
  }
}
