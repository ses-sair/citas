// Sistema de Conexión de Usuarios Seguro para Capstone de Ciberseguridad
// Implementa geolocalización + códigos de amigo + invitaciones con máxima seguridad

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import '../../core/security/advanced_security_service.dart';

class UserConnectionService {
  static final Map<String, UserProfile> _users = {};
  static final Map<String, List<String>> _friendCodes = {};
  static final Map<String, PendingInvitation> _pendingInvitations = {};
  static final Map<String, LocationData> _userLocations = {};
  static final List<ConnectionLog> _connectionLogs = [];

  // 🌍 GEOLOCALIZACIÓN SEGURA

  /// Obtiene la ubicación del usuario con verificaciones de seguridad
  static Future<SecureLocationResult> getSecureLocation(String userId) async {
    try {
      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return SecureLocationResult(
            success: false,
            error: 'Permisos de ubicación denegados',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return SecureLocationResult(
          success: false,
          error: 'Permisos de ubicación denegados permanentemente',
        );
      }

      // Obtener ubicación con alta precisión
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // Verificaciones de seguridad
      final securityCheck =
          await _performLocationSecurityChecks(position, userId);
      if (!securityCheck.isSecure) {
        return SecureLocationResult(
          success: false,
          error:
              'Verificación de seguridad de ubicación falló: ${securityCheck.reason}',
          securityFlags: securityCheck.flags,
        );
      }

      // Crear hash de ubicación para privacidad
      final locationHash =
          _createLocationHash(position.latitude, position.longitude);

      // Almacenar ubicación de forma segura
      _userLocations[userId] = LocationData(
        userId: userId,
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        timestamp: DateTime.now(),
        locationHash: locationHash,
        isVerified: true,
      );

      _logConnection(ConnectionLog(
        type: ConnectionLogType.locationUpdate,
        userId: userId,
        details: {
          'accuracy': position.accuracy,
          'timestamp': DateTime.now().toIso8601String(),
        },
        timestamp: DateTime.now(),
      ));

      return SecureLocationResult(
        success: true,
        position: position,
        locationHash: locationHash,
      );
    } catch (e) {
      return SecureLocationResult(
        success: false,
        error: 'Error obteniendo ubicación: $e',
      );
    }
  }

  /// Encuentra usuarios cercanos con verificaciones de seguridad
  static Future<List<NearbyUser>> findNearbyUsers(String userId,
      {double radiusKm = 50}) async {
    final currentUser = _userLocations[userId];
    if (currentUser == null || !currentUser.isVerified) {
      return [];
    }

    final nearbyUsers = <NearbyUser>[];

    for (final entry in _userLocations.entries) {
      final otherUserId = entry.key;
      final otherLocation = entry.value;

      if (otherUserId == userId || !otherLocation.isVerified) continue;

      // Calcular distancia
      final distance = Geolocator.distanceBetween(
            currentUser.latitude,
            currentUser.longitude,
            otherLocation.latitude,
            otherLocation.longitude,
          ) /
          1000; // Convertir a km

      if (distance <= radiusKm) {
        // Verificaciones de seguridad adicionales
        final user = _users[otherUserId];
        if (user == null) continue;

        final securityScore = await _calculateUserSecurityScore(otherUserId);
        if (securityScore < 0.7) continue; // Solo usuarios seguros

        nearbyUsers.add(NearbyUser(
          userId: otherUserId,
          profile: user,
          distance: distance,
          lastSeen: otherLocation.timestamp,
          securityScore: securityScore,
        ));
      }
    }

    // Ordenar por distancia y score de seguridad
    nearbyUsers.sort((a, b) {
      final distanceCompare = a.distance.compareTo(b.distance);
      if (distanceCompare == 0) {
        return b.securityScore.compareTo(a.securityScore);
      }
      return distanceCompare;
    });

    return nearbyUsers;
  }

  // 🔑 SISTEMA DE CÓDIGOS DE AMIGO SEGURO

