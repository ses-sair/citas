// Servicio de Autenticación con Seguridad Avanzada
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:math';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const Uuid _uuid = Uuid();

  // 🔐 SEGURIDAD AVANZADA
  
  // Verificación anti-bot usando reCAPTCHA simulado
  static Future<bool> verifyHuman(String challenge) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulación de verificación humana
    return challenge.length > 5;
  }

  // Detección de dispositivos sospechosos
  static String _generateDeviceFingerprint() {
    final random = Random();
    final deviceInfo = {
      'userAgent': kIsWeb ? 'web' : 'mobile',
      'screenResolution': '${random.nextInt(2000)}x${random.nextInt(1500)}',
      'timezone': DateTime.now().timeZoneOffset.toString(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    final deviceString = deviceInfo.entries
        .map((e) => '${e.key}:${e.value}')
        .join('|');
    
    return sha256.convert(utf8.encode(deviceString)).toString().substring(0, 16);
  }

  // 🚫 PREVENCIÓN DE SUPLANTACIÓN
  
  // Validación de email con múltiples verificaciones
  static Future<bool> isValidEmail(String email) async {
    // Validación de formato
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$');
    if (!emailRegex.hasMatch(email)) return false;
    
    // Lista de dominios temporales/sospechosos (simulada)
    final suspiciousDomains = [
      '10minutemail.com', 'tempmail.org', 'guerrillamail.com',
      'mailinator.com', 'trashmail.com'
    ];
    
    final domain = email.split('@')[1].toLowerCase();
    if (suspiciousDomains.contains(domain)) return false;
    
    return true;
  }

  // 🔑 AUTENTICACIÓN SEGURA
  
  static Future<AuthResult> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String humanVerification,
  }) async {
    try {
      // 1. Verificación anti-bot
      if (!await verifyHuman(humanVerification)) {
        return AuthResult.error('Verificación de seguridad fallida');
      }

      // 2. Validación de email
      if (!await isValidEmail(email)) {
        return AuthResult.error('Email no válido o de dominio sospechoso');
      }

      // 3. Validación de contraseña segura
      if (!_isStrongPassword(password)) {
        return AuthResult.error('La contraseña no cumple con los requisitos de seguridad');
      }

      // 4. Generar ID único para el usuario
      final userId = _uuid.v4();
      final deviceId = _generateDeviceFingerprint();

      // 5. Crear perfil de usuario con datos de seguridad
      final userData = {
        'id': userId,
        'name': name,
        'email': email.toLowerCase().trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'deviceFingerprint': deviceId,
        'isVerified': false,
        'securityLevel': 'standard',
        'lastActiveAt': FieldValue.serverTimestamp(),
      };

      // Por ahora simularemos el registro exitoso
      await Future.delayed(const Duration(seconds: 2));
      
      return AuthResult.success(
        MockUser(
          id: userId,
          name: name,
          email: email,
          isVerified: false,
        ),
      );

    } catch (e) {
      return AuthResult.error('Error en el registro: ${e.toString()}');
    }
  }

  static Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
    required String humanVerification,
  }) async {
    try {
      // 1. Verificación anti-bot
      if (!await verifyHuman(humanVerification)) {
        return AuthResult.error('Verificación de seguridad fallida');
      }

      // 2. Validación de email
      if (!await isValidEmail(email)) {
        return AuthResult.error('Email no válido');
      }

      // 3. Detectar intentos de fuerza bruta (simulado)
      if (await _detectBruteForce(email)) {
        return AuthResult.error('Demasiados intentos. Cuenta temporalmente bloqueada.');
      }

      // 4. Autenticación simulada
      await Future.delayed(const Duration(seconds: 2));
      
      final userId = _uuid.v4();
      return AuthResult.success(
        MockUser(
          id: userId,
          name: 'Usuario Demo',
          email: email,
          isVerified: true,
        ),
      );

    } catch (e) {
      return AuthResult.error('Error en el inicio de sesión: ${e.toString()}');
    }
  }

  // 🔍 VALIDACIONES DE SEGURIDAD

  static bool _isStrongPassword(String password) {
    // Mínimo 8 caracteres
    if (password.length < 8) return false;
    
    // Al menos una mayúscula
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    
    // Al menos una minúscula
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    
    // Al menos un número
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    
    // Al menos un carácter especial
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    
    return true;
  }

  static Future<bool> _detectBruteForce(String email) async {
    // Simulación de detección de fuerza bruta
    await Future.delayed(const Duration(milliseconds: 100));
    return false; // Por ahora siempre permitir
  }

  // 🚪 CERRAR SESIÓN SEGURO
  
  static Future<void> signOut() async {
    // Limpiar tokens y datos sensibles
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

// 📊 CLASES DE RESULTADO

class AuthResult {
  final bool isSuccess;
  final MockUser? user;
  final String? error;

  AuthResult.success(this.user) : isSuccess = true, error = null;
  AuthResult.error(this.error) : isSuccess = false, user = null;
}

class MockUser {
  final String id;
  final String name;
  final String email;
  final bool isVerified;

  MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
  });
}
