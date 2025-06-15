// Sistema de Chat en Tiempo Real
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ChatService {
  static final Map<String, List<ChatMessage>> _conversations = {};
  static final StreamController<ChatMessage> _messageController =
      StreamController<ChatMessage>.broadcast();

  static Stream<ChatMessage> get messageStream => _messageController.stream;

  // Obtener conversaciones del usuario
  static List<ChatConversation> getConversations() {
    final conversations = <ChatConversation>[];

    // Simular conversaciones con matches
    final matchNames = [
      'Ana García',
      'Carlos López',
      'María Rodríguez',
      'Diego Martín',
      'Sofía Hernández',
      'Javier Pérez',
      'Carmen Sánchez',
      'Pablo Ruiz'
    ];

    for (int i = 0; i < matchNames.length; i++) {
      final conversationId = 'conv_$i';
      final messages = _getOrCreateConversation(conversationId);

      if (messages.isEmpty) {
        // Agregar mensaje inicial
        messages.add(ChatMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          senderId: 'other_$i',
          senderName: matchNames[i],
          message: _getRandomInitialMessage(),
          timestamp: DateTime.now().subtract(Duration(hours: i + 1)),
          isFromCurrentUser: false,
        ));
      }

      conversations.add(ChatConversation(
        id: conversationId,
        participantName: matchNames[i],
        participantImage:
            'https://via.placeholder.com/100x100/FF69B4/FFFFFF?text=${matchNames[i].substring(0, 1)}',
        lastMessage: messages.last,
        unreadCount: Random().nextInt(3),
        isOnline: Random().nextBool(),
      ));
    }

    // Ordenar por último mensaje
    conversations.sort(
        (a, b) => b.lastMessage.timestamp.compareTo(a.lastMessage.timestamp));

    return conversations;
  }

  // Obtener mensajes de una conversación
  static List<ChatMessage> getMessages(String conversationId) {
    return _getOrCreateConversation(conversationId);
  }

  // Enviar mensaje
  static Future<void> sendMessage({
    required String conversationId,
    required String message,
    required String senderId,
    required String senderName,
  }) async {
    final newMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      senderName: senderName,
      message: message.trim(),
      timestamp: DateTime.now(),
      isFromCurrentUser: true,
    );

    final conversation = _getOrCreateConversation(conversationId);
    conversation.add(newMessage);

    // Emitir el mensaje
    _messageController.add(newMessage);

    // Simular respuesta automática después de 2-5 segundos
    Future.delayed(Duration(seconds: 2 + Random().nextInt(4)), () {
      _simulateResponse(conversationId);
    });
  }

  // Simular respuesta del otro usuario
  static void _simulateResponse(String conversationId) {
    final responses = [
      '¡Hola! ¿Cómo estás?',
      'Me alegra que hayamos hecho match 😊',
      '¿Te gusta algún lugar en particular para tomar café?',
      'Veo que tenemos gustos similares',
      '¿Qué planes tienes para el fin de semana?',
      'Me encanta tu perfil 💕',
      '¿Has estado en algún concierto últimamente?',
      'Cuéntame algo interesante sobre ti',
    ];

    final randomResponse = responses[Random().nextInt(responses.length)];
    final conversationIndex = int.tryParse(conversationId.split('_')[1]) ?? 0;

    final responseMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'other_$conversationIndex',
      senderName: 'Match #$conversationIndex',
      message: randomResponse,
      timestamp: DateTime.now(),
      isFromCurrentUser: false,
    );

    final conversation = _getOrCreateConversation(conversationId);
    conversation.add(responseMessage);

    _messageController.add(responseMessage);
  }

  // Obtener o crear conversación
  static List<ChatMessage> _getOrCreateConversation(String conversationId) {
    if (!_conversations.containsKey(conversationId)) {
      _conversations[conversationId] = <ChatMessage>[];
    }
    return _conversations[conversationId]!;
  }

  // Mensajes iniciales aleatorios
  static String _getRandomInitialMessage() {
    final messages = [
      '¡Hola! Me gustó mucho tu perfil 😊',
      'Hey, veo que tenemos gustos similares',
      'Hola, ¿cómo estás?',
      '¡Qué bueno que hicimos match!',
      'Me encanta que nos hayamos encontrado',
      'Hola, me pareció muy interesante tu descripción',
    ];
    return messages[Random().nextInt(messages.length)];
  }

  // Marcar mensajes como leídos
  static void markAsRead(String conversationId) {
    // En implementación real, esto actualizaría la base de datos
  }

  // Limpiar recursos
  static void dispose() {
    _messageController.close();
  }
}

// Modelos de datos
class ChatConversation {
  final String id;
  final String participantName;
  final String participantImage;
  final ChatMessage lastMessage;
  final int unreadCount;
  final bool isOnline;

  ChatConversation({
    required this.id,
    required this.participantName,
    required this.participantImage,
    required this.lastMessage,
    required this.unreadCount,
    required this.isOnline,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isFromCurrentUser;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.isFromCurrentUser,
  });
}