  /// Genera un código de amigo único y seguro
  static Future<FriendCodeResult> generateFriendCode(String userId) async {
    // Verificar que el usuario existe y está verificado
    final user = _users[userId];
    if (user == null || !user.isVerified) {
      return FriendCodeResult(
        success: false,
        error: 'Usuario no verificado',
      );
    }

    // Generar código seguro (8 caracteres alfanuméricos)
    final random = Random.secure();
    final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = '';

    do {
      code = List.generate(8, (index) => chars[random.nextInt(chars.length)])
          .join();
    } while (_friendCodes.containsKey(code)); // Asegurar unicidad

    // Expiración del código (24 horas)
    final expiresAt = DateTime.now().add(const Duration(hours: 24));

    // Almacenar código
    _friendCodes[code] = [userId, expiresAt.millisecondsSinceEpoch.toString()];

    _logConnection(ConnectionLog(
      type: ConnectionLogType.friendCodeGenerated,
      userId: userId,
      details: {
        'code': code,
        'expiresAt': expiresAt.toIso8601String(),
      },
      timestamp: DateTime.now(),
    ));

    return FriendCodeResult(
      success: true,
      code: code,
      expiresAt: expiresAt,
    );
  }

  /// Conecta con otro usuario usando código de amigo
  static Future<ConnectionResult> connectWithFriendCode(
      String userId, String friendCode) async {
    // Verificar usuario
    final user = _users[userId];
    if (user == null || !user.isVerified) {
      return ConnectionResult(
        success: false,
        error: 'Usuario no verificado',
      );
    }

    // Verificar código
    final codeData = _friendCodes[friendCode.toUpperCase()];
    if (codeData == null) {
      _logConnection(ConnectionLog(
        type: ConnectionLogType.invalidFriendCode,
        userId: userId,
        details: {'attemptedCode': friendCode},
        timestamp: DateTime.now(),
      ));

      return ConnectionResult(
        success: false,
        error: 'Código de amigo inválido',
      );
    }

    final friendUserId = codeData[0];
    final expiresAt =
        DateTime.fromMillisecondsSinceEpoch(int.parse(codeData[1]));

    // Verificar expiración
    if (DateTime.now().isAfter(expiresAt)) {
      _friendCodes.remove(friendCode.toUpperCase());
      return ConnectionResult(
        success: false,
        error: 'Código de amigo expirado',
      );
    }

    // No permitir autoconexión
    if (friendUserId == userId) {
      return ConnectionResult(
        success: false,
        error: 'No puedes usar tu propio código',
      );
    }

    // Verificaciones de seguridad
    final securityCheck =
        await _performConnectionSecurityCheck(userId, friendUserId);
    if (!securityCheck.isSecure) {
      return ConnectionResult(
        success: false,
        error: 'Verificación de seguridad falló: ${securityCheck.reason}',
        securityFlags: securityCheck.flags,
      );
    }

    // Crear conexión
    final connection = UserConnection(
      id: _generateConnectionId(),
      user1Id: userId,
      user2Id: friendUserId,
      connectionType: ConnectionType.friendCode,
      createdAt: DateTime.now(),
      isActive: true,
      securityScore: securityCheck.score,
    );

    // Limpiar código usado
    _friendCodes.remove(friendCode.toUpperCase());

    _logConnection(ConnectionLog(
      type: ConnectionLogType.connectionEstablished,
      userId: userId,
      details: {
        'friendUserId': friendUserId,
        'connectionType': 'friendCode',
        'securityScore': securityCheck.score,
      },
      timestamp: DateTime.now(),
    ));

    return ConnectionResult(
      success: true,
      connection: connection,
      message: 'Conexión establecida exitosamente',
    );
  }

  // 📨 SISTEMA DE INVITACIONES SEGURO

