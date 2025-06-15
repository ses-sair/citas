# Citas App 💕

Una aplicación de citas moderna construida con Flutter que permite a los usuarios conectarse y encontrar el amor.

## Características 🌟

- **Interfaz moderna**: Diseño atractivo y fácil de usar
- **Autenticación segura**: Sistema de registro e inicio de sesión
- **Perfiles personalizados**: Crea y edita tu perfil personal
- **Sistema de matches**: Descubre personas compatibles
- **Chat en tiempo real**: Comunícate con tus matches
- **Configuración personalizable**: Ajusta la app a tus preferencias

## Tecnologías Utilizadas 🛠️

- **Flutter**: Framework de desarrollo multiplataforma
- **Dart**: Lenguaje de programación
- **Material Design 3**: Sistema de diseño moderno
- **BLoC**: Gestión de estado (próximamente)
- **Firebase**: Backend y autenticación (próximamente)

## Estructura del Proyecto 📁

```
lib/
├── core/              # Funcionalidades centrales
├── features/          # Características principales
│   ├── auth/         # Autenticación
│   ├── profile/      # Perfiles de usuario
│   ├── matching/     # Sistema de matches
│   └── chat/         # Chat entre usuarios
├── shared/           # Componentes compartidos
└── main.dart         # Punto de entrada de la aplicación
```

## Funcionalidades Implementadas ✅

- [x] Pantalla de bienvenida
- [x] Sistema de autenticación (UI)
- [x] Navegación entre pantallas
- [x] Pantallas principales (Descubrir, Matches, Chat, Perfil)
- [x] Diseño responsive
- [x] Tema claro y oscuro

## Próximas Funcionalidades 🚀

- [ ] Integración con Firebase
- [ ] Sistema de swipe para matches
- [ ] Chat en tiempo real
- [ ] Subida de fotos
- [ ] Filtros de búsqueda
- [ ] Notificaciones push
- [ ] Geolocalización

## Instalación y Ejecución 🚀

### Requisitos Previos

- Flutter SDK (3.24.5 o superior)
- Dart SDK
- Navegador web (Chrome recomendado)

### Pasos de Instalación

1. **Clonar el repositorio** (si está en Git):
   ```bash
   git clone <url-del-repositorio>
   cd citas
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**:
   ```bash
   flutter run -d chrome
   ```

## Comandos Útiles 📋

- **Ejecutar en modo debug**: `flutter run -d chrome`
- **Construir para producción**: `flutter build web`
- **Analizar código**: `flutter analyze`
- **Ejecutar tests**: `flutter test`
- **Ver dispositivos disponibles**: `flutter devices`

## Contribución 🤝

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## Licencia 📄

Este proyecto está bajo la licencia MIT. Ver el archivo `LICENSE` para más detalles.

## Soporte 💬

Si tienes alguna pregunta o necesitas ayuda, no dudes en abrir un issue en el repositorio.

---

**¡Desarrollado con ❤️ y Flutter!**
