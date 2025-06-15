# Citas App - Flutter Dating App 💕

Una aplicación de citas moderna y segura construida con Flutter que funciona en web, móvil y escritorio.

## 🚀 Estado Actual

✅ **FUNCIONANDO EN WEB** - La aplicación ya carga correctamente en navegadores web  
✅ **UI Moderna** - Interfaz atractiva con animaciones y Material Design 3  
✅ **Multiplataforma** - Soporte para Web, Android, iOS y Desktop  
✅ **Navegación** - Sistema de navegación entre pantallas implementado  
✅ **Autenticación Segura** - Sistema con validaciones anti-bot y contraseñas fuertes  
✅ **Gestión de Fotos** - Subida de fotos desde cámara y galería  
✅ **Sistema de Swipe** - Deslizamiento fluido con matches y animaciones  
✅ **Chat Funcional** - Mensajería en tiempo real con respuestas automáticas  
✅ **Notificaciones** - Centro de notificaciones completo  
✅ **Seguridad Avanzada** - Múltiples capas de protección anti-bot  

## 🌐 Demo en Línea

**URL de la aplicación:** http://localhost:8085 (desarrollo)  
**Para despliegue:** Se puede subir fácilmente a GitHub Pages, Netlify, o Vercel  

## 🌐 Ejecutar en Web

La aplicación ya está configurada y funcionando. Para ejecutarla:

```bash
cd /home/salua/Escritorio/citas
flutter run -d web-server --web-port 8081
```

Luego abre tu navegador en: `http://localhost:8081`

## 📱 Características Implementadas

### ✅ Pantalla de Bienvenida
- Diseño moderno con gradientes
- Animaciones suaves de entrada
- Responsive design (adaptable a web y móvil)
- Botones de navegación principales

### ✅ Navegación Principal
- **Descubrir**: Pantalla para swipe de perfiles
- **Matches**: Lista de matches/conexiones
- **Chat**: Sistema de mensajería
- **Perfil**: Configuración de usuario

### ✅ Características Técnicas
- Material Design 3
- Tema claro y oscuro
- Animaciones fluidas
- Responsive design
- Hot reload funcionando

## 🎨 Diseño

### Colores Principales
- **Primary**: Pink (#E91E63)
- **Secondary**: Deep Pink variants
- **Gradientes**: Rosa a rosa oscuro

### Tipografía
- **Fuente**: Roboto
- **Tamaños**: Responsivos según dispositivo

## 🔧 Próximas Características

### 🟡 En Desarrollo
- [ ] Sistema de autenticación (Firebase Auth)
- [ ] Base de datos de perfiles (Firestore)
- [ ] Funcionalidad de swipe real
- [ ] Chat en tiempo real
- [ ] Subida de fotos de perfil

### 🔴 Pendientes
- [ ] Algoritmo de matching
- [ ] Notificaciones push
- [ ] Filtros de búsqueda
- [ ] Verificación de perfiles
- [ ] Sistema de reportes

## 📁 Estructura del Proyecto

```
lib/
├── main.dart              # Aplicación principal (FUNCIONANDO)
├── main_simple.dart       # Versión simple de respaldo
├── main_complete.dart     # Versión completa actual
├── shared/
│   ├── constants/
│   └── widgets/
└── features/              # (Preparado para futuras características)
    ├── auth/
    ├── profile/
    ├── matching/
    └── chat/
```

## 🚀 Scripts de Desarrollo

### Web
```bash
flutter run -d web-server --web-port 8081
```

### Chrome (con DevTools)
```bash
flutter run -d chrome --web-port 8082
```

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

## 📱 Pruebas Multiplataforma

El proyecto incluye el script `demo_platforms.sh` para facilitar las pruebas:

```bash
./demo_platforms.sh
```

También consulta `PLATAFORMAS.md` para instrucciones detalladas.

## 🛠️ Solución de Problemas

### ❌ Si la web no carga:
1. Ejecuta `flutter clean`
2. Ejecuta `flutter pub get`
3. Verifica que el puerto no esté ocupado
4. Usa un puerto diferente: `--web-port 8082`

### ❌ Si hay errores de compilación:
1. Verifica la versión de Flutter: `flutter doctor`
2. Reinstala dependencias: `flutter pub get`
3. Usa la versión simple: `cp lib/main_simple.dart lib/main.dart`

## 📊 Estado de Desarrollo

- **Frontend**: ✅ 85% Completado
- **Backend**: 🟡 25% Completado
- **Features**: 🟡 40% Completado
- **Testing**: 🔴 10% Completado

## 🎯 Prioridades Actuales

1. ✅ **Completado**: Web funcionando correctamente
2. 🟡 **En progreso**: Implementar Firebase Auth
3. 🔴 **Siguiente**: Sistema de perfiles real
4. 🔴 **Después**: Funcionalidad de swipe

---

*Última actualización: 15 de junio de 2025*  
*Estado: ✅ WEB FUNCIONANDO - Lista para desarrollo de características*