  /// Envía una invitación a otro usuario
  static Future<InvitationResult> sendInvitation({
    required String fromUserId,
    required String toUserId,
    required String message,
    InvitationType type = InvitationType.general,
  }) async {
    // Verificaciones básicas
    final fromUser = _users[fromUserId];
    final toUser = _users[toUserId];

    if (fromUser == null || !fromUser.isVerified) {
      return InvitationResult(
        success: false,
        error: 'Usuario remitente no verificado',
      );
    }

    if (toUser == null || !toUser.isVerified) {
      return InvitationResult(
        success: false,
        error: 'Usuario destinatario no verificado',
      );
    }

    // Análisis de seguridad del mensaje
    final socialEngineeringResult =
        await AdvancedSecurityService.analyzeCommunication(
      message: message,
      senderId: fromUserId,
      receiverId: toUserId,
    );

    if (socialEngineeringResult.shouldBlock) {
      _logConnection(ConnectionLog(
        type: ConnectionLogType.suspiciousInvitation,
        userId: fromUserId,
        details: {
          'toUserId': toUserId,
          'riskScore': socialEngineeringResult.riskScore,
          'risks': socialEngineeringResult.detectedRisks,
        },
        timestamp: DateTime.now(),
      ));

      return InvitationResult(
        success: false,
        error: 'Invitación bloqueada por razones de seguridad',
        securityFlags: socialEngineeringResult.detectedRisks,
      );
    }

    // Verificar límites de invitaciones
    final invitationLimitCheck = _checkInvitationLimits(fromUserId);
    if (!invitationLimitCheck.allowed) {
      return InvitationResult(
        success: false,
        error: invitationLimitCheck.reason,
      );
    }

    // Crear invitación
    final invitation = PendingInvitation(
      id: _generateInvitationId(),
      fromUserId: fromUserId,
      toUserId: toUserId,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      status: InvitationStatus.pending,
      securityScore: 1.0 - socialEngineeringResult.riskScore,
    );

    _pendingInvitations[invitation.id] = invitation;

    // Notificar al usuario destinatario (comentado para demo)
    // await NotificationService.sendNotification(
    //   toUserId,
    //   'Nueva invitación',
    //   'Has recibido una invitación de ${fromUser.name}',
    //   type: NotificationType.invitation,
    //   data: {'invitationId': invitation.id},
    // );

    _logConnection(ConnectionLog(
      type: ConnectionLogType.invitationSent,
      userId: fromUserId,
      details: {
        'toUserId': toUserId,
        'invitationId': invitation.id,
        'type': type.toString(),
      },
      timestamp: DateTime.now(),
    ));

    return InvitationResult(
      success: true,
      invitation: invitation,
      message: 'Invitación enviada exitosamente',
    );
  }

  /// Responde a una invitación
  static Future<InvitationResponseResult> respondToInvitation(
    String invitationId,
    bool accept,
    String userId,
  ) async {
    final invitation = _pendingInvitations[invitationId];
    if (invitation == null) {
      return InvitationResponseResult(
        success: false,
        error: 'Invitación no encontrada',
      );
    }

    // Verificar que el usuario puede responder
    if (invitation.toUserId != userId) {
      return InvitationResponseResult(
        success: false,
        error: 'No autorizado para responder esta invitación',
      );
    }

    // Verificar expiración
    if (DateTime.now().isAfter(invitation.expiresAt)) {
      _pendingInvitations.remove(invitationId);
      return InvitationResponseResult(
        success: false,
        error: 'Invitación expirada',
      );
    }

    // Actualizar estado
    invitation.status =
        accept ? InvitationStatus.accepted : InvitationStatus.rejected;
    invitation.respondedAt = DateTime.now();

    UserConnection? connection;

    if (accept) {
      // Verificaciones de seguridad finales
      final securityCheck = await _performConnectionSecurityCheck(
        invitation.fromUserId,
        invitation.toUserId,
      );

      if (!securityCheck.isSecure) {
        return InvitationResponseResult(
          success: false,
          error: 'Verificación de seguridad falló: ${securityCheck.reason}',
          securityFlags: securityCheck.flags,
        );
      }

      // Crear conexión
      connection = UserConnection(
        id: _generateConnectionId(),
        user1Id: invitation.fromUserId,
        user2Id: invitation.toUserId,
        connectionType: ConnectionType.invitation,
        createdAt: DateTime.now(),
        isActive: true,
        securityScore: securityCheck.score,
        originalInvitationId: invitationId,
      );

      // Notificar al remitente (comentado para demo)
      // await NotificationService.sendNotification(
      //   invitation.fromUserId,
      //   'Invitación aceptada',
      //   'Tu invitación ha sido aceptada',
      //   type: NotificationType.connectionAccepted,
      //   data: {'connectionId': connection.id},
      // );
    } else {
      // Notificar rechazo (opcional, por privacidad) (comentado para demo)
      // await NotificationService.sendNotification(
      //   invitation.fromUserId,
      //   'Invitación respondida',
      //   'Tu invitación ha sido procesada',
      //   type: NotificationType.invitationProcessed,
      // );
    }

    // Limpiar invitación procesada
    _pendingInvitations.remove(invitationId);

    _logConnection(ConnectionLog(
      type: accept
          ? ConnectionLogType.invitationAccepted
          : ConnectionLogType.invitationRejected,
      userId: userId,
      details: {
        'invitationId': invitationId,
        'fromUserId': invitation.fromUserId,
        'connectionId': connection?.id,
      },
      timestamp: DateTime.now(),
    ));

    return InvitationResponseResult(
      success: true,
      accepted: accept,
      connection: connection,
      message: accept ? 'Invitación aceptada' : 'Invitación rechazada',
    );
  }

