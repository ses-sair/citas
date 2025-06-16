// Sistema Avanzado de Seguridad para Aplicación de Citas
// Diseñado para Capstone de Ciberseguridad
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class AdvancedSecurityService {
  static const Uuid _uuid = Uuid();
  static final _securityLog = <SecurityEvent>[];

  // 🔐 NIVEL 1: VERIFICACIÓN DE IDENTIDAD MULTICAPA

  /// Verificación biométrica simulada (en producción usaría APIs reales)
  static Future<BiometricResult> verifyBiometric(String userId) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulación de verificación biométrica
    final confidence = Random().nextDouble();

    return BiometricResult(
      isValid: confidence > 0.7,
      confidence: confidence,
      biometricType: BiometricType.facial,
      timestamp: DateTime.now(),
    );
  }

  /// Verificación de documentos con IA simulada
  static Future<DocumentVerificationResult> verifyDocument({
    required String documentType,
    required String documentImage, // Base64
    required String selfieImage, // Base64
  }) async {
    await Future.delayed(const Duration(seconds: 3));

    // Simulación de verificación de documentos
    final checks = DocumentChecks(
      faceMatch: Random().nextDouble() > 0.2,
      documentAuthenticity: Random().nextDouble() > 0.1,
      liveness: Random().nextDouble() > 0.15,
      textExtraction: Random().nextDouble() > 0.1,
    );

    final isValid = checks.faceMatch &&
        checks.documentAuthenticity &&
        checks.liveness &&
        checks.textExtraction;

    return DocumentVerificationResult(
      isValid: isValid,
      checks: checks,
      confidence: _calculateDocumentConfidence(checks),
      timestamp: DateTime.now(),
    );
  }

  // 🤖 NIVEL 2: DETECCIÓN DE BOTS AVANZADA

  /// Análisis de comportamiento humano vs bot
  static Future<BotDetectionResult> analyzeBehavior({
    required List<UserAction> actions,
    required Duration sessionTime,
    required Map<String, dynamic> deviceMetrics,
  }) async {
    var botScore = 0.0;

    // Análisis de patrones temporales
    if (_analyzeTimingPatterns(actions)) botScore += 0.3;

    // Análisis de movimientos del mouse/touch
    if (_analyzeMouseMovements(actions)) botScore += 0.2;

    // Análisis de velocidad de escritura
    if (_analyzeTypingSpeed(actions)) botScore += 0.25;

    // Análisis de JavaScript y características del navegador
    if (_analyzeJavaScriptCapabilities(deviceMetrics)) botScore += 0.25;

    _logSecurityEvent(SecurityEvent(
      type: SecurityEventType.botAnalysis,
      severity: botScore > 0.6 ? SecuritySeverity.high : SecuritySeverity.low,
      details: {'botScore': botScore},
      timestamp: DateTime.now(),
    ));

    return BotDetectionResult(
      isBot: botScore > 0.6,
      confidence: botScore,
      detectionReasons: _getBotDetectionReasons(botScore),
      timestamp: DateTime.now(),
    );
  }

  // 🔄 NIVEL 3: PREVENCIÓN DE ATAQUES DE FUERZA BRUTA

  static final Map<String, List<DateTime>> _loginAttempts = {};
  static final Map<String, DateTime> _blockedIPs = {};

  static Future<RateLimitResult> checkRateLimit(String identifier) async {
    final now = DateTime.now();
    final attempts = _loginAttempts[identifier] ?? [];

    // Limpiar intentos antiguos (últimos 15 minutos)
    attempts.removeWhere((attempt) => now.difference(attempt).inMinutes > 15);

    // Verificar si está bloqueado
    if (_blockedIPs.containsKey(identifier)) {
      final blockedUntil = _blockedIPs[identifier]!;
      if (now.isBefore(blockedUntil)) {
        return RateLimitResult(
          isAllowed: false,
          remainingAttempts: 0,
          blockDuration: blockedUntil.difference(now),
        );
      } else {
        _blockedIPs.remove(identifier);
      }
    }

    // Verificar límite de intentos
    if (attempts.length >= 5) {
      // Bloquear por 30 minutos
      _blockedIPs[identifier] = now.add(const Duration(minutes: 30));

      _logSecurityEvent(SecurityEvent(
        type: SecurityEventType.bruteForceDetected,
        severity: SecuritySeverity.critical,
        details: {'identifier': identifier, 'attempts': attempts.length},
        timestamp: now,
      ));

      return RateLimitResult(
        isAllowed: false,
        remainingAttempts: 0,
        blockDuration: const Duration(minutes: 30),
      );
    }

    // Registrar intento
    attempts.add(now);
    _loginAttempts[identifier] = attempts;

    return RateLimitResult(
      isAllowed: true,
      remainingAttempts: 5 - attempts.length,
      blockDuration: Duration.zero,
    );
  }

  // 📱 NIVEL 4: PROTECCIÓN CONTRA SIM SWAPPING

  static Future<SIMSecurityResult> verifySIMSecurity(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));

    // Simulación de verificación SIM
    final recentChanges = Random().nextBool();
    final suspiciousActivity = Random().nextDouble() > 0.8;

    return SIMSecurityResult(
      isSecure: !recentChanges && !suspiciousActivity,
      recentSIMChange: recentChanges,
      suspiciousActivity: suspiciousActivity,
      lastVerified: DateTime.now(),
    );
  }

  // 🕵️ NIVEL 5: DETECCIÓN DE SOCIAL ENGINEERING

  static Future<SocialEngineeringResult> analyzeCommunication({
    required String message,
    required String senderId,
    required String receiverId,
  }) async {
    var riskScore = 0.0;
    final risks = <String>[];

    // Análisis de patrones de phishing
    if (_containsPhishingPatterns(message)) {
      riskScore += 0.4;
      risks.add('Posibles patrones de phishing detectados');
    }

    // Análisis de solicitudes de información personal
    if (_requestsPersonalInfo(message)) {
      riskScore += 0.3;
      risks.add('Solicita información personal');
    }

    // Análisis de urgencia artificial
    if (_createsArtificialUrgency(message)) {
      riskScore += 0.2;
      risks.add('Crea sensación de urgencia');
    }

    // Análisis de enlaces sospechosos
    if (_containsSuspiciousLinks(message)) {
      riskScore += 0.5;
      risks.add('Contiene enlaces sospechosos');
    }

    return SocialEngineeringResult(
      riskLevel: _getRiskLevel(riskScore),
      riskScore: riskScore,
      detectedRisks: risks,
      shouldBlock: riskScore > 0.7,
      timestamp: DateTime.now(),
    );
  }

  // 💳 NIVEL 6: PREVENCIÓN DE CATFISHING

  static Future<CatfishingAnalysis> analyzeCatfishingRisk({
    required String userId,
    required List<String> photos,
    required Map<String, dynamic> profileData,
  }) async {
    var riskScore = 0.0;
    final indicators = <String>[];

    // Análisis de coherencia de fotos
    final photoAnalysis = await _analyzePhotoConsistency(photos);
    if (!photoAnalysis.isConsistent) {
      riskScore += 0.4;
      indicators.add('Inconsistencias en las fotos del perfil');
    }

    // Análisis de reverse image search simulado
    final reverseSearchResults = await _performReverseImageSearch(photos);
    if (reverseSearchResults.foundElsewhere) {
      riskScore += 0.6;
      indicators.add('Fotos encontradas en otros perfiles');
    }

    // Análisis de información del perfil
    if (_analyzeProfileInconsistencies(profileData)) {
      riskScore += 0.3;
      indicators.add('Inconsistencias en información del perfil');
    }

    return CatfishingAnalysis(
      riskLevel: _getRiskLevel(riskScore),
      riskScore: riskScore,
      indicators: indicators,
      photoAnalysis: photoAnalysis,
      reverseSearchResults: reverseSearchResults,
      timestamp: DateTime.now(),
    );
  }

  // 🌐 NIVEL 7: PROTECCIÓN MITM Y CIFRADO

  static String encryptSensitiveData(String data, String userKey) {
    // Implementación de cifrado AES-256
    final key = sha256.convert(utf8.encode(userKey)).bytes;
    final iv = List.generate(16, (i) => Random().nextInt(256));

    // En producción, usaría una biblioteca de cifrado real
    // Aquí simulo el proceso
    final encryptedData = base64Encode(utf8.encode(data));
    final ivBase64 = base64Encode(iv);

    return '$ivBase64:$encryptedData';
  }

  static String decryptSensitiveData(String encryptedData, String userKey) {
    final parts = encryptedData.split(':');
    if (parts.length != 2) throw Exception('Datos cifrados inválidos');

    // En producción, usaría una biblioteca de cifrado real
    return utf8.decode(base64Decode(parts[1]));
  }

  // 📊 NIVEL 8: MONITOREO Y LOGGING

  static void _logSecurityEvent(SecurityEvent event) {
    _securityLog.add(event);

    // En producción, esto se enviaría a un SIEM
    if (kDebugMode) {
      print('🔒 SECURITY EVENT: ${event.type} - ${event.severity}');
      print('Details: ${event.details}');
    }
  }

  static List<SecurityEvent> getSecurityLog({
    SecuritySeverity? minSeverity,
    DateTime? since,
  }) {
    return _securityLog.where((event) {
      if (minSeverity != null && event.severity.index < minSeverity.index)
        return false;
      if (since != null && event.timestamp.isBefore(since)) return false;
      return true;
    }).toList();
  }

  // 🔍 MÉTODOS DE ANÁLISIS PRIVADOS

  static bool _analyzeTimingPatterns(List<UserAction> actions) {
    if (actions.length < 5) return false;

    final intervals = <Duration>[];
    for (int i = 1; i < actions.length; i++) {
      intervals.add(actions[i].timestamp.difference(actions[i - 1].timestamp));
    }

    // Detectar patrones demasiado regulares (indicativo de bot)
    final avgInterval =
        intervals.map((d) => d.inMilliseconds).reduce((a, b) => a + b) /
            intervals.length;
    final deviations =
        intervals.map((d) => (d.inMilliseconds - avgInterval).abs()).toList();
    final avgDeviation = deviations.reduce((a, b) => a + b) / deviations.length;

    // Si la desviación es muy pequeña, probablemente es un bot
    return avgDeviation < 50; // menos de 50ms de desviación promedio
  }

  static bool _analyzeMouseMovements(List<UserAction> actions) {
    // Análisis de movimientos de mouse/touch demasiado perfectos
    final moveActions =
        actions.where((a) => a.type == ActionType.mouseMove).toList();
    if (moveActions.length < 10) return false;

    // Los humanos tienen movimientos más erráticos
    // Los bots tienden a tener movimientos más lineales
    return _calculateMovementEntropy(moveActions) < 0.3;
  }

  static bool _analyzeTypingSpeed(List<UserAction> actions) {
    final typingActions =
        actions.where((a) => a.type == ActionType.keyPress).toList();
    if (typingActions.length < 10) return false;

    // Velocidad de escritura sobrehumana
    final intervals = <Duration>[];
    for (int i = 1; i < typingActions.length; i++) {
      intervals.add(typingActions[i]
          .timestamp
          .difference(typingActions[i - 1].timestamp));
    }

    final avgInterval =
        intervals.map((d) => d.inMilliseconds).reduce((a, b) => a + b) /
            intervals.length;

    // Menos de 50ms entre teclas es sospechoso
    return avgInterval < 50;
  }

  static bool _analyzeJavaScriptCapabilities(Map<String, dynamic> metrics) {
    // Verificar características que los bots suelen omitir
    final requiredCapabilities = [
      'webGL',
      'canvas',
      'audioContext',
      'deviceMemory',
      'hardwareConcurrency'
    ];

    for (final capability in requiredCapabilities) {
      if (!metrics.containsKey(capability)) return true;
    }

    return false;
  }

  static double _calculateMovementEntropy(List<UserAction> moveActions) {
    // Cálculo simplificado de entropía de movimientos
    // En producción, esto sería mucho más sofisticado
    return Random().nextDouble(); // Simulado
  }

  static double _calculateDocumentConfidence(DocumentChecks checks) {
    var confidence = 0.0;
    if (checks.faceMatch) confidence += 0.4;
    if (checks.documentAuthenticity) confidence += 0.3;
    if (checks.liveness) confidence += 0.2;
    if (checks.textExtraction) confidence += 0.1;
    return confidence;
  }

  static List<String> _getBotDetectionReasons(double botScore) {
    final reasons = <String>[];
    if (botScore > 0.2) reasons.add('Patrones de timing sospechosos');
    if (botScore > 0.4) reasons.add('Movimientos de mouse/touch artificiales');
    if (botScore > 0.6) reasons.add('Velocidad de escritura sobrehumana');
    if (botScore > 0.8) reasons.add('Capacidades de JavaScript limitadas');
    return reasons;
  }

  static bool _containsPhishingPatterns(String message) {
    final phishingPatterns = [
      r'click.*here.*urgent',
      r'verify.*account.*immediately',
      r'suspended.*click.*link',
      r'confirm.*identity.*now',
    ];

    return phishingPatterns.any(
        (pattern) => RegExp(pattern, caseSensitive: false).hasMatch(message));
  }

  static bool _requestsPersonalInfo(String message) {
    final personalInfoPatterns = [
      r'social.*security',
      r'credit.*card',
      r'bank.*account',
      r'password',
      r'full.*name.*birth',
    ];

    return personalInfoPatterns.any(
        (pattern) => RegExp(pattern, caseSensitive: false).hasMatch(message));
  }

  static bool _createsArtificialUrgency(String message) {
    final urgencyPatterns = [
      r'urgent',
      r'immediate',
      r'expires.*today',
      r'limited.*time',
      r'act.*now',
    ];

    return urgencyPatterns.any(
        (pattern) => RegExp(pattern, caseSensitive: false).hasMatch(message));
  }

  static bool _containsSuspiciousLinks(String message) {
    final linkPattern = RegExp(r'https?://[^\s]+');
    final links = linkPattern.allMatches(message);

    for (final link in links) {
      final url = message.substring(link.start, link.end);
      if (_isSuspiciousURL(url)) return true;
    }

    return false;
  }

  static bool _isSuspiciousURL(String url) {
    final suspiciousPatterns = [
      r'bit\.ly',
      r'tinyurl',
      r'[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}', // IP addresses
      r'[a-z0-9]{10,}\.tk', // Long random domains
    ];

    return suspiciousPatterns
        .any((pattern) => RegExp(pattern, caseSensitive: false).hasMatch(url));
  }

  static Future<PhotoConsistencyAnalysis> _analyzePhotoConsistency(
      List<String> photos) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulación de análisis de coherencia facial
    return PhotoConsistencyAnalysis(
      isConsistent: Random().nextDouble() > 0.2,
      confidenceScore: Random().nextDouble(),
      analysisDetails: 'Análisis facial completado',
    );
  }

  static Future<ReverseImageSearchResult> _performReverseImageSearch(
      List<String> photos) async {
    await Future.delayed(const Duration(seconds: 3));

    return ReverseImageSearchResult(
      foundElsewhere: Random().nextDouble() > 0.8,
      matchingSites: Random().nextBool() ? ['Instagram', 'Facebook'] : [],
      confidence: Random().nextDouble(),
    );
  }

  static bool _analyzeProfileInconsistencies(Map<String, dynamic> profileData) {
    // Análisis de inconsistencias en la información del perfil
    return Random().nextDouble() > 0.7;
  }

  static SecurityRiskLevel _getRiskLevel(double score) {
    if (score < 0.3) return SecurityRiskLevel.low;
    if (score < 0.6) return SecurityRiskLevel.medium;
    if (score < 0.8) return SecurityRiskLevel.high;
    return SecurityRiskLevel.critical;
  }
}

