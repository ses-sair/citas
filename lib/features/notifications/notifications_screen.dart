// Pantalla de notificaciones
import 'package:flutter/material.dart';
import 'notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => isLoading = true);
    try {
      final loadedNotifications = await NotificationService.getNotifications();
      if (loadedNotifications.isEmpty) {
        // Si no hay notificaciones, generar algunas de demo
        await NotificationService.generateDemoNotifications();
        final demoNotifications = await NotificationService.getNotifications();
        setState(() {
          notifications = demoNotifications;
          isLoading = false;
        });
      } else {
        setState(() {
          notifications = loadedNotifications;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar notificaciones: $e')),
        );
      }
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    await NotificationService.markAsRead(notificationId);
    await _loadNotifications();
  }

  Future<void> _markAllAsRead() async {
    await NotificationService.markAllAsRead();
    await _loadNotifications();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todas las notificaciones marcadas como leídas'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    await NotificationService.deleteNotification(notificationId);
    await _loadNotifications();
  }

  Future<void> _clearAllNotifications() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpiar notificaciones'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar todas las notificaciones?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar todas',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await NotificationService.clearAllNotifications();
      await _loadNotifications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todas las notificaciones eliminadas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (notifications.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'mark_all_read':
                    _markAllAsRead();
                    break;
                  case 'clear_all':
                    _clearAllNotifications();
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'mark_all_read',
                  child: Text('Marcar todas como leídas'),
                ),
                const PopupMenuItem<String>(
                  value: 'clear_all',
                  child: Text('Eliminar todas',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No tienes notificaciones',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cuando tengas nuevas actividades aparecerán aquí',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              await NotificationService.generateDemoNotifications();
              await _loadNotifications();
            },
            child: const Text('Generar notificaciones de ejemplo'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: notification.isRead ? 1 : 4,
        color: notification.isRead ? Colors.grey[50] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: notification.isRead
              ? BorderSide.none
              : BorderSide(
                  color: notification.color.withOpacity(0.3), width: 1),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: notification.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notification.icon,
              color: notification.color,
              size: 24,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead
                        ? FontWeight.normal
                        : FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: notification.color,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.message,
                style: TextStyle(
                  color:
                      notification.isRead ? Colors.grey[600] : Colors.black87,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notification.timeAgo,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          onTap: () async {
            if (!notification.isRead) {
              await _markAsRead(notification.id);
            }
            // Aquí podrías agregar navegación específica según el tipo de notificación
            _handleNotificationTap(notification);
          },
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'mark_read':
                  _markAsRead(notification.id);
                  break;
                case 'delete':
                  _deleteNotification(notification.id);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              if (!notification.isRead)
                const PopupMenuItem<String>(
                  value: 'mark_read',
                  child: Text('Marcar como leída'),
                ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              ),
            ],
            child: Icon(
              Icons.more_vert,
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(AppNotification notification) {
    // Aquí puedes implementar navegación específica según el tipo de notificación
    switch (notification.type) {
      case NotificationType.match:
        // Navegar a la pantalla de matches
        break;
      case NotificationType.message:
        // Navegar al chat específico
        break;
      case NotificationType.like:
      case NotificationType.superLike:
        // Navegar a la pantalla de likes recibidos
        break;
      case NotificationType.profileView:
        // Navegar a las estadísticas del perfil
        break;
      case NotificationType.reminder:
        // Navegar a la edición del perfil
        break;
      case NotificationType.system:
        // Mostrar información del sistema
        break;
    }

    // Por ahora, solo mostrar un mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notificación: ${notification.title}'),
        backgroundColor: notification.color,
      ),
    );
  }
}