  // 🔒 MÉTODOS DE SEGURIDAD PRIVADOS

  static Future<LocationSecurityCheck> _performLocationSecurityChecks(
    Position position,
    String userId,
  ) async {
    final flags = <String>[];
    var isSecure = true;
    var reason = '';

    // Verificar precisión
    if (position.accuracy > 100) {
      flags.add('LOW_ACCURACY');
      isSecure = false;
      reason = 'Precisión de ubicación insuficiente';
    }

    // Verificar ubicaciones sospechosas (simulado)
    if (_isSuspiciousLocation(position.latitude, position.longitude)) {
      flags.add('SUSPICIOUS_LOCATION');
      isSecure = false;
      reason = 'Ubicación sospechosa';
    }

    // Verificar cambios de ubicación muy rápidos
    final lastLocation = _userLocations[userId];
    if (lastLocation != null) {
      final distance = Geolocator.distanceBetween(
        lastLocation.latitude,
        lastLocation.longitude,
        position.latitude,
        position.longitude,
      );

      final timeDiff =
          DateTime.now().difference(lastLocation.timestamp).inMinutes;
      final speedKmh = (distance / 1000) / (timeDiff / 60);

      if (speedKmh > 300) {
        // Más de 300 km/h es sospechoso
        flags.add('IMPOSSIBLE_SPEED');
        isSecure = false;
        reason = 'Cambio de ubicación imposiblemente rápido';
      }
    }

    return LocationSecurityCheck(
      isSecure: isSecure,
      reason: reason,
      flags: flags,
    );
  }

  static Future<ConnectionSecurityCheck> _performConnectionSecurityCheck(
    String user1Id,
    String user2Id,
  ) async {
    var score = 1.0;
    final flags = <String>[];
    var isSecure = true;
    var reason = '';

    // Verificar perfiles de usuarios
    final user1 = _users[user1Id];
    final user2 = _users[user2Id];

    if (user1 == null || user2 == null) {
      isSecure = false;
      reason = 'Usuario no encontrado';
      return ConnectionSecurityCheck(
        isSecure: isSecure,
        reason: reason,
        flags: flags,
        score: 0.0,
      );
    }

    // Análisis de catfishing
    final catfishAnalysis1 =
        await AdvancedSecurityService.analyzeCatfishingRisk(
      userId: user1Id,
      photos: user1.photos,
      profileData: user1.toMap(),
    );

    final catfishAnalysis2 =
        await AdvancedSecurityService.analyzeCatfishingRisk(
      userId: user2Id,
      photos: user2.photos,
      profileData: user2.toMap(),
    );

    if (catfishAnalysis1.riskScore > 0.7) {
      score -= 0.3;
      flags.add('CATFISH_RISK_USER1');
    }

    if (catfishAnalysis2.riskScore > 0.7) {
      score -= 0.3;
      flags.add('CATFISH_RISK_USER2');
    }

    // Verificar conexiones previas sospechosas
    if (_hasRepeatedConnectionPatterns(user1Id) ||
        _hasRepeatedConnectionPatterns(user2Id)) {
      score -= 0.2;
      flags.add('SUSPICIOUS_CONNECTION_PATTERN');
    }

    if (score < 0.7) {
      isSecure = false;
      reason = 'Score de seguridad insuficiente';
    }

    return ConnectionSecurityCheck(
      isSecure: isSecure,
      reason: reason,
      flags: flags,
      score: score,
    );
  }