// 📋 MODELOS DE DATOS DE SEGURIDAD

enum BiometricType { facial, fingerprint, voice, behavioral }

enum SecurityEventType {
  loginAttempt,
  botAnalysis,
  bruteForceDetected,
  socialEngineeringAttempt,
  catfishingDetected,
  documentVerification,
  biometricVerification,
  suspiciousActivity,
}

enum SecuritySeverity { low, medium, high, critical }

enum SecurityRiskLevel { low, medium, high, critical }

enum ActionType { mouseMove, keyPress, click, scroll, focus }

class BiometricResult {
  final bool isValid;
  final double confidence;
  final BiometricType biometricType;
  final DateTime timestamp;

  BiometricResult({
    required this.isValid,
    required this.confidence,
    required this.biometricType,
    required this.timestamp,
  });
}

class DocumentChecks {
  final bool faceMatch;
  final bool documentAuthenticity;
  final bool liveness;
  final bool textExtraction;

  DocumentChecks({
    required this.faceMatch,
    required this.documentAuthenticity,
    required this.liveness,
    required this.textExtraction,
  });
}

class DocumentVerificationResult {
  final bool isValid;
  final DocumentChecks checks;
  final double confidence;
  final DateTime timestamp;

  DocumentVerificationResult({
    required this.isValid,
    required this.checks,
    required this.confidence,
    required this.timestamp,
  });
}

