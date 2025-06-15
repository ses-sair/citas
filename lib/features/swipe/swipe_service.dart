// Sistema de Swipe y Perfiles
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'dart:math';

class SwipeService {
  static final Random _random = Random();
  
  // Generar perfiles demo para el swipe
  static List<UserProfile> generateDemoProfiles() {
    final names = [
      'Ana García', 'Carlos López', 'María Rodríguez', 'Diego Martín',
      'Sofía Hernández', 'Javier Pérez', 'Carmen Sánchez', 'Pablo Ruiz',
      'Lucía Jiménez', 'Andrés Moreno', 'Isabel Álvarez', 'Raúl Castro',
      'Elena Ortega', 'Fernando Ramos', 'Natalia Flores', 'Hugo Delgado'
    ];
    
    final descriptions = [
      'Me encanta viajar y conocer culturas nuevas ✈️',
      'Amante de la música y los conciertos 🎵',
      'Deportista, siempre en busca de aventuras 🏃‍♀️',
      'Foodie empedernido, ¿conoces algún lugar bueno? 🍕',
      'Lector voraz y amante del arte 📚',
      'Aventurero que disfruta de la naturaleza 🌲',
      'Creativo, me gusta la fotografía 📸',
      'Bailarín de salsa, ¿te animas? 💃',
    ];
    
    final interests = [
      ['Viajar', 'Música', 'Películas'],
      ['Deportes', 'Cocinar', 'Arte'],
      ['Lectura', 'Naturaleza', 'Fotografía'],
      ['Baile', 'Cine', 'Tecnología'],
      ['Yoga', 'Meditación', 'Plantas'],
      ['Gaming', 'Anime', 'Café'],
    ];
    
    return List.generate(20, (index) {
      return UserProfile(
        id: 'user_$index',
        name: names[index % names.length],
        age: 20 + _random.nextInt(15),
        description: descriptions[index % descriptions.length],
        interests: interests[index % interests.length],
        images: _generateDemoImages(),
        distance: _random.nextInt(50) + 1,
      );
    });
  }
  
  static List<String> _generateDemoImages() {
    // URLs de imágenes demo (usando placeholders)
    final colors = ['FF6B9D', '4ECDC4', 'FFE66D', 'A8E6CF', 'FFAAA5'];
    final color = colors[_random.nextInt(colors.length)];
    
    return [
      'https://via.placeholder.com/400x600/$color/FFFFFF?text=Foto+1',
      'https://via.placeholder.com/400x600/$color/FFFFFF?text=Foto+2',
      'https://via.placeholder.com/400x600/$color/FFFFFF?text=Foto+3',
    ];
  }
}

class UserProfile {
  final String id;
  final String name;
  final int age;
  final String description;
  final List<String> interests;
  final List<String> images;
  final int distance;
  
  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.description,
    required this.interests,
    required this.images,
    required this.distance,
  });
}

// Widget de tarjeta de perfil para swipe
class ProfileCard extends StatelessWidget {
  final UserProfile profile;
  
  const ProfileCard({super.key, required this.profile});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Imagen de fondo
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Color(
                int.parse('FF${profile.images[0].split('/')[5].split('x')[0].substring(0, 6)}', radix: 16),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
            
            // Gradiente inferior
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            
            // Información del perfil
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nombre y edad
                  Text(
                    '${profile.name}, ${profile.age}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Distancia
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${profile.distance} km de distancia',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Descripción
                  Text(
                    profile.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Intereses
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: profile.interests.map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          interest,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // Indicadores de imagen
            if (profile.images.length > 1)
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                  children: profile.images.asMap().entries.map((entry) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(
                          right: entry.key < profile.images.length - 1 ? 4 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: entry.key == 0 
                              ? Colors.white 
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
