# 🚀 Guía de Despliegue - Citas App

Esta guía te ayudará a desplegar la aplicación Citas App en diferentes plataformas web.

## 📋 Tabla de Contenidos

1. [Preparación](#preparación)
2. [GitHub Pages](#github-pages)
3. [Netlify](#netlify)
4. [Vercel](#vercel)
5. [Firebase Hosting](#firebase-hosting)
6. [Solución de Problemas](#solución-de-problemas)

## 🛠️ Preparación

### Prerrequisitos
- Flutter SDK 3.5 o superior
- Git instalado
- Cuenta en la plataforma de despliegue elegida

### Construir la aplicación
```bash
# Limpiar builds anteriores
flutter clean
flutter pub get

# Construir para web
flutter build web --release
```

## 🐙 GitHub Pages

### Opción 1: GitHub Actions (Automático)
1. **Subir código a GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/TU_USUARIO/citas.git
   git push -u origin main
   ```

2. **Configurar GitHub Pages:**
   - Ve a Settings > Pages
   - Source: GitHub Actions
   - El workflow ya está configurado en `.github/workflows/deploy.yml`

3. **URL de acceso:**
   `https://TU_USUARIO.github.io/citas/`

### Opción 2: Manual
1. **Construir con base-href:**
   ```bash
   flutter build web --release --base-href="/citas/"
   ```

2. **Crear rama gh-pages:**
   ```bash
   git checkout --orphan gh-pages
   git rm -rf .
   cp -r build/web/* .
   git add .
   git commit -m "Deploy to GitHub Pages"
   git push origin gh-pages
   ```

## 🌍 Netlify

### Despliegue Drag & Drop
1. Ve a [netlify.com](https://netlify.com)
2. Arrastra la carpeta `build/web/` a la interfaz
3. ¡Listo! Tu app estará en línea

### Despliegue desde Git
1. Conecta tu repositorio GitHub
2. Configurar build:
   - Build command: `flutter build web --release`
   - Publish directory: `build/web`

## ⚡ Vercel

1. Ve a [vercel.com](https://vercel.com)
2. Conecta tu repositorio GitHub
3. Configurar:
   - Framework Preset: Other
   - Build Command: `flutter build web --release`
   - Output Directory: `build/web`

## 🔥 Firebase Hosting

1. **Instalar Firebase CLI:**
   ```bash
   npm install -g firebase-tools
   ```

2. **Inicializar proyecto:**
   ```bash
   firebase login
   firebase init hosting
   ```

3. **Configurar firebase.json:**
   ```json
   {
     "hosting": {
       "public": "build/web",
       "ignore": [
         "firebase.json",
         "**/.*",
         "**/node_modules/**"
       ],
       "rewrites": [
         {
           "source": "**",
           "destination": "/index.html"
         }
       ]
     }
   }
   ```

4. **Desplegar:**
   ```bash
   flutter build web --release
   firebase deploy
   ```

## 🚀 Script Automático

Usa el script `deploy.sh` incluido:

```bash
chmod +x deploy.sh
./deploy.sh
```

## 🔧 Solución de Problemas

### Error: "Failed to load"
- Verifica que la base-href esté correcta
- Para GitHub Pages usa: `--base-href="/NOMBRE_REPO/"`

### Error: "White screen"
- Revisa la consola del navegador
- Verifica que todos los assets estén en las rutas correctas

### Error: "Flutter service worker"
- Limpia la caché del navegador
- Reconstruye con `flutter clean && flutter build web --release`

### Problemas de CORS
- Algunos servicios requieren configuración adicional
- Contacta el soporte de la plataforma

## 📊 Monitoreo

Una vez desplegado, puedes:
- Usar Google Analytics para estadísticas
- Configurar alertas de tiempo de actividad
- Monitorear errores con Sentry

## 🔒 Configuración de Producción

Para producción, recuerda:
1. Configurar Firebase con credenciales reales
2. Activar HTTPS (automático en la mayoría de plataformas)
3. Configurar dominio personalizado si tienes uno
4. Optimizar imágenes y assets

## 📱 PWA (Progressive Web App)

La app ya está configurada como PWA:
- Se puede instalar en dispositivos
- Funciona offline (limitado)
- Icono de aplicación incluido

## 🎉 ¡Felicidades!

Tu aplicación Citas App ya está desplegada y accesible desde cualquier navegador web. Los usuarios pueden:

- Registrarse e iniciar sesión
- Gestionar sus fotos de perfil
- Usar el sistema de swipe
- Chatear con matches
- Recibir notificaciones
- Y mucho más...

### URLs de Ejemplo:
- **GitHub Pages**: https://tu-usuario.github.io/citas/
- **Netlify**: https://amazing-app-123.netlify.app/
- **Vercel**: https://citas-app.vercel.app/
- **Firebase**: https://citas-app-123.web.app/

¡Comparte tu enlace y disfruta de tu aplicación de citas en línea! 💕