class UserAction {
  final ActionType type;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  UserAction({
    required this.type,
    required this.timestamp,
    required this.data,
  });
}

class BotDetectionResult {
  final bool isBot;
  final double confidence;
  final List<String> detectionReasons;
  final DateTime timestamp;

  BotDetectionResult({
    required this.isBot,
    required this.confidence,
    required this.detectionReasons,
    required this.timestamp,
  });
}

class RateLimitResult {
  final bool isAllowed;
  final int remainingAttempts;
  final Duration blockDuration;

  RateLimitResult({
    required this.isAllowed,
    required this.remainingAttempts,
    required this.blockDuration,
  });
}

class SIMSecurityResult {
  final bool isSecure;
  final bool recentSIMChange;
  final bool suspiciousActivity;
  final DateTime lastVerified;

  SIMSecurityResult({
    required this.isSecure,
    required this.recentSIMChange,
    required this.suspiciousActivity,
    required this.lastVerified,
  });
}

class SocialEngineeringResult {
  final SecurityRiskLevel riskLevel;
  final double riskScore;
  final List<String> detectedRisks;
  final bool shouldBlock;
  final DateTime timestamp;

  SocialEngineeringResult({
    required this.riskLevel,
    required this.riskScore,
    required this.detectedRisks,
    required this.shouldBlock,
    required this.timestamp,
  });
}