  static Future<double> _calculateUserSecurityScore(String userId) async {
    final user = _users[userId];
    if (user == null) return 0.0;

    var score = 0.5; // Base score

    // Verificación de identidad
    if (user.isVerified) score += 0.2;
    if (user.hasDocumentVerification) score += 0.2;
    if (user.hasBiometricVerification) score += 0.1;

    // Actividad normal
    if (user.lastActive
        .isAfter(DateTime.now().subtract(const Duration(days: 7)))) {
      score += 0.1;
    }

    // Sin reportes de seguridad
    if (!_hasSecurityReports(userId)) {
      score += 0.1;
    }

    return score.clamp(0.0, 1.0);
  }

  // Métodos auxiliares
  static String _createLocationHash(double lat, double lng) {
    final data = '${lat.toStringAsFixed(4)},${lng.toStringAsFixed(4)}';
    return sha256.convert(utf8.encode(data)).toString();
  }

  static String _generateConnectionId() {
    return 'conn_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
  }

  static String _generateInvitationId() {
    return 'inv_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
  }

  static bool _isSuspiciousLocation(double lat, double lng) {
    // Implementar lógica para ubicaciones sospechosas
    // Por ejemplo, océanos, polos, etc.
    return false; // Simplificado para demo
  }

  static bool _hasRepeatedConnectionPatterns(String userId) {
    // Verificar patrones sospechosos en conexiones
    return false; // Simplificado para demo
  }

  static bool _hasSecurityReports(String userId) {
    // Verificar reportes de seguridad del usuario
    return false; // Simplificado para demo
  }

  static InvitationLimitCheck _checkInvitationLimits(String userId) {
    // Verificar límites de invitaciones (ej: 10 por día)
    return InvitationLimitCheck(
      allowed: true,
      reason: '',
    );
  }

  static void _logConnection(ConnectionLog log) {
    _connectionLogs.add(log);
    print('🔗 Connection Log: ${log.type} - ${log.userId} - ${log.timestamp}');
  }

  // Métodos públicos para gestión

  static Future<void> registerUser(UserProfile user) async {
    _users[user.id] = user;
  }

  static List<ConnectionLog> getConnectionLogs() => List.from(_connectionLogs);

  static Map<String, PendingInvitation> getPendingInvitations(String userId) {
    return Map.fromEntries(_pendingInvitations.entries.where((entry) =>
        entry.value.toUserId == userId &&
        entry.value.status == InvitationStatus.pending));
  }
}

// Clases de datos
class UserProfile {
  final String id;
  final String name;
  final String email;
  final List<String> photos;
  final bool isVerified;
  final bool hasDocumentVerification;
  final bool hasBiometricVerification;
  final DateTime lastActive;
  final Map<String, dynamic> additionalData;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.photos,
    this.isVerified = false,
    this.hasDocumentVerification = false,
    this.hasBiometricVerification = false,
    required this.lastActive,
    this.additionalData = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photos': photos,
      'isVerified': isVerified,
      'hasDocumentVerification': hasDocumentVerification,
      'hasBiometricVerification': hasBiometricVerification,
      'lastActive': lastActive.toIso8601String(),
      ...additionalData,
    };
  }
}

