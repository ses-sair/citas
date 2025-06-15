import 'dart:html' as html;
import 'package:flutter/material.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  // Simulated storage for images (en producción usar Firebase Storage)
  static final Map<String, String> _imageStorage = {};

  // Subir imagen de perfil
  static Future<String?> uploadProfileImage(String userId) async {
    try {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.multiple = false;
      uploadInput.accept = 'image/*';
      
      uploadInput.click();
      
      await uploadInput.onChange.first;
      
      final files = uploadInput.files;
      if (files!.isEmpty) return null;
      
      final file = files[0];
      final reader = html.FileReader();
      
      // Validar tamaño del archivo (max 5MB)
      if (file.size > 5 * 1024 * 1024) {
        throw Exception('La imagen es muy grande. Máximo 5MB.');
      }
      
      // Validar tipo de archivo
      if (!file.type.startsWith('image/')) {
        throw Exception('Solo se permiten archivos de imagen.');
      }
      
      reader.readAsDataUrl(file);
      await reader.onLoad.first;
      
      final dataUrl = reader.result as String;
      
      // Simular subida a servidor (en producción usar Firebase Storage)
      await Future.delayed(const Duration(seconds: 2));
      
      final imageId = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}';
      _imageStorage[imageId] = dataUrl;
      
      return imageId;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  // Obtener URL de imagen
  static String? getImageUrl(String imageId) {
    return _imageStorage[imageId];
  }

  // Eliminar imagen
  static Future<bool> deleteImage(String imageId) async {
    try {
      _imageStorage.remove(imageId);
      return true;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  // Validar imagen
  static bool isValidImageFormat(String? mimeType) {
    if (mimeType == null) return false;
    return ['image/jpeg', 'image/png', 'image/gif', 'image/webp']
        .contains(mimeType.toLowerCase());
  }

  // Redimensionar imagen (simplificado para demo)
  static Future<String?> resizeImage(String dataUrl, {int maxWidth = 800, int maxHeight = 600}) async {
    // En producción, usar una librería como image para redimensionar
    // Por ahora devolvemos la imagen original
    return dataUrl;
  }

  // Galería de imágenes demo
  static List<String> getDemoImages() {
    return [
      'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
    ];
  }
}