class PhotoConsistencyAnalysis {
  final bool isConsistent;
  final double confidenceScore;
  final String analysisDetails;

  PhotoConsistencyAnalysis({
    required this.isConsistent,
    required this.confidenceScore,
    required this.analysisDetails,
  });
}

class ReverseImageSearchResult {
  final bool foundElsewhere;
  final List<String> matchingSites;
  final double confidence;

  ReverseImageSearchResult({
    required this.foundElsewhere,
    required this.matchingSites,
    required this.confidence,
  });
}

class CatfishingAnalysis {
  final SecurityRiskLevel riskLevel;
  final double riskScore;
  final List<String> indicators;
  final PhotoConsistencyAnalysis photoAnalysis;
  final ReverseImageSearchResult reverseSearchResults;
  final DateTime timestamp;

  CatfishingAnalysis({
    required this.riskLevel,
    required this.riskScore,
    required this.indicators,
    required this.photoAnalysis,
    required this.reverseSearchResults,
    required this.timestamp,
  });
}

class SecurityEvent {
  final SecurityEventType type;
  final SecuritySeverity severity;
  final Map<String, dynamic> details;
  final DateTime timestamp;

  SecurityEvent({
    required this.type,
    required this.severity,
    required this.details,
    required this.timestamp,
  });
}