class LocationData {
  final String userId;
  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime timestamp;
  final String locationHash;
  final bool isVerified;

  LocationData({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
    required this.locationHash,
    required this.isVerified,
  });
}

class NearbyUser {
  final String userId;
  final UserProfile profile;
  final double distance;
  final DateTime lastSeen;
  final double securityScore;

  NearbyUser({
    required this.userId,
    required this.profile,
    required this.distance,
    required this.lastSeen,
    required this.securityScore,
  });
}

class UserConnection {
  final String id;
  final String user1Id;
  final String user2Id;
  final ConnectionType connectionType;
  final DateTime createdAt;
  final bool isActive;
  final double securityScore;
  final String? originalInvitationId;

  UserConnection({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.connectionType,
    required this.createdAt,
    required this.isActive,
    required this.securityScore,
    this.originalInvitationId,
  });
}

class PendingInvitation {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String message;
  final InvitationType type;
  final DateTime createdAt;
  final DateTime expiresAt;
  InvitationStatus status;
  DateTime? respondedAt;
  final double securityScore;

  PendingInvitation({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.expiresAt,
    required this.status,
    this.respondedAt,
    required this.securityScore,
  });
}

// Resultados y tipos
class SecureLocationResult {
  final bool success;
  final Position? position;
  final String? error;
  final String? locationHash;
  final List<String>? securityFlags;

  SecureLocationResult({
    required this.success,
    this.position,
    this.error,
    this.locationHash,
    this.securityFlags,
  });
}

class FriendCodeResult {
  final bool success;
  final String? code;
  final DateTime? expiresAt;
  final String? error;

  FriendCodeResult({
    required this.success,
    this.code,
    this.expiresAt,
    this.error,
  });
}

class ConnectionResult {
  final bool success;
  final UserConnection? connection;
  final String? error;
  final String? message;
  final List<String>? securityFlags;

  ConnectionResult({
    required this.success,
    this.connection,
    this.error,
    this.message,
    this.securityFlags,
  });
}

class InvitationResult {
  final bool success;
  final PendingInvitation? invitation;
  final String? error;
  final String? message;
  final List<String>? securityFlags;

  InvitationResult({
    required this.success,
    this.invitation,
    this.error,
    this.message,
    this.securityFlags,
  });
}

class InvitationResponseResult {
  final bool success;
  final bool? accepted;
  final UserConnection? connection;
  final String? error;
  final String? message;
  final List<String>? securityFlags;

  InvitationResponseResult({
    required this.success,
    this.accepted,
    this.connection,
    this.error,
    this.message,
    this.securityFlags,
  });
}

class LocationSecurityCheck {
  final bool isSecure;
  final String reason;
  final List<String> flags;

  LocationSecurityCheck({
    required this.isSecure,
    required this.reason,
    required this.flags,
  });
}

class ConnectionSecurityCheck {
  final bool isSecure;
  final String reason;
  final List<String> flags;
  final double score;

  ConnectionSecurityCheck({
    required this.isSecure,
    required this.reason,
    required this.flags,
    required this.score,
  });
}

class InvitationLimitCheck {
  final bool allowed;
  final String reason;

  InvitationLimitCheck({
    required this.allowed,
    required this.reason,
  });
}

class ConnectionLog {
  final ConnectionLogType type;
  final String userId;
  final Map<String, dynamic> details;
  final DateTime timestamp;

  ConnectionLog({
    required this.type,
    required this.userId,
    required this.details,
    required this.timestamp,
  });
}

// Enums
enum ConnectionType {
  geolocation,
  friendCode,
  invitation,
}

enum InvitationType {
  general,
  meetup,
  date,
  friendship,
}

enum InvitationStatus {
  pending,
  accepted,
  rejected,
  expired,
}

enum ConnectionLogType {
  locationUpdate,
  friendCodeGenerated,
  invalidFriendCode,
  connectionEstablished,
  invitationSent,
  invitationAccepted,
  invitationRejected,
  suspiciousInvitation,
}
