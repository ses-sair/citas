// Servicio para manejo de fotos de perfil
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PhotoService {
  static final ImagePicker _picker = ImagePicker();
  static const String _photosKey = 'user_profile_photos';
  static const int maxPhotos = 6;

  // Obtener fotos guardadas localmente
  static Future<List<ProfilePhoto>> getProfilePhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final photosJson = prefs.getStringList(_photosKey) ?? [];

      return photosJson.map((json) {
        final data = jsonDecode(json);
        return ProfilePhoto.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('Error al cargar fotos: $e');
      return [];
    }
  }

  // Guardar fotos localmente
  static Future<void> saveProfilePhotos(List<ProfilePhoto> photos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final photosJson =
          photos.map((photo) => jsonEncode(photo.toJson())).toList();
      await prefs.setStringList(_photosKey, photosJson);
    } catch (e) {
      debugPrint('Error al guardar fotos: $e');
    }
  }

  // Seleccionar foto desde la galería
  static Future<ProfilePhoto?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1600,
        imageQuality: 85,
      );

      if (image != null) {
        return await _processImage(image);
      }
    } catch (e) {
      debugPrint('Error al seleccionar desde galería: $e');
    }
    return null;
  }

  // Tomar foto con la cámara
  static Future<ProfilePhoto?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1600,
        imageQuality: 85,
      );

      if (image != null) {
        return await _processImage(image);
      }
    } catch (e) {
      debugPrint('Error al tomar foto: $e');
    }
    return null;
  }

  // Procesar imagen seleccionada
  static Future<ProfilePhoto> _processImage(XFile image) async {
    final bytes = await image.readAsBytes();
    final base64String = base64Encode(bytes);

    return ProfilePhoto(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      base64Data: base64String,
      fileName: image.name,
      size: bytes.length,
      uploadDate: DateTime.now(),
    );
  }

  // Agregar nueva foto
  static Future<List<ProfilePhoto>> addPhoto(ProfilePhoto photo) async {
    final photos = await getProfilePhotos();

    if (photos.length < maxPhotos) {
      photos.add(photo);
      await saveProfilePhotos(photos);
    }

    return photos;
  }

  // Eliminar foto
  static Future<List<ProfilePhoto>> removePhoto(String photoId) async {
    final photos = await getProfilePhotos();
    photos.removeWhere((photo) => photo.id == photoId);
    await saveProfilePhotos(photos);
    return photos;
  }

  // Reordenar fotos
  static Future<List<ProfilePhoto>> reorderPhotos(
      List<ProfilePhoto> newOrder) async {
    await saveProfilePhotos(newOrder);
    return newOrder;
  }

  // Verificar si el usuario puede agregar más fotos
  static Future<bool> canAddPhoto() async {
    final photos = await getProfilePhotos();
    return photos.length < maxPhotos;
  }

  // Obtener foto principal (primera de la lista)
  static Future<ProfilePhoto?> getMainPhoto() async {
    final photos = await getProfilePhotos();
    return photos.isNotEmpty ? photos.first : null;
  }
}

// Modelo de datos para fotos de perfil
class ProfilePhoto {
  final String id;
  final String base64Data;
  final String fileName;
  final int size;
  final DateTime uploadDate;

  ProfilePhoto({
    required this.id,
    required this.base64Data,
    required this.fileName,
    required this.size,
    required this.uploadDate,
  });

  // Convertir imagen base64 a bytes para mostrar
  Uint8List get imageBytes => base64Decode(base64Data);

  // Convertir a JSON para almacenamiento
  Map<String, dynamic> toJson() => {
        'id': id,
        'base64Data': base64Data,
        'fileName': fileName,
        'size': size,
        'uploadDate': uploadDate.toIso8601String(),
      };

  // Crear desde JSON
  factory ProfilePhoto.fromJson(Map<String, dynamic> json) => ProfilePhoto(
        id: json['id'],
        base64Data: json['base64Data'],
        fileName: json['fileName'],
        size: json['size'],
        uploadDate: DateTime.parse(json['uploadDate']),
      );

  // Obtener tamaño formateado
  String get formattedSize {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

// Widget para mostrar foto de perfil
class ProfilePhotoWidget extends StatelessWidget {
  final ProfilePhoto photo;
  final double size;
  final bool showDeleteButton;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ProfilePhotoWidget({
    super.key,
    required this.photo,
    this.size = 100,
    this.showDeleteButton = false,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.memory(
                photo.imageBytes,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: size,
                    height: size,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.error,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            if (showDeleteButton)
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
